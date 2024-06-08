#!/bin/bash

MODEL_DIR="/Users/smb-uh/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/"


SO_DIR="${MODEL_DIR}CMIP5/so/"
THETAO_DIR="${MODEL_DIR}CMIP5/thetao/"
RHO_DIR="${MODEL_DIR}CMIP5/rhopoto/"

int_levels="2.5000000,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,182.5,200,220,240,260,280,300,320,340,360,380,400,420,440,462.5,500,550,600,650,700,750,800"

# THETAO_DIR='/Users/smb-uh/Dropbox/Data/Model_Output/CMIP5/thetao/'

# eval cd $RHO_DIR
# echo "Directory changed to $RHO_DIR"

# for i in rhopoto_Omon_*.nc; do
#     cdo selyear,2010/2019 "$i" temp.nc
#         echo "Starting $i"
#    if [[ "$i" == *"MRI"* ]]; then

#  #   if [[ "$i" == *"CNRM"*  ||  "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
# #	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
# 	cdo setctomiss,0 temp.nc temp2.nc
# 	mv temp2.nc temp.nc
#     fi

#     cdo intlevel,5,10,15,20,25,30,35,40,45,50,60,70,80,90,100,120,140,160,180,200,250,300,350,400,450,500,550,600,700,800,900,1000 temp.nc temp2.nc
#     mv temp2.nc temp.nc # removes new temporary file

#     cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
#     mv temp2.nc temp.nc # removes new temporary file

#     cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
#     mv temp2.nc temp.nc # removes new temporary file
    
#     cdo remapbil,r360x180 temp.nc regrid/"$i"
#     rm temp.nc
# done


eval cd $SO_DIR
echo "Directory changed to $SO_DIR"

for i in so_Omon_*.nc; do
    cdo selyear,2010/2019 "$i" temp.nc
        echo "Starting $i"
   if [[ "$i" == *"MRI"* ]]; then

 #   if [[ "$i" == *"CNRM"*  ||  "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
#	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi

#    cdo intlevel,5,10,15,20,25,30,35,40,45,50,60,70,80,90,100,120,140,160,180,200,250,300,350,400,450,500,550,600,700,800,900,1000 temp.nc temp2.nc

    cdo intlevel,level="$int_levels" temp.nc temp2.nc
    mv temp2.nc temp.nc # removes new temporary file

    # cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    # mv temp2.nc temp.nc # removes new temporary file

    # cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    # mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid_for_MLD/"$i"
    rm temp.nc
done


eval cd $THETAO_DIR
echo "Directory changed to $THETAO_DIR"

for i in thetao_Omon_*.nc; do
    cdo selyear,2010/2019 "$i" temp.nc
        echo "Starting $i"

    if [[ "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
	
    # cdo intlevel,5,10,15,20,25,30,35,40,45,50,60,70,80,90,100,120,140,160,180,200,250,300,350,400,450,500,550,600,700,800,900,1000 temp.nc temp2.nc
    cdo intlevel,level="$int_levels" temp.nc temp3.nc
    cp temp3.nc temp.nc # keeps temp 3, but copies it to temp.nc. will use temp3 for the tim_mean version later

    # cdo timmean temp.nc temp2.nc
    # mv temp2.nc temp.nc # removes new temporary file

    # cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    # mv temp2.nc temp.nc # removes new temporary file

    # cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    # mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid_for_MLD/"$i"
    rm temp.nc

    # calculate a time mean version for matlab ingestion
    cdo timmean temp3.nc temp2.nc
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc 
    rm temp3.nc
done
