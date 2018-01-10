#!/bin/bash
./medias.awk lat.dat | sort -gk 1 > lat2.dat
./medias.awk trans.dat | sort -gk 1 > trans2.dat
