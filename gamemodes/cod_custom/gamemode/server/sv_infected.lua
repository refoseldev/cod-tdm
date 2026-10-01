COD.DelayGamemodeNumber = 999999999

function COD:JoinAllToTeam()
    for _, ply in ipairs(player.GetAll()) do
        ply:SetTeam(1)
        ply:KillSilent()
        ply:Spawn()
    end
end

function COD:ShowTimer(num)
    net.Start("COD.TimerShow")
    net.WriteFloat(num)
    net.Broadcast()
end

function COD:RandomInfection()
    local tabp = player.GetAll()
    local ply = table.Random(tabp)
    for _, plys in ipairs(tabp) do
        if plys != ply then
            COD:GiveMessageCenter(plys, 9)
            plys:ChangeScore(50)
        end
    end
    if IsValid(ply) then
        local pos = ply:GetPos()
        local ang = ply:EyeAngles()
        ply:SetTeam(2)
        ply:KillSilent()
        ply:Spawn()
        COD:GiveMessageCenter(ply, 7)
        timer.Simple(0.02, function()
            if !IsValid(ply) then return end
            
            ply:SetPos(pos)
            ply:SetEyeAngles(ang)
        end)
    end
end

hook.Add("PlayerDeath", "TDMPlayer_Infection", function(ply, inf, att)
	if COD.GameStarted and COD.DataTable["Gamemode"] == 4 then
        COD.DataTable["Team1_Kills"] = 0
        COD.DataTable["Team2_Kills"] = 0
        if ply:Team() == 1 then
            COD.TimeBeforeEnd = COD.TimeBeforeEnd+30
            BroadcastLua([[
                COD.TimeMatch = ]]..COD.TimeBeforeEnd..[[
            ]])
            for _, plys in ipairs(team.GetPlayers(1)) do
                COD:GiveMessageCenter(plys, 9)
                plys:ChangeScore(50)
            end
        end
        timer.Simple(0.1, function()
            if !IsValid(ply) or ply:Team() == 2 then return end

	        ply:SetTeam(2)
            if #team.GetPlayers(1) == 1 then
                COD:GiveMessageCenter(player.GetAll(), 8)
            end
        end)
    end
end)

hook.Add("PlayerSpawn", "TDMPlayer_Infection", function(ply)
    if COD.GameStarted and COD.DataTable["Gamemode"] == 4 then
        timer.Simple(0.01, function()
            if !IsValid(ply) then return end

            ply:SetNWFloat('Perk1', 4)
            ply:SetNWFloat('Perk2', 0)
            ply:SetNWFloat('Perk1_Choose', 0)
            ply:SetNWFloat('Perk2_Choose', 0)
            ply:SetNWFloat('KillStreak1', 0)
            ply:SetNWFloat('KillStreak2', 0)
            ply:SetNWFloat('KillStreak3', 0)
            ply:SetPos(table.Random(COD.DataTable["simple_Spawns"]))
            if ply:Team() == 2 then
                ply:SetModel("models/humangrunt/cod4/captain_macmillan_pm.mdl")
                ply:SetupHands()
                ply:StripWeapons()
                ply:Give('tdm_infection_knife')
                ply:SetNWFloat('FragGrenades', 0)
                ply:SetNWFloat('FlashGrenades', 0)
            end
        end)
    end
end)

hook.Add("COD.ChangeState", "TDMPlayer_Infection", function(start)
    if start and COD.DataTable["Gamemode"] == 4 then
        COD.TimeBefore1PerkUnlock = math.huge
		COD.TimeBefore2PerkUnlock = math.huge
        COD.DisableSpawn = false
        COD.DelayGamemodeNumber = CurTime()+COD.DataTable["Delay_Before_Start"]+21
        COD.DisableEndGameByNoTeam = true
        COD:JoinAllToTeam()
        timer.Simple(COD.DataTable["Delay_Before_Start"]+10, function()
            if COD.DataTable["Gamemode"] == 4 and COD.GameStarted then
                COD:ShowTimer(10)
            end
        end)
        timer.Simple(COD.DataTable["Delay_Before_Start"]+20, function()
            if COD.DataTable["Gamemode"] == 4 and COD.GameStarted then
                COD:RandomInfection()
            end
        end)
    else
        COD.DisableSpawn = false
    end
end)

hook.Add("Think", "TDMPlayer_Infection", function()
    if COD.GameStarted and COD.DataTable["Gamemode"] == 4 then
        local team1, team1alive = team.GetPlayers(1), false
        local team2alive = false
        local loseteam = 0

        for k, p in ipairs(team1) do
            if p:Alive() then
                team1alive = true
                break
            end
        end

        if #team.GetPlayers(2) != 0 then
            team2alive = true
        end

        if team1alive and team2alive then
            COD.DelayGamemodeNumber = CurTime()+2
            loseteam = 0
        elseif team1alive and not team2alive then
            loseteam = 1
        elseif team2alive and not team1alive then
            loseteam = 2
            COD.TimeBeforeEnd = 0
        elseif not team1alive and not team2alive then
            loseteam = 3
        end

        if COD.TimeBeforeStart < CurTime()+1 and team1alive then
            loseteam = 1
            COD.DelayGamemodeNumber = 0
        end

        if loseteam == 1 and COD.DelayGamemodeNumber < CurTime() then
            COD.DataTable["Team1_Kills"] = 1
            COD.DataTable["Team2_Kills"] = 0
            BroadcastLua([[
                COD.DataTable["Team2_Kills"] = ]]..COD.DataTable["Team2_Kills"]..[[
                COD.DataTable["Team1_Kills"] = ]]..COD.DataTable["Team1_Kills"]..[[
            ]])
        elseif loseteam == 2 and COD.DelayGamemodeNumber < CurTime() then
            COD.DataTable["Team2_Kills"] = 1
            COD.DataTable["Team1_Kills"] = 0
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