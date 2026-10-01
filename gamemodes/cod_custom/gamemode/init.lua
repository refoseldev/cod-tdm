-----------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("client/cl_hud.lua")
AddCSLuaFile("client/cl_outline.lua")
AddCSLuaFile("client/cl_menu.lua")
AddCSLuaFile("client/cl_takedown.lua")
AddCSLuaFile("client/cl_scoreboard.lua")
AddCSLuaFile("client/cl_abilities.lua")
AddCSLuaFile("client/cl_killfeed.lua")
AddCSLuaFile("client/cl_radar.lua")
AddCSLuaFile("client/cl_cutscenes.lua")
AddCSLuaFile("client/cl_killcam.lua")
AddCSLuaFile("client/cl_error.lua")
AddCSLuaFile("post_shared.lua")

local files1 = file.Find("cod_tdm/*", "LUA")
for k, v in ipairs(files1) do
    AddCSLuaFile("cod_tdm/"..v)
end

include("shared.lua")
include("server/sv_functions.lua")
include("server/sv_killstreaks.lua")
include("server/sv_takedown.lua")
include("server/sv_abilities.lua")
include("server/sv_killcam.lua")
include("server/sv_invasion.lua")
include("server/sv_knockout.lua")
include("server/sv_infected.lua")
include("server/sv_domination.lua")

include("other/sv_mwii_npc.lua")
include("post_shared.lua")