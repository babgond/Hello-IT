#!/bin/bash

#  Display MDM status
#
#  Title: MDM enrollement
#  Tooltip: DEP status
#  On-click: /
#
#  Status:
#    Green  - MDM Enrolled if macos 
#    Red - NO MDM Enrolled if macos 
#
#  Created by babgond
#
#  Written: 27/05/2018
#  Updated: 29/05/2018
#
### The following line load the Hello IT bash script lib
. "$HELLO_IT_SCRIPT_SH_LIBRARY/com.github.ygini.hello-it.scriptlib.sh"

function onClickAction {
  setTitleAction "$@"
}

function fromCronAction {
   setTitleAction "$@"
}

function setTitleAction {
  minor_version="$(sw_vers -productVersion | awk -F. '{print $2}')"
  patch_version="$(sw_vers -productVersion | awk -F. '{print $3}')"
  if [ $minor_version -ge "13" -a $patch_version -ge "4" ] || [ $minor_version -gt "13" ]
	then
 	 DEPstatus="$(profiles status -type enrollment | grep "Enrolled via DEP" | awk '{print $4}')"
	 MDMStatus="$(profiles status -type enrollment | grep "MDM enrollment" | awk '{print $3}')"
	 updateTitle "MDM : $MDMStatus"
		if [ $MDMStatus == "Yes" -o "Yes (User Approved)" ]
		then
	 	 updateState "${STATE[0]}"
		 updateTooltip "DEP : $DEPstatus"
		else 
		 updateState "${STATE[2]}"
         updateTooltip "pas de MDM decteté"
		fi
	else	
	MDMStatus="$(profiles -C | awk '{print $1$2$3}')"
		if [ $MDMStatus == "Thereareno" ]
		then
    	  updateTitle "MDM : non"
		  updateState "${STATE[2]}"
    	  updateTooltip "pas de MDM installé"
    	 else
    	 	updateTitle "MDM : oui"
		  updateState "${STATE[0]}"
    	  updateTooltip "pour le DEP il faut 10.13.4"
     	fi
	fi
  setEnabled YES
}
### The only things to do outside of a bash function is to call the main function defined by the Hello IT bash lib.
main "$@"

exit 0
