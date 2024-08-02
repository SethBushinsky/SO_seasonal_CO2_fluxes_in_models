#!/bin/bash

# MODEL_DIR="/Users/sethbushinsky/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/"
MODEL_DIR="/Users/smb-uh/UHM_Ocean_BGC_Group\ Dropbox/Datasets/Model_Output/"

FGCO2_C6_DIR="${MODEL_DIR}CMIP6/fgco2/"
DIC_MON_DIR="${MODEL_DIR}CMIP6/dissic/monthly/"
DIC_DIR="${MODEL_DIR}CMIP6/dissic/"

TALK_MON_DIR="${MODEL_DIR}CMIP6/talk/monthly/"
TALK_DIR="${MODEL_DIR}CMIP6/talk/"


SOS_DIR="${MODEL_DIR}CMIP6/sos/"
TOS_DIR="${MODEL_DIR}CMIP6/tos/"

SPCO2_DIR="${MODEL_DIR}CMIP6/spco2/"
intpp_DIR="${MODEL_DIR}CMIP6/intpp/"

PSL_DIR="${MODEL_DIR}CMIP6/psl/"
ML_DIR="${MODEL_DIR}CMIP6/mlotst/"
WMO_DIR="${MODEL_DIR}CMIP6/wmo/"
THETAO_DIR="${MODEL_DIR}CMIP6/thetao/"
SO_DIR="${MODEL_DIR}CMIP6/so/"


dir_type[0]='historical_download'
dir_type[1]='ssp585_download'

fgco2_flag=false
dic_mon_flag=false
dic_flag=false
talk_mon_flag=false
talk_flag=false
sos_flag=false
tos_flag=false
spco2_flag=false
intpp_flag=false
psl_flag=false
ml_flag=false
wmo_flag=false
thetao_flag=true
so_flag=true

# int_levels="2.5000000,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,182.5,200,220,240,260,280,300,320,340,360,380,400,420,440,462.5,500,550,600,650,700,750,800"
int_levels="2.5,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,182.5,200,220,240,260,280,300,320,340,360,380,400,420,440,462.5,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300,1350,1412.5,1500,1600,1700,1800,1900,1975"


if [ "$fgco2_flag" = true ]
then
    eval cd $FGCO2_C6_DIR
    echo "Directory changed to $FGCO2_C6_DIR "


    for f in ${dir_type[*]}; do
	
	for i in "$f"'/'fgco2_Omon_*.nc; do
            echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc  # select specific years
	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,fgco2 temp.nc regrid/"$i"

	    
	    rm temp.nc
            echo "Finished $i"

	done
    done
fi

if [ "$dic_mon_flag" = true ]
then
    eval cd $DIC_MON_DIR
    echo "Directory changed to $DIC_MON_DIR"

    for f in ${dir_type[*]}; do

	for i in "$f"'/'dissic_*.nc; do
	    echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc
	    levels=$(cdo -s showlevel temp.nc)

	    needs_conversion=false
	    for value in $levels; do
		#echo $value
		test_val=$(echo "scale=0; $value/1" | bc -l)
		#echo $test_val
		if [ $test_val -gt 100 ]; then
		    needs_conversion=true
		    echo "conversion set to true"
		    break
		else
		    break
		fi
	    done

	    if [ "$needs_conversion" = true ]; then
		echo "Depth seems to be in centimeters, converting"
		echo "original levels = $levels"
		
		h=0
		for value in $levels; do
		    v=$(echo "scale=6; $value/100" | bc -l)
		    # echo "$value cm = $v m"
		    if [[ $h -gt 0 ]]; then
			levelsm=$(echo "$levelsm, $v")
		    else
			levelsm=$v
		    fi
		    h=`expr $h + 1`
		done

		cat > zaxis_meter.txt << EOF
zaxistype = depth_below_land
size      = $h
name      = lev
units     = "m" 
levels    = $levelsm
EOF
		cdo -f nc setzaxis,zaxis_meter.txt temp.nc temp2.nc

		new_levels=$(cdo -s showlevel temp2.nc)
		echo "new levels = $new_levels"
		mv temp2.nc temp.nc
	    fi

	    cdo intlevel,10 temp.nc temp2.nc
	    # cdo sellevidx,1 temp.nc temp2.nc
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,dissic temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"

	done
    done
fi

