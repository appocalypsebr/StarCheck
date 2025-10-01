@echo off
chcp 1252
echo código de página 1252 (Windows Latin-1), que suporta acentuação

:: Verifica se está rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissões de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title Verificação e Correção do Sistema Windows
color 1F

echo ============================================
echo     INICIANDO VERIFICAÇÃO DO SISTEMA
echo ============================================
echo.

:: Executa o SFC para verificar e corrigir arquivos do sistema
echo Executando SFC...
sfc /scannow
echo SFC concluído.
echo.

:: Executa o DISM para reparar a imagem do sistema
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM concluído.
echo.

echo ============================================
echo     PROCESSO FINALIZADO
echo ============================================
pause