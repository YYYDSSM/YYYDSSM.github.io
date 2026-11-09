# 重新生成站点并推送到 GitHub Pages（YYYDSSM.github.io 的 master 分支）
# 用法：在项目根目录执行  .\deploy.ps1
#
# 为什么不用 hexo deploy：
#   本机 hexo-deployer-git 无法在 .deploy_git 里建立独立 git 仓库（git init 静默失败），
#   结果会把源工程的 commit 误推到 master。此脚本自行组装独立部署仓库后强制推送。

$ErrorActionPreference = "Stop"
$root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$git   = "C:\Program Files\Git\cmd\git.exe"
$repo  = "https://github.com/YYYDSSM/YYYDSSM.github.io.git"

Set-Location -LiteralPath $root

Write-Host "[1/4] 清理并生成静态文件"
& node "node_modules\hexo\bin\hexo" clean
& node "node_modules\hexo\bin\hexo" generate
if ($LASTEXITCODE -ne 0) { throw "hexo generate 失败" }

Write-Host "[2/4] 组装部署目录"
$dep = Join-Path $root ".deploy_git"
if (Test-Path -LiteralPath $dep) { Remove-Item -LiteralPath $dep -Recurse -Force }
New-Item -ItemType Directory -Path $dep | Out-Null
Copy-Item -Path (Join-Path $root "public\*") -Destination $dep -Recurse -Force
$nojekyll = Join-Path $dep ".nojekyll"
if (-not (Test-Path -LiteralPath $nojekyll)) { New-Item -ItemType File -Path $nojekyll | Out-Null }

Write-Host "[3/4] 建立部署仓库并提交"
& $git -C $dep init -b master | Out-Null
& $git -C $dep add -A
& $git -C $dep -c user.name=shaomingyang -c user.email=1306704057@qq.com commit -m ("Site generated " + (Get-Date -Format "yyyy-MM-dd HH:mm")) | Out-Null
if ($LASTEXITCODE -ne 0) { throw "git commit 失败" }

Write-Host "[4/4] 强制推送到 master"
& $git -C $dep remote add origin $repo
& $git -C $dep push -f origin HEAD:master
if ($LASTEXITCODE -ne 0) { throw "git push 失败" }

Write-Host "部署完成：https://yyydssm.github.io/"
