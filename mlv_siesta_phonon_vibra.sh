#!/bin/bash

#======================================================#
#Script:mlv_siesta_phonon_vibra for phonon  vibra run  #
#======================================================#
# Author: Mohan L Verma,                               #
#        Computational Nanoionics Research lab,        #  
#        Department of Applied Physics,                #
#        SSGI, Shri Shanakaracharya Technical          # 
#        Campus-Junwani Bhilai(Chhattisgarh)  INDIA    #
#        Aug 2021 ver-1                                #
# Commands to run this example:                        #
# $ sh mlv_siesta_phonon_vibra.sh                      #
# make sure      #
#===================================================== #
#                                                      #
# Before runing the script make sure that *.psf files  # 
# are there with this script and vibra tools           #
#  are compilled. If not use following commands :      #
# $ cd ~/siesta-master/Util/Vibra/Src                  #                 
# $ make 						 #
# $ sudo cp fcbuild /usr/local/bin/			 #
# $ sudo cp vibra /usr/local/bin/			 #
#======================================================#

mkdir phonon_run
cd phonon_run
cp ../*.psf .
head="

SystemName          CoO
SystemLabel         CoO

NumberOfAtoms       8

LatticeConstant             1.00 Ang

%block LatticeVectors
    20.000006      0.000000      0.000000
     0.000000      3.204288      0.000000
     0.000000      0.000000     11.098955
%endblock LatticeVectors

AtomicCoordinatesFormat  ScaledCartesian 

%block AtomicCoordinatesAndAtomicSpecies
 10.059434	0.855402	10.224547	1	15.99900  # pls don't forget to mention atomic mass of spicies in the last column 
9.962389	0.746552	0.978779	2	58.93320
9.940241	2.353255	1.900797	1	15.99900
10.038266	2.348496	3.755938	2	58.93320
10.059535	0.747694	4.676255	1	15.99900
9.961712	0.753064	6.530428	2	58.93320
9.940371	2.352450	7.450791	1	15.99900
10.037074	2.459841	9.301408	2	58.93320
%endblock AtomicCoordinatesAndAtomicSpecies

Eigenvectors         True 
AtomicDispl          0.04  Bohr

"
#Depending on the types of your sample and computational power you can select different supercells. But remeber that to avoid negative 
# frequency output in phonon band plot use suffcient numbers of supercells. 

sup_cell="
SuperCell_1	 1
SuperCell_2     1
SuperCell_3     1
"

phonon_bands="
  
BandLinesScale ReciprocalLatticeVectors

%block BandLines
1	   0.0000000000     0.0000000000     0.0000000000     GM
40	   0.5000000000     0.5000000000     0.0000000000     K
50	   0.5000000000     0.5000000000    -0.5000000000     M
60	   0.0000000000     0.0000000000     0.0000000000     GM
%endblock Bandlines
"

head_siesta="
 
SystemName          CoO
SystemLabel         CoO

NumberOfSpecies     2

%block ChemicalSpeciesLabel
  1   8  O
  2  27  Co
%endblock ChemicalSpeciesLabel


PAO.BasisSize     SZ

MD.MaxForceTol    0.005  eV/Ang
MeshCutoff       450 Ry                 
DM.MixingWeight   0.001
DM.NumberPulay   5
MaxSCFIterations    20           # you can take more numbers if converegence is proper not taking time 
SCF.MustConverge     .false.     # if you have good computational facility then keep this as true.
 
%include FC.fdf
" 
 
echo "$head" >> fc_vibra.fdf
echo "$sup_cell" >> fc_vibra.fdf
echo "$phonon_bands" >> fc_vibra.fdf
echo "$head_siesta" >> phonon_vibra.fdf 
fcbuild <fc_vibra.fdf
mpirun -np 6 siesta phonon_vibra.fdf | tee phonon_vibra.out
vibra<fc_vibra.fdf
gnubands -F *.bands> phonon_bands.dat
xmgrace phonon_bands.dat
cd ..

  
#you can give feedback in:-
# drmohanlv@gmail.com  OR  9303452648  
# we can also disscuss some problem regarding to this."
#================================================================================================
 
 
 
 
