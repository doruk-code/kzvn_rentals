local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('qb-kiralama:aracver')
AddEventHandler('qb-kiralama:aracver', function()
    local Player = QBCore.Functions.GetPlayerData()
    local PlayerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPed)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
    local plate = GetVehicleNumberPlateText(vehicle)
    local vehProps = QBCore.Functions.GetVehicleProperties(vehicle)
    local vehClass = GetVehicleClass(vehicle)
    local vehModel = GetEntityModel(vehicle)
    local vehFuel = exports['LegacyFuel']:GetFuel(vehicle)
    local vehHealth = GetEntityHealth(vehicle)
    local vehDamage = GetVehicleBodyHealth(vehicle)
    local vehEngine = GetIsVehicleEngineRunning(vehicle)
    local vehLock = GetVehicleDoorLockStatus(vehicle)
    local vehTires = {}
    for i = 1, 7 do
        if IsVehicleTyreBurst(vehicle, i, false) then
            table.insert(vehTires, i)
        end
    end
    local vehDoors = {}
    for i = 0, 5 do
        if IsVehicleDoorDamaged(vehicle, i) then
            table.insert(vehDoors, i)
        end
    end
    local vehWindows = {}
    for i = 0, 13 do
        if IsVehicleWindowIntact(vehicle, i) then
            table.insert(vehWindows, i)
        end
    end
    local vehProps = {
        plate = plate,
        model = vehModel,
        fuel = vehFuel,
        health = vehHealth,
        damage = vehDamage,
        engine = vehEngine,
        lock = vehLock,
        tires = vehTires,
        doors = vehDoors,
        windows = vehWindows,
    }
    TriggerServerEvent('qb-kiralama:aracver', vehProps)
end)









