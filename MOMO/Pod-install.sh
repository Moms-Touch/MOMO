#!/bin/sh

#  Pod-Install.sh
#  
#
#  Created by Nikunj Modi on 26/09/20.
#  
osascript <<END
tell application "Terminal"
if not (exists window 1) then reopen
activate
do script "cd `pwd`;ls;pod install" in window 1
end tell
END
