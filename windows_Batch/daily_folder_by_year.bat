@echo off
setlocal EnableDelayedExpansion

::This program creates folders based on the year entered
::The directories created are on the folder where this file is saved in the form of "\year\mm month\ddmmyyyy"
::where mm is the number of the month (i.e. 01 Jan, 02 Feb,etc..), dd is the day, mm the month, and yyyy the year

set /P "year=Enter year you want to create: "

:: Check if Feb has 28 or 29 days
set leapYear=28
if %year %% 4 == 0 set "leapYear=29"


:: Select the base folder
cd "%~P0"

:: Initialize all variables
set i=0
for %%a in (Jan:31 Feb:%leapYear% Mar:31 Apr:30 May:31 Jun:30 Jul:31 Aug:31 Sep:30 Oct:31 Nov:30 Dec:31) do (
   for /F "tokens=1,2 delims=:" %%m in ("%%a") do (
      set /A i+=1
      set "month[!i!]=%%m"
      set "dpm[!i!]=%%n"
   )
)
set /A "dpm[2]+=^!(year%%4), d=((year+4799)*1461/4-(year+4899)/100*3/4+1)%%7*3, rot=^!d+((d-15)>>31)+1"

:: Create the folders
md %year%
cd %year%
for /L %%m in (1,1,12) do (
   set "m=0%%m"
   set "m=!m:~-2!"
   md "!m! !month[%%m]!"
   cd "!m! !month[%%m]!"
   for /L %%d in (1,1,!dpm[%%m]!) do (
      set "d=0%%d"
      md !d:~-2!!m!!year!
      set "dow=!dow:~3!!dow:~0,3!"
   )
   cd ..
)
endlocal