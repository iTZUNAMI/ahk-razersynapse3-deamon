#Persistent  ; Keep the script running until the user exits it.
#SingleInstance force  ;he word FORCE skips the dialog box and replaces the old instance automatically

If Not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

NomeProgramma := "myRazerRestart"
Versione := "2.0"
Installato := 0
DirProgrammaAvvio := "C:\myScriptRUN\"
RegRun :="Software\Microsoft\Windows\CurrentVersion\Run"
PathReg := ""

Menu, Tray, NoStandard
Menu, Tray, Tip, %NomeProgramma%

;Tray Menu
Menu, mOpzioni, Add, AutoStart, AvvioAutomaticoToogle
Menu, mOpzioni, Add, Info, InfoTool
Menu, Tray, Add, Options, :mOpzioni
Menu, Tray, Add  ; Add a separator line.
Menu, Tray, Add, %NomeProgramma% (ALT GR+M),EseguiManuale
menu, Tray, Default, %NomeProgramma% (ALT GR+M)
Menu, Tray, Add,Exit,ChiudiApp

;funzione check avvio
checkAvvioAutomatico()

return



;programma 


;ALT GR + M
;riavvia il synapse
<^>!m:: 
RiavviaRazer()
return



EseguiManuale:
{
    RiavviaRazer()
}
return


RiavviaRazer(){
    
    PathLocal := "C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host\Razer Synapse 3.exe"
    PathLocal2 := "C:\Program Files (x86)\Razer\Razer Services\Razer Central\Razer Central.exe"
    
    ;kill processo1 
    process=Razer Synapse 3.exe
	Process, Exist, %process%
	if	pid :=	ErrorLevel
	{
		Loop 
		{
			WinClose, ahk_pid %pid%, , 5	; will wait 5 sec for window to close
			if	ErrorLevel	; if it doesn't close
				Process, Close, %pid%	; force it 
			Process, Exist, %process%
		}	Until	!pid :=	ErrorLevel
	
	}
    
    ;kill processo2 
    process=Razer Central.exe
	Process, Exist, %process%
	if	pid :=	ErrorLevel
	{
		Loop 
		{
			WinClose, ahk_pid %pid%, , 5	; will wait 5 sec for window to close
			if	ErrorLevel	; if it doesn't close
				Process, Close, %pid%	; force it 
			Process, Exist, %process%
		}	Until	!pid :=	ErrorLevel
	
	}

    ;stop service
    RunWait,sc stop "Razer Synapse Service" ;Stop Razer Synapse Service service.
        If (ErrorLevel = 0){
           
        }
    ;start service
    RunWait,sc start "Razer Synapse Service" ;Start Razer Synapse Service service.
        If (ErrorLevel = 0){
            
        }
    
    ;riavvio processo
    Run , %PathLocal%,, hide
    Run , %PathLocal2%,, hide
    
    ;close Razer windows (2x)
    
    ;check every 0.5 sec and than close
    SetTimer, ClosePathLocal1Window, 500
    SetTimer, ClosePathLocal2Window, 500
    
}
return






;imposta la spunta se attivo e cambia booleano per rimuoverlo
checkAvvioAutomatico()
{
    global Installato
    global NomeProgramma
    global PathReg
    global RegRun
    
    RegRead, valtest, HKEY_CURRENT_USER, %RegRun%, %NomeProgramma%
    ;se esiste il path allora e' installato e metto spunta sul menu e bool true
   if (valtest <> "") ;se non e blank
    {
        Installato :=1
        Menu, mOpzioni, Check, AutoStart
        PathReg := valtest
    }
}
return

ClosePathLocal1Window:
{
        SetTitleMatchMode 2

		;A window's title can contain WinTitle anywhere inside it to be a match. 
		;chiusura copytexty pop
		IfWinExist, Razer Synapse
		{
			WinClose
			SetTimer,ClosePathLocal1Window,off
            
		}
        return
}

ClosePathLocal2Window:
{
        SetTitleMatchMode 2

		;A window's title can contain WinTitle anywhere inside it to be a match. 
		;chiusura copytexty pop
		IfWinExist, Razer Central
		{
			WinClose
			SetTimer,ClosePathLocal2Window,off
            
		}
        return
}



TrayMess(var1,var2)
{
	TrayTip, %var1%,%var2%, 800
	
}
return

AvvioAutomaticoToogle:
{
    global Installato
    global DirProgrammaAvvio
    global NomeProgramma
    global RegRun
    
    ;se non e' installato allora copio il file nella dir
    ;aggiungo il registro per avvio automatico
    if (Installato = 0){
        Menu, mOpzioni, Check, AutoStart
        Installato:=1
        
        ;se non esiste dir la creo
        IfNotExist, %DirProgrammaAvvio%
        {
            
            FileCreateDir, %DirProgrammaAvvio%
        }
        ;copio file corrente
        FileCopy, %A_ScriptDir%\%A_ScriptName%, %DirProgrammaAvvio%, 1
        ;aggiungo reg
        RegWrite, REG_SZ, HKEY_CURRENT_USER, %RegRun%, %NomeProgramma%, "%DirProgrammaAvvio%%A_ScriptName%"
        TrayMess(NomeProgramma,"Added to Windows startup")

    }
    else if (Installato = 1){
        ;se gia installato allora rimuovo avvio automatico
         Installato := 0   
         Menu, mOpzioni, UnCheck, AutoStart
         RegDelete, HKEY_CURRENT_USER, %RegRun% , %NomeProgramma%
         
    }
    
    
    
    
}
return

InfoTool:
{
    global Installato
    global DirProgrammaAvvio
    global NomeProgramma
    global Versione
    global PathReg
    global RegRun
    
    ;re-check in caso
    checkAvvioAutomatico()
    if (Installato = 0)
    {
        MsgBox, 64, %NomeProgramma%, %NomeProgramma% v%Versione%`n`nLocalPath: %A_ScriptDir% `n`nRunPath: -`n`nRunReg: -`n`nRunRegValue: - 
    }
    else
    {
    MsgBox, 64, %NomeProgramma%, %NomeProgramma% v%Versione%`n`nLocalPath: %A_ScriptDir% `n`nRunPath: %DirProgrammaAvvio%`n`nRunReg: HKEY_CURRENT_USER\`n%RegRun% `n`nRunRegValue: %PathReg% 
    }
}
return



ChiudiApp(){
ExitApp
return
}

