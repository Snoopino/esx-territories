ESX = nil


Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(30)
  end
end)

local Territories = {}
local insidePoint = false
local activeZone = nil


isLoggedIn = false
PlayerGang = {}
PlayerJob = {}

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    isLoggedIn = true
    PlayerGang = ESX.GetPlayerData().gang
    PlayerJob = ESX.GetPlayerData().job
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
    isLoggedIn = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(JobInfo)
    PlayerJob = JobInfo
    isLoggedIn = true
end)

CreateThread(function()
    Wait(500)
    for k, v in pairs(Zones["Territories"]) do
        local zone = CircleZone:Create(v.centre, v.radius, {
            name = "greenzone-"..k,
            debugPoly = Zones["Config"].debug,
        })

        local blip = AddBlipForRadius(v.centre.x, v.centre.y, v.centre.z, v.radius)
        SetBlipAlpha(blip, 80) -- Change opacity here
        SetBlipColour(blip, Zones["Colours"][v.winner] ~= nil and Zones["Colours"][v.winner] or Zones["Colours"].neutral)


        local blip2 = AddBlipForCoord(v.centre.x, v.centre.y, v.centre.z)
        SetBlipSprite (blip2, 437)
        SetBlipDisplay(blip2, 4)
        SetBlipAsShortRange(blip2, true)
        SetBlipColour(blip2, Zones["Colours"][v.winner] ~= nil and Zones["Colours"][v.winner] or Zones["Colours"].neutral)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Zone Hostile")
        EndTextCommandSetBlipName(blip2)

        Territories[k] = {
            zone = zone,
            id = k,
            blip = blip
        }
    end
end)

CreateThread(function()
    while true do 
        Wait(500)
        if isLoggedIn then
            
                local PlayerPed = PlayerPedId()
                local pedCoords = GetEntityCoords(PlayerPed)

                for k, zone in pairs(Territories) do
                    if Territories[k].zone:isPointInside(pedCoords) then
                        insidePoint = true
                        activeZone = Territories[k].id
                        
                        ESX.ShowHelpNotification(Translation.Enter)

                       
                        while insidePoint == true do
                            
                           
                              ESX.ShowNotification(Translation.Zone)
                            
                           
                            

                            if not Territories[k].zone:isPointInside(GetEntityCoords(PlayerPed)) then

                                insidePoint = false
                                activeZone = nil

                                ESX.ShowHelpNotification(Translation.Leave)

                                Wait(1000)

                            end

                            Wait(1000)
                        end
                    end
                end
                Wait(2000)
         
        end
    end
end)

