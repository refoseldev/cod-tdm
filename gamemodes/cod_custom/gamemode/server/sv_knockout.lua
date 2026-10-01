COD.DelayGamemodeNumber = 999999999

hook.Add("PlayerDeath", "TDMPlayer_Knockout", function(ply)
	if COD.GameStarted and COD.DataTable["Gamemode"] == 3 then
        timer.Simple(0.1, function()
            if !IsValid(ply) then return end

	        ply.DeathTime = CurTime()+999999999
        end)
    end
end)

hook.Add("PlayerSpawn", "TDMPlayer_Knockout", function(ply)
    if COD.GameStarted and COD.DataTable["Gamemode"] == 3 then
        timer.Simple(0.1, function()
            if !IsValid(ply) then return end

            ply:SetNWFloat('Perk1', 0)
            ply:SetNWFloat('Perk2', 2)
            ply:SetNWFloat('Perk1_Choose', 0)
            ply:SetNWFloat('Perk2_Choose', 0)
            ply:SetNWFloat('KillStreak1', 0)
            ply:SetNWFloat('KillStreak2', 0)
            ply:SetNWFloat('KillStreak3', 0)
        end)
    end
end)

hook.Add("COD.ChangeState", "TDMGmodStartMatch_Knockout", function(start)
    if start and COD.DataTable["Gamemode"] == 3 then
        COD.TimeBefore1PerkUnlock = math.huge
		COD.TimeBefore2PerkUnlock = math.huge
        COD.DisableSpawn = true
        COD.DelayGamemodeNumber = CurTime()+5
        COD.DisableEndGameByNoTeam = false
    else
        COD.DisableSpawn = false
    end
end)

hook.Add("Think", "TDMGmodStartMatch_Knockout", function()
    if COD.GameStarted and COD.DataTable["Gamemode"] == 3 then
        local team1, team1alive = team.GetPlayers(1), false
        local team2, team2alive = team.GetPlayers(2), false
        local loseteam = 0

        for k, p in ipairs(team1) do
            if p:Alive() then
                team1alive = true
                break
            end
        end

        for k, p in ipairs(team2) do
            if p:Alive() then      
                team2alive = true
                break
            end
        end

        if team1alive and team2alive then
            COD.DelayGamemodeNumber = CurTime()+2
            loseteam = 0
        elseif team1alive and not team2alive then
            loseteam = 1
        elseif team2alive and not team1alive then
            loseteam = 2
        elseif not team1alive and not team2alive then
            loseteam = 3
        end

        if loseteam == 1 and COD.DelayGamemodeNumber < CurTime() then
            COD.DataTable["Team1_Kills"] = COD.DataTable["MaxKills"]
            BroadcastLua([[
                COD.DataTable["Team2_Kills"] = ]]..COD.DataTable["Team2_Kills"]..[[
                COD.DataTable["Team1_Kills"] = ]]..COD.DataTable["Team1_Kills"]..[[
            ]])
        elseif loseteam == 2 and COD.DelayGamemodeNumber < CurTime() then
            COD.DataTable["Team2_Kills"] = COD.DataTable["MaxKills"]
            BroadcastLua([[
                COD.DataTable["Team2_Kills"] = ]]..COD.DataTable["Team2_Kills"]..[[
                COD.DataTable["Team1_Kills"] = ]]..COD.DataTable["Team1_Kills"]..[[
            ]])
        elseif loseteam == 3 and COD.DelayGamemodeNumber < CurTime() then
            COD.DataTable["Team1_Kills"] = 0
            COD.DataTable["Team2_Kills"] = 0
            BroadcastLua([[
                COD.DataTable["Team2_Kills"] = ]]..COD.DataTable["Team2_Kills"]..[[
                COD.DataTable["Team1_Kills"] = ]]..COD.DataTable["Team1_Kills"]..[[
            ]])
        end
    end
end)