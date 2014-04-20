
@ECHO OFF

set foldername=lizards-journey-v0.3.1
md %foldername%
copy readme.md "%~dp0\%foldername%\readme.txt"
"D:\Program Files\7-Zip\7z" -r a -tzip .\%foldername%\game.love .\love2d\*.*
copy "buildmaterial\lovewin64\*.*" "%foldername%\"
copy /b "%foldername%\love.exe"+"%foldername%\game.love" "%foldername%\%foldername%.exe"
del ".\%foldername%\game.love"
del ".\%foldername%\love.exe"
"D:\Program Files\7-Zip\7z" -r a -tzip .\%foldername%.zip .\%foldername%
::rd /s /q %foldername%
pause