if [ "$dic_flag" = true ]
then
    eval cd $DIC_DIR
    echo "Directory changed to $DIC_DIR"

    for f in ${dir_type[*]}; do

	for i in "$f"'/'dissic*.nc; do
	    echo "Starting $i"
	    

	    cdo selyear,2010/2019 "$i" temp.nc
	    levels=$(cdo -s showlevel temp.nc)

	    needs_conversion=false
	    for value in $levels; do
		#echo $value
		test_val=$(echo "scale=0; $value/1" | bc -l)
		#echo $test_val
		if [ $test_val -gt 100 ]; then
		    needs_conversion=true
		    echo "conversion set to true"
		    break
		else
		    
		    break
		fi
	    done

	    if [ "$needs_conversion" = true ]; then
		echo "Depth seems to be in centimeters, converting"
		echo "original levels = $levels"
		
		h=0
		for value in $levels; do
		    v=$(echo "scale=6; $value/100" | bc -l)
		    # echo "$value cm = $v m"
		    if [[ $h -gt 0 ]]; then
			levelsm=$(echo "$levelsm, $v")
		    else
			levelsm=$v
		    fi
		    h=`expr $h + 1`
		done

		cat > zaxis_meter.txt << EOF
zaxistype = depth_below_land
size      = $h
name      = lev
units     = "m" 
levels    = $levelsm
EOF
		cdo -f nc setzaxis,zaxis_meter.txt temp.nc temp2.nc

		new_levels=$(cdo -s showlevel temp2.nc)
		echo "new levels = $new_levels"
		mv temp2.nc temp.nc
	    fi

	    cdo intlevel,10,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000 temp.nc temp2.nc
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,dissic temp.nc regrid/"$i"
	    rm temp.nc
	    rm temp2.nc
	    echo "Finished $i"

	done
    done
fi

if [ "$tos_flag" = true ]
then
    eval cd $TOS_DIR
    echo "Directory changed to $TOS_DIR"

    for f in ${dir_type[*]}; do

	for i in "$f"'/'tos_Omon_*.nc; do
	    echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc

	    if [[ "$i" == *"INM-CM4-8"* ]]; then
		# CNRM, GISS, and MRI all have land set to "0".  This must be changed prior to regridding
		cdo setctomiss,0 temp.nc temp2.nc
		mv temp2.nc temp.nc
	    fi
	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,tos temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"

	done
    done
fi

if [ "$sos_flag" = true ]
then
    eval cd $SOS_DIR
    echo "Directory changed to $SOS_DIR"

    for f in ${dir_type[*]}; do

	for i in "$f"'/'sos_Omon_*.nc; do
            echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,sos temp.nc regrid/"$i"
	    rm temp.nc
            echo "Finished $i"
	done
    done
fi

if [ "$intpp_flag" = true ]
then
    eval cd $intpp_DIR
    echo "Directory changed to $intpp_DIR"

    for f in ${dir_type[*]}; do

	for i in "$f"'/'intpp_Omon_*.nc; do
            echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,intpp temp.nc regrid/"$i"
	    rm temp.nc
            echo "Finished $i"
	done
    done
fi

if [ "$spco2_flag" = true ]
then
    eval cd $SPCO2_DIR
    echo "Directory changed to $SPCO2_DIR"

    for f in ${dir_type[*]}; do


	for i in "$f"'/'spco2_Omon_*.nc; do
            echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,spco2 temp.nc regrid/"$i"
	    rm temp.nc
            echo "Finished $i"
	done
    done
fi

if [ "$talk_mon_flag" = true ]
then
    eval cd $TALK_MON_DIR
    echo "Directory changed to $TALK_MON_DIR"
    for f in ${dir_type[*]}; do

	for i in "$f"'/'talk_*.nc; do
	    echo "Starting $i"
	    cdo selyear,2010/2019 "$i" temp.nc
		levels=$(cdo -s showlevel temp.nc)

	    needs_conversion=false
	    for value in $levels; do
		#echo $value
		test_val=$(echo "scale=0; $value/1" | bc -l)
		#echo $test_val
		if [ $test_val -gt 100 ]; then
		    needs_conversion=true
		    echo "conversion set to true"
		    break
		else
		    
		    break
		fi
	    done

	    if [ "$needs_conversion" = true ]; then
		echo "Depth seems to be in centimeters, converting"
		echo "original levels = $levels"
		
		h=0
		for value in $levels; do
		    v=$(echo "scale=6; $value/100" | bc -l)
		    # echo "$value cm = $v m"
		    if [[ $h -gt 0 ]]; then
			levelsm=$(echo "$levelsm, $v")
		    else
			levelsm=$v
		    fi
		    h=`expr $h + 1`
		done

		cat > zaxis_meter.txt << EOF
zaxistype = depth_below_land
size      = $h
name      = lev
units     = "m" 
levels    = $levelsm
EOF
		cdo -f nc setzaxis,zaxis_meter.txt temp.nc temp2.nc

		new_levels=$(cdo -s showlevel temp2.nc)
		echo "new levels = $new_levels"
		mv temp2.nc temp.nc
	    fi
	    
	    cdo intlevel,10 temp.nc temp2.nc
	    #cdo sellevidx,1 temp.nc temp2.nc
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,talk temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"
	done
    done
fi

