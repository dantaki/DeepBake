import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import interp
import scipy.stats
import warnings
from datetime import datetime
from sklearn.preprocessing import QuantileTransformer
import subprocess
import keras
from keras.models import Sequential
from keras.layers import Dense, Activation, Dropout
from keras.activations import relu
import tensorflow as tf
warnings.simplefilter("ignore")

def timestamp(): return datetime.today().strftime('%Y%m%d')


def quantile_scale(df,feats):
	qua = df
	scaler = QuantileTransformer(
		n_quantiles=10,
		random_state=42,
		ignore_implicit_zeros=True, #sparse matrix
	)
	# fit the scaler
	scaler.fit(qua[feats])
	# transform values
	qua[feats] = scaler.transform(qua[feats])
	return qua


def tiered(classes):
	trans = []
	for x in classes:
		if x==1: c=0
		if x==2: c=1
		if x>=3 and x<=4: c=2
		if x>=5 and x<=7: c=3
		if x>=8: c=4
		trans.append(c)
	return trans


def merge_feats(episode):
	subprocess.run(f'bash src/get_data_ready.sh {episode}', shell=True)
	merge_col = ['season','baker','episode']
	tech = pd.read_csv(f"deepbake_s12_technical_features.tsv",sep="\t")
	star = pd.read_csv(f"deepbake_judge_features_s12_e{episode}.tsv",sep="\t")
	gbbo = pd.merge(tech, star,  how='left', left_on=merge_col, right_on =merge_col).drop_duplicates()
	gbbo = gbbo[['season','baker','episode','tech_mean','tech','mean_star','star','mean_good','good','mean_bad','bad']]
	gbbo.to_csv(f"deepbake_features_s12_e{episode}.tsv",sep="\t",index=False)


def process_episode(episode):
	merge_feats(episode)
	gbbo = pd.read_csv(f"deepbake_features_s12_e{episode}.tsv",sep="\t")
	feats = ['tech_mean','tech','mean_star','star','mean_good','good','mean_bad','bad']
	gbbo = gbbo.loc[gbbo['episode']==episode]
	gbbo = quantile_scale(gbbo,feats)
	return gbbo


def create_model( nl1=1, nl2=1,  nl3=1, 
				 nn1=1000, nn2=500, nn3 = 200, lr=0.01, decay=0., l1=0.01, l2=0.01,
				act = 'relu', dropout=0,input_shape=None,output_shape=None):    
	'''This is a model generating function so that we can search over neural net 
	parameters and architecture
	https://www.kaggle.com/arrogantlymodest/randomised-cv-search-over-keras-neural-network
	'''
	opt = tf.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999,  decay=decay)
	reg = keras.regularizers.l1_l2(l1=l1, l2=l2)
	model = Sequential()
	first=True  
	for i in range(nl1):
		if first:
			model.add(Dense(nn1, input_dim=input_shape, activation=act, kernel_regularizer=reg))
			first=False
		else: 
			model.add(Dense(nn1, activation=act, kernel_regularizer=reg))
		if dropout!=0:
			model.add(Dropout(dropout))    
	for i in range(nl2):
		if first:
			model.add(Dense(nn2, input_dim=input_shape, activation=act, kernel_regularizer=reg))
			first=False
		else: 
			model.add(Dense(nn2, activation=act, kernel_regularizer=reg))
		if dropout!=0:
			model.add(Dropout(dropout))    
	for i in range(nl3):
		if first:
			model.add(Dense(nn3, input_dim=input_shape, activation=act, kernel_regularizer=reg))
			first=False
		else: 
			model.add(Dense(nn3, activation=act, kernel_regularizer=reg))
		if dropout!=0:
			model.add(Dropout(dropout))       
	model.add(Dense(output_shape, activation='softmax'))
	model.compile(loss='sparse_categorical_crossentropy', optimizer=opt, metrics=['accuracy'],)
	return model



def deep_bake(episode):
	feats = ['tech_mean','tech','mean_star','star','mean_good','good','mean_bad','bad']
	tech = pd.read_csv("../../RESULTS/deepbake_features.20210926.tsv",sep='\t')
	tech['place']=tiered(tech['place'])
	input_shape = len(feats)
	output_shape = len(set(tech['place']))

	l1 = 0.0001
	l2 = 0.0001
	lr = 0.0001
	nl1 = 1
	nl2 = 1
	nl3 = 1
	nn1 = 800
	nn2 = 800
	nn3 = 300
	dropout = 0.1
	decay = 1e-09
	act='relu'
	n_dims = len(feats)
	n_classes = len(set(tech['place']))
	BATCH,EPOCHS = 12, 25
	
	GBBO = pd.read_csv(f"deepbake_features_s12_e{episode}.tsv",sep="\t")
	S11 = pd.DataFrame()
	
	gbbo = GBBO.loc[GBBO['episode']==episode].copy()
	gbbo = quantile_scale(gbbo,feats)
	test = np.matrix(gbbo[feats])

	tech2 = tech.loc[tech['episode']==episode].copy()
	qua = quantile_scale(tech2,feats)
	qua['place']=tiered(qua['place'])

	X, y = np.matrix(qua[feats]), np.array(qua['place'])

	nn = create_model( nl1=nl1, nl2=nl2,  nl3=nl3, 
					 nn1=nn1, nn2=nn2, nn3 = nn3, 
					 lr=lr, decay=decay, l1=l1, l2=l2,
					 act = act, dropout=dropout,
					 input_shape=n_dims,
					 output_shape=n_classes)

	nn.fit(X,y,validation_split=0., batch_size=BATCH, epochs=EPOCHS,verbose=0)
	preds = np.argmax(nn.predict(test) > 0.5, axis=-1).astype("int32")
	probs = nn.predict(test)
	gbbo['preds']=preds
	# probability baker is a finalist
	top = probs[:,0]
	# probability baker is a finalist or a runner-up
	top3 = probs[:,0]+probs[:,1]
	# bottom tier (8th and below)
	bot = probs[:,-1]
	# 5th - 7th
	nextbot = probs[:,-2]
	third = probs[:,-3]

	gbbo['bottom']=np.round(bot*100,decimals=2)
	gbbo['finalist']=np.round(top*100,decimals=2) 
	gbbo['top3'] = np.round(top3*100,decimals=2)
	gbbo['fifthseventh'] = np.round(nextbot*100,decimals=2)
	gbbo['thirdforth'] = np.round(third*100,decimals=2)
	gbbo.to_csv(f"deepbake_s11.week{episode}_preditions.txt",sep="\t",index=False)

	return gbbo
	