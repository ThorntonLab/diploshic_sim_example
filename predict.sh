#!/bin/bash

~/src/discoal/discoal 50 1 1000 -ws 0 -a 1000 -x 0.9 -t 1000 -r 1000 > data.discoal
python3 diploSHIC.py fvecSim haploid data.discoal data_orig.txt
python3 add_fake_columns.py data_orig.txt data.txt
python3 diploSHIC.py predict modelfile.txt.json  modelfile.txt.weights.hdf5 data.txt data.pred

