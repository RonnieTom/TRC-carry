-- 存储背人状态（参考文件实现方式）
local carrying = {}
local carried = {}

-- 检查距离的辅助函数
local function CheckDistance(src, targetSrc, maxDistance)
    local sourcePed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetSrc)
    
    if not sourcePed or sourcePed == 0 or not targetPed or targetPed == 0 then
        return false
    end
    
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = #(sourceCoords - targetCoords)
    
    return distance <= (maxDistance or 3.0)
end

-- 开始背人（服务端验证和同步）- 参考文件实现方式
RegisterNetEvent('trc-carry:server:startCarry', function(targetServerId)
    local src = source
    
    -- 检查距离
    if CheckDistance(src, targetServerId, 3.0) then
        -- 直接通知目标玩家被背起（目标玩家会自己附加，参考文件实现方式）
        TriggerClientEvent('trc-carry:client:beingCarried', targetServerId, src)
        carrying[src] = targetServerId
        carried[targetServerId] = src
        
        if Config.Debug then
            print(string.format("玩家 %d 开始背起玩家 %d", src, targetServerId))
        end
    elseif Config.Debug then
        print(string.format("玩家 %d 距离玩家 %d 太远", src, targetServerId))
    end
end)

-- 清理背人状态的辅助函数
local function CleanupCarry(carrierSrc, carriedSrc)
    if carrierSrc and carrying[carrierSrc] then
        TriggerClientEvent('trc-carry:client:stopBeingCarried', carrying[carrierSrc])
        carried[carrying[carrierSrc]] = nil
        carrying[carrierSrc] = nil
    end
    if carriedSrc and carried[carriedSrc] then
        TriggerClientEvent('trc-carry:client:stopCarry', carried[carriedSrc])
        carrying[carried[carriedSrc]] = nil
        carried[carriedSrc] = nil
    end
end

-- 停止背人（服务端同步，参考文件实现方式）
RegisterNetEvent('trc-carry:server:stopCarry', function(targetServerId)
    local src = source
    
    if carrying[src] then
        -- 通知被背玩家停止
        TriggerClientEvent('trc-carry:client:stopBeingCarried', carrying[src])
        carried[carrying[src]] = nil
        carrying[src] = nil
    elseif carried[src] then
        -- 被背玩家请求停止
        TriggerClientEvent('trc-carry:client:stopCarry', carried[src])
        carrying[carried[src]] = nil
        carried[src] = nil
    end
    
    if Config.Debug then
        print(string.format("玩家 %d 停止了背人", src))
    end
end)

-- 被背玩家请求停止
RegisterNetEvent('trc-carry:server:requestStop', function(carrierServerId)
    local src = source
    
    if carried[src] then
        local carrierSrc = carried[src]
        -- 通知背人玩家停止
        TriggerClientEvent('trc-carry:client:stopCarry', carrierSrc)
        -- 通知被背玩家停止
        TriggerClientEvent('trc-carry:client:stopBeingCarried', src)
        -- 清理状态
        carrying[carrierSrc] = nil
        carried[src] = nil
        
        if Config.Debug then
            print(string.format("玩家 %d 请求停止被背，已通知玩家 %d", src, carrierSrc))
        end
    end
end)

-- 玩家断开连接时清理（参考文件实现方式）
AddEventHandler('playerDropped', function(reason)
    local src = source
    CleanupCarry(src, src)
end)

