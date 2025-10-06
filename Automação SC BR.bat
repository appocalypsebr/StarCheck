@echo off
chcp 1252
title Verifica��o e Corre��o do Sistema Windows
color 1F
set "version=v1.8"
echo.
echo Iniciando StarCheck %version%...
echo.
echo Verificando se est� sendo executado como administrador...
echo.
:: Verifica se est� rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permiss�es de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

setlocal
set "midicaminho=%~dp0bem-ti-vi.mp3"
	if exist "%midicaminho%" (
     echo Tocando som em segundo plano...
	 start /min "" "%midicaminho%" >nul 2>&1
	) else (
     echo Arquivo n�o encontrado: %midicaminho%
	)
endlocal

:MENU
cls
echo ***************************************************
echo *  *         * *                  *         *   * *
echo *   [ NoLaser Systems :: StarCheck %version% ] *   *   *
echo * * VERIFICA��O E CORRE��O DO SISTEMA  *    *     *
echo *   Preparando os motores rumo �s estrelas...  *  *
echo *   * *    *             *            *   *       *
echo ***************************************************
echo Op��o 4 - Executar a limpeza sempre ap�s cada atualiza��o do jogo.
echo Op��o 6 - Para problemas como n�o abre, travamentos ou crashes.
echo Op��o 7 - Ajustar a mem�ria virtual se estiver com problemas de performance.
echo Op��o 9 - Para problemas como bugs dentro do jogo, como morto vivo.
echo Problema resolvido^?^! Compartilhe este script com seus amigos^!
echo.
echo 1 - Executar apenas SFC (Verificar Disco)
echo 2 - Executar apenas DISM (Verificar Instala��o Windows)
echo 3 - Executar ambos (SFC e DISM)
echo 4 - Executar Limpeza do SC (Remove pasta tempor�ria do Star Citizen)
echo 5 - Abrir RSI Launcher
echo 6 - Executar Tudo (SFC + DISM + Limpeza do SC)
echo 7 - Memoria Virtual (Recomendado 30GB ou mais)
echo 8 - Gerar Relat�rio do Sistema
echo 9 - Resetar Conta RSI (Se estiver com problemas dentro do jogo)
echo 0 - Sair
echo.
set /p opcao=Escolha uma op��o: 

if "%opcao%"=="1" goto SFC
if "%opcao%"=="2" goto DISM
if "%opcao%"=="3" goto AMBOS
if "%opcao%"=="4" goto SC
if "%opcao%"=="5" goto RSI
if "%opcao%"=="6" goto TUDO
if "%opcao%"=="7" goto MEMO
if "%opcao%"=="8" goto REPORT
if "%opcao%"=="9" goto RESET
if "%opcao%"=="0" exit
goto MENU

:SFC
cls
echo ============================================
echo     EXECUTANDO SFC /SCANNOW
echo ============================================
echo.
sfc /scannow
echo.
echo SFC conclu�do.
echo.
echo Se continuar com problemas abra o launcher, clique na engrenagem e selecione "Verificar arquivos".
echo.
echo Se continuar com problemas desinstale o jogo por completo, execute esta limpeza novamente, reinstale o jogo.
pause
goto MENU

:DISM
cls
echo ============================================
echo     EXECUTANDO DISM /RESTOREHEALTH
echo ============================================
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo DISM conclu�do.
echo.
echo Se continuar com problemas abra o launcher, clique na engrenagem e selecione "Verificar arquivos".
echo.
echo Se continuar com problemas desinstale o jogo por completo, execute esta limpeza novamente, reinstale o jogo.
pause
goto MENU

:AMBOS
cls
echo ============================================
echo     EXECUTANDO DISM E SFC
echo ============================================
echo.
echo Executando SFC...
sfc /scannow
echo SFC conclu�do.
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM conclu�do.
echo.
echo Se continuar com problemas abra o launcher, clique na engrenagem e selecione "Verificar arquivos".
echo.
echo Se continuar com problemas desinstale o jogo por completo, execute esta limpeza novamente, reinstale o jogo.
echo.
pause
goto MENU

:SC
cls
echo ============================================
echo     EXECUTANDO LIMPEZA DO SC
echo ============================================
echo.
echo Este script deleta a pasta de arquivos tempor�rios do StarCitizen.
echo � recomendado executar sempre depois de cada atualiza��o!
echo Verificando se a pasta existe "%localappdata%\Star Citizen"
if exist "%localappdata%\Star Citizen\" (
	echo A pasta existe. 
	echo Deletando a pasta. 
	echo Confira o caminho da pasta e digite S para confirmar dele��o da pasta
	rmdir /s "%localappdata%\Star Citizen"
	if not exist "%localappdata%\Star Citizen\" echo Pasta foi deletada e nao existe mais.
	) else (
	echo Pasta n�o existe!
	rem mkdir "%localappdata%\Star Citizen" 
	rem echo Pasta Criada!
	)
echo.
echo Limpeza das pastas conclu�do.
echo.
echo Se continuar com problemas abra o launcher, clique na engrenagem e selecione "Verificar arquivos".
echo.
echo Se continuar com problemas desinstale o jogo por completo, execute esta limpeza novamente, reinstale o jogo.
pause
goto MENU