if [ "$talk_flag" = true ]
then
    eval cd $TALK_DIR
    echo "Directory changed to $TALK_DIR"
    for f in ${dir_type[*]}; do

	for i in "$f"'/'talk*.nc; do
	    echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc

	    levels=$(cdo -s showlevel temp.nc)

	    needs_conversion=false
	    for value in $levels; do
		#echo $value
		test_val=$(echo "scale=0; $value/1" | bc -l)
		#echo $test_val
		if [ $test_val -gt 100 ]; then
		    needs_conversion=true
		    echo "conversion set to true"
		    break
		else
		    
		    break
		fi
	    done

	    if [ "$needs_conversion" = true ]; then
		echo "Depth seems to be in centimeters, converting"
		echo "original levels = $levels"
		
		h=0
		for value in $levels; do
		    v=$(echo "scale=6; $value/100" | bc -l)
		    # echo "$value cm = $v m"
		    if [[ $h -gt 0 ]]; then
			levelsm=$(echo "$levelsm, $v")
		    else
			levelsm=$v
		    fi
		    h=`expr $h + 1`
		done

		cat > zaxis_meter.txt << EOF
zaxistype = depth_below_land
size      = $h
name      = lev
units     = "m" 
levels    = $levelsm
EOF
		cdo -f nc setzaxis,zaxis_meter.txt temp.nc temp2.nc

		new_levels=$(cdo -s showlevel temp2.nc)
		echo "new levels = $new_levels"
		mv temp2.nc temp.nc
	    fi
	    
	    cdo intlevel,10,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900,1000,1200,1400,1600,1800,2000 temp.nc temp2.nc
		mv temp2.nc temp.nc

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"
	done
    done
fi

if [ "$psl_flag" = true ]
then
    eval cd $PSL_DIR
    echo "Directory changed to $PSL_DIR"
    for f in ${dir_type[*]}; do

	for i in "$f"'/'psl_*.nc; do
	    echo "Starting $i"
	    cdo selyear,2010/2019 "$i" temp.nc

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo remapbil,r360x180 temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"
	done
    done
fi

if [ "$ml_flag" = true ]
then
    eval cd $ML_DIR
    echo "Directory changed to $ML_DIR"
    for f in ${dir_type[*]}; do

	for i in "$f"'/'mlotst_*.nc; do
	    echo "Starting $i"
	    cdo selyear,2010/2019 "$i" temp.nc

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 -selname,mlotst temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"

	done
    done
fi


if [ "$wmo_flag" = true ]
then
    eval cd $WMO_DIR
    echo "Directory changed to $WMO_DIR"
    for f in ${dir_type[*]}; do

	for i in "$f"'/'wmo*.nc; do
	    echo "Starting $i"

	    cdo selyear,2010/2019 "$i" temp.nc
	    cdo intlevel,10,25,50,75,100,125,150,175,200,300,400,500,600,700,800,900 temp.nc temp2.nc
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file

	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
	    mv temp2.nc temp.nc # removes new temporary file
	    
	    cdo -L remapbil,r360x180 temp.nc regrid/"$i"
	    rm temp.nc
	    echo "Finished $i"

	done
    done
fi

if [ "$so_flag" = true ]
then
    eval cd $SO_DIR
    echo "Directory changed to $SO_DIR"
    for f in ${dir_type[*]}; do

	for i in "$f"'/'so*.nc; do
	    echo "Starting $i"

		cdo sinfov "$i"

		# cdo -delname,name=so "$i" temp.nc
# 	    cdo selyear,2010/2019 "$i" temp.nc


# 		# removing unneeded variables that were causing processing to crash
# 		if [[ "$i" == *"MIROC-ES2L"* ]]; then 
# 		cdo delname,eta temp.nc temp2.nc
# 		mv temp2.nc temp.nc # removes new temporary file
# 		cdo delname,depth temp.nc temp2.nc
# 		mv temp2.nc temp.nc # removes new temporary file
# 		fi
# 		# removing unneeded variables that were causing processing to crash
# 		if [[ "$i" == *"IPSL-CM6A-LR"* ]]; then 
# 		cdo delname,area temp.nc temp2.nc
# 		mv temp2.nc temp.nc # removes new temporary file
# 		fi

# 		levels=$(cdo -s showlevel temp.nc)

# 	    needs_conversion=false
# 	    for value in $levels; do
# 		#echo $value
# 		test_val=$(echo "scale=0; $value/1" | bc -l)
# 		#echo $test_val
# 		if [ $test_val -gt 100 ]; then
# 		    needs_conversion=true
# 		    echo "conversion set to true"
# 		    break
# 		else
		    
# 		    break
# 		fi
# 	    done

# 	    if [ "$needs_conversion" = true ]; then
# 		echo "Depth seems to be in centimeters, converting"
# 		echo "original levels = $levels"
		
