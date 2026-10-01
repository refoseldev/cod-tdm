local lang = GetConVar("gmod_language"):GetString()

AddCSLuaFile('lang/russian.lua')
AddCSLuaFile('lang/ukrainian.lua')
AddCSLuaFile('lang/spanish.lua')
AddCSLuaFile('lang/turkish.lua')
AddCSLuaFile('lang/german.lua')
AddCSLuaFile('lang/lithuanian.lua')
AddCSLuaFile('lang/hungarian.lua')
AddCSLuaFile('lang/polish.lua')
AddCSLuaFile('lang/brazilian.lua')
AddCSLuaFile('lang/english.lua')

if lang == "ru" then
    include('lang/russian.lua')
elseif lang == "uk" then
    include('lang/ukrainian.lua')
elseif lang == "es-ES" then
    include('lang/spanish.lua')
elseif lang == "tr" then
    include('lang/turkish.lua')
elseif lang == "de" then
    include('lang/german.lua')
elseif lang == "lt" then
    include('lang/lithuanian.lua')
elseif lang == "hu" then
    include('lang/hungarian.lua')
elseif lang == "pl" then
    include('lang/polish.lua')
elseif lang == "pt-BR" then
    include('lang/brazilian.lua')
else
    include('lang/english.lua')
end