@Echo off


:: The following Function is created by kvc...don't modify it...if you don't know what are you doing...
:: it takes following arguments...
:: it is the ver.1.0 of List function... and it contains diffrnet types of List printing options... #kvc

rem [%1 = X-ordinate]
rem [%2 = Y-co_ordinate]
rem [%3 = the colour Code for the List,e.g. fc,08,70,07 etc...don't define it if you want default colour...or type '-' (minus) for no color change...]

rem #kvc

rem :: Visit www.thebateam.org for more extensions / plug-ins like this.... :]
rem #TheBATeam

If /i "%~1" == "" (goto :help)
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "-help" (goto :help)

If /i "%~1" == "ver" (echo.1.0&&goto :eof)


If /i "%~2" == "" (goto :help)
If /i "%~3" == "" (goto :help)
If /i "%~4" == "" (goto :help)


:List
setlocal Enabledelayedexpansion
Set _List_Count=1
Set _List_Width=1
Set _Final=
Set Delay=15
Set _Return_code=0

set x_val=%~1
set y_val=%~2
set color=%~3
If defined color (if /i "!color!" == "-" (set color=) Else (set "color=%~3"))

Set /a y_val_old=!y_val! + 1

REM TO Get All List Items...
:List_Loop
REM List Items loop...
Set "Item_!_List_Count!=%~4"

REM Checking for Max. Width of List...
Call Getlen "%~4"
IF !ErrorLevel! GTR !_List_Width! (Set _List_Width=!ErrorLevel!)

REM Preparing for next Item...
Shift /4
IF /I "%~4" == "" (Goto :Next)
Set /A _List_Count+=1
Goto :List_Loop

:Next
Set /A _List_Width=!_List_Width!+10
Set /A _List_Height=!_List_Count!+2

For /l %%A in (1,1,!_List_Width!) do (Set "_List_Space=!_List_Space! ")

for /l %%A in (1,1,!_List_Height!) do (
set "_final=!_final! /w !Delay! /g !x_val! !y_val! /d "!_List_Space!" "
set /a y_val+=1
)

Set "_final=!_final! /c 0x%color% "

REM Printing List Items...
Set /A x_val+=1
Set y_val=!y_val_old!
For /l %%A In (1,1,!_List_Count!) DO (
	Set "_Final=!_Final! /g !x_val! !y_val! /d "!Item_%%A!" "
	Set /A y_val+=1
	)

REM Final Output...
batbox.exe /c 0x%color:~0,1%%color:~0,1% %_final% /c 0x07

REM Some necessary variables...
Set /A x_val-=1
Set /A _List_Width=!x_val! + !_List_Width!
Set /A y_end=!y_val_old! + !_List_Count! - 1
	

REM Stopping for getting User Input...
REM Enabling Mouse Interaction with Cmd... Using 'Batbox'
For /F "Delims=: Tokens=1,2,3" %%A in ('Batbox.exe /m') Do (
	set Button=%%C
	set X=%%A
	set Y=%%B
	)

REM Checking clicked area...
IF /I "!Button!" == "1" (
	For /l %%A In (1,1,!_List_Count!) DO (
		If !X! GEQ !x_val! If !X! LEQ !_List_Width! If !Y! GEQ !y_val_old! If !Y! LEQ !y_end! (Set /A _Return_code=!Y! - !y_val_old! + 1)
		Set /A y_val+=1
		)
	)
Exit /b !_Return_code!


:help
Echo.
Echo. This function helps in Adding a little GUI effect into your batch program...
echo. It Prints simple List on the cmd console at specified X Y co-ordinate...
Echo. After printing, it stops For User 'mouse' input... ANd returns the Item No.
Echo. Which is clicked by User... 
Echo. 
Echo. IF No Item is clicked, or clicked anywhere else... then it will return 0 in 
Echo. the 'Errorlevel' Variable.
echo.
echo. Syntax: call List [X] [Y] [color] [Items 1] [Items 2] ...
echo. Syntax: call List [help ^| /^? ^| -h ^| -help]
echo. Syntax: call List ver
echo.
echo. Where:-
echo. X		= X-ordinate of top-left corner of List
echo. Y		= Y-co_ordinate of top-left corner of List
echo. ver		= Version of List function
Echo. Items #	= The Items to display in the List... They maybe Enclosed within "".
echo.
echo. This version 1.0 of List function contains much more GUI Capabilities.
echo. As it uses batbox.exe and calls it only once at the end of calculation...
echo. Visit www.thebateam.org for more...
echo. #Kvc with #TheBATeam
goto :eof
