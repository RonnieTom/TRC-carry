# TRC Carry Script - 背人系统 / Carry System

一个用于 FiveM 的背人（Carry）脚本，无需任何核心框架。  
A FiveM carry script that requires no core framework.

## 功能特性 / Features

- ✅ 支持 `/carry` 指令背起附近玩家 / Support `/carry` command to carry nearby players
- ✅ 支持 qb-target 交互系统 / Support qb-target interaction system
- ✅ 支持 ox_target 交互系统 / Support ox_target interaction system
- ✅ 可配置的 Target 系统 / Configurable Target system
- ✅ 流畅的动画效果 / Smooth animation effects
- ✅ 服务端同步验证 / Server-side synchronization and validation
- ✅ 18种语言支持 / 18 languages support

## 安装说明 / Installation

1. 将 `TRC-carry` 文件夹放入 `resources` 目录  
   Place the `TRC-carry` folder into the `resources` directory

2. 在 `server.cfg` 中添加：  
   Add to your `server.cfg`:
   ```
   ensure TRC-carry
   ```

3. 根据你的服务器配置修改 `Config.lua`  
   Modify `Config.lua` according to your server configuration

## 配置说明 / Configuration

在 `Config.lua` 文件中可以配置以下选项：  
You can configure the following options in `Config.lua`:

```lua
Config.Target = 'qb-target' -- 可选: 'qb-target', 'ox_target', false / Options: 'qb-target', 'ox_target', false
Config.Language = 'zh-CN' -- 语言设置 / Language setting
```

### Target 系统配置 / Target System Configuration
- `'qb-target'`: 使用 qb-target 交互系统 / Use qb-target interaction system
- `'ox_target'`: 使用 ox_target 交互系统 / Use ox_target interaction system
- `false`: 不使用 Target 系统，仅使用指令 / Do not use Target system, command only

### 语言配置 / Language Configuration
支持以下18种语言：  
Supports the following 18 languages:

- `'zh-CN'`: 中文简体（默认）/ Simplified Chinese (Default)
- `'zh-TW'`: 中文繁體 / Traditional Chinese
- `'zh-HK'`: 香港繁體 / Hong Kong Traditional Chinese
- `'ko'`: 한국어 / Korean
- `'en'`: English / 英文
- `'ja'`: 日本語 / Japanese
- `'fr'`: Français / French
- `'de'`: Deutsch / German
- `'es'`: Español / Spanish
- `'ru'`: Русский / Russian
- `'pt'`: Português / Portuguese
- `'it'`: Italiano / Italian
- `'nl'`: Nederlands / Dutch
- `'pl'`: Polski / Polish
- `'tr'`: Türkçe / Turkish
- `'ar'`: العربية / Arabic
- `'th'`: ไทย / Thai
- `'vi'`: Tiếng Việt / Vietnamese

## 使用方法 / Usage

### 指令方式 / Command Method
- 输入 `/carry` 背起或放下附近的玩家  
  Type `/carry` to carry or put down nearby players

### Target 方式 / Target Method
如果启用了 Target 系统：  
If Target system is enabled:
- 对准玩家会出现"背起玩家"选项  
  Aim at a player to see "Carry Player" option
- 背起后对准玩家会出现"放下玩家"选项  
  After carrying, aim at the player to see "Put Down Player" option

### 控制说明 / Controls
- **背人玩家 / Carrying Player**: 按 `X` 键放下玩家 / Press `X` to put down player
- **被背玩家 / Carried Player**: 按 `X` 键取消被背 / Press `X` to cancel being carried

## 依赖 / Dependencies

- qb-target 或 ox_target（可选，根据配置）  
  qb-target or ox_target (Optional, based on configuration)

## 版本 / Version

v1.0.0

## 作者 / Author

Tom Ronnie / TRC
