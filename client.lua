-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
DK = {}
Tunnel.bindInterface("dk_blipmap",DK)
vSERVER = Tunnel.getInterface("dk_blipmap")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS CONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
local createdBlips = {}

local function ClearAllBlips()
    for _, blip in ipairs(createdBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    createdBlips = {}
end

RegisterNetEvent("blipmap:clearAll")
AddEventHandler("blipmap:clearAll", function()
    ClearAllBlips()
end)

RegisterNetEvent("criarBlipGlobal")
AddEventHandler("criarBlipGlobal", function(nome, sprite, tamanho, cor, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, tamanho)
    SetBlipColour(blip, cor)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(nome)
    EndTextCommandSetBlipName(blip)

    table.insert(createdBlips, blip)
end)

AddEventHandler("onClientResourceStart", function(res)
    if res ~= GetCurrentResourceName() then return end
    ClearAllBlips()
    TriggerServerEvent("blipmap:sync")
end)

RegisterCommand("blipmap", function(source, args)
    if #args < 4 then
        print("Uso: /blipmap [nome] [spriteID] [tamanho] [cor]")
        return
    end

    local nome = args[1]
    local sprite = tonumber(args[2]) or 1
    local tamanho = tonumber(args[3]) or 0.6
    local cor = tonumber(args[4]) or 4
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    TriggerServerEvent("blipmap:criar", nome, sprite, tamanho, cor, { x = coords.x, y = coords.y, z = coords.z })
end)
