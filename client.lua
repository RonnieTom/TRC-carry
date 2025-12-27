-- 状态变量
local isCarrying = false
local carriedPed = nil
local isBeingCarried = false
local carrierPed = nil

-- 常量
local INPUT_CANCEL = 73 -- X键 (INPUT_VEH_DUCK)
local ANIM_DICT_CARRIED = 'nm'
local ANIM_NAME_CARRIED = 'firemans_carry'

-- 语言获取函数
local function GetLangText(key)
    if GetLang then
        return GetLang(key)
    else
        return key
    end
end

-- 被背玩家需要禁用的控制列表
local DISABLED_CONTROLS = {
    30, 31, 32, 33, 34, 35, -- 移动 (WASD)
    21, 22, 36,             -- 冲刺、跳跃、蹲下
    44, 38, 47, 58, 140,    -- Q、E、G、武器选择、R
    141, 142, 143,          -- 鼠标中键
    172, 173, 174, 175,     -- 方向键
    177, 178, 199, 200      -- 返回、删除、暂停、ESC
}

-- GTA5原版通知函数
local function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- 获取最近的玩家
local function GetClosestPlayer(maxDistance)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local closestPed = nil
    local closestDistance = maxDistance or Config.CarryDistance
    
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed and targetPed ~= 0 then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestPed = targetPed
            end
        end
    end
    
    return closestPed
end

-- 初始化 Target 系统
Citizen.CreateThread(function()
    if Config.Target == 'qb-target' then
        -- 等待 qb-target 资源加载
        Wait(1000)
        exports['qb-target']:AddGlobalPlayer({
            options = {
                {
                    type = "client",
                    event = "trc-carry:client:carryPlayer",
                    icon = "fas fa-hand-holding",
                    label = GetLangText('target_carry'),
                    canInteract = function(entity)
                        return not isCarrying and not IsPedInAnyVehicle(PlayerPedId(), false)
                    end,
                },
                {
                    type = "client",
                    event = "trc-carry:client:stopCarry",
                    icon = "fas fa-hand-paper",
                    label = GetLangText('target_stop'),
                    canInteract = function(entity)
                        return isCarrying
                    end,
                }
            },
            distance = 2.0
        })
    elseif Config.Target == 'ox_target' then
        -- 等待 ox_target 资源加载
        Wait(1000)
        exports.ox_target:addGlobalPlayer({
            {
                name = 'carryPlayer',
                icon = 'fas fa-hand-holding',
                label = GetLangText('target_carry'),
                onSelect = function()
                    TriggerEvent('trc-carry:client:carryPlayer')
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isCarrying and not IsPedInAnyVehicle(PlayerPedId(), false)
                end,
            },
            {
                name = 'stopCarry',
                icon = 'fas fa-hand-paper',
                label = GetLangText('target_stop'),
                onSelect = function()
                    TriggerEvent('trc-carry:client:stopCarry')
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    return isCarrying
                end,
            }
        })
    end
end)

-- 加载动画字典（优化：避免重复加载）
local loadedAnimDicts = {}
local function LoadAnimDict(dict)
    if loadedAnimDicts[dict] then
        return
    end
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    loadedAnimDicts[dict] = true
end

-- 开始背人
function StartCarry(targetPed)
    local playerPed = PlayerPedId()
    
    if isCarrying then
        ShowNotification(GetLangText('carry_already'))
        return
    end
    
    if IsPedInAnyVehicle(playerPed, false) then
        ShowNotification(GetLangText('carry_in_vehicle'))
        return
    end
    
    if targetPed == playerPed then
        ShowNotification(GetLangText('carry_self'))
        return
    end
    
    -- 加载动画
    LoadAnimDict(Config.CarryAnimDict)
    
    -- 请求服务端同步
    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
    TriggerServerEvent('trc-carry:server:startCarry', targetServerId)
    
    isCarrying = true
    carriedPed = targetPed
    
    -- 播放动画（参考文件实现方式，使用100000作为持续时间）
    TaskPlayAnim(playerPed, Config.CarryAnimDict, Config.CarryAnimName, 8.0, -8.0, 100000, 49, 0, false, false, false)
    
    if Config.Debug then
        print("开始背人: " .. tostring(targetPed))
    end
