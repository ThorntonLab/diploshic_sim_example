#!/bin/bash
# Super-quick haploid example

# Neutral training data
mspms 50 50 -t 1000 -r 1000 10000 > neutral_data_msprime.txt


# You have to make and maintain all the directories yourself:
if [ ! -d hardTraining ]
then 
    mkdir hardTraining
else
    rm -f hardTraining/*
fi

if [ ! -d softTraining ]
then 
    mkdir softTraining
else
    rm -f softTraining/*
fi


WIN=0
if [ -e simcommands.txt ]
then
    rm -f simcommands.txt
fi
if [ -e fveccommands.txt ]
then
    rm -f fveccommands.txt
fi
for x in $(seq 0 0.1 1)
do
    # Make selected data
    echo "~/src/discoal/discoal 50 50 1000 -ws 0 -a 1000 -x $x -t 1000 -r 1000 > hard_$WIN.discoal" >> simcommands.txt
    echo "~/src/discoal/discoal 50 50 1000 -ws 0 -a 1000 -x $x -f 0.1 -t 1000 -r 1000 > soft_$WIN.discoal" >> simcommands.txt
    #The file names cannot have multiple _ in them
    echo "python3 diploSHIC.py fvecSim haploid hard_$WIN.discoal hardTraining/hard_$WIN.txt" >> fveccommands.txt
    echo "python3 diploSHIC.py fvecSim haploid soft_$WIN.discoal softTraining/soft_$WIN.txt" >> fveccommands.txt
    WIN=$(($WIN+1))
done

# Make the features from neutral data
echo "python3 diploSHIC.py fvecSim haploid neutral_data_msprime.txt neutral_data_msprime_features.txt" >> fveccommands.txt

parallel --jobs 8 < simcommands.txt
parallel --jobs 8  < fveccommands.txt


if [ ! -d training_out ]
then
    mkdir training_out
else 
    rm -f training_out/*
fi

python3 diploSHIC.py makeTrainingSets neutral_data_msprime_features.txt hardTraining/hard softTraining/soft 5 0,1,2,3,4,6,7,8,9,10 training_out
    
python3 diploSHIC.py train training_out/ training_out/ modelfile.txt

# As of Aug 22, things work for KRT up until now.

# Attempting to get a real data set analyzed is failing for me.
# My attempt is:
bash predict.sh
