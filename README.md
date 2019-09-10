# DeepBake
Baking Machine Learning into Great British Bake Off
----------------------------------------------------

### What is this? 

DeepBake is a set of deep learning neural network models to predict the final rankings of GBBO contestants. 

DeepBake consists of 10 models for each episode, and was trained on data from seasons 2-9.

Data include 8 variables:

* Technical Challenge Ranking for that week and running mean from prior weeks
* Contestant was Star Baker and running mean of times named Star Baker
* Contestant was a favorite baker that week and running mean from prior weeks
* Contestant was an unfavored baker that week and the running mean

Data were obtained from [Wikipedia](https://en.wikipedia.org/wiki/The_Great_British_Bake_Off). Thanks to those who made those pages. 

Data were then quantile scaled to fit a normal distribution.

----------------------------------------

### Does this work? 

DeepBake's performance was measured using a Leave One Out method. One season was set aside for evaluation while training the model on using the remaining seasons. A mean receiver operating curve was calculated by iterating through all seasons. 

The closer the area under the curve (AUC) is to 1, the more accurate the model. 


<img src="https://github.com/dantaki/DeepBake/blob/master/FIGURES/gbbo.loo.norm.tiered.nos1.keras.deepbake.results.20190910.png" height="500">


Random chance of making a correct prediction has an AUC of 0.5 (dotted diagonal line). The Episode 4 model has an AUC of 0.91 (+/- 0.04 95% Confidence Interval), meaning it has a very good chance of predicting the final GBBO winner!

DeepBake makes 5 predictions:

* 1st Place :trophy: :trophy:
* Runner-Up :trophy:
* 3rd-4th Place
* 5th-7th Place
* 8th Place and Below

The evaluation was measured using this tiered class system. 

Note how the classifier gets better at predicting as the season progresses. This makes sense because the good bakers rise to the top (favored and star bakers) and historical data are recorded as running means. 

------------------------------------------

### Does this mean DeepBake can predict the winner Season 10?

Absolutely! Here are the current standings!

#### Season 10 : Episode 2 Predictions

##### Finalist Prediction

DeepBake puts Alice in the lead with a 36.8% probability score for being the finalist. Michael, David, and Rosie are close contenders with around 21% probability. 

<img src="https://github.com/dantaki/DeepBake/blob/master/FIGURES/s10.e2.finalist.png" height="500">

##### Finalist + Runner-Up

This score is the addition of the finalist probability and the runner-up probability. It's a measurement of how likely a baker would be in the final episode. 

DeepBake thinks Alice (87%), David (62%), and Michael (60%) will vie for the title of best baker.

<img src="https://github.com/dantaki/DeepBake/blob/master/FIGURES/s10.e2.top3.png" height="500">

##### 8th and Below

DeepBake gave Dan and Jamie the highest scores (80% and 78%) for being in the bottom tier. Dan was eliminated in week 1, while Jamie was eliminated at the end of episode 2. 

<img src="https://github.com/dantaki/DeepBake/blob/master/FIGURES/s10.e2.bottom.png" height="500">

In fact, the data DeepBake learned how to rank bakers can be inputted before the judges eliminate someone. This means DeepBake correctly predicted Jamie would leave the tent!

----------------------------------------

### Stay tuned for Week 3! 
