Config = {}

-- Target 系统配置
-- 可选值: 'qb-target', 'ox_target', false
-- 如果选择 'qb-target' 或者 'ox_target' 会启动对应的函数
-- 如果选择 false 则不会启用 target
Config.Target = 'qb-target' -- 或 'ox_target' 或 false

-- 动画配置
Config.CarryAnimDict = 'missfinale_c2mcs_1'
Config.CarryAnimName = 'fin_c2_mcs_1_camman'
Config.CarryProp = 'prop_cs_tablet'

-- 距离配置
Config.CarryDistance = 2.0 -- 背人时的最大距离

-- 语言配置
-- 可选值: 'zh-CN' (中文简体), 'zh-TW' (中文繁體), 'zh-HK' (香港繁體), 'ko' (한국어), 'en' (English),
--         'ja' (日本語), 'fr' (Français), 'de' (Deutsch), 'es' (Español), 'ru' (Русский),
--         'pt' (Português), 'it' (Italiano), 'nl' (Nederlands), 'pl' (Polski), 'tr' (Türkçe),
--         'ar' (العربية), 'th' (ไทย), 'vi' (Tiếng Việt)
Config.Language = 'zh-CN' -- 默认语言

-- 其他配置
Config.Debug = false -- 调试模式

