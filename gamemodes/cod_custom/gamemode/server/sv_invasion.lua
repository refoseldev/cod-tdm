COD_Invasion = COD_Invasion or {}
COD_Invasion.current_ai_spawned_team1 = 0
COD_Invasion.current_ai_spawned_team2 = 0
COD_Invasion.current_ai_max_team = COD.DataTable["MaxAIInTeam"]
COD_Invasion.HeavyUnitsDelay = 0
COD_Invasion.HeavyUnits = false
COD_Invasion.SupportPackagesDelay = 0
COD_Invasion.SupportPackages = false

local delay_in_action = 0
local spawn_team1_delay = 0
local spawn_team2_delay = 0
local heli_team1_delay = 0
local heli_team2_delay = 0
------------------------------------------------------------------------

hook.Add("OnNPCKilled", "TDM_Invasion", function(ent, att)
    if COD.DataTable["Gamemode"] == 2 then
        local class1 = "vj_tdm_invasion_soldier1"
        local class2 = "vj_tdm_invasion_soldier2"
        
        if class1 == ent:GetClass() then
            COD:AddFragsToData(2, 1)
            COD_Invasion.current_ai_spawned_team1 = COD_Invasion.current_ai_spawned_team1 - 1
        elseif class2 == ent:GetClass() then
            COD:AddFragsToData(1, 1)
            COD_Invasion.current_ai_spawned_team2 = COD_Invasion.current_ai_spawned_team2 - 1
        end
    end
    if att:IsPlayer() then
        att:AddFrags(1)
    end
end)

hook.Add("PlayerDeath", "TDM_Invasion", function(ply)
    if COD.DataTable["Gamemode"] == 2 then
        if ply:Team() == 1 then
            COD:AddFragsToData(2, 4)
        elseif ply:Team() == 2 then
            COD:AddFragsToData(1, 4)
        end
    end
end)

hook.Add("COD.ChangeState", "TDM_Invasion", function(start)
    if COD.DataTable["Gamemode"] == 2 then
        COD_Invasion:RemoveAllAI()
        if start then
            spawn_team1_delay = CurTime()+15
            spawn_team2_delay = CurTime()+15
            heli_team1_delay = CurTime()+30
            heli_team2_delay = CurTime()+30
            COD_Invasion:CreateStartAI()
            COD_Invasion.HeavyUnits = false
            COD_Invasion.SupportPackages = false
            COD_Invasion.HeavyUnitsDelay = CurTime()+COD.GamemodeSettings[2]["Time_Before_HeavyUnits"]
            COD_Invasion.SupportPackagesDelay = CurTime()+COD.GamemodeSettings[2]["Time_Before_SupportPackages"]  
        else
            COD_Invasion.HeavyUnitsDelay = math.huge
            COD_Invasion.SupportPackagesDelay = math.huge  
        end
    end
end)

hook.Add("OnEntityCreated", "TDM_Invasion", function(ent)
    local class1 = "vj_tdm_invasion_soldier1"
    local class2 = "vj_tdm_invasion_soldier2"

    if class1 == ent:GetClass() then
        COD_Invasion.current_ai_spawned_team1 = COD_Invasion.current_ai_spawned_team1 + 1
    elseif class2 == ent:GetClass() then
        COD_Invasion.current_ai_spawned_team2 = COD_Invasion.current_ai_spawned_team2 + 1
    end
end)

