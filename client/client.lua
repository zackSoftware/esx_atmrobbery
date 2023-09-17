ESX = exports['es_extended']:getSharedObject()

local isNear = false
local ableToHack 
local recieved = false
local counter = 0
RegisterNetEvent('esx_scamphone:refreshHack' , function(val)
    print('assigining able to hack to a new value')
    ableToHack = val
    recieved = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('esx_scamphone:checkHackStatus')
    while not ableToHack do
        Wait(0)
    end
    print('Hacking status is set to ' .. ableToHack)
    
end)

function startHacking(hackType)
    counter = 0
    Mhack = nil
    doingit = true
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    if hackType then -- Hacking the atm to get from another players account money
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer(pCoords)
        if closestPlayer ~= nil then
            local targetPlayer = GetPlayerServerId(closestPlayer)
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start", 4, 15, PhoneHacking)
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
                    TriggerServerEvent("esx_scamphone:giveMoney", reward, targetPlayer)
                    ableToHack = false
                    TriggerServerEvent('esx_scamphone:startResetCounter')
                else
                    counter = counter + 1
                --  doingit = false
                    ClearPedTasks(ped)
                    FreezeEntityPosition(ped, false)
                    exports["mythic_notify"]:SendAlert("error", "You failed..", 5000)
                     if counter == 3 then 
                        ableToHack = false
                        TriggerServerEvent('esx_scamphone:startResetCounter')
                     end
                end
            end)
        else
            exports["mythic_notify"]:SendAlert("error", "Unable to find an account to hack..", 5000)
        end

    elseif not hackType then -- Hacking the atm for a random prize
        
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start", 4, 15, PhoneHacking)
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
                TriggerServerEvent("esx_scamphone:giveMoney", reward)                
                ableToHack = false
                TriggerServerEvent('esx_scamphone:startResetCounter')
                 
                
            else
                counter = counter + 1
                doingit = false
                ClearPedTasks(ped)
                FreezeEntityPosition(ped, false)
                exports["mythic_notify"]:SendAlert("error", "You failed..", 5000)
                if counter == 3 then 
                    ableToHack = false
                    TriggerServerEvent('esx_scamphone:startResetCounter')
                end
            end
        end)

        

    end

end



RegisterNetEvent('esx_scamphone:itemUsed', function(playerHack)
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    print('Checking')
    for _, atm in pairs(Config.ATMModelsString) do
        local hash = GetHashKey(atm)
        if IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.5) then
            isNear = true
            print('ATM ' .. _ .. ' is near')
        end
        
    end
    recieved = false
    TriggerServerEvent('esx_scamphone:checkHackStatus')
    while not recieved do
        Wait(0)
        print('waiting')
    end
    print('Hacking status is set to ' .. tostring(ableToHack))
    if isNear then -- Telling the player that he doesnt have the needed phone to hack
        if ableToHack then 
            startHacking(playerHack)
           
        else
            ESX.ShowNotification('ATM Robbery is disabled now due to a previous attack')
          
        end
    else
        ESX.ShowNotification('No ATM Nearby found')
    end
    
end)

function PhoneHacking(output, time)
    TriggerEvent("mhacking:hide")
    local pCoords = GetEntityCoords(PlayerPedId())
    Mhack = output
    if output == false then
        local rnd = math.random(0, 100)
        if rnd <= Config.PoliceNotifyPercentage and not Config.PoliceNotifyPercentage ~= 0 then
            TriggerServerEvent("esx_scamphone:sendPolice", pCoords)
            exports["mythic_notify"]:SendAlert("error", "Police informed.", 8000)
        end
        print('failleeeeeeeeeed')
    elseif output == true then
        local rnd = math.random(0, 100)

        if rnd <= Config.PoliceNotifyPercentage and not Config.PoliceNotifyPercentage == 0 then
            --TriggerServerEvent("esx_phonescam:sendPolice", GetEntityCoords(PlayerPedId()))
            TriggerServerEvent("esx_scamphone:sendPolice", pCoords)
            exports["mythic_notify"]:SendAlert("error", "Police informed.", 8000)
        end
    end
end


RegisterNetEvent('esx_scamphone:policeAlert', function(coords)
    exports["mythic_notify"]:SendAlert("error", "There has been an atm hack in the marked area.", 10000)
    print(coords)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 2.0)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("ATM Hack")
    EndTextCommandSetBlipName(blip)
    PulseBlip(blip)
        Citizen.CreateThreadNow(function()
            Citizen.Wait(15000)
            RemoveBlip(blip)
        end)


end)








