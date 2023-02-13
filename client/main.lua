local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local npc = {
    {x = 418.95, y = -663.25, z = 29.06, h = 317.65, npc = "a_f_m_skidrow_01"},
}

Citizen.CreateThread(function()
    for k, v in pairs(npc) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Araç Kiralama")
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(npc) do
        RequestModel(GetHashKey(v.npc))
        while not HasModelLoaded(GetHashKey(v.npc)) do
            Wait(1)
        end
        ped = CreatePed(4, GetHashKey(v.npc), v.x, v.y, v.z - 1, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for k, v in pairs(npc) do
            local distance = #(pedCoords - vector3(v.x, v.y, v.z))
            if distance < 1.5 then
                sleep = 5
                DrawText3Ds(v.x, v.y, v.z, "~g~E~w~ - Araç Kiralama")
                if IsControlJustPressed(0, 38) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    if vehicle ~= 1 then
                        SetEntityCoords(ped, 415.43, -652.31, 28.5)

                        TriggerEvent('QBCore:Command:SpawnVehicle', "bmx")

                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function DrawText3Ds (x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
end


RegisterNetEvent('qb-kiralama:aracveradama') 
AddEventHandler('qb-kiralama:aracveradama', function(price, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local model = "rumpo"
    local veh = QBCore.Shared.Vehicles[model]
    
    -- oyuncunun oldugu noktanın konumunu al
    local coords = GetEntityCoords(PlayerPedId())


    local plate = "KIRALAMA"
    local price = 1000

    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price)
        TriggerClientEvent('qb-kiralama:aracveradama', src, price, plate)
        TriggerClientEvent('QBCore:Notify', src, 'Araç Kiralandı', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli Paranız Yok', 'error')
    end
end)