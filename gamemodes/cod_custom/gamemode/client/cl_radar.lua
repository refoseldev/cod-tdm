local cachedEntities = {}
local max_radar_distance = 800
local max_radar_distance_sqr = max_radar_distance ^ 2
local radar_scale = 2
local uav_update_rate = 5
local radarMat = Material("tdmg/hud/radar.png", "noclamp")
local glitchMat = Material("tdmg/hud/glitch.png", "noclamp")
local playerMat = Material("tdmg/hud/radar/player.png", "noclamp")
local enemyColor = Color(200, 50, 0)
local playerColor = Color(0, 150, 250)
local yourColor = Color(255, 255, 0)
local enemyMat = Material("tdmg/hud/radar/enemy.png", "noclamp")
local UAVEnemies = {}

local function GetFriends()
	cachedEntities = {}
	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), max_radar_distance * radar_scale)) do
		if !v:IsPlayer() or v == LocalPlayer() or !v:Alive() or v:Team() != LocalPlayer():Team() then continue end
		table.insert(cachedEntities, v)
	end
	return cachedEntities
end

local function GetEnemies(ismuav)
	cachedEntities = {}
	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), max_radar_distance * radar_scale)) do
		if !v:IsPlayer() or v == LocalPlayer() or !v:Alive() or v:Team() == LocalPlayer():Team() then continue end
        if not ismuav then
		    table.insert(cachedEntities, {pos = v:GetPos(), alpha = 255})
            UAVEnemies = cachedEntities
        else
            table.insert(cachedEntities, v)
        end
	end
	return cachedEntities
end

local function GetEntities()
	cachedEntities = {}
	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), max_radar_distance * radar_scale)) do
		if v:IsPlayer() or v:Health() <= 0 then continue end
        if v:GetNWFloat('Team') > 0 then
            table.insert(cachedEntities, v)
        end
	end
	return cachedEntities
end

local IconsEntityTab = {
    ["tdm_harrier"] = {mat = Material("tdmg/hud/radar/jet.png"), rotate = true, size = 32, without_uav = true, bone = "tag_body"},
    ["tdm_infil"] = {mat = Material("tdmg/hud/radar/heli.png"), rotate = true, size = 32, without_uav = true, bone = "tag_body"},
    ["tdm_mi24"] = {mat = Material("tdmg/hud/radar/heli.png"), rotate = true, size = 32, without_uav = true, bone = "Body"},
    ["tdm_ah64"] = {mat = Material("tdmg/hud/radar/heli.png"), rotate = true, size = 32, without_uav = true, bone = "root"},
    ["tdm_drone"] = {mat = Material("tdmg/hud/radar/drone.png"), rotate = true, size = 16, without_uav = false},
    ["tdm_sentry"] = {mat = Material("tdmg/hud/radar/turret.png"), rotate = false, size = 24, without_uav = false},
    ["vj_tdm_k9"] = {mat = Material("tdmg/hud/radar/dog.png"), rotate = false, size = 20, without_uav = false},
    ["vj_tdm_npc"] = {mat = Material("tdmg/hud/radar/soldier.png"), rotate = false, size = 20, without_uav = false},
    ["vj_tdm_invasion_soldier1"] = {mat = Material("tdmg/hud/radar/enemy.png"), rotate = false, size = 16, without_uav = false},
    ["vj_tdm_invasion_soldier2"] = {mat = Material("tdmg/hud/radar/enemy.png"), rotate = false, size = 16, without_uav = false},
}

