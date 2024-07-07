--********************************************************************************--
--*                                                                                *--
--*       MFPD - ImmersiveMechanic! by MajorFivePD (dsvipeer on github)             *--
--*                                                                               *--
--********************************************************************************--


local initialMarkerActive = true
local mechanicPed = nil
local activeMechanicIndex = nil

local function resetScriptState()
    initialMarkerActive = true
    activeMechanicIndex = nil
end

Citizen.CreateThread(function()
    if Config.UseBlips then
        for index, initialArea in ipairs(Config.InitialAreas) do
            local blip = AddBlipForCoord(initialArea.x, initialArea.y, initialArea.z)
            SetBlipSprite(blip, 566)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 30)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Mechanic Shop")
            EndTextCommandSetBlipName(blip)
        end
    end
end)


local function spawnMechanic(coords)
    RequestModel(Config.MechanicModel)
    while not HasModelLoaded(Config.MechanicModel) do
        Wait(1)
    end
    
    mechanicPed = CreatePed(4, Config.MechanicModel, coords.x, coords.y, coords.z, 0.0, false, true)
    SetEntityHeading(mechanicPed, coords.w)
    SetEntityInvincible(mechanicPed, true)
    SetBlockingOfNonTemporaryEvents(mechanicPed, true)
end

local function playMechanicAnimation()
    RequestAnimDict(Config.MechanicAnimDict)
    while not HasAnimDictLoaded(Config.MechanicAnimDict) do
        Wait(1)
    end
    
    TaskPlayAnim(mechanicPed, Config.MechanicAnimDict, Config.MechanicAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)
end

local function startRepair(vehicle)
    local engineCoords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "engine"))

    TaskGoStraightToCoord(mechanicPed, engineCoords.x, engineCoords.y, engineCoords.z, 1.0, -1, GetEntityHeading(vehicle) - 180, 0)
    while #(engineCoords - GetEntityCoords(mechanicPed, true)) > 2 do
        Wait(200)
    end

    TaskTurnPedToFaceCoord(mechanicPed, engineCoords.x, engineCoords.y, engineCoords.z, -1)
    Wait(1000)

    FreezeEntityPosition(vehicle, true)
    SetVehicleDoorOpen(vehicle, 4, false, false)

    playMechanicAnimation()

    local damage = GetVehicleEngineHealth(vehicle)
    local repairTime = (1000 - damage) * 5
    
    Citizen.Wait(repairTime)

    SetVehicleEngineHealth(vehicle, 1000)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleFixed(vehicle)

    ClearPedTasks(mechanicPed)
    FreezeEntityPosition(mechanicPed, false)
    TaskGoStraightToCoord(mechanicPed, Config.MechanicCoords[activeMechanicIndex].x, Config.MechanicCoords[activeMechanicIndex].y, Config.MechanicCoords[activeMechanicIndex].z, 1.0, -1, Config.MechanicCoords[activeMechanicIndex].w, 0)
    while #(vector3(Config.MechanicCoords[activeMechanicIndex].x, Config.MechanicCoords[activeMechanicIndex].y, Config.MechanicCoords[activeMechanicIndex].z) - GetEntityCoords(mechanicPed, true)) > 2 do
        Wait(200)
    end

    SetVehicleDoorShut(vehicle, 4, false)
    FreezeEntityPosition(vehicle, false)

    DoScreenFadeOut(500)
    Citizen.Wait(500)
    DoScreenFadeIn(500)

    if mechanicPed and DoesEntityExist(mechanicPed) then
        DeleteEntity(mechanicPed)
        mechanicPed = nil
        resetScriptState()
    end
end

if mechanicPed and DoesEntityExist(mechanicPed) then
    DeleteEntity(mechanicPed)
    mechanicPed = nil
    resetScriptState()  
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if initialMarkerActive then
            for index, initialArea in ipairs(Config.InitialAreas) do
                if #(playerCoords - vector3(initialArea.x, initialArea.y, initialArea.z)) < 1.0 then
                    if IsControlJustPressed(0, 38) then 
                        DoScreenFadeOut(1200)
                        Wait(1200)
                        spawnMechanic(Config.MechanicCoords[index])
                        DoScreenFadeIn(1200)
                        initialMarkerActive = false
                        activeMechanicIndex = index
                        break
                    end
                end
            end
        else
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle ~= 0 then
                local finalArea = Config.FinalAreas[activeMechanicIndex]
                if #(playerCoords - vector3(finalArea.coords.x, finalArea.coords.y, finalArea.coords.z)) < finalArea.radius then
                    if IsControlJustPressed(0, 38) then 
                        startRepair(vehicle)
                    end
                end
            end
        end
    end
end)
