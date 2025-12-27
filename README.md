# TRC Carry Script - 背人系统

一个用于 FiveM 的背人（Carry）脚本，无需任何核心框架。

## 功能特性

- ✅ 支持 `/carry` 指令背起附近玩家
- ✅ 支持 qb-target 交互系统
- ✅ 支持 ox_target 交互系统
- ✅ 可配置的 Target 系统
- ✅ 流畅的动画效果
- ✅ 服务端同步验证

## 安装说明

1. 将 `TRC-carry` 文件夹放入 `resources` 目录
2. 在 `server.cfg` 中添加：
   ```
   ensure TRC-carry
   ```
3. 根据你的服务器配置修改 `Config.lua`

## 配置说明

在 `Config.lua` 文件中可以配置以下选项：

```lua
Config.Target = 'qb-target' -- 可选: 'qb-target', 'ox_target', false
Config.Language = 'zh-CN' -- 语言设置
```

### Target 系统配置
- `'qb-target'`: 使用 qb-target 交互系统
- `'ox_target'`: 使用 ox_target 交互系统
- `false`: 不使用 Target 系统，仅使用指令

### 语言配置
支持以下18种语言：
- `'zh-CN'`: 中文简体（默认）
- `'zh-TW'`: 中文繁體
- `'zh-HK'`: 香港繁體
- `'ko'`: 한국어 (韩语)
- `'en'`: English (英文)
- `'ja'`: 日本語 (日语)
- `'fr'`: Français (法语)
- `'de'`: Deutsch (德语)
- `'es'`: Español (西班牙语)
- `'ru'`: Русский (俄语)
- `'pt'`: Português (葡萄牙语)
- `'it'`: Italiano (意大利语)
- `'nl'`: Nederlands (荷兰语)
- `'pl'`: Polski (波兰语)
- `'tr'`: Türkçe (土耳其语)
- `'ar'`: العربية (阿拉伯语)
- `'th'`: ไทย (泰语)
- `'vi'`: Tiếng Việt (越南语)

## 使用方法

### 指令方式
- 输入 `/carry` 背起或放下附近的玩家

### Target 方式
如果启用了 Target 系统：
- 对准玩家会出现"背起玩家"选项
- 背起后对准玩家会出现"放下玩家"选项

## 依赖

- qb-target 或 ox_target（可选，根据配置）

## 版本

v1.0.0

## 作者

TRC

