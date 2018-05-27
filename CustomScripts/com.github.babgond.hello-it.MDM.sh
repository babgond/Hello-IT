#!/bin/bash

#  Display MDM status
#
#  Title: MDM enrollement
#  Tooltip: DEP status
#  On-click: /
#
#  Status:
#    Green  - MDM Enrolled if macos >= 10.12.3
#    Red - NO MDM Enrolled if macos >= 10.12.3
#    grey - non test if macos < 10.12.3
#
#  Created by babgond
#
#  Written: 27/05/2018
#  Updated: 
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

  osversion="$(sw_vers | grep "ProductVersion" | awk '{print $2}')"
  buildversion="$(sw_vers | grep "Build" | awk '{print $2}')"
  if [ "$osversion" >= "10.12.3"]
	then
 	 DEPstatus="$(profiles status -type enrollment | grep "Enrolled via DEP" | awk '{print $2}')"
	 MDMStatus="$(profiles status -type enrollment | grep "MDM enrollment" | awk '{print $2}')"
	 updateTitle "MDM : $MDMStatus"
		if [ "$MDMStatus" = "Yes" OR "Yes (User Approved)"]
		then
	 	 updateState "${STATE[0]}"
		 updateTooltip "DEP : $DEPstatus"
		else 
		 updateState "${STATE[2]}"
         updateTooltip "pas de MDM installé"
		fi
	else	 
     updateTitle "MDM : non testé"
	 updateState "${STATE[3]}"
     updateTooltip "il faut macOS 10.12.3"
	fi
  setEnabled YES
}
### The only things to do outside of a bash function is to call the main function defined by the Hello IT bash lib.
main "$@"

exit 0
