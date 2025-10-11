@echo off
chcp 1252
title Windows System Check and Repair
color 1F
set "version=v1.8"
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
echo ***************************************************
echo *  *         * *                  *         *   * *
echo *   [ NoLaser Systems :: StarCheck %version% ] *   *   *
echo * * SYSTEM CHECK AND REPAIR         *    *     *
echo *   Preparing for launch to the stars...   *  *
echo *   * *    *             *            *   *       *
echo ***************************************************
echo Option 4 - Run cleanup after every game update.
echo Option 6 - For issues like not launching, crashes, or freezes.
echo Option 7 - Adjust virtual memory if you have performance problems.
echo Option 9 - For in-game bugs like stuck/dead character.
echo Problem solved^?^! Share this script with your friends^!
echo.
echo 1 - Run only DISM (Check Windows Installation)
echo 2 - Run only SFC (Check Disk)
echo 3 - Run both (DISM and SFC)
echo 4 - Run SC Cleanup (Remove Star Citizen temp folder)
echo 5 - Open RSI Launcher
echo 6 - Run All (DISM + SFC + SC Cleanup)
echo 7 - Virtual Memory (Recommend 30GB or more)
echo 8 - Generate System Report
echo 9 - RSI Account Reset (If you are having issues inside the game)
echo 0 - Exit
echo.
set /p option=Choose an option: 

if "%option%"=="1" goto DISM
if "%option%"=="2" goto SFC
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
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM completed.
echo Running SFC...
sfc /scannow
echo SFC completed.
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
setlocal enabledelayedexpansion
set /a total=0

REM Capture InitialSize value via WMIC, summing only strictly numeric lines
for /f "skip=1 tokens=*" %%A in ('wmic path Win32_PageFileSetting get InitialSize') do (
	set "_tmp=%%A"
	echo !_tmp! | findstr /r "[0-9]" >nul
	if not errorlevel 1 call :sum_if_number "%%A"
)

goto after_sum

:sum_if_number
set "value=%~1"
REM Remove spaces and control characters
set "value=!value: =!"
REM Remove all non-numeric characters
for /f "delims=0123456789" %%C in ("!value!") do set "value=!value:%%C=!"
set "sum=!total!"
set /a sum+=!value!
set "total=!sum!"
goto :eof

:after_sum

echo Initial virtual memory size: !total! MB

set /a recommended=31003
echo Recommended virtual memory size: !recommended! MB

set pathdir=%~dp0
set /a total=!total!+0
set /a recommended=!recommended!+0
if !total! GEQ !recommended! (
	echo Congratulations! You are above the recommended value: !recommended!MB
	if exist "%~dp0congratulations.mp3" (
		echo "Playing in background... Congratulations!"
		start /B "" "%~dp0congratulations.mp3" >nul 2>&1
		goto MEMO_END
	) else (
		echo File not found: "%~dp0congratulations.mp3"
	)
) else (
	echo Below recommended.
	echo Please set it to !recommended!MB or more.
	echo.
	echo Choose an option to configure virtual memory:
	echo 1 - Show manual adjustment instructions
	echo 2 - Try automatic adjustment on the default path.
	set /p memoption=Enter the desired option number: 
	set memoption=!memoption: =!
	if /i !memoption! == 1 goto MEMO_MANUAL
	if /i !memoption! == 2 goto MEMO_AUTO
	echo Invalid option. Showing manual instructions by default.
	goto MEMO_MANUAL
)

:MEMO_MANUAL
echo.
echo Instructions to adjust virtual memory:
echo 1. Press Win + R, type "sysdm.cpl" and press Enter.
echo 2. Go to the Advanced tab and click Settings... in the Performance section.
echo 3. In the new window, go to the Advanced tab and click Change... in the Virtual Memory section.
echo 4. Uncheck "Automatically manage paging file size for all drives".
echo 5. Preferably select a drive different from Windows, but if you only have one, select the drive where Windows is installed (usually C:).
echo 6. Select "Custom size" and set both Initial size and Maximum size to at least !recommended!MB.
echo 7. Click Set and then OK to apply the changes.
echo 8. Restart your computer for the changes to take effect.
echo.
echo Opening the configuration panel for you...
start /B "" "sysdm.cpl" >nul 2>&1
goto MEMO_END

:MEMO_AUTO
echo.
echo Listing drives and free space...
echo ---Current Pagefile Settings---
powershell -NoProfile -Command "Get-CimInstance -ClassName Win32_PageFileSetting | ForEach-Object { \"File: $($_.Name) - Initial: $($_.InitialSize) MB - Maximum: $($_.MaximumSize) MB\" } | Out-String -Stream | ? { $_.Trim() -ne '' }"
echo --------------------------------
echo ---Available Drives---
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 -and $_.Size -gt 0 -and $_.DeviceID -match '^[A-Z]:$' } | ForEach-Object { if ($_.FreeSpace -ne $null -and $_.Size -ne $null) { \"Drive: $($_.DeviceID) - Label: $($_.VolumeName) - Free: $([math]::Round($_.FreeSpace/1GB,1)) GB / Total: $([math]::Round($_.Size/1GB,1)) GB\" } } | Out-String -Stream | ? { $_.Trim() -ne '' }"
echo ----------------------
echo.
set /p drive=Enter the drive letter you want to use for the pagefile (e.g., D): 
set drive=!drive:~0,1!
set drive=!drive!:
set "pagefile=!drive!\\pagefile.sys"
echo.
echo Attempting to automatically set virtual memory to !recommended!MB on drive !drive!...
set "pagefilePS=!drive!\pagefile.sys"
powershell -NoProfile -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management' -Name 'PagingFiles' -Value ('!pagefilePS! !recommended! !recommended!'); Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management' -Name 'AutomaticManagedPagefile' -Value 0; Write-Host 'Configuration applied. Please restart your computer.'"
echo.
echo Automatic adjustment completed (if no error above).
echo.
echo ATTENTION: Save your work and close all running programs.
echo The computer will automatically restart in 30 seconds to apply the virtual memory changes.
pause
shutdown /r /t 30
goto MEMO_END

:MEMO_END
endlocal
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
echo     REPORT GENERATION
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