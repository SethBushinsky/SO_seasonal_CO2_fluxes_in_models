#!/bin/bash

# SOSE_DIR="/Users/smb-uh/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/SOSE/2013-2018_ITER133_1_6deg/"
SOSE_DIR="/Users/smb-uh/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/SOSE/2013-2023_ITER154/"

# SOSE_122_DIR='/Users/smb-uh/Dropbox/Data/Model_Output/SOSE/2013-2017v2_ITER122_1_6deg/'

fgco2_flag=false
dic_mon_flag=false
talk_mon_flag=false
spco2_flag=false
intpp_flag=true
ml_flag=false
thetao_flag=false
salt_flag=false
fgo2_flag=false

eval cd $SOSE_DIR
echo "Directory changed to $SOSE_DIR"



# 4d variables
# DIC
if [ "$dic_mon_flag" = true ]
then
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
fi

#ALK
if [ "$talk_mon_flag" = true ]
then
Echo "starting ALK"
for i in bsose*Alk.nc; do
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
fi

# NPP
if [ "$intpp_flag" = true ]
then
Echo "starting NPP"
for i in bsose*NPP.nc; do
# cdo intlevel,level=-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc
cdo intlevel,level=-10,-25,-50,-75,-100,-125,-150,-175,-200 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done
fi

# SAL
if [ "$salt_flag" = true ]
then
    Echo "starting SAL"
    for i in bsose*Salt.nc; do
    # cdo intlevel,-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc
    # cdo intlevel,level=-5,-10,-15,-20,-25,-30,-35,-40,-45,-50,-60,-70,-80,-90,-100,-120,-140,-160,-180,-200,-250,-300,-350,-400,-450,-500,-550,-600,-700,-800,-900,-1000 "$i" temp.nc
    cdo intlevel,level=-2.5,-10,-20,-30,-40,-50,-60,-70,-80,-90,-100,-110,-120,-130,-140,-150,-160,-170,-182.5,-200,-220,-240,-260,-280,-300,-320,-340,-360,-380,-400,-420,-440,-462.5,-500,-550,-600,-650,-700,-750,-800,-850,-900,-950,-1000,-1050,-1100,-1150,-1200,-1250,-1300,-1350,-1412.5,-1500,-1600,-1700,-1800,-1900,-1975 "$i" temp.nc

    cdo setctomiss,0 temp.nc temp2.nc
    mv temp2.nc temp.nc

    # cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    # mv temp2.nc temp.nc

    # cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
    # mv temp2.nc temp.nc # removes new temporary file

    cdo remapbil,r360x180 temp.nc regrid_for_MLD/"$i"
    rm temp.nc

    # redo to get surface salinity
    cdo intlevel,level=-10 "$i" temp.nc

    cdo setctomiss,0 temp.nc temp2.nc
    mv temp2.nc temp.nc

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc

    cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
    done
fi

# SST
if [ "$thetao_flag" = true ]
then
Echo "starting SST"
for i in bsose*Theta.nc; do
# cdo intlevel,-10,-25,-50,-75,-100,-125,-150,-175,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1200,-1400,-1600,-1800,-2000 "$i" temp.nc
# cdo intlevel,level=-5,-10,-15,-20,-25,-30,-35,-40,-45,-50,-60,-70,-80,-90,-100,-120,-140,-160,-180,-200,-250,-300,-350,-400,-450,-500,-550,-600,-700,-800,-900,-1000 "$i" temp.nc
cdo intlevel,level=-2.5,-10,-20,-30,-40,-50,-60,-70,-80,-90,-100,-110,-120,-130,-140,-150,-160,-170,-182.5,-200,-220,-240,-260,-280,-300,-320,-340,-360,-380,-400,-420,-440,-462.5,-500,-550,-600,-650,-700,-750,-800,-850,-900,-950,-1000,-1050,-1100,-1150,-1200,-1250,-1300,-1350,-1412.5,-1500,-1600,-1700,-1800,-1900,-1975 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

# cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
# mv temp2.nc temp.nc

# cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
# mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid_for_MLD/"$i"
rm temp.nc

cdo intlevel,level=-2.5,-10,-20,-50,-100,-200,-300,-400 "$i" temp.nc

cdo setctomiss,0 temp.nc temp2.nc
mv temp2.nc temp.nc

cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc

cdo -setreftime,'0000-01-00','00:00:00','days' temp.nc temp2.nc # changes date format to matlab date format
mv temp2.nc temp.nc # removes new temporary file

cdo remapbil,r360x180 temp.nc regrid/"$i"
rm temp.nc
done
fi


# surface variables
if [ "$spco2_flag" = true ]
then
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
fi

if [ "$fgco2_flag" = true ]
then
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
fi

if [ "$fgo2_flag" = true ]
then
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
fi

if [ "$ml_flag" = true ]
then
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
fi