end


-- 停止背人
function StopCarry()
    if not isCarrying then
        return
    end
    
    local playerPed = PlayerPedId()
    
    -- 通知服务端
    if carriedPed and DoesEntityExist(carriedPed) then
        local targetPlayerIndex = NetworkGetPlayerIndexFromPed(carriedPed)
        if targetPlayerIndex ~= -1 then
            TriggerServerEvent('trc-carry:server:stopCarry', GetPlayerServerId(targetPlayerIndex))
        end
    end
    
    -- 停止动画（参考文件实现方式）
    ClearPedSecondaryTask(playerPed)
    
    -- 分离实体（参考文件实现方式，被背玩家会自己分离）
    -- 不需要在这里分离，因为被背玩家会自己处理
    
    isCarrying = false
    carriedPed = nil
    
    if Config.Debug then
        print("停止背人")
    end
end

-- 指令处理
RegisterCommand('carry', function()
    if isCarrying then
        StopCarry()
        ShowNotification(GetLangText('carry_stop'))
    else
        local closestPed = GetClosestPlayer()
        if closestPed then
            StartCarry(closestPed)
            ShowNotification(GetLangText('carry_success'))
        else
            ShowNotification(GetLangText('carry_no_player'))
        end
    end
end, false)

-- 事件处理（Target系统）
RegisterNetEvent('trc-carry:client:carryPlayer', function()
    local closestPed = GetClosestPlayer()
    if closestPed then
        StartCarry(closestPed)
    end
end)

RegisterNetEvent('trc-carry:client:stopCarry', function()
    StopCarry()
end)

-- 被背起事件（从服务端触发）- 参考文件实现方式
RegisterNetEvent('trc-carry:client:beingCarried', function(carrierServerId)
    local carrier = GetPlayerPed(GetPlayerFromServerId(carrierServerId))
    local playerPed = PlayerPedId()
    
    if carrier and carrier ~= 0 and DoesEntityExist(carrier) then
        isBeingCarried = true
        carrierPed = carrier
        
        -- 清除所有任务和动画
        ClearPedTasksImmediately(playerPed)
        ClearPedSecondaryTask(playerPed)
        
        -- 加载动画字典
        LoadAnimDict(ANIM_DICT_CARRIED)
        
        -- 关键：被背玩家自己附加到自己身上（参考文件的实现方式）
        -- AttachEntityToEntity参数：entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot
        AttachEntityToEntity(
            playerPed,        -- entity1: 要附加的实体（被背玩家自己）
            carrier,          -- entity2: 附加到的实体（背人玩家）
            0,                -- boneIndex: 使用SKEL_ROOT (0)
            0.27,             -- xPos: X偏移
            0.15,             -- yPos: Y偏移
            0.63,             -- zPos: Z偏移
            0.5,              -- xRot: X旋转
            0.5,              -- yRot: Y旋转
            180,              -- zRot: Z旋转（参考文件使用180）
            false,            -- p9: 未知参数
            false,            -- useSoftPinning: 不使用软固定
            false,            -- collision: 不启用碰撞
            false,            -- isPed: 不使用isPed参数（参考文件使用false）
            2,                -- vertexIndex: 顶点索引（参考文件使用2）
            false             -- fixedRot: 不固定旋转
        )
        
        -- 禁用碰撞和混合
        SetEntityCollision(playerPed, false, false)
        NetworkSetEntityCanBlend(playerPed, false)
        SetEntityInvincible(playerPed, true)
        
        if Config.Debug then
            print("被背起，实体已附加到: " .. tostring(carrier))
        end
    end
end)