hook.Add("Think", "TDM_Invasion", function(start)
    if COD.TimeBeforeEnd < CurTime() and COD.GameStarted then
        COD_Invasion:RemoveAllAI()
    end
    if COD.GameStarted and COD.DataTable["Gamemode"] == 2 then
        if COD_Invasion.HeavyUnitsDelay < CurTime() and not COD_Invasion.HeavyUnits then
            COD_Invasion.HeavyUnits = true
            COD:ShowAnnouncment(2)
        end
        if COD_Invasion.SupportPackagesDelay < CurTime() and not COD_Invasion.SupportPackages then
            COD_Invasion.SupportPackages = true
            COD_Invasion:SupplyPackages()
            COD:ShowAnnouncment(1)
        end
        if delay_in_action < CurTime() then
        
            delay_in_action = CurTime() + 1

            local team1 = COD_Invasion:GetAICount(1)
            local team2 = COD_Invasion:GetAICount(2)
            local max = COD_Invasion.current_ai_max_team

            if team1 < max and spawn_team1_delay < CurTime() then
                spawn_team1_delay = CurTime() + 2
                COD_Invasion:CreateSoldier(1)

                if heli_team1_delay < CurTime() then
                    heli_team1_delay = CurTime()+math.random(60,120)
                    COD_Invasion:CreateHeli(1)
                end
            end

            if team2 < max and spawn_team2_delay < CurTime() then
                spawn_team2_delay = CurTime() + 2
                COD_Invasion:CreateSoldier(2)

                if heli_team2_delay < CurTime() then
                    heli_team2_delay = CurTime()+math.random(60,120)
                    COD_Invasion:CreateHeli(2)
                end
            end
        end
    end
end)

----------------------------------------------------------------------------------

function COD_Invasion:SupplyPackages()
    heli_team1_delay = CurTime()+30
    heli_team2_delay = CurTime()+30

    for i, pos in ipairs(COD.DataTable["backup_Spawns"]) do
        local tr2 = util.TraceLine( {
            start = pos,
            endpos = pos+Vector(0,0,99999),
            filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
        } )
    
        local height = math.Clamp(tr2.HitPos:Distance(pos), 100, 600)
    
        local heli = ents.Create("prop_dynamic")
        heli:SetModel("models/tdmg/heli.mdl")
        heli:SetPos(pos+Vector(0,0,4))
        heli:SetAngles(Angle(0,math.random(0,360),0))
        heli:Spawn()
        heli:ResetSequence("spawn")
        heli:SetBodygroup(3, 1)
    
        timer.Simple(1, function()
            for i=1,10 do
                local sproxy = ents.Create("tdm_infil_soundproxy")
                sproxy:SetOwner(heli:GetOwner())
                sproxy:SetPos(heli:GetPos())
                sproxy:SetAngles(heli:GetAngles())
                sproxy:SetParent(heli)
                sproxy.Sound = "tdmg/sas1_veh1_int_quad_front_stat.wav"
                sproxy.Bone = "tag_main_rotor_static"
                sproxy.Vol = 100
                sproxy:Spawn()
            end
        end)
    
        timer.Simple(12, function()
            if !IsValid(heli) then return end
            local care = ents.Create("tdm_package")
            care:SetPos(pos+Vector(0,0,height-64))
            care:Spawn()
            care:SetAngles(heli:GetAngles())
        end)
    
        timer.Simple(30, function()
            if IsValid(heli) then
                heli:Remove()
            end
        end)
    end
end

function COD_Invasion:CreateSoldier(team, custompos, freezetime)
    local sol = ents.Create("vj_tdm_invasion_soldier"..team)
    if custompos then
        sol:SetPos(custompos)
    else
        sol:SetPos(COD_Invasion:GetAIPosition(team))
    end
    sol.Team = team
    sol:Spawn()
    if freezetime then
        sol:AddEFlags(EFL_NO_THINK_FUNCTION)
        sol:SetSequence("idle_passive")
        timer.Simple(freezetime, function()
            if !IsValid(sol) then return end
            sol:RemoveEFlags(EFL_NO_THINK_FUNCTION)
        end)
    end
end

function COD_Invasion:CreateHeli(team, custompos)
    local h = ents.Create("tdm_infil")
    if custompos then
        h:SetPos(custompos)
    else
        h:SetPos(COD_Invasion:GetHeliPosition(team))
    end
    h.Team2Team = team == 2
    h.Invasion = true
    h.KillstreakModel = true
    h.Team = team
    h:Spawn()
    h:SetNWFloat('Team', h.Team)