local function Draw()
    if COD.HideHUD or !LocalPlayer():Alive() then return end
	local w, h = ScrW(), ScrH()
	local x, y, size = 10, 10, 250
	local cx, cy = x + size / 2, y + size / 2
	local playerSize = 24
	local enemySize = 16
    local IsMUAV = false
    local ply = LocalPlayer()
	draw.RoundedBox(0, x, y, size, size, Color(0, 0, 0, 200))

	local localPos = ply:GetPos()
	local localAng = ply:GetAngles()

    if not COD.Counter_UAV_Active then
        local entities = GetFriends()
        for k, ent in pairs(entities) do
            if !IsValid(ent) then continue end

            local enemyPos = ply:GetPos() - ent:GetPos()
            enemyPos:Rotate(Angle(180, (ply:EyeAngles().y) * -1, -180))

            local ex = size / 2 * (enemyPos.y / max_radar_distance / radar_scale)
            local ey = size / 2 * (enemyPos.x / max_radar_distance / radar_scale)

            local posx = cx - ex - (enemySize / 2)
            local posy = cy - ey - (enemySize / 2)

            local mat = enemyMat
            posx = math.Clamp(posx, x, x + size - playerSize / 2)
            posy = math.Clamp(posy, y, y + size - playerSize / 2)
            local size = playerSize
            surface.SetDrawColor(playerColor)
            surface.SetMaterial(playerMat)
            surface.DrawTexturedRectRotated(posx + size / 4, posy + size / 4, size, size, (ent:IsPlayer() and ent:EyeAngles() or ent:GetAngles()).y + ply:EyeAngles().y * -1)
        end

        local entnpc = GetEntities()
        for k, ent in pairs(entnpc) do
            if !IsValid(ent) then continue end

            local data = IconsEntityTab[ent:GetClass()]
            local enemyPos = ply:GetPos() - ent:GetPos()
            local enemyAng = ent:GetAngles().y
            if data and data.bone then
                local bonepos, boneang = ent:GetBonePosition(ent:LookupBone(data.bone))
                enemyPos = ply:GetPos() - bonepos
                enemyAng = boneang.y
            end
            enemyPos:Rotate(Angle(180, (ply:EyeAngles().y) * -1, -180))

            local ex = size / 2 * (enemyPos.y / max_radar_distance / radar_scale)
            local ey = size / 2 * (enemyPos.x / max_radar_distance / radar_scale)

            local posx = cx - ex - (enemySize / 2)
            local posy = cy - ey - (enemySize / 2)

            posx = math.Clamp(posx, x, x + size - playerSize / 2)
            posy = math.Clamp(posy, y, y + size - playerSize / 2)
            local size = playerSize
            if ent:GetNWFloat('Team') == LocalPlayer():Team() then
                surface.SetDrawColor(playerColor)
            else
                surface.SetDrawColor(enemyColor)
            end

            if data then
                if not data.without_uav and ent:GetNWFloat('Team') != LocalPlayer():Team() and (not COD.UAV_Active and not COD.Adv_UAV_Active) then continue end
                surface.SetMaterial(data.mat)
                size = data.size
                if data.rotate then
                    surface.DrawTexturedRectRotated(posx + size / 4, posy + size / 4, size, size, enemyAng + ply:EyeAngles().y * -1)
                else
                    surface.DrawTexturedRectRotated(posx + size / 4, posy + size / 4, size, size, 0)
                end
            else
                surface.SetMaterial(enemyMat)
                size = 12
                surface.DrawTexturedRectRotated(posx + size / 4, posy + size / 4, size, size, 0)
            end
        end


        if not COD.Adv_UAV_Active and COD.UAV_Active then
                
            if uav_update_rate < CurTime() then
                uav_update_rate = CurTime() + 4
                GetEnemies()
            end

            local entities = UAVEnemies
            for k, ent in pairs(entities) do
                ent.alpha = math.max(ent.alpha - FrameTime()*75, 0)

                local enemyPos = ply:GetPos() - ent.pos
                enemyPos:Rotate(Angle(180, (ply:EyeAngles().y) * -1, -180))

                local ex = size / 2 * (enemyPos.y / max_radar_distance / radar_scale)
                local ey = size / 2 * (enemyPos.x / max_radar_distance / radar_scale)

                local posx = cx - ex - (enemySize / 2)
                local posy = cy - ey - (enemySize / 2)

                local mat = enemyMat
                posx = math.Clamp(posx, x, x + size - playerSize / 2)
                posy = math.Clamp(posy, y, y + size - playerSize / 2)
                local size = enemySize
                surface.SetDrawColor(Color(enemyColor.r, enemyColor.g, enemyColor.b, ent.alpha))
                surface.SetMaterial(enemyMat)
                surface.DrawTexturedRectRotated(posx + size / 4, posy + size / 4, size, size, 0)
            end
        end

        if COD.Adv_UAV_Active then
            local entities = GetEnemies(true)
            for k, ent in pairs(entities) do
                if !IsValid(ent) then continue end

                local enemyPos = ply:GetPos() - ent:GetPos()
                enemyPos:Rotate(Angle(180, (ply:EyeAngles().y) * -1, -180))

                local ex = size / 2 * (enemyPos.y / max_radar_distance / radar_scale)
                local ey = size / 2 * (enemyPos.x / max_radar_distance / radar_scale)

                local posx = cx - ex - (enemySize / 2)
                local posy = cy - ey - (enemySize / 2)

                local mat = enemyMat
                posx = math.Clamp(posx, x, x + size - playerSize / 2)
                posy = math.Clamp(posy, y, y + size - playerSize / 2)
                local size = playerSize
                surface.SetDrawColor(enemyColor)
                surface.SetMaterial(playerMat)
                surface.DrawTexturedRectRotated(posx + size / 4, posy + size / 4, size, size, (ent:IsPlayer() and ent:EyeAngles() or ent:GetAngles()).y + ply:EyeAngles().y * -1)
            end
        end

        surface.SetMaterial(playerMat)
        surface.SetDrawColor(yourColor)
        surface.DrawTexturedRect(cx - playerSize / 2, cy - playerSize / 2, playerSize, playerSize)
    else
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.SetMaterial(glitchMat)
        surface.DrawTexturedRect(x, y, size, size)
    end

    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.SetMaterial(radarMat)
    surface.DrawTexturedRect(x, y, size, size)
end

hook.Add("HUDPaint", "MWRadar", Draw)