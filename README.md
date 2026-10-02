# 身心日历（OctoSense Script App）

一个可运行的 OctoSense Script App：在月历中记录每天的**饮食、健身、保健品和身心状态**，支持给当餐拍照，并可选地把记录交给设备助手做非医疗的关联分析。

所有字段都是可选的，没有任何一项必填；日常记录完全保存在应用隔离存储中，不联网也能用。

## 界面总览

| 月历与统计 | 历史月份 |
| --- | --- |
| ![月历与统计](bundle/screenshots/01-calendar.png) | ![历史月份](bundle/screenshots/02-month.png) |

| 饮食 | 健身 |
| --- | --- |
| ![饮食](bundle/screenshots/03-diet.png) | ![健身](bundle/screenshots/04-fitness.png) |

| 保健品 | 身心状态 |
| --- | --- |
| ![保健品](bundle/screenshots/05-supplements.png) | ![身心状态](bundle/screenshots/06-body.png) |

![AI 辅助分析](bundle/screenshots/07-ai.png)

![自定义选项](bundle/screenshots/08-settings.png)

## 功能详解

### 月历与统计

- 顶部三个数字：**当月记录**、**连续天数**、**累计记录**。
- 月历可前后翻月，“今天”一键回到当天。
- 有记录的日期下面显示圆点；今天用描边标出，选中的日期填充实心。
- 每次切换日期会自动保存上一天的编辑，不会丢内容。

### 饮食记录

- **类别多选**：粥类、米面主食、肉类、青菜、蛋奶、水果、汤羹、饮品、甜点。
- **菜系 / 来源多选**：家常、川菜、粤菜、江浙、西北、日韩、西式、外卖。
- 也可以只在文本框里自由描述，例如“早餐燕麦粥和鸡蛋；午后拿铁”。
- **拍照记录**：点击“拍照”打开相机取景，快门后照片存入应用自己的隔离目录（`DCIM/`）。已保存的照片以缩略图显示，点缩略图可全屏查看，“删最后一张”会连文件一起删除。
- 类别、菜系和照片都是可选的，不选也能只写文字。

### 健身记录

- **器械 / 项目多选**：哑铃、杠铃、壶铃、跑步机、动感单车、划船机、椭圆机、瑜伽垫、弹力带、徒手。
- **组数**、**每组次数**、**负重（kg）**、**有氧时长（分钟）** 四个数值输入，留空即为不做该项。
- 训练细节文本框可以记动作安排和主观感受，例如“深蹲 4 组，最后一组有点吃力”。

### 保健品记录

- **一键多选**：维生素C、维生素B族、维生素D、鱼油、钙片、益生菌、蛋白粉、镁、锌、铁、褪黑素。
- 用量和时间写在同一个文本框里，例如“维生素C 500mg 早饭后；鱼油 1 粒随午餐”。

### 身心状态

- 睡眠（小时 / 质量）、情绪 / 精力、身体状态（疼痛、肠胃、过敏等）和备注。
- 每项都带常用快捷标签，例如“轻松 / 平静 / 焦虑 / 低落”“良好 / 疲劳 / 肠胃不适 / 疼痛”，点一下填进输入框。

### 自定义选项

- 点右上角“设置”，可分别给饮食类别、菜系、健身器械、保健品添加选项；点现有选项末尾的 `×` 删除。
- 自定义内容保存在本机应用隔离目录的 `settings.json`，重启后仍在。“恢复默认选项”只重置选项，不清空日历记录或 AI 配置。
- 删除选项不会抹掉已经保存的历史记录。

### AI 辅助分析

- 按钮“根据记录生成分析”会把**当天记录 + 最多 20 条历史记录**交给 AI，请它寻找饮食、睡眠、情绪、运动、补剂之间的关联，并给出保守、可执行的建议。
- 提示词明确要求：不下医学诊断、不假装确定病因，并在出现胸痛、呼吸困难、意识异常、自伤想法或持续加重时建议立即就医；同时把记录内容标记为数据而非指令，避免记录里的文字被当成提示词执行。
- 只有你主动点击才会发送；**照片不会被发送**，只发送文字。Windows 开发环境可从本机配置导入方舟凭据。未配置时尝试 OctoSense 宿主助手。
- AI 不可用时界面会显示明确原因，其余功能完全不受影响。分析结果保存在当天记录里，切换日期后可重新查看。

2026-10-01 的演示数据已通过方舟 `ark-code-latest` 实际生成分析（原文保存在本机演示记录中）。模型指出：两次辛辣餐后记录了腹胀或胃热；力量训练后的疲劳同时伴随较短睡眠，不能归因于训练或单一补剂；午后拿铁与睡眠的关联证据较弱。它建议继续记录餐后症状、咖啡因时间、睡眠与训练强度，并提醒严重或持续加重的症状应就医。截图见上方“AI 辅助分析”。

### 数据与隐私

- 记录保存在应用隔离目录的 `health_calendar.json`；照片保存在同一隔离目录的 `DCIM/`。
- 应用不要求登录，也不会在后台自动上传。AI 凭据由本机脚本导入到被 Git 忽略的隔离目录，应用界面不显示它；文件本身是明文。
- 相机是可选能力：只有在清单里声明 `camera` 时才能调用，未声明会被宿主直接拒绝。
- 完整说明见 [PRIVACY.md](PRIVACY.md)。

## 编译与运行

### 1. 准备 workspace

