#!/bin/bash

SOSE_133_DIR="/Users/smb-uh/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/SOSE/2013-2018_ITER133_1_6deg/"
# SOSE_122_DIR='/Users/smb-uh/Dropbox/Data/Model_Output/SOSE/2013-2017v2_ITER122_1_6deg/'

eval cd $SOSE_133_DIR

# 4d variables
# DIC
Echo "starting DIC"
for i in bsose*DIC.nc; do
cdo intlevel,level=-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc

done

#ALK
Echo "starting ALK"
for i in bsose*Alk.nc; do
cdo intlevel,-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

# NPP
Echo "starting NPP"
for i in bsose*NPP.nc; do
cdo intlevel,-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc

done




# SAL
Echo "starting SAL"
for i in bsose*Salt.nc; do
# cdo intlevel,-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc
cdo intlevel,level=-5,-10,-15,-20,-25,-30,-35,-40,-45,-50,-60,-70,-80,-90,-100,-120,-140,-160,-180,-200,-250,-300,-350,-400,-450,-500,-550,-600,-700,-800,-900,-1000 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

# SST
Echo "starting SST"
for i in bsose*Theta.nc; do
# cdo intlevel,-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc
cdo intlevel,level=-5,-10,-15,-20,-25,-30,-35,-40,-45,-50,-60,-70,-80,-90,-100,-120,-140,-160,-180,-200,-250,-300,-350,-400,-450,-500,-550,-600,-700,-800,-900,-1000 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

# surface variables
Echo "starting pCO2"
for i in bsose*pCO2.nc; do
cdo setctomiss,0 "$i" temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

Echo "starting CO2 Flux"
for i in bsose*surfCO2flx.nc; do
cdo setctomiss,0 "$i" temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

Echo "starting O2 Flux"
for i in bsose*surfO2flx.nc; do
cdo setctomiss,0 "$i" temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

Echo "starting MLD"
for i in bsose*MLD.nc; do
    
cdo setctomiss,0 "$i" temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done