-- 停止被背事件（参考文件实现方式）
RegisterNetEvent('trc-carry:client:stopBeingCarried', function()
    local playerPed = PlayerPedId()
    
    isBeingCarried = false
    carrierPed = nil
    
    -- 清除任务和分离实体（参考文件实现方式）
    ClearPedSecondaryTask(playerPed)
    DetachEntity(playerPed, true, false)
    
    -- 恢复实体属性
    SetEntityCollision(playerPed, true, true)
    NetworkSetEntityCanBlend(playerPed, true)
    SetEntityInvincible(playerPed, false)
    
    if Config.Debug then
        print("停止被背")
    end
end)

-- 显示帮助文本
function ShowHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- 主循环：保持背人状态
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isCarrying and carriedPed then
            local playerPed = PlayerPedId()
            
            -- 检查实体是否存在（参考文件没有距离检查）
            if not DoesEntityExist(carriedPed) then
                StopCarry()
            end
            
            -- 保持动画（参考文件实现方式，使用100000作为持续时间）
            if not IsEntityPlayingAnim(playerPed, Config.CarryAnimDict, Config.CarryAnimName, 3) then
                TaskPlayAnim(playerPed, Config.CarryAnimDict, Config.CarryAnimName, 8.0, -8.0, 100000, 49, 0, false, false, false)
            end
            
            -- 显示帮助提示
            ShowHelpText(GetLangText('help_carry'))
            
            -- 检查X键（INPUT_VEH_DUCK = 73）
            if IsControlJustPressed(0, 73) then
                StopCarry()
                ShowNotification(GetLangText('carry_stop'))
            end
            
            -- 禁用某些动作
            DisableControlAction(0, 75, true) -- 离开载具
        elseif isBeingCarried then
            local playerPed = PlayerPedId()
            
            -- 保持被背动画（参考文件实现方式，使用100000作为持续时间）
            if not IsEntityPlayingAnim(playerPed, ANIM_DICT_CARRIED, ANIM_NAME_CARRIED, 3) then
                LoadAnimDict(ANIM_DICT_CARRIED)
                TaskPlayAnim(playerPed, ANIM_DICT_CARRIED, ANIM_NAME_CARRIED, 8.0, -8.0, 100000, 33, 0, false, false, false)
            end
            
            -- 显示帮助提示
            ShowHelpText(GetLangText('help_carried'))
            
            -- 检查X键（INPUT_VEH_DUCK = 73）
            if IsControlJustPressed(0, 73) then
                -- 通知服务端取消
                if carrierPed and DoesEntityExist(carrierPed) then
                    local carrierPlayerIndex = NetworkGetPlayerIndexFromPed(carrierPed)
                    if carrierPlayerIndex ~= -1 then
                        TriggerServerEvent('trc-carry:server:requestStop', GetPlayerServerId(carrierPlayerIndex))
                    end
                end
                -- 本地也停止
                TriggerEvent('trc-carry:client:stopBeingCarried')
                ShowNotification(GetLangText('carry_cancel'))
            end
            
            -- 被背玩家禁用移动相关控制，但保留视角控制和X键
            for _, control in ipairs(DISABLED_CONTROLS) do
                DisableControlAction(0, control, true)
            end
            
            -- 保留视角控制（鼠标/右摇杆）- 不禁用视角相关控制
            -- 保留X键用于取消
            EnableControlAction(0, INPUT_CANCEL, true)
            EnableControlAction(1, INPUT_CANCEL, true)
            EnableControlAction(2, INPUT_CANCEL, true)
            
            -- 检查是否还在被背
            if not carrierPed or not DoesEntityExist(carrierPed) then
                isBeingCarried = false
                carrierPed = nil
                ClearPedTasksImmediately(playerPed)
                SetEntityCollision(playerPed, true, true)
                NetworkSetEntityCanBlend(playerPed, true)
                SetEntityInvincible(playerPed, false)
            end
        else
            Wait(500)
        end
    end
end)

-- 清理
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if isCarrying then
            StopCarry()
        end
        if isBeingCarried then
            local playerPed = PlayerPedId()
            isBeingCarried = false
            carrierPed = nil
            ClearPedTasksImmediately(playerPed)
            SetEntityCollision(playerPed, true, true)
            NetworkSetEntityCanBlend(playerPed, true)
        end
    end
end)

