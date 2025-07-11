local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local model = Config.DoctorModel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    local npc = CreatePed(0, model, Config.DoctorLocation, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = "client",
                event = "tde-illegaledoctor:client:openMenu",
                icon = "fas fa-user-md",
                label = Config.Text.Target
            }
        },
        distance = Config.InteractionDistance
    })
end)

RegisterNetEvent("tde-illegaledoctor:client:openMenu", function()
    local currentPlayerHealth = GetEntityHealth(PlayerPedId())

    exports['qb-menu']:openMenu({
        {
            header = Config.Text.Title,
            isMenuHeader = true
        },
        {
            header = Config.Text.Revive .. " ($" .. Config.RevivePrice .. ")",
            txt = Config.Text.ReviveBio,
            params = {
                event = "tde-illegaledoctor:client:sendChoice",
                args = {
                    type = "revive"
                }
            }
        },
        {
            header = Config.Text.Heal .. " ($" .. Config.HealPrice .. ")",
            txt = Config.Text.HealBio,
            params = {
                event = "tde-illegaledoctor:client:sendChoice",
                args = {
                    type = "heal"
                }
            }
        },
        {
            header = Config.Text.Adrenaline .. " ($" .. Config.AdrenalinePrice .. ")",
            txt = Config.Text.AdrenalineBio,
            params = {
                event = "tde-illegaledoctor:client:sendChoice",
                args = {
                    type = "adrenaline"
                }
            }
        },
        {
            header = Config.Text.CloseMenu
        }
    })
end)

RegisterNetEvent("tde-illegaledoctor:client:sendChoice", function(data)
    TriggerServerEvent("tde-illegaledoctor:server:handleChoice", data.type)
end)

RegisterNetEvent("tde-illegaledoctor:client:applyAdrenaline", function()
    local player = PlayerPedId()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
    Wait(Config.AdrenalineEffectCooldown .. 000) -- 60 seconds effect
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    QBCore.Functions.Notify(Config.Text.AdrenalineElaborated, "primary")
end)