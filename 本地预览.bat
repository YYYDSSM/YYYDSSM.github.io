@echo off
chcp 936 >nul
cd /d "%~dp0"
echo 正在启动本地预览，7 秒后会自动打开浏览器 http://127.0.0.1:4000
start "Hexo 预览（关闭本窗口即停止预览）" /min "%~dp0tools\node\node.exe" node_modules\hexo\bin\hexo server -p 4000
timeout /t 7 >nul
start "" http://127.0.0.1:4000
echo 预览已启动。改完文章回到这里双击“发布上线.bat”即可。
pause