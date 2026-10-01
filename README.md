# 身心日历

一个可运行的 OctoSense Script App：在月历中记录每天的饮食、睡眠、情绪精力、身体感受和备注。日常记录完全保存在应用隔离存储中；AI 分析是可选能力，当前 OctoSense 官方宿主可能显示“不可用”。

## 功能

- 顶部统计：当月记录、连续天数、累计记录
- 月历浏览、前后月份切换和“回到今天”
- 每日饮食、睡眠、情绪/精力、身体状态和备注
- 常用状态快捷标签
- 圆点标记已有记录的日期
- 本地 JSON 持久化，重启后保留
- 通过 `octos.session.open` 与 `octos.turn.start` 请求设备助手分析
- AI 不可用时清楚显示原因，不影响记录功能

## 开发环境

按照 [OctoScript-App-Design-Flow 快速上手](https://github.com/OctoSense-org/OctoScript-App-Design-Flow/blob/main/docs/QUICKSTART.md) 准备：

```text
<workspace>/
  OctoScript-App-Design-Flow/
  OctoSense-App-Hub/
  makepad/
  octoscript/
  octoscript-makepad/
  apps/octosense-app/       # 本仓库
```

构建 `hub` 和 `card-host`：

```powershell
cd <workspace>\OctoSense-App-Hub
cargo build --release -p octosense-card-host -p octosense-app-hub
```

宿主编译好后，本仓库自带脚本可以直接运行（自动设置 `OCTO_HUB` / `OCTO_CARD_HOST`）：

```powershell
.\run.ps1                 # 以可见窗口启动，自己点着看
.\run.ps1 -Check          # 只跑 hub 准入检查并盖戳
.\run.ps1 -Hidden         # 无头启动，不占屏幕（适合截图 / agent）
.\run.ps1 -Port 8142      # 换端口
```

脚本等价的手动命令（运行与截图，PowerShell）：

```powershell
$env:PYTHONUTF8='1'
$env:OCTO_HUB='<workspace>\OctoSense-App-Hub\target\release\hub.exe'
$env:OCTO_CARD_HOST='<workspace>\OctoSense-App-Hub\target\release\card-host.exe'
$OCTO='<workspace>\OctoScript-App-Design-Flow\tools\octo'
python $OCTO run '<workspace>\apps\octosense-app\bundle' --hidden --port 8141 --detach
python $OCTO shot 8141 '<workspace>\apps\octosense-app\bundle\screenshots\01-calendar.png'
python $OCTO check '<workspace>\apps\octosense-app\bundle'
curl.exe -s http://127.0.0.1:8141/quit
```

## 数据与隐私

运行时数据保存在应用隔离目录的 `health_calendar.json`。记录只有在用户点击“根据记录生成分析”时才会通过宿主助手接口发送；应用不包含、不索取模型密钥。完整说明见 [PRIVACY.md](PRIVACY.md)。

## 重要限制

- AI 分析不是医疗诊断或治疗建议。
- AI 服务不可用时，记录、回看和本地保存仍然完整可用。
- 当前仅在 Windows 的 `card-host` 上做过运行验证；Android、iOS、macOS 和真机均未验证。