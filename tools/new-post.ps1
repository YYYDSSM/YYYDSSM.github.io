# 新建一篇博客文章：只输入标题，自动生成带头信息的 Markdown 文件并打开编辑器
# 由「新建文章.bat」调用，也可以单独右键“使用 PowerShell 运行”

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location -LiteralPath $root

Write-Host "==== 新建博客文章 ===="
$title = Read-Host "请输入文章标题（直接回车则取消）"
if ([string]::IsNullOrWhiteSpace($title)) { Write-Host "没有输入标题，已取消。"; exit }
$title = $title.Trim()

$now = Get-Date
$yamlTitle = ($title -replace '["\\]', '').Trim()
$safeTitle = ($title -replace '[/\\:*?"<>|：／＼＊？＂＜＞｜]', '').Trim() -replace '\s+', '-'
if ([string]::IsNullOrWhiteSpace($safeTitle)) { $safeTitle = $now.ToString('yyyyMMddHHmmss') }

$permalink = $now.ToString('yyyy/MM/dd') + '/' + $safeTitle + '/'
$fileName  = $now.ToString('yyyy-MM-dd-HHmmss') + '.md'
$postsDir  = Join-Path $root 'source\_posts'
if (-not (Test-Path -LiteralPath $postsDir)) { New-Item -ItemType Directory -Path $postsDir | Out-Null }
$file = Join-Path $postsDir $fileName

$lines = @(
    '---'
    ('title: "' + $yamlTitle + '"')
    ('date: ' + $now.ToString('yyyy-MM-dd HH:mm:ss'))
    ('permalink: ' + $permalink)
    'categories: FPGA'
    'tags:'
    '---'
    ''
    '在这里写正文，支持 Markdown：**加粗**、`代码`、图片、表格。'
    ''
    '<!-- more -->'
    ''
    '## 小标题'
    ''
    ''
)
$text = ($lines -join "`r`n")
[IO.File]::WriteAllText($file, $text, (New-Object Text.UTF8Encoding($false)))

Write-Host ""
Write-Host ('已创建：' + $file)
Write-Host ('文章地址将是：https://yyydssm.github.io/' + $permalink)

$codeCmd = 'D:\Program Files\VScode\bin\code.cmd'
if ($env:NEWPOST_NOEDIT -eq '1') { exit }
if (Test-Path -LiteralPath $codeCmd) {
    & $codeCmd $file
    Write-Host "已用 VS Code 打开，写完保存即可。"
} else {
    Start-Process notepad.exe $file
    Write-Host "已用记事本打开，写完保存即可。"
}

Write-Host ""
Write-Host "下一步：双击「本地预览.bat」看效果，满意后双击「发布上线.bat」。"
