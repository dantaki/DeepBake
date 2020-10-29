#!/bin/sh
WEEK=$1
perl ../src/reformat_badseasons.pl episodes_s11.txt  >tmp; mv tmp episodes_s11.txt
perl src/get_technical_features.pl
perl -pi -e 's/\r//g' starbaker_s11_e*
perl src/get_judge_features.pl $WEEK 