:RSI
cls
echo ============================================
echo     LOCALIZANDO RSI LAUNCHER
echo ============================================
echo.
@echo off
setlocal enabledelayedexpansion

set "arquivo=RSI Launcher.exe"
set "encontrado="

echo Procurando por "%arquivo%" em todas as unidades dispon�veis...
echo.

for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%D:\ (
        for /f "delims=" %%F in ('dir "%%D:\%arquivo%" /s /b 2^>nul') do (
            if exist "%%F" (
                set "encontrado=%%F"
                goto iniciar
            )
        )
    )
)

echo Arquivo n�o encontrado em nenhuma unidade.
goto fim

:iniciar
echo Arquivo encontrado: !encontrado!
echo Iniciando em segundo plano...
start /B "" "!encontrado!" >nul 2>&1
echo Executado com sucesso.
echo.
goto fim

:fim
endlocal
pause
goto MENU

:TUDO
cls
echo ============================================
echo     EXECUTANDO TODOS OS PASSOS
echo ============================================
echo.
echo Executando SFC...
sfc /scannow
echo SFC conclu�do.
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM conclu�do.
echo.
echo Este script deleta a pasta de arquivos tempor�rios do StarCitizen.
echo � recomendado executar sempre depois de TODA atualiza��o!
echo Verificando se a pasta existe "%localappdata%\Star Citizen"
if exist "%localappdata%\Star Citizen\" (
	echo A pasta existe. 
	echo Deletando a pasta. 
	echo Confira o caminho da pasta e digite S para confirmar dele��o da pasta
	rmdir /s "%localappdata%\Star Citizen"
	if not exist "%localappdata%\Star Citizen\" echo Pasta foi deletada e nao existe mais.
	) else (
	echo Pasta n�o existe!
	rem mkdir "%localappdata%\Star Citizen" 
	rem echo Pasta Criada!
	)
echo.
echo Se continuar com problemas abra o launcher, clique na engrenagem e selecione "Verificar arquivos".
echo.
echo Se continuar com problemas desinstale o jogo por completo, execute esta limpeza novamente, reinstale o jogo.
pause
goto MENU

:MEMO
cls
echo ============================================
echo     CONFIGURA��O DA MEM�RIA VIRTUAL
echo ============================================

setlocal enabledelayedexpansion
set /a total=0

REM Captura o valor de InitialSize via WMIC, somando apenas linhas estritamente num�ricas
	for /f "skip=1 tokens=*" %%A in ('wmic path Win32_PageFileSetting get InitialSize') do (
		set "_tmp=%%A"
		echo !_tmp! | findstr /r "[0-9]" >nul
		if not errorlevel 1 call :soma_se_numero "%%A"
	)

goto depois_soma

:soma_se_numero
set "valor=%~1"
REM Remove espa�os e caracteres de controle
set "valor=!valor: =!"
REM Remove todos os caracteres n�o num�ricos
for /f "delims=0123456789" %%C in ("!valor!") do set "valor=!valor:%%C=!"
REM Debug: mostrar valor capturado
REM echo Debug 1 Valor capturado: '!valor!'
		REM echo Debug 2 Valor capturado: '!valor!'
		set "soma=!total!"
		set /a soma+=!valor!
		set "total=!soma!"
		REM echo Total parcial: !total!
goto :eof

:depois_soma

echo Tamanho inicial da mem�ria virtual: !total! MB

REM Valor recomendado
set /a recomendado=30000

echo Tamanho recomendado da mem�ria virtual: !recomendado! MB
set caminho=%~dp0
REM Garante que ambos s�o n�meros
set /a total=!total!+0
set /a recomendado=!recomendado!+0
@REM echo DEBUG: total=!total! recomendado=!recomendado!
if !total! GEQ !recomendado! (
    @REM echo DEBUG TESTE IF: !total! GEQ !recomendado! == TRUE
    echo Parab�ns^^! Voc� est� acima do recomendado: !recomendado!MB
    if exist "%~dp0parabens.m4a" (
        echo "Playing in background... Congratulations!"
        start /B "" "%~dp0parabens.m4a" >nul 2>&1
		goto MEMO_FIM
    ) else (
        echo File not found: "%~dp0parabens.m4a"
    )
) else (
    @REM echo DEBUG TESTE IF: !total! GEQ !recomendado! == FALSE
    echo Est� abaixo do recomendado
	echo Ajuste para !recomendado!MB ou mais.
    echo.
    echo Escolha uma op��o para configurar a mem�ria virtual:
    echo 1 - Exibir instru��es para ajuste manual
    echo 2 - Tentar ajuste autom�tico no caminho padr�o.
	set /p memopcao=Digite o n�mero da op��o desejada: 
	set memopcao=!memopcao: =!
	if /i !memopcao! == 1 goto MEMO_MANUAL
	if /i !memopcao! == 2 goto MEMO_AUTO
	echo Op��o inv�lida. Exibindo instru��es manuais por padr�o.
	goto MEMO_MANUAL
)