# 		h=0
# 		for value in $levels; do
# 		    v=$(echo "scale=6; $value/100" | bc -l)
# 		    # echo "$value cm = $v m"
# 		    if [[ $h -gt 0 ]]; then
# 			levelsm=$(echo "$levelsm, $v")
# 		    else
# 			levelsm=$v
# 		    fi
# 		    h=`expr $h + 1`
# 		done

# 		cat > zaxis_meter.txt << EOF
# zaxistype = depth_below_land
# size      = $h
# name      = lev
# units     = "m" 
# levels    = $levelsm
# EOF
# 		cdo -f nc setzaxis,zaxis_meter.txt temp.nc temp2.nc

# 		new_levels=$(cdo -s showlevel temp2.nc)
# 		echo "new levels = $new_levels"
# 		mv temp2.nc temp.nc
# 	    fi

#     	cdo intlevel,level="$int_levels" temp.nc temp2.nc
# 	    mv temp2.nc temp.nc # removes new temporary file

# 	    # cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
# 	    # mv temp2.nc temp.nc # removes new temporary file

# 	    # cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
# 	    # mv temp2.nc temp.nc # removes new temporary file
	    
# 	    cdo -L remapbil,r360x180 temp.nc regrid_for_MLD/"$i"
# 	    rm temp.nc
# 	    echo "Finished $i"

	done
    done
fi

if [ "$thetao_flag" = true ]
then

    eval cd $THETAO_DIR
    echo "Directory changed to $THETAO_DIR"
    for f in ${dir_type[*]}; do

	for i in  "$f"'/'thetao_Omon_*.nc; do
	    echo "Starting $i"

		cdo sinfov "$i"
		# cdo delname," thetao" "$i" temp.nc

# 	    cdo selyear,2010/2019 "$i" temp.nc
# 		levels=$(cdo -s showlevel temp.nc)

# 	    needs_conversion=false
# 	    for value in $levels; do
# 		#echo $value
# 		test_val=$(echo "scale=0; $value/1" | bc -l)
# 		#echo $test_val
# 		if [ $test_val -gt 100 ]; then
# 		    needs_conversion=true
# 		    echo "conversion set to true"
# 		    break
# 		else
		    
# 		    break
# 		fi
# 	    done

# 	    if [ "$needs_conversion" = true ]; then
# 		echo "Depth seems to be in centimeters, converting"
# 		echo "original levels = $levels"
		
# 		h=0
# 		for value in $levels; do
# 		    v=$(echo "scale=6; $value/100" | bc -l)
# 		    # echo "$value cm = $v m"
# 		    if [[ $h -gt 0 ]]; then
# 			levelsm=$(echo "$levelsm, $v")
# 		    else
# 			levelsm=$v
# 		    fi
# 		    h=`expr $h + 1`
# 		done

# 		cat > zaxis_meter.txt << EOF
# zaxistype = depth_below_land
# size      = $h
# name      = lev
# units     = "m" 
# levels    = $levelsm
# EOF
# 		cdo -f nc setzaxis,zaxis_meter.txt temp.nc temp2.nc

# 		new_levels=$(cdo -s showlevel temp2.nc)
# 		echo "new levels = $new_levels"
# 		mv temp2.nc temp.nc
# 	    fi

# 	    # cdo intlevel,12,25,50,75,100,125,150,175,200,250,300,350,400 temp.nc temp2.nc
#     	cdo intlevel,level="$int_levels" temp.nc temp3.nc
# 		cp temp3.nc temp.nc # keeps temp 3, but copies it to temp.nc. will use temp3 for the tim_mean version later

# 	    # mv temp2.nc temp.nc # removes new temporary file

# 	    # cdo timmean temp.nc temp2.nc
# 	    # mv temp2.nc temp.nc # removes new temporary file

# 	    # cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
# 	    # mv temp2.nc temp.nc # removes new temporary file

# 	    # cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
# 	    # mv temp2.nc temp.nc # removes new temporary file
	    
# 	    cdo -L remapbil,r360x180 -selname,thetao temp.nc regrid_for_MLD/"$i"
# 	    rm temp.nc

# 	    # calculate a time mean version for matlab ingestion
# 		cdo timmean temp3.nc temp2.nc
# 	    mv temp2.nc temp.nc # removes new temporary file

# 	    cdo -setcalendar,'proleptic_gregorian' temp.nc temp2.nc # changes date format to matlab date format
# 	    mv temp2.nc temp.nc # removes new temporary file

# 	    cdo -setreftime,'0000-01-00','00:00:00' temp.nc temp2.nc # changes date format to matlab date format
# 	    mv temp2.nc temp.nc # removes new temporary file
	    
# 	    cdo -L remapbil,r360x180 -selname,thetao temp.nc regrid/"$i"
# 	    rm temp.nc
# 		rm temp3.nc
# 	    echo "Finished $i"

	done
    done
fi