end

function COD_Invasion:CreateStartAI()
    local spos_team1 = COD.DataTable["Team1_AISpawns"]
    local spos_team2 = COD.DataTable["Team2_AISpawns"]
    local hpos_team1 = COD.DataTable["Team1_HeliSpawns"]
    local hpos_team2 = COD.DataTable["Team2_HeliSpawns"]

    for k, v in pairs(spos_team1) do
        COD_Invasion:CreateSoldier(1, v, COD.DataTable["Delay_Before_Start"]-2)
    end
    for k, v in pairs(spos_team2) do
        COD_Invasion:CreateSoldier(2, v, COD.DataTable["Delay_Before_Start"]-2)
    end

    local delay = 0
    if COD.DataTable["Enable_InfilAnimations"] then
        delay = 20
    end

    timer.Simple(delay, function()
        for k, v in pairs(hpos_team1) do
            COD_Invasion:CreateHeli(1, v, COD.DataTable["Delay_Before_Start"]-2)
        end
        for k, v in pairs(hpos_team2) do
            COD_Invasion:CreateHeli(2, v, COD.DataTable["Delay_Before_Start"]-2)
        end
    end)
end

function COD_Invasion:RemoveAllAI()
    local soldiers = ents.FindByClass("vj_tdm_invasion_*")

    COD_Invasion.current_ai_spawned_team1 = 0
    COD_Invasion.current_ai_spawned_team2 = 0
    for k, v in pairs(soldiers) do
        v:Remove()
    end
end

function COD_Invasion:GetAICount(team)
    local soldiers = ents.FindByClass("vj_tdm_invasion_*")
    local count = 0

    for k, v in pairs(soldiers) do
        if v.Team == team then
            count = count + 1
        end
    end

    return count
end

function COD_Invasion:GetAIPosition(team)
	local enemy_players = player.GetAll()

	local positions = {}
	for _, pos in ipairs(COD.DataTable["simple_Spawns"]) do
		local can = true
		local gdist = 0
		for _, en in ipairs(enemy_players) do
            if en:Alive() and en:Team() != team then
                local dist = en:GetPos():DistToSqr(pos)
                if en:IsLineOfSightClear(pos) or dist < 50000 then
                    can = false
                end
                for v, n in ipairs(ents.FindInSphere(pos, 64)) do
                    if n:IsNPC() or n:IsPlayer() then
                        can = false
                        break 
                    end
                end
                if dist > gdist then
                    gdist = dist
                end
            end
		end
		if can then
			table.insert(positions, {vec = pos, dist = gdist})
		end
	end
	if #positions > 0 then
		local position, dist = positions[1].vec, 0
		for _, p in ipairs(positions) do
			if p.dist > dist then
				dist = p.dist
				position = p.vec
			end
		end
		return position
	else
		return table.Random(COD.DataTable["simple_Spawns"])
	end
end

function COD_Invasion:GetHeliPosition(team)
    local enemy_players = ents.GetAll()

	local positions = {}
	for _, pos in ipairs(COD.DataTable["backup_Spawns"]) do
		local can = true
		local gdist = 0
		for _, en in ipairs(enemy_players) do
            if en:IsNPC() and en.Team != team or en:IsPlayer() and en:Team() != team then
                local dist = en:GetPos():DistToSqr(pos)
                if dist < 50000 then
                    can = false
                end
                if dist > gdist then
                    gdist = dist
                end
            end
		end
		if can then
			table.insert(positions, {vec = pos, dist = gdist})
		end
	end
	if #positions > 0 then
		local position, dist = positions[1].vec, 0
		for _, p in ipairs(positions) do
			if p.dist > dist then
				dist = p.dist
				position = p.vec
			end
		end
		return position
	else
		return table.Random(COD.DataTable["backup_Spawns"])
	end
end