:MEMO_MANUAL
echo.
echo Instru��es para ajustar a mem�ria virtual^:
echo 1. Pressione Win + R, digite "sysdm.cpl" e pressione Enter.
echo 2. V� para a aba Avan�ado e clique em Configura��es... na se��o Desempenho.
echo 3. Na nova janela, v� para a aba Avan�ado e clique em Alterar... na se��o Mem�ria Virtual.
echo 4. Desmarque "Gerenciar automaticamente o tamanho do arquivo de pagina��o para todas as unidades".
echo 5. De prefer�ncia selecione uma unidade diferente da do Windows, mas caso s� tenha uma unidade, selecione a unidade onde o Windows est� instalado geralmente C:.
echo 6. Selecione "Tamanho personalizado" e defina o Tamanho inicial e Tamanho m�ximo para pelo menos !recomendado!MB.
echo 7. Clique em Definir e depois em OK para aplicar as mudan�as.
echo 8. Reinicie o computador para que as mudan�as tenham efeito.
echo.
echo Iniciando o painel de configura��o para voc�...
start /B "" "sysdm.cpl" >nul 2>&1
goto MEMO_FIM

:MEMO_AUTO
echo.
echo Listando unidades e espa�o livre...
echo ---Configura��es atuais do Pagefile---
powershell -NoProfile -Command "Get-CimInstance -ClassName Win32_PageFileSetting | ForEach-Object { \"Arquivo: $($_.Name) - Inicial: $($_.InitialSize) MB - M�ximo: $($_.MaximumSize) MB\" } | Out-String -Stream | ? { $_.Trim() -ne '' }"
echo -------------------------------------
echo ---Unidades dispon�veis---
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 -and $_.Size -gt 0 -and $_.DeviceID -match '^[A-Z]:$' } | ForEach-Object { if ($_.FreeSpace -ne $null -and $_.Size -ne $null) { \"Unidade: $($_.DeviceID) - Label: $($_.VolumeName) - Livre: $([math]::Round($_.FreeSpace/1GB,1)) GB / Total: $([math]::Round($_.Size/1GB,1)) GB\" } } | Out-String -Stream | ? { $_.Trim() -ne '' }"
echo -------------------------
echo.
set /p unidade=Digite a letra da unidade desejada para o arquivo de pagina��o (ex: D): 
set unidade=!unidade:~0,1!
set unidade=!unidade!:
set "pagefile=!unidade!\\pagefile.sys"
echo.
echo Tentando ajuste autom�tico da mem�ria virtual para !recomendado!MB na unidade !unidade!...
set "pagefilePS=!unidade!\pagefile.sys"
powershell -NoProfile -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management' -Name 'PagingFiles' -Value ('!pagefilePS! !recomendado! !recomendado!'); Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management' -Name 'AutomaticManagedPagefile' -Value 0; Write-Host 'Configura��o aplicada. Reinicie o computador.'"
echo.
echo Ajuste autom�tico conclu�do (se n�o houver erro acima).
echo.
echo ATEN��O: Salve seu trabalho e feche todos os programas em funcionamento.
echo O computador ser� reiniciado automaticamente em 30 segundos para aplicar as mudan�as de mem�ria virtual.
shutdown /r /t 30
goto MEMO_FIM

:MEMO_FIM
endlocal
echo.
echo Se continuar com problemas abra o launcher, clique na engrenagem e selecione "Verificar arquivos".
echo.
echo Se continuar com problemas desinstale o jogo por completo, execute esta limpeza novamente, reinstale o jogo.
echo.
pause
goto MENU

:REPORT
cls
echo ============================================
echo     GERANDO RELAT�RIO DO SISTEMA
echo ============================================
echo.
echo. > "%~dp0relatorio.txt" 2>&1
echo "Gerando relatorio do sistema... %~dp0relatorio.txt"
echo.
systeminfo > "%~dp0relatorio.txt" 2>&1
echo "Relatorio gerado: relatorio.txt envie para seu colega te ajudar!"
echo.
start /B "Relatorio" "%~dp0relatorio.txt" >nul 2>&1
pause
goto MENU

:RESET
cls
echo ============================================
echo     RESETAR CONTA RSI (�LTIMO RECURSO)
echo ============================================
echo.
echo Isso ir� resetar as configura��es da sua conta RSI no site. Use isso para corrigir problemas dentro do jogo, como personagem preso, itens sumidos, ou outros bugs estranhos.
echo.
echo Isso ir� abrir seu navegador padr�o e deslogar voc� do site da RSI. Voc� precisar� fazer login, clicar em "Request Repair", descrever o problema, informar os e-mails e confirmar a senha, depois enviar.
echo.
echo Isso N�O ir� deletar sua conta ou dados, apenas ir� resetar as configura��es da conta no site.
echo.
echo Pressione uma tecla para abrir a p�gina de reset da conta RSI aberta no seu navegador padr�o.
pause
start /B "" "https://robertsspaceindustries.com/en/account/reset" >nul 2>&1
echo.
pause
goto MENU