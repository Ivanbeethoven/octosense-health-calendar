param([switch]$Clear)

$ErrorActionPreference = 'Stop'
$jail = Join-Path $PSScriptRoot '.local-state\health-calendar'
$path = Join-Path $jail 'settings.json'
New-Item -ItemType Directory -Path $jail -Force | Out-Null

if (Test-Path $path) {
    $settings = Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
} else {
    $settings = [pscustomobject]@{}
}

if ($Clear) {
    $token = ''
    $model = $null
} elseif ($env:ARK_API_KEY) {
    $token = $env:ARK_API_KEY
    $model = $env:ARK_MODEL
} else {
    $configPath = Join-Path $env:USERPROFILE '.codex\config.toml'
    if (-not (Test-Path $configPath)) { throw '未找到 Codex 配置；请设置 ARK_API_KEY 环境变量。' }
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8
    $baseUrl = [regex]::Match($config, '(?m)^base_url\s*=\s*"([^"]+)"').Groups[1].Value
    if ($baseUrl -ne 'https://ark.cn-beijing.volces.com/api/plan/v3') {
        if ($settings.PSObject.Properties['ai_token'] -and $settings.ai_token) {
            Write-Host 'Codex 当前不是方舟接口；保留应用隔离存储中已有的方舟凭据。'
            return
        }
        throw 'Codex 当前不是本应用支持的方舟 Agent Plan 接口；请设置 ARK_API_KEY。'
    }
    $token = [regex]::Match($config, '(?m)^experimental_bearer_token\s*=\s*"([^"]+)"').Groups[1].Value
    $model = [regex]::Match($config, '(?m)^model\s*=\s*"([^"]+)"').Groups[1].Value
    if (-not $token) { throw 'Codex 配置中没有方舟令牌；请设置 ARK_API_KEY。' }
}

$settings | Add-Member -NotePropertyName ai_token -NotePropertyValue $token -Force
if ($model) { $settings | Add-Member -NotePropertyName ai_model -NotePropertyValue $model -Force }
$json = $settings | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($path, $json + "`n", [System.Text.UTF8Encoding]::new($false))
if ($Clear) { Write-Host '已从应用隔离存储清除 AI 凭据。重启应用生效。' }
else { Write-Host '已导入方舟凭据到应用隔离存储。重启应用生效。' }
