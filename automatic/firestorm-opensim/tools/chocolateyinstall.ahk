#NoEnv
#NoTrayIcon
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 1  ; A windows's title must start with the specified WinTitle to be a match.
SetControlDelay 0  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; License agreement
winTitle1 = Firestorm
WinWait, %winTitle1% ahk_exe i)Phoenix-FirestormOS-.*_Setup\.exe$,, 600

ControlClick, Button1, %winTitle1% ; &Yes