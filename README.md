
Autor: Philip Ruehl
Date: 13.07.2022

Description: 

A simple shell script that checks the battery charge routinely 
via cron. Warnings are sent via notify-send when the battery charge drops
below 15%, and 10%. A final warning is sent after the charge drops below 5%.
The warnings are displayed for 5 seconds. After the last final warning 
disappears, the system is suspended (to RAM) to avoid a hard crash and loss
of unsaved data on systems without other precautions (or where precautions
are not functioning properly)

So far the script has to be registered in the crontab of the root user by hand.

