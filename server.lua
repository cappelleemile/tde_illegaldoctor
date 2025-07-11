local QBCore = exports['qb-core']:GetCoreObject()

local lastUsed = {}

-- Net Event: Speler kiest optie
RegisterNetEvent("tde-illegaledoctor:server:handleChoice", function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local isDead = Player.PlayerData.metadata['inlaststand']

    if type == "revive" then
        if isDead then
            if Player.Functions.RemoveMoney("cash", Config.RevivePrice, "illegale-revive") then
                TriggerClientEvent("hospital:client:Revive", src)
                TriggerClientEvent('QBCore:Notify', src, Config.Text.YouAreRevived, "success")
                TryAlertPolice(src)
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Text.YouDontHaveEnoughMoney, "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Text.YouSeemAlive, "error")
        end
    elseif not isDead and type == "heal" then
        if not isDead then
            if Player.Functions.RemoveMoney("cash", Config.HealPrice, "illegale-heal") then
                TriggerClientEvent("hospital:client:ResetLimbs", src)
                TriggerClientEvent("hospital:client:SetHeal", src)
                TriggerClientEvent("hospital:client:Revive", src)
                TriggerClientEvent('QBCore:Notify', src, Config.Text.YouAreHeald, "success")
                TryAlertPolice(src)
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Text.YouDontHaveEnoughMoney, "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Text.YouAreDead, "error")
        end
    elseif type == "adrenaline" then
        if not isDead then
            if Player.Functions.RemoveMoney("cash", 600, "illegale-adrenaline") then
                TriggerClientEvent("tde-illegaledoctor:client:applyAdrenaline", src)
                TriggerClientEvent('QBCore:Notify', src, Config.Text.YouAreInjected, "success")
                TryAlertPolice(src)
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Text.YouDontHaveEnoughMoney, "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Text.YouAreDead, "error")
        end
    end
end)

-- Kans op politiealert
function TryAlertPolice(src)
    if math.random(1, 100) <= Config.PoliceAlertChance then
        local pos = GetEntityCoords(GetPlayerPed(src))
        TriggerEvent("police:server:policeAlert", Config.Text.PoliceAlert)
    end
end