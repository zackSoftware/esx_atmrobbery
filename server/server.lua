ESX = exports['es_extended']:getSharedObject()

-------- Time between hacks server side logic
hackStatus = true -- setting the hack status to true on resource start
RegisterNetEvent('esx_scamphone:startResetCounter', function() -- start the counter on hacking start
    hackStatus = false -- disabling the ability of hacking when using the check event
    local src = source
    CreateThread(function()
        while true do
            Wait(1000 * 60 * Config.HackTimeOut)
            TriggerClientEvent('esx_scamphone:refreshHack', -1, true) -- re enabling the ability of hacking after the time finishes and sending it to the client
            hackStatus = true -- setting the checking stats to true
            break
        end
    end)
end)

RegisterNetEvent('esx_scamphone:checkHackStatus', function()
    print(hackStatus)
    local src = source
    TriggerClientEvent('esx_scamphone:refreshHack', src, hackStatus)

end)
----------------------------------------------------------------

RegisterNetEvent('esx_scamphone:sendPolice', function(atmCoords)
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local jobname = xPlayer.job.name
        print(xPlayers[i], jobname)
        if jobname == "police" then
            TriggerClientEvent("esx_scamphone:policeAlert", xPlayers[i], atmCoords)
        end
    end

    
    
end)

RegisterServerEvent("esx_scamphone:giveMoney")
AddEventHandler("esx_scamphone:giveMoney", function(reward, target)
    local src = source
  local xPlayer = ESX.GetPlayerFromId(source)
    print('Giving money to ' .. src)
    if target ~= nil then
        print('target is ' .. target)
        local targetxPlayer = ESX.GetPlayerFromId(target)
        xPlayer.addMoney(reward)
        targetxPlayer.removeMoney(reward)
    else
        xPlayer.addMoney(reward)
    end
    
end)

ESX.RegisterUsableItem(Config.ItemName, function(source)
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)
    
	TriggerClientEvent('esx_scamphone:itemUsed', src, false)

end)

ESX.RegisterUsableItem(Config.PlayersHackingItemName, function(source)
	local src = source
	local xPlayer  = ESX.GetPlayerFromId(src)

	TriggerClientEvent('esx_scamphone:itemUsed', src, true)

end)