按 [OctoScript-App-Design-Flow 快速上手](https://github.com/OctoSense-org/OctoScript-App-Design-Flow/blob/main/docs/QUICKSTART.md) 准备同级的五个仓库：

```text
<workspace>/
  OctoScript-App-Design-Flow/
  OctoSense-App-Hub/
  makepad/
  octoscript/
  octoscript-makepad/
  apps/octosense-app/       # 本仓库
```

### 2. 编译宿主

```powershell
cd <workspace>\OctoSense-App-Hub
cargo build --release -p octosense-card-host -p octosense-app-hub
```

产物在 `<workspace>\OctoSense-App-Hub\target\release\{hub.exe, card-host.exe}`。只要不改宿主的 Rust 代码，这步不用重复做。

### 3. 运行

本仓库自带脚本，会自动设置 `OCTO_HUB` / `OCTO_CARD_HOST`：

```powershell
cd <workspace>\apps\octosense-app
.\run.ps1                 # 可见窗口，自己点着看
.\run.ps1 -Check          # 只跑 hub 准入检查并盖戳
.\run.ps1 -Hidden         # 无头启动，不占屏幕（适合截图 / agent）
.\run.ps1 -Port 8155      # 换端口（默认 8154）
```

如果报“禁止运行脚本”，改用：

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

### 配置本机 AI

本机已配置火山方舟 Agent Plan 时，在应用目录运行：

```powershell
.\configure-ai.ps1
# 然后关闭并重启 App，再选一个有记录的日期点击“根据记录生成分析”
```

脚本优先读取 `ARK_API_KEY` 环境变量；没有时读取 `~/.codex/config.toml` 中指向方舟 Agent Plan 的凭据。可用 `ARK_MODEL` 指定模型（默认从 Codex 配置读取，或在 App 的“设置”里改）。运行 `.\configure-ai.ps1 -Clear` 可清除导入的凭据。`settings.json` 位于 `.local-state/health-calendar/`，已被 Git 忽略；不要把该文件加入截图或仓库。

OctoSense 的网络门禁只允许清单中声明的公开 HTTPS 主机。若当前 Codex 配置指向本地 HTTP 网关，导入脚本会保留已经导入的方舟凭据；首次配置时请提供 `ARK_API_KEY`，本地 HTTP 地址不能直接用于这个 bundle。

等价的手动命令：

```powershell
$env:PYTHONUTF8='1'
$env:OCTO_HUB='<workspace>\OctoSense-App-Hub\target\release\hub.exe'
$env:OCTO_CARD_HOST='<workspace>\OctoSense-App-Hub\target\release\card-host.exe'
$OCTO='<workspace>\OctoScript-App-Design-Flow\tools\octo'
python $OCTO run '<workspace>\apps\octosense-app\bundle' --port 8154
```

### 4. 校验与截图

```powershell
# 改过 bundle/ 之后必须重新盖戳，否则宿主会拒绝启动
python $OCTO check '<workspace>\apps\octosense-app\bundle'

# 截图
python $OCTO shot 8154 '<workspace>\apps\octosense-app\bundle\screenshots\01-calendar.png'

# 结束运行中的实例
curl.exe -s http://127.0.0.1:8154/quit
```

> `.gitattributes` 里的 `bundle/** -text` 必须保留：`main.splash` 会被宿主按字节校验完整性，行尾被 Git 转换会直接导致校验失败。

## 打包与上架

只有 `bundle/` 是提交物（`manifest.json`、`listing.json`、`main.splash`、`assets/`、`screenshots/`）。上架流程见 [PUBLISHING](https://github.com/OctoSense-org/OctoScript-App-Design-Flow/blob/main/docs/PUBLISHING.md)，其中签名和提交是需要本人操作的步骤。

## 关于手机与 APK

这个项目**不是一个可以直接编译成 APK 的独立应用**，它是一个 OctoSense **bundle**（数据 + `main.splash` 脚本），由 OctoSense 宿主来运行。所以：

- **不能**把这一个 bundle 单独编译成 APK。APK 是 OctoSense 宿主本身，一个宿主承载很多 bundle。
- **想装到手机上，走官方上架**：签名并发布到 catalog 之后，它就会出现在每台手机的商店里。这是官方支持的路径。
- **想自己出 APK**：需要把整个 OctoSense Android 壳连同这个 bundle 一起编译（bundle 放进 `apps/<name>/bundle/`、登记到 `phone/system-apps.json`，再走 Android 的构建），需要 Android SDK/NDK 和 OctoSense 仓库；这条路径面向 `os.*` 系统应用。
- **侧载暂时不行**：官方文档明确说“任意 bundle 目前还不能侧载到官方 OctoSense 手机上”，因为手机商店只读取编译进去的 hub 和 anchor。

## 平台支持

| 能力 | Windows | Android / iOS / macOS / Linux |
| --- | --- | --- |
| 月历、记录、本地存储 | ✅ 已在 Windows `card-host` 实测 | 未实测 |
| 相机拍照 | ❌ 宿主无相机后端，显示明确不可用提示 | 宿主有相机实现，未在真机实测 |
| AI 分析 | 方舟本机配置已实测；无配置时宿主 `octos` 服务可能不可用 | 取决于宿主与配置 |

本仓库的截图均来自 Windows `card-host` 的真实运行。相机不可用是宿主平台的限制，不是应用缺陷：应用会捕获错误并显示原因，其他记录方式照常可用。

## 重要限制

- AI 分析不是医疗诊断或治疗建议。
- AI 服务不可用时，记录、回看和本地保存仍然完整可用。
- 当前仅在 Windows 的 `card-host` 上做过运行验证；Android、iOS、macOS 和真机均未验证。

## 许可证

Apache-2.0
