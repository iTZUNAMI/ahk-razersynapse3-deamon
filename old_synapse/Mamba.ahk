#Persistent  ; Keep the script running until the user exits it.
#SingleInstance force  ;he word FORCE skips the dialog box and replaces the old instance automatically


NomeProgramma := "Mamba"
Versione := "1.0"
Installato := 0
DirProgrammaAvvio := "C:\myScriptRUN\"
RegRun :="Software\Microsoft\Windows\CurrentVersion\Run"
PathReg := ""

Menu, Tray, NoStandard
Menu, Tray, Tip, %NomeProgramma%

;Tray Menu
Menu, mOpzioni, Add, Avvio Automatico, AvvioAutomaticoToogle
Menu, mOpzioni, Add, Info, InfoTool
Menu, Tray, Add, Opzioni, :mOpzioni
Menu, Tray, Add  ; Add a separator line.
Menu, Tray, Add, %NomeProgramma% (ALT GR+m),EseguiManuale
menu, Tray, Default, %NomeProgramma% (ALT GR+m)
Menu, Tray, Add,Esci,ChiudiApp

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
    
    PathLocal := "C:\Program Files (x86)\Razer\Synapse\RzSynapse.exe"
    
    ;kill processo 
    process=RzSynapse.exe
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
    
    ;riavvio processo
    Run , %PathLocal%,, hide
    
    
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
        Menu, mOpzioni, Check, Avvio Automatico
        PathReg := valtest
    }
}
return


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
        Menu, mOpzioni, Check, Avvio Automatico
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
        TrayMess(NomeProgramma,"Aggiunto all'avvio automatico")

    }
    else if (Installato = 1){
        ;se gia installato allora rimuovo avvio automatico
         Installato := 0   
         Menu, mOpzioni, UnCheck, Avvio Automatico
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

