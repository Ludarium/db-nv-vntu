@echo off
chcp 65001 > nul

echo Запуск резервного копіювання

for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%b%%a)
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set mytime=%mytime: =0%

set BACKUP_DIR=C:\MySQL_Backups\
set FILENAME=%BACKUP_DIR%db_backup_%mydate%_%mytime%.sql

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" --login-path=backup_admin --no-tablespaces it_department > "%FILENAME%"


:: 5. Проверка кода возврата (errorLevel) утилиты mysqldump
if %errorLevel% == 0 (
    echo Резервна копія створена: %FILENAME%
) else (
    echo Помилка створення резервного копіювання:
    echo У поточного користувача Windows немає налаштованого 'backup_admin' або у нього немає прав Адміністратора MySQL.
)

timeout /t 5
