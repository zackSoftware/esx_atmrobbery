ESX = exports['es_extended']:getSharedObject()

-------- Time between hacks server side logic
local hackStatus = true -- setting the hack status to true on resource start
RegisterNetEvent('esx_scamphone:startResetCounter', function() -- start the counter on hacking start
    hackStatus = false -- disabling the ability of hacking when using the check event
    CreateThread(function()
        while true do
            Wait(1000 * 60 * Config.HackTimeOut)
            TriggerClientEvent('esx_scamphone:refreshHack', true) -- re enabling the ability of hacking after the time finishes and sending it to the client
            hackStatus = true -- setting the checking stats to true
            break
        end
    )
end)

RegisterNetEvent('esx_scamphone:checkHackStatus', function()

    TriggerClientEvent('esx_scamphone:refreshHack', hackStatus)

end)
----------------------------------------------------------------

RegisterNetEvent('esx_phonescam:sendPolice', function()
    local jobname = ESX.GetPlayerData().job.name
    if jobname == "police" then
        exports["mythic_notify"]:SendAlert("error", "There has been an atm hack in the marked area.", 10000)
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
    end
end)

RegisterServerEvent("esx_scamphone:giveMoney")
AddEventHandler("esx_scamphone:giveMoney", function(reward, target)
  local xPlayer = ESX.GetPlayerFromId(source)

    if target ~= nil then
        local target = ESX.GetPlayerFromId(target)
        xPlayer.addMoney(reward)
        target.removeMoney(reward)
    else
        xPlayer.addMoney(reward)
    end
    
end)

-- ESX.RegisterServerCallback('esx_scamphone:getClosestPlayerAccount', function(source, closestPlayer, cb)
-- 	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
-- 		cb(inventory.items)
-- 	end)
--     MySQL.fetch
-- end)



ESX.RegisterUsableItem(Config.ItemName, function(source)
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
    
	--xPlayer.removeInventoryItem(Config.ItemName, 1)

	TriggerClientEvent('esx_scamphone:itemUsed', src, false)
    --TriggerClientEvent('esx:showNotification', src, _U(''))
end)

ESX.RegisterUsableItem(Config.PlayersHackingItemName, function(source)
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
    
	--xPlayer.removeInventoryItem(Config.ItemName, 1)

	TriggerClientEvent('esx_scamphone:itemUsed', src, true)
	--TriggerClientEvent('esx:showNotification', src, _U('you_used_blowtorch'))
end)