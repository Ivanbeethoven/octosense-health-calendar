# 运行 / 校验 身心日历（OctoSense Script App）
#
#   .\run.ps1              以可见窗口启动，方便自己点着看
#   .\run.ps1 -Hidden      无头启动（不占屏幕，适合 agent / 截图）
#   .\run.ps1 -Check       只跑 hub 准入检查并盖戳
#   .\run.ps1 -Port 8142   换端口（默认 8141）
#
# 前提：宿主二进制已编译过（见 README「开发环境」）。
param(
    [switch]$Hidden,
    [switch]$Check,
    [int]$Port = 8141
)

$ErrorActionPreference = 'Stop'

$AppDir    = $PSScriptRoot
$Bundle    = Join-Path $AppDir 'bundle'                       # 只有 bundle/ 是应用本体
$Workspace = Split-Path (Split-Path $AppDir -Parent) -Parent  # <workspace>/apps/<app> -> <workspace>
$HubRepo   = Join-Path $Workspace 'OctoSense-App-Hub'
$FlowRepo  = Join-Path $Workspace 'OctoScript-App-Design-Flow'
$Octo      = Join-Path $FlowRepo 'tools\octo'

$env:PYTHONUTF8     = '1'
$env:OCTO_HUB       = Join-Path $HubRepo 'target\release\hub.exe'
$env:OCTO_CARD_HOST = Join-Path $HubRepo 'target\release\card-host.exe'

foreach ($p in @($Octo, $env:OCTO_HUB, $env:OCTO_CARD_HOST)) {
    if (-not (Test-Path $p)) {
        Write-Host "找不到 $p" -ForegroundColor Red
        Write-Host "请先准备 workspace 并编译宿主：" -ForegroundColor Red
        Write-Host "  cd $HubRepo"
        Write-Host "  cargo build --release -p octosense-card-host -p octosense-app-hub"
        exit 2
    }
}

if ($Check) {
    Write-Host "octo check $Bundle" -ForegroundColor Cyan
    python $Octo check $Bundle
    exit $LASTEXITCODE
}

$octoArgs = @($Octo, 'run', $Bundle, '--port', $Port)
if ($Hidden) { $octoArgs += @('--hidden', '--detach') }

Write-Host ("python " + ($octoArgs -join ' ')) -ForegroundColor Cyan
python @octoArgs
exit $LASTEXITCODE