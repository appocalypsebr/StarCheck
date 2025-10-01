@echo off
chcp 1252
echo c�digo de p�gina 1252 (Windows Latin-1), que suporta acentua��o

:: Verifica se est� rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permiss�es de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title Verifica��o e Corre��o do Sistema Windows
color 1F

echo ============================================
echo     INICIANDO VERIFICA��O DO SISTEMA
echo ============================================
echo.

:: Executa o SFC para verificar e corrigir arquivos do sistema
echo Executando SFC...
sfc /scannow
echo SFC conclu�do.
echo.

:: Executa o DISM para reparar a imagem do sistema
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM conclu�do.
echo.

echo ============================================
echo     PROCESSO FINALIZADO
echo ============================================
pause