function COD:SpawnDominationFlags()
    local tab = COD.DataTable["flag_Spawns"]
    for i=1,3 do
        local flag = ents.Create("tdm_domination_flag")
        flag:SetPos(tab[i])
        flag:Spawn()
    end
end

------------------------------------------------------

hook.Add("PlayerDeath", "TDMPlayer_Domination", function(ply)
	if COD.GameStarted and COD.DataTable["Gamemode"] == 5 then
        if ply:Team() == 1 then
            COD:AddFragsToData(2, -1)
        elseif ply:Team() == 2 then
            COD:AddFragsToData(1, -1)
        end
    end
end)

hook.Add("COD.ChangeState", "TDMPlayer_Domination", function(start)
    if start and COD.DataTable["Gamemode"] == 5 then
        COD:SpawnDominationFlags()
    end
end)

local thinkdelay = 0
hook.Add("Think", "TDMPlayer_Domination", function()
    if COD.GameStarted and COD.DataTable["Gamemode"] == 5 and thinkdelay < CurTime() then
        thinkdelay = CurTime()+3

        for k, v in ipairs(ents.FindByClass("tdm_domination_flag")) do
            local team = v:GetNWFloat('Team')
            if team > 0 then
                COD:AddFragsToData(team, 1)
            end
        end
    end
end)