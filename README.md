# ahk-razersynapse3-deamon (myRazerRestart)

## problem 1: 
sometimes the Razer Synapse 3 process/service (Windows) isn't correctly working, the rgb lighting of keyboard and mouse are not working, all macro or profiles aren't loaded. I have this problem after the last Synapse update and it comes usually after 1-2 hours of pc in idle. (just to know i have disabled all energy saving from usb, keyboard, mouse and other windows stuff, it's a problem of Razer Synapse, on their last version there were no problems..)

This script will auto-restart the razer service and the 2 process (razer synapse.exe and razer central.exe). Than all razer profiles will be correctly loaded and all rgb/macro will works again.

Process restarted:
 "C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host\Razer Synapse 3.exe"
 
 "C:\Program Files (x86)\Razer\Razer Services\Razer Central\Razer Central.exe"
 
Windows service restarted:

 "Razer Synapse Service"
 

## problem 2: (now fixed on the  Razer client)
at startup the software does not auto-close correctly

## Usage and key binding :

ALT GR + M 
to restart the application, than the software will work again...

at startup this script will auto-close all razer windows /spalsh startup 

UPDATE:
CHANGING PATH OF THE PROCESS FOR THE NEW RAZER SYNAPSE 
VERSION 3.5.116.10714


## DEMO HERE -> https://youtu.be/jmMmj9SLffg



