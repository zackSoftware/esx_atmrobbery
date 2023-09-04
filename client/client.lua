ESX = exports['es_extended']:getSharedObject()

local isNear = false
local ableToHack 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('esx_scamphone:checkHackStatus')
    print('Hacking status is set to ' .. ableToHack)
end)

function startHacking(hackType)
    ableToHack = false
    TriggerServerEvent('esx_scamphone:startResetCounter')
    Mhack = nil
    doingit = true
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    if hackType then -- Hacking the atm to get from another players account money
        local closestPlayer, closestPlayerDistanceESX.Game.GetClosestPlayer(pCoords)
        if closestPlayer ~= nil then
            local targetPlayer = GetPlayerServerId(closestPlayer)
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start", 4, 40000, PhoneHacking)
            Citizen.CreateThreadNow(function()
                while Mhack == nil do
                    Citizen.Wait(100)
                end
                if Mhack == true then
                    local reward = Config.HackingEarnings
                    --doingit = false
                    ClearPedTasks(ped)
                    FreezeEntityPosition(ped, false)
                    exports["mythic_notify"]:SendAlert("success", "Success. You stole "..reward.."$ From another person's account", 5000)
                    TriggerServerEvent("fivemserver_hacker:giveMoney", reward, targetPlayer)
                    
                else
                --  doingit = false
                    ClearPedTasks(ped)
                    FreezeEntityPosition(ped, false)
                    exports["mythic_notify"]:SendAlert("error", "You failed..", 5000)
                end
            end)
        else
            exports["mythic_notify"]:SendAlert("error", "Unable to find an account to hack..", 5000)
        end

    elseif not hackType then -- Hacking the atm for a random prize
        
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start", 4, 40000, PhoneHacking)
        Citizen.CreateThreadNow(function()
            while Mhack == nil do
                Citizen.Wait(100)
            end
            if Mhack == true then
                local reward = Config.HackingEarnings
                doingit = false
                ClearPedTasks(ped)
                FreezeEntityPosition(ped, false)
                exports["mythic_notify"]:SendAlert("success", "Success. You stole "..reward.."$", 5000)
                TriggerServerEvent("fivemserver_hacker:giveMoney", reward)
                
            else

                doingit = false
                ClearPedTasks(ped)
                FreezeEntityPosition(ped, false)
                exports["mythic_notify"]:SendAlert("error", "You failed..", 5000)
            end
        end)

        

    end

end



RegisterNetEvent('esx_scamphone:itemUsed', function(playerHack)
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, atm in pairs(Config.ATMModels) do
        local hash = GetHashKey(atm)
        if IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.5) then
            isNear = true
            print('ATM ' .. _ .. 'is near')
        end
        
    end
    if isNear do -- Telling the player that he doesnt have the needed phone to hack
        if ableToHack then 
            startHacking(playerHack)
        else
            ESX.ShowNotification('ATM Robbery is disabled now due to a previous attack')
        end
    else
        ESX.ShowNotification('You dont have a hacker phone!')
    end
end)

function PhoneHacking(output, time)
    TriggerEvent("mhacking:hide")
    Mhack = output
    if output == false then
        local rnd = math.random(0, 100)
        if rnd <= Config.PoliceNotifyPercentage and not Config.PoliceNotifyPercentage == 0 then
            TriggerServerEvent("esx_scamphone:sendPolice", GetEntityCoords(PlayerPedId()))
            if Config.InformPlayer then
                exports["mythic_notify"]:SendAlert("error", "Police informed.", 8000)
            end
        end
    elseif output == true then
        local rnd = math.random(0, 100)

        if rnd <= Config.PoliceNotifyPercentage and not Config.PoliceNotifyPercentage == 0 then

            TriggerServerEvent("esx_phonescam:sendPolice", GetEntityCoords(PlayerPedId()))
            if InformPlayer then
                exports["mythic_notify"]:SendAlert("error", "Police informed.", 8000)
            end
        end
    end
end

RegisterNetEvent('esx_scamphone:refreshHack' , function(val)
    
    ableToHack = true

end)






