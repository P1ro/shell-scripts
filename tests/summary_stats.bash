#!/bin/bash

# summary_stats.bash works in the following manner:
# 1) ./batspp_report.py -k (regenerates all KCOV dirs and output in HTML)
# 2) ./kcov_result.py --list --export (returns result according to the KCOV outputs) 
# 3) Output of the process is also stored in ./summary_stats.txt
<<<<<<< HEAD
# BUG: Might fail on first run

./batspp_report.py -k && ./kcov_result.py --list --summary --export | tee summary_stats.txt
=======

./batspp_report.py -k && ./kcov_result.py --export | tee summary_stats.txt
>>>>>>> integration-testing-3fa2c13