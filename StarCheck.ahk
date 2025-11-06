#Requires AutoHotkey v2.0
if !A_IsAdmin {
    Run("*RunAs " A_ScriptFullPath)
    ExitApp
}

logFile := A_ScriptDir "\StarCheck_Historico.txt"

MyGui := Gui()
MyGui.Title := "StarCheck - Diagnóstico Interativo"
MyGui.Add("Text", "w400", "Responda às perguntas para identificar o problema:")

MyGui.Add("Text", "y+10", "1. Você tem menos de 64GB de Memoria RAM e tem desempenho ruim?")
perf := MyGui.Add("DropDownList", "w400 Choose2", ["Sim", "Não"])

MyGui.Add("Text", "y+10", "2. O jogo está travando, fecha do nada, tela azul, ou não abre?")
crash := MyGui.Add("DropDownList", "w400 Choose2", ["Sim", "Não"])

MyGui.Add("Text", "y+10", "3. Estou jogando mas estou preso em bug dentro do jogo?")
bugs := MyGui.Add("DropDownList", "w400 Choose2", ["Sim", "Não"])

MyGui.Add("Text", "y+10", "4. São problemas estranhos que só acontecem na minha maquina?")
full := MyGui.Add("DropDownList", "w400 Choose2", ["Sim", "Não"])

MyGui.Add("Text", "y+10", "5. Gerar Relatório do Sistema para pedir ajuda?")
launch := MyGui.Add("DropDownList", "w400 Choose2", ["Sim", "Não"])

MyGui.Add("Button", "y+20 w400", "Executar").OnEvent("Click", RunDiagnosis)
MyGui.Show()

RunDiagnosis(*) {
    timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    resultado := []

    if perf.Value = 1 {
        resultado.Push("Ajuste de memória virtual")
        ShowInstructions("Ajuste de Memória Virtual", MemoryText())
        RunMemory()
    }
    if crash.Value = 1 {
        resultado.Push("Executar todas as correções DISM + SFC + Limpeza")
        ShowInstructions("Verificação de Sistema", CrashText())
        RunAll()
    }
    if bugs.Value = 1 {
        resultado.Push("Redefinir conta RSI")
        ShowInstructions("Resetar Conta RSI", ResetText())
        RunReset()
    }
    if full.Value = 1 {
        resultado.Push("Limpeza do cache do StarCitizen")
        ShowInstructions("Limpeza de cache", FullText())
        RunClean()
    }
    if launch.Value = 1 {
        resultado.Push("Relatório do Sistema")
        ;ShowInstructions("Abrir Relatório", RelatorioText())
        GerarRelatorio()
    }

    if resultado.Length = 0 {
        MsgBox("Nenhuma ação foi selecionada. Tente novamente.")
        return
    }

    log := timestamp " - " JoinArray(resultado, " | ")
    FileAppend(log "`n", logFile)
    ;MsgBox("Diagnóstico executado:`n" JoinArray(resultado, "`n"))
}

ShowInstructions(title, text) {
    infoGui := Gui("+AlwaysOnTop +Resize")
    infoGui.Title := title
    infoGui.SetFont("s10", "Segoe UI")
    infoGui.Add("Text", "w500", "Leia as instruções abaixo com atenção:")
    edit := infoGui.Add("Edit", "r20 w500 ReadOnly vInfoText") ; Removido -Wrap
    infoGui["InfoText"].Value := text
    infoGui.Add("Button", "w500", "OK").OnEvent("Click", (*) => infoGui.Destroy())
    infoGui.Show()
}

JoinArray(array, sep := ", ") {
    result := ""
    for index, item in array {
        result .= (index > 1 ? sep : "") item
    }
    return result
}

runTempBat(commands) {
    tempBat := A_Temp "\starcheck_temp.bat"
    FileAppend("@echo off`n" commands, tempBat)
    RunWait(tempBat)
    FileDelete(tempBat)
}

RunMemory() {
    Run("SystemPropertiesPerformance")
}

RunAll() {
    runTempBat("
    (
echo Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo Executando SFC...
sfc /scannow
echo Limpando pasta temporária...
rmdir /s ""%appdata%\Star Citizen""
echo Tudo concluído.
pause
    )")
}

RunReset() {
    Run("https://robertsspaceindustries.com/account/reset")
}

RunClean() {
    runTempBat("
    (
@echo off
chcp 1252
echo Limpando pasta temporária...
echo rmdir /s "%localappdata%\Star Citizen"
rmdir /s "%localappdata%\Star Citizen"
echo Tudo concluído.
pause
    )")
}

GerarRelatorio() {
    caminho := A_ScriptDir "\RelatorioSistema.txt"
    RunWait("msinfo32 /report `"" caminho "`"", , "Hide")
}

RunRSI() {
    Run("C:\Program Files\Roberts Space Industries\RSI Launcher\RSI Launcher.exe")
}

MemoryText() {
    return "
(
Instruções para ajustar a memória virtual:

Caso janela de configuração não abra automaticamente:
1. Pressione Win + R, digite 'sysdm.cpl' e pressione Enter.
2. Vá para a aba Avançado e clique em Configurações... na seção Desempenho.
Se a janela de configuração abriu automaticamente começe por aqui:
3. Na nova janela, vá para a aba Avançado e clique em Alterar... na seção Memória Virtual.
4. Desmarque 'Gerenciar automaticamente o tamanho do arquivo de paginação para todas as unidades'.
5. Selecione uma unidade (de preferência diferente da do Windows e seja um SSD) ou use C: se for a única.
6. Marque 'Tamanho personalizado' e defina o Tamanho inicial e máximo para pelo menos o valor recomendado 32000.
7. Clique no botão > Definir e depois 
8. Se tiver outras unidades selecione cada um delas, depois clique em "Sem Arquivo de Paginação" e clique em "Definir".
9. Quando tiver somente 1 das unidades com 32000 - 32000 na lista em OK para aplicar.
10. Reinicie o computador para que as mudanças tenham efeito.
)"
}

ResetText() {
    return "
(
RESETAR CONTA RSI (ÚLTIMO RECURSO)

Isso irá resetar as configurações da sua conta RSI no site. Use isso para corrigir problemas dentro do jogo, como personagem preso, itens sumidos, ou outros bugs estranhos.

Isso irá abrir seu navegador padrão e deslogar você do site da RSI. Você precisará fazer login, clicar em 'Request Repair', descrever o problema, informar os e-mails e confirmar a senha, depois enviar.

Isso NÃO irá deletar sua conta ou dados, apenas irá resetar as configurações da conta no site.
)"
}

CrashText() {
    return "
(
VERIFICAÇÃO DE SISTEMA

Esta opção executa comandos de verificação e reparo do Windows:

- DISM /RestoreHealth: repara a imagem do sistema
- SFC /scannow: verifica e corrige arquivos corrompidos
- Limpa a pasta temporária do Star Citizen

Reinicie o computador após a conclusão para garantir que as correções tenham efeito.
)"
}

FullText() {
    return "
(
Limpando o Cache

Este script deleta a pasta de arquivos temporários do StarCitizen.
È recomendado executar sempre depois de TODA atualização!
Verificando se a pasta existe "%localappdata%\Star Citizen"

)"
}

RelatorioText() {
    return "
(
O realtório será aberto agora.

)"
}