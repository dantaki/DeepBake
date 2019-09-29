# DeepBake
Baking Machine Learning into Great British Bake Off
----------------------------------------------------

## :crystal_ball: [Season 10 Predictions](https://github.com/dantaki/DeepBake#season-10-week-5-predictions) :crystal_ball:

#### GBBO Winner: running probability
<img src="https://raw.githubusercontent.com/dantaki/DeepBake/master/FIGURES/gbbo.winner.running.probs.20190928.png" height="300">

#### GBBO Finalist: running probability
<img src="https://raw.githubusercontent.com/dantaki/DeepBake/master/FIGURES/gbbo.finalist.running.probs.20190928.png" height="300">

#### 5th-7th Place: running probability
<img src="https://raw.githubusercontent.com/dantaki/DeepBake/master/FIGURES/gbbo.5th-7th.running.probs.20190928.png" height="300">

-----------------------

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

## Does this mean DeepBake can predict the winner for Season 10?

Absolutely! Here are the current standings!

### Season 10: Week 5 Predictions:

First off, I realize I have been using "finalist" incorrectly, now I have labeled plots as "GBBO Winner" and "GBBO Finalist". The finalist probability is the chance a baker will compete in the final week. 

This week my wife and I paused the show right after Steph was announced star baker and ran the model with the new data. Steph has been starbaker twice and been favored by the judges for two other weeks. Therefore, her standings as a GBBO finalist and series winner is gaining ground with a 46% and 77% chance respectively.  

<img src="https://raw.githubusercontent.com/dantaki/DeepBake/master/FIGURES/s10e5.preds.png" height="500">

For the outright winner, Henry is next in line with a 28% chance and then is David with 17%. Likewise, David is next in line to be a finalist with 70% probability. Then comes Michael (60%). Last week, DeepBake thought Michael would be next on the chopping block with Henry, but both bakers are doing well this week. When it comes to predicting who will leave next week, DeepBake made some misses but also some hits. 

As I mentioned, my wife and I entered the new data into the model after Steph was crowned star baker to predict who would leave. This week it was obvious two bakers had to go, so looking at the model Priya was heads above all with 27% chance of leaving. Following her was Helena with 15% chance to leave. The chances for the remaining bakers quickly decay with probabilities less than 3%. 

Priya was not eliminated, but you have to admit she probably should have been. Helena was eliminated and so was Michelle. If we look at the 5th to 7th place predictions, which we should since we are at the point of the series to use that score to predict who might leave the tent, we see Michelle and Helena with 71% and 63% probability respectively. Next up is Pryia with a 55% chance to leave; Rosie and Alice tail her with 36% and 33% chances. 

-------------------------

#### Season 10: Week 4 Predictions

What can I say, even Neural Networks make mistakes. The top baker prediction now thinks Rosie is in the lead with 23% chance, with Alice following behind her with a 18% chance. Something about Alice is really making the model put her at the top, which I don't really agree with. 

Anyhoo, the finalist (top 3 bakers) predictions seem to make more sense with Steph (75%), David (64%), and Rosie (43%). Alice is still up there and so is Michael. 

<img src="https://raw.githubusercontent.com/dantaki/DeepBake/master/FIGURES/s10e4.preds.png" height="750">

As for the bottom bakers, last week the model said Henry had a good chance of leaving and he did have some pretty hard bakes in week 4. However, Phil was eliminated and the week 3 model did not put him anywhere near the bottom... So DeepBake got it wrong in week 3. But the week 4 predictions put him right at the bottom, which means if I were to pause the show right after the judges reveal who is star baker and input all the data needed for DeepBake, the model would have made a correct prediction that Phil would leave.

Henry is slated to leave again with a 30% chance, not sure why Henry is not favored by the model too. Oddly, Michael is right behind him, probably because he got an unfavorable status from the judges in week 4. Priya is next and so is Michelle, which makes sense to me. 

---------------------------------------


#### Season 10: Week 3 Predictions

DeepBake now thinks Alice hasn't proven herself and her standing has slid to danger territory ([week 2](https://github.com/dantaki/DeepBake/blob/master/README.md#finalist-prediction)). David is now the most likely winner and Steph jumped up in the rankings. 

As for the finalists (top 3 bakers), Michael has a 67% chance of baking in the final, DeepBake thinks Steph has a 59% chance and David a 
47% chance. 

DeepBake in week 2 gave Amelia a 48% of being in the bottom tier, right behind the two eliminated bakers Dan and Jamie. In week 3 Amelia was eliminated, which is bad news for her but great news for DeepBake! 

<img src="https://raw.githubusercontent.com/dantaki/DeepBake/master/FIGURES/s10e3.preds.png" height="750">

For remaining bakers in week 3, Amelia was at the top of the ranking for the bottom tier with a 43% probabiliy. Next is Henry, (winner of the bap technical) with a 36% probability. Following him is a tight pack led by Priya with Helena, Michelle, and Alice following her, all with probability scores between 23-20%. 

--------------
#### Season 10 : Week 2 Predictions

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

In fact, DeepBake can make a prediction before the judges eliminate a baker. These results suggest DeepBake correctly predicted Jamie would leave the tent!

----------------------------------------

### Stay tuned for Week 4! 
