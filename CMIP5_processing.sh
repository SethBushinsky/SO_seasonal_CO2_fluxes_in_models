#!/bin/bash

# MODEL_DIR="/Users/smb-uh/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/"
MODEL_DIR="/Users/sethbushinsky/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/"

DIC_DIR="${MODEL_DIR}CMIP5/dissic/"
DIC_MON_DIR="${MODEL_DIR}CMIP5/dissic/monthly/"

FGCO2_DIR="${MODEL_DIR}CMIP5/fgco2/"

SPCO2_DIR="${MODEL_DIR}CMIP5/spco2/"
intpp_DIR="${MODEL_DIR}CMIP5/intpp/"

SOS_DIR="${MODEL_DIR}CMIP5/sos/"
TOS_DIR="${MODEL_DIR}CMIP5/tos/"

TALK_MON_DIR="${MODEL_DIR}CMIP5/talk/monthly/"
TALK_DIR="${MODEL_DIR}CMIP5/talk/"

PSL_DIR="${MODEL_DIR}CMIP5/psl/"
ML_DIR="${MODEL_DIR}CMIP5/mlotst/"

WMO_DIR="${MODEL_DIR}CMIP5/wmo/"



eval cd $TOS_DIR
echo "Directory changed to $TOS_DIR"

for i in tos_Omon_*.nc; do
    cdo selyear,2010/2019 "$i" temp.nc
        echo "Starting $i"
   if [[ "$i" == *"MRI"* ]]; then

 #   if [[ "$i" == *"CNRM"*  ||  "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
#	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done

eval cd $SOS_DIR
echo "Directory changed to $SOS_DIR"

for i in sos_Omon_*.nc; do
            echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc
    # if [[ "$i" == *"MRI"* ]]; then
 #   if [[ "$i" == *"CNRM"*  ||  "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
#	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	# cdo setctomiss,0 temp.nc temp2.nc
	# mv temp2.nc temp.nc
    # fi

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done

for i in so_Omon_*.nc; do #MRI-ESM1 only has so available. Has 51 depth levels, going to just interpolate to 10
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

   if [[   "$i" == *"MRI"* ]]; then
#	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    cdo intlevel,10 temp.nc temp2.nc
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done


eval cd $intpp_DIR
echo "Directory changed to $intpp_DIR"

for i in intpp_Omon_*.nc; do
            echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

    if [[ "$i" == *"CNRM"*  ||  "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done

eval cd $SPCO2_DIR
echo "Directory changed to $SPCO2_DIR"

for i in spco2_Omon_*.nc; do
            echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

    if [[ "$i" == *"GISS"*  ||   "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    
    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done

eval cd $FGCO2_DIR
echo "Directory changed to $FGCO2_DIR"

for i in fgco2_Omon_*.nc; do
            echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc
    if [[ "$i" == *"MIROC"* ]]; then
	# MIROC has land set to ~3e-13.  This must be changed prior to regridding
	cdo setrtomiss,-4e-13,4e-13 temp.nc temp2.nc
	mv temp2.nc temp.nc
    elif [[ "$i" == *"CNRM"*  ||  "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
 
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done


eval cd $DIC_MON_DIR
echo "Directory changed to $DIC_MON_DIR"

for i in dissic_*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

    if [[ "$i" == *"CNRM"* || "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
	
    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc

done


eval cd $DIC_DIR
echo "Directory changed to $DIC_DIR"

for i in dissic*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

    if [[ "$i" == *"CNRM"* || "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    cdo intlevel,10,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000 temp.nc temp2.nc

    cdo -setcalendar,'proleptic_gregorian' temp2.nc temp3.nc # changes date format to matlab date format
    mv temp3.nc temp2.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp2.nc temp3.nc # changes date format to matlab date format
    mv temp3.nc temp2.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp2.nc regrid/"$i"
    rm temp.nc
    rm temp2.nc
done

eval cd $TALK_MON_DIR
echo "Directory changed to $TALK_MON_DIR"

for i in talk_*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc
    if [[ "$i" == *"CNRM"* || "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc

done


eval cd $TALK_DIR
echo "Directory changed to $TALK_DIR"

for i in talk*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc
    if [[ "$i" == *"CNRM"* || "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    cdo intlevel,10,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000 temp.nc temp2.nc

    cdo -setcalendar,'proleptic_gregorian' temp2.nc temp3.nc # changes date format to matlab date format
    mv temp3.nc temp2.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp2.nc temp3.nc # changes date format to matlab date format
    mv temp3.nc temp2.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp2.nc regrid/"$i"
    rm temp.nc
    rm temp2.nc
done


eval cd $PSL_DIR
echo "Directory changed to $PSL_DIR"

for i in psl_Amon_*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done

eval cd $ML_DIR
echo "Directory changed to $ML_DIR"

for i in mlotst_Omon_*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc

    if [[ "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
	
    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
    mv temp2.nc temp.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp.nc regrid/"$i"
    rm temp.nc
done


eval cd $WMO_DIR
echo "Directory changed to $WMO_DIR"

for i in wmo*.nc; do
    echo "Starting $i"

    cdo selyear,2010/2019 "$i" temp.nc
    if [[ "$i" == *"GISS"*  ||  "$i" == *"MRI"* ]]; then
	# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
	cdo setctomiss,0 temp.nc temp2.nc
	mv temp2.nc temp.nc
    fi
    
    cdo intlevel,12,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900 temp.nc temp2.nc

    cdo -setcalendar,'proleptic_gregorian' temp2.nc temp3.nc # changes date format to matlab date format
    mv temp3.nc temp2.nc # removes new temporary file

    cdo -setreftime,'0000-01-00','00:00:00' temp2.nc temp3.nc # changes date format to matlab date format
    mv temp3.nc temp2.nc # removes new temporary file
    
    cdo remapbil,r360x180 temp2.nc regrid/"$i"
    rm temp.nc
    rm temp2.nc
done

#cdo remapbil,r360x180 dissic_Oyr_GFDL-ESM2M_rcp85_r1i1p1_2006-2020.nc test_gfdl_remap.nc
