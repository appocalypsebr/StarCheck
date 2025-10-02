@echo off
chcp 1252
title Verificação e Correção do Sistema Windows
color 1F


:: Verifica se está rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissões de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

setlocal
set "midicaminho=%~dp0bem-ti-vi.mp3"
	if exist "%midicaminho%" (
     echo Tocando MIDI em segundo plano...
	 start /B "" "%midicaminho%" >nul 2>&1
	) else (
     echo Arquivo não encontrado: %midicaminho%
	)
endlocal

:MENU
cls
echo.
echo ***************************************************
echo *  *         * *                  *         *   * *
echo *   [ NoLaser Systems :: StarCheck v1.4 ] *   *   *
echo * * VERIFICAÇÃO E CORREÇÃO DO SISTEMA  *    *     *
echo *   Preparando os motores rumo às estrelas...  *  *
echo *   * *    *             *            *   *       *
echo ***************************************************
echo.
echo 1 - Executar apenas SFC (Verificar Disco)
echo 2 - Executar apenas DISM (Verificar Instalação Windows)
echo 3 - Executar ambos (SFC e DISM)
echo 4 - Executar Limpeza do SC (Remove pasta temporária do Star Citizen)
echo 5 - Abrir RSI Launcher
echo 6 - Executar Tudo (SFC + DISM + Limpeza do SC)
echo 7 - Memoria Virtual (Recomendado 30GB ou mais)
echo 8 - Gerar Relatório do Sistema
echo 9 - Resetar Conta RSI (Se estiver com problemas dentro do jogo)
echo 0 - Sair
echo.
set /p opcao=Escolha uma opção: 

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
echo SFC concluído.
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
echo DISM concluído.
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
echo SFC concluído.
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM concluído.
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
echo Este script deleta a pasta de arquivos temporários do StarCitizen.
echo É recomendado executar sempre depois de cada atualização!
echo Verificando se a pasta existe "%localappdata%\Star Citizen"
if exist "%localappdata%\Star Citizen\" (
	echo A pasta existe. 
	echo Deletando a pasta. 
	echo Confira o caminho da pasta e digite S para confirmar deleção da pasta
	rmdir /s "%localappdata%\Star Citizen"
	if not exist "%localappdata%\Star Citizen\" echo Pasta foi deletada e nao existe mais.
	) else (
	echo Pasta não existe!
	rem mkdir "%localappdata%\Star Citizen" 
	rem echo Pasta Criada!
	)
echo.
echo Limpeza das pastas concluído.
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

echo Procurando por "%arquivo%" em todas as unidades disponíveis...
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

echo Arquivo não encontrado em nenhuma unidade.
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
echo SFC concluído.
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM concluído.
echo.
echo Este script deleta a pasta de arquivos temporários do StarCitizen.
echo È recomendado executar sempre depois de TODA atualização!
echo Verificando se a pasta existe "%localappdata%\Star Citizen"
if exist "%localappdata%\Star Citizen\" (
	echo A pasta existe. 
	echo Deletando a pasta. 
	echo Confira o caminho da pasta e digite S para confirmar deleção da pasta
	rmdir /s "%localappdata%\Star Citizen"
	if not exist "%localappdata%\Star Citizen\" echo Pasta foi deletada e nao existe mais.
	) else (
	echo Pasta não existe!
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
echo     CONFIGURAÇÃO DA MEMÓRIA VIRTUAL
echo ============================================
echo.
echo WMI
wmic pagefile list /format:list
set /a total=0

setlocal enabledelayedexpansion
REM Captura o valor de InitialSize via WMIC
for /f "skip=1 tokens=*" %%A in ('wmic path Win32_PageFileSetting get InitialSize') do (
    set "valor=%%A"
	set "valor=!valor: =!"
	set /a total+=!valor!
)

echo Tamanho inicial da memória virtual: !total! MB

REM Valor recomendado
set /a recomendado=30000

REM Compara com o recomendado
if !total! GEQ !recomendado! (
    echo "MEUS PARABEEEEEeeeEEEeeEEENS^! Você está acima do recomendado^! (!recomendado! MB ou 30 GB)"
	if exist "%~dp0parabens.m4a" (
     echo "Tocando em segundo plano... Parabens^!"
	 start /B "" "%~dp0parabens.m4a" >nul 2>&1
	 ) else (
     	echo Arquivo não encontrado: "%~dp0parabens.m4a"
	 )
	
) else (
    echo "Está abaixo do recomendado^! (!recomendado! MB ou 30 GB) ajuste para 30GB ou mais^!"
	echo.
	echo Instruções para ajustar a memória virtual:
	echo 1. Pressione Win + R, digite "sysdm.cpl" e pressione Enter.
	echo 2. Vá para a aba "Avançado" e clique em "Configurações..." na seção "Desempenho".
	echo 3. Na nova janela, vá para a aba "Avançado" e clique em "Alterar..." na seção "Memória Virtual".
	echo 4. Desmarque "Gerenciar automaticamente o tamanho do arquivo de paginação para todas as unidades".
	echo 5. De preferencia selecione uma unidade diferente da do Windows, mas caso somente tenha uma unidade, selecione a unidade onde o Windows está instalado (geralmente C:).
	echo 6. Selecione "Tamanho personalizado" e defina o "Tamanho inicial" e "Tamanho máximo" para pelo menos 30000 MB (30 GB).
	echo 7. Clique em "Definir" e depois em "OK" para aplicar as mudanças.
	echo 8. Reinicie o computador para que as mudanças tenham efeito.
)

endlocal
	
echo.
echo Se continuar com problemas ^> Ajuste sua memória virtual para no mínimo 30 GB, de preferência em um SSD diferente do Windows.
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
echo     CONFIGURAÇÃO DA MEMÓRIA VIRTUAL
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
echo     RESETAR CONTA RSI (ÚLTIMO RECURSO)
echo ============================================
echo.
echo Isso irá resetar as configurações da sua conta RSI no site. Use isso para corrigir problemas dentro do jogo, como personagem preso, itens sumidos, ou outros bugs estranhos.
echo.
echo Isso irá abrir seu navegador padrão e deslogar você do site da RSI. Você precisará fazer login, clicar em "Request Repair", descrever o problema, informar os e-mails e confirmar a senha, depois enviar.
echo.
echo Isso NÃO irá deletar sua conta ou dados, apenas irá resetar as configurações da conta no site.
echo.
echo Pressione uma tecla para abrir a página de reset da conta RSI aberta no seu navegador padrão.
pause
start /B "" "https://robertsspaceindustries.com/en/account/reset" >nul 2>&1
echo.
pause
goto MENU