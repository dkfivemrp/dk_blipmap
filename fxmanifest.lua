fx_version "bodacious"
game "gta5"
lua54 "yes"

server_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"blips.json",
	"server.lua"
}

client_scripts {
	"@PolyZone/client.lua",
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"blips.json",
	"client.lua"
}

files {
	"blips.json"
}
