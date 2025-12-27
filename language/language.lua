-- 语言数据存储（所有语言文件会在shared_scripts中加载）
if not Languages then
    Languages = {}
end

-- 获取语言文本
function GetLang(key)
    if not Config then
        return key
    end
    
    local lang = Config.Language or 'zh-CN'
    
    -- 检查语言是否存在
    if Languages and Languages[lang] and Languages[lang][key] then
        return Languages[lang][key]
    elseif Languages and Languages['zh-CN'] and Languages['zh-CN'][key] then
        -- 如果找不到，返回默认语言（中文简体）
        return Languages['zh-CN'][key]
    elseif Languages and Languages['en'] and Languages['en'][key] then
        -- 如果中文也找不到，返回英文
        return Languages['en'][key]
    else
        -- 如果都找不到，返回key本身
        return key
    end
end

