local json = require("json")

local resourceName = GetCurrentResourceName()
local fileName = "blips.json"

---@type table[] --- https://docs.fivem.net/
local blips = {}

local function loadBlips()
    local fileContent = LoadResourceFile(resourceName, fileName)

    if fileContent and fileContent ~= "" then
        blips = json.decode(fileContent) or {}
        print(("[blipmap] %s blips carregados do arquivo."):format(tostring(#blips)))
    else
        blips = {}
        print("[blipmap] Nenhum arquivo encontrado, iniciando vazio.")
    end
end

local function saveBlips()
    local encoded = json.encode(blips, { indent = true })
    SaveResourceFile(resourceName, fileName, encoded, -1)
end

---@param playerId number
local function sendBlipsToPlayer(playerId)
    if not blips or #blips == 0 then
        return
    end

    for _, blip in ipairs(blips) do
        TriggerClientEvent(
            "criarBlipGlobal",
            playerId,
            blip.nome,
            blip.sprite,
            blip.tamanho,
            blip.cor,
            blip.coords
        )
    end
end

CreateThread(function()
    loadBlips()
end)

AddEventHandler("onResourceStart", function(startedResource)
    if startedResource ~= resourceName then
        return
    end

    loadBlips()

    CreateThread(function()
        Wait(500)

        for _, playerId in ipairs(GetPlayers()) do
            playerId = tonumber(playerId)
            TriggerClientEvent("blipmap:clearAll", playerId)
            sendBlipsToPlayer(playerId)
        end

        print("[blipmap] Blips reenviados para jogadores online após restart do resource.")
    end)
end)

RegisterNetEvent("blipmap:sync", function()
    local playerId = source
    TriggerClientEvent("blipmap:clearAll", playerId)
    sendBlipsToPlayer(playerId)
end)

RegisterNetEvent("blipmap:criar", function(nome, sprite, tamanho, cor, coords)
    local playerId = source

    local blip = {
        nome = nome,
        sprite = sprite,
        tamanho = tamanho,
        cor = cor,
        coords = coords,
    }

    table.insert(blips, blip)

    TriggerClientEvent("criarBlipGlobal", -1, nome, sprite, tamanho, cor, coords)

    saveBlips()

    print(("[blipmap] Blip '%s' criado por %s e salvo."):format(nome, GetPlayerName(playerId)))
end)
