#!/bin/bash
function extrai(){
	KIND=$(file $FILE | cut -d ':' -f2 | cut -c 1-5)
	if [ "$KIND" = " bzip" ];then                         
		echo "[-] bzip detect"                
		echo "[+] Starting routine"           
		until [ "$KIND" != " bzip" ];do               
			OLD=$FILE                             
			FILE=`tar -xjvf "$FILE"`              
			KIND=$(file $FILE | cut -d: -f2 | cut -c 1-5) 
			rm $OLD                               
		done
	elif [ "$KIND" = " gzip" ];then                  
        	echo "[-] gzip detect"                 
                echo "[+] Starting routine"            
                until [ "$KIND" != " gzip" ];do        
                	OLD=$FILE                     
                        FILE=`tar -xzvf "$FILE"`       
	                KIND=$(file $FILE | cut -d: -f2 | cut -c 1-5)
	                rm $OLD
                done                                   
          else                                          
                echo "Error in Extraction"
		exit 0
                                                                     
	fi
	echo "[*] Done!"                      

}
function compacta(){
	OLD=$FILE
	counter=0
	if [ $J ];then                     
		while [ $counter -le $N ];do
			counter=$(( counter+1)) 
			NEW=`echo $OLD | md5sum | cut -d " " -f 1` 
			tar -cjvf "$NEW" "$OLD"       
			rm `echo $OLD`                
			OLD=$NEW 
		 done                        
                          
	elif [ $Z ];then             
		while [ $counter -le $N ];do
			counter=$(( counter+1)) 
			NEW=`echo $OLD | md5sum | cut -d " " -f 1` 
			tar -czvf "$NEW" "$OLD"       
			rm `echo $OLD`                
			OLD=$NEW  
		done                          
	else
		echo "Sorry"
		exit 0                                    
	fi                                            

}

if [ $# -ge 3 ];then
	while getopts ecjzn:f: OPT;do
		case "${OPT}" in
			e) EXTRAI=1;;
			c) COMP=1;;
			j) J=1;;
			z) Z=1;;
			n) N=${OPTARG};;
			f) FILE=${OPTARG};;
		esac
	done
	if [ ! -z $EXTRAI ];then

		extrai

	elif [ ! -z $COMP ];then
		compacta
	else 
		echo "Error"	
	fi
else
	echo "Usage: 	-e extrait 
			-c compactar 
				-j Bzip 
				-z Gzip
				-n valor	
	     Example: To Extract: $0 -e -f  <file_name>
		      To Compact: $0 -c -j -f <file_name> -n 200"
	exit 0
fi
