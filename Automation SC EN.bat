@echo off
chcp 1252
title Windows System Check and Repair
color 1F
set "version=v1.6"
echo.
echo Starting StarCheck %version%...
echo.
echo Checking if running as administrator...
echo.
:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator permissions...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

setlocal
set "midipath=%~dp0bem-ti-vi.mp3"
	if exist "%midipath%" (
     echo Playing sound in background...
	 start /B "" "%midipath%" >nul 2>&1
	) else (
     echo File not found: %midipath%
	)
endlocal

:MENU
cls
echo.
echo ***************************************************
echo *  *         * *                  *         *   * *
echo *   [ NoLaser Systems :: StarCheck %version% ] *   *   *
echo * * SYSTEM CHECK AND REPAIR         *    *     *
echo *   Preparing for launch to the stars...   *  *
echo *   * *    *             *            *   *       *
echo ***************************************************
echo.
echo 1 - Run only SFC (Check Disk)
echo 2 - Run only DISM (Check Windows Installation)
echo 3 - Run both (SFC and DISM)
echo 4 - Run SC Cleanup (Remove Star Citizen temp folder)
echo 5 - Open RSI Launcher
echo 6 - Run All (SFC + DISM + SC Cleanup)
echo 7 - Virtual Memory (Recommend 30GB or more)
echo 8 - Generate System Report
echo 9 - RSI Account Reset (If you are having issues inside the game)
echo 0 - Exit
echo.
set /p option=Choose an option: 

if "%option%"=="1" goto SFC
if "%option%"=="2" goto DISM
if "%option%"=="3" goto BOTH
if "%option%"=="4" goto SC
if "%option%"=="5" goto RSI
if "%option%"=="6" goto ALL
if "%option%"=="7" goto MEMO
if "%option%"=="8" goto REPORT
if "%option%"=="9" goto RESET
if "%option%"=="0" exit
goto MENU

:SFC
cls
echo ============================================
echo     RUNNING SFC /SCANNOW
echo ============================================
echo.
sfc /scannow
echo.
echo SFC completed.
echo.
echo If you still have issues, open the launcher, click the gear icon and select "Verify files".
echo.
echo If you still have issues, uninstall the game completely, run this cleanup again, and reinstall the game.
pause
goto MENU

:DISM
cls
echo ============================================
echo     RUNNING DISM /RESTOREHEALTH
echo ============================================
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo DISM completed.
echo.
echo If you still have issues, open the launcher, click the gear icon and select "Verify files".
echo.
echo If you still have issues, uninstall the game completely, run this cleanup again, and reinstall the game.
pause
goto MENU

:BOTH
cls
echo ============================================
echo     RUNNING DISM AND SFC
echo ============================================
echo.
echo Running SFC...
sfc /scannow
echo SFC completed.
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM completed.
echo.
echo If you still have issues, open the launcher, click the gear icon and select "Verify files".
echo.
echo If you still have issues, uninstall the game completely, run this cleanup again, and reinstall the game.
echo.
pause
goto MENU

:SC
cls
echo ============================================
echo     RUNNING SC CLEANUP
echo ============================================
echo.
echo This script deletes the StarCitizen temporary files folder.
echo It is recommended to run after every update!
echo Checking if folder exists "%localappdata%\Star Citizen"
if exist "%localappdata%\Star Citizen\" (
	echo Folder exists.
	echo Deleting folder.
	echo Check the folder path and type Y to confirm deletion
	rmdir /s "%localappdata%\Star Citizen"
	if not exist "%localappdata%\Star Citizen\" echo Folder deleted and no longer exists.
	) else (
	echo Folder does not exist!
	rem mkdir "%localappdata%\Star Citizen"
	rem echo Folder Created!
	)
echo.
echo Cleanup completed.
echo.
echo If you still have issues, open the launcher, click the gear icon and select "Verify files".
echo.
echo If you still have issues, uninstall the game completely, run this cleanup again, and reinstall the game.
pause
goto MENU

:RSI
cls
echo ============================================
echo     LOCATING RSI LAUNCHER
echo ============================================
echo.
@echo off
setlocal enabledelayedexpansion

set "file=RSI Launcher.exe"
set "found="
echo Searching for "%file%" on all available drives...
echo.

for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%D:\ (
        for /f "delims=" %%F in ('dir "%%D:\%file%" /s /b 2^>nul') do (
            if exist "%%F" (
                set "found=%%F"
                goto start
            )
        )
    )
)

echo File not found on any drive.
goto end

:start
echo File found: !found!
echo Starting in background...
start /B "" "!found!" >nul 2>&1
echo Launched successfully.
echo.
goto end

:end
endlocal
pause
goto MENU

:ALL
cls
echo ============================================
echo     RUNNING ALL STEPS
echo ============================================
echo.
echo Running SFC...
sfc /scannow
echo SFC completed.
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM completed.
echo.
echo This script deletes the StarCitizen temporary files folder.
echo It is recommended to run after EVERY update!
echo Checking if folder exists "%localappdata%\Star Citizen"
if exist "%localappdata%\Star Citizen\" (
	echo Folder exists.
	echo Deleting folder.
	echo Check the folder path and type Y to confirm deletion
	rmdir /s "%localappdata%\Star Citizen"
	if not exist "%localappdata%\Star Citizen\" echo Folder deleted and no longer exists.
	) else (
	echo Folder does not exist!
	rem mkdir "%localappdata%\Star Citizen"
	rem echo Folder Created!
	)
echo.
echo If you still have issues, open the launcher, click the gear icon and select "Verify files".
echo.
echo If you still have issues, uninstall the game completely, run this cleanup again, and reinstall the game.
pause
goto MENU

:MEMO
cls
echo ============================================
echo     VIRTUAL MEMORY CONFIGURATION
echo ============================================
@REM echo DEBUG WMI
@REM echo WMI
@REM wmic pagefile list /format:list
@REM echo.
@REM echo DEBUG InitialSize
@REM wmic path Win32_PageFileSetting get InitialSize

set /a total=0

setlocal enabledelayedexpansion
REM Get InitialSize value via WMIC
for /f "skip=1 tokens=*" %%A in ('wmic path Win32_PageFileSetting get InitialSize') do (
    set "value=%%A"
	set "value=!value: =!"
	set /a total+=!value!
)

echo.
echo Initial virtual memory size: !total! MB
echo.

REM Recommended value
set /a recommended=30000

REM Compare with recommended
if !total! GEQ !recommended! (
    echo "CONGRATULATIONS^! You are above the recommended value (!recommended! MB or 30 GB)"
	echo.
	if exist "%~dp0congratulations.mp3" (
     echo "Playing in background... Congratulations!"
	 start /B "" "%~dp0congratulations.mp3" >nul 2>&1
	 ) else (
     	echo File not found: "%~dp0congratulations.mp3"
	 )

) else (
	echo Below recommended^^! Please set it to above the !recommended!MB or more^^!
	echo Instructions to adjust your virtual memory:
	echo 1. Press Win + R, type "sysdm.cpl" and press Enter.
	echo 2. Go to the "Advanced" tab and click "Settings..." in the "Performance" section.
	echo 3. In the new window, go to the "Advanced" tab and click "Change..." in the "Virtual Memory" section.
	echo 4. Uncheck "Automatically manage paging file size for all drives".
	echo 5. Preferably select a drive different from Windows, but if you only have one, select the drive where Windows is installed ^(usually C:^).
	echo 6. Select "Custom size" and set both "Initial size" and "Maximum size" to at least !recommended!MB.
	echo 7. Click "Set" and then "OK" to apply the changes.
	echo 8. Restart your computer for the changes to take effect.
	echo.
	echo Starting the configuration panel for you...
	start /B "" "sysdm.cpl" >nul 2>&1
)

endlocal

echo.
echo If you still have issues > Set your virtual memory to at least 30 GB, preferably on a different SSD from Windows.
echo.
echo If you still have issues, open the launcher, click the gear icon and select "Verify files".
echo.
echo If you still have issues, uninstall the game completely, run this cleanup again, and reinstall the game.
echo.
pause
goto MENU

:REPORT
cls
echo ============================================
echo     VIRTUAL MEMORY CONFIGURATION
echo ============================================
echo.
echo. > "%~dp0report.txt" 2>&1
echo "Generating system report... %~dp0report.txt"
echo.
systeminfo > "%~dp0report.txt" 2>&1
echo "Report generated: report.txt send it to your friend for help!"
echo.
start /B "Report" "%~dp0report.txt" >nul 2>&1
pause
goto MENU

:RESET
cls
echo ============================================
echo     RSI ACCOUNT RESET (LAST RESORT)
echo ============================================
echo.
echo This will reset your RSI account settings in the website use this to fix issues inside the game, like stuck dead alive, missing items, etc. or some other wierd bugs.
echo.
echo This will open your default web browser and log you out of the RSI website, you will need to log in, click in Request Repair, write your issue, emails and cofirm password and submit.
echo.
echo This will not delete your account or any data, it will just reset your account settings in the website.
echo.
echo Press any key to open the RSI Account Reset page in your default web browser.
pause
start /B "" "https://robertsspaceindustries.com/en/account/reset" >nul 2>&1
echo Opened RSI Account Reset page in your default web browser.
echo.
pause
goto MENU