local meta = FindMetaTable("Player")

function COD:IsAllowedSelfRevive()
    return COD.DataTable["Gamemode"] != 3
end

function meta:StopSlide()
    return self.Takedowning or self:GetNWBool('Downed') or self:GetNWString('SVAnim') != "" or self:WaterLevel() > 1 or !self:Alive() or !self:OnGround()
end

function meta:Sliding(bool)
    if bool then
        if isvector(self.SlidingVelocity) then return end

        local ang = self:GetAngles()
        ang.x = 0
        ang.z = 0
        local vec = ang:Forward()*32
        self.SlidingDuration = CurTime()+1
        self.SlidingVelocity = vec
        self:SetNWBool('Sliding', true)
        self:EmitSound("tdmg/ply/slide"..math.random(1,3)..".wav")
        self:ViewPunch(Angle(-5,0,0))
    else
        self.SlidingVelocity = nil
        self:SetNWBool('Sliding', false)
    end
end

function meta:IsDowned()
    return self:GetNWBool('Downed') 
end

function meta:MovingDirection(threshold) --This function was made by OpenAI ChatGPT
    threshold = threshold or 0.1
    local vel = self:GetVelocity()
    local forward = self:GetForward()
    local right = self:GetRight()
    local forwardDot = vel:Dot(forward)
    local rightDot = vel:Dot(right)

    if forwardDot > threshold then
        return "forward"
    elseif forwardDot < -threshold then
        return "backward"
    end

    if rightDot > threshold then
        return "right"
    elseif rightDot < -threshold then
        return "left"
    end

    return "stand"
end

function meta:Down()
    if COD:IsAllowedSelfRevive() then
        self:SetNWFloat('DownedTime', CurTime()+15)
    else
        self:SetNWFloat('DownedTime', CurTime()+30)
    end
    self:SetNWBool('Downed', true)
    self:SetViewOffset( Vector(0,0,24) )
    self:SetViewOffsetDucked( Vector(0,0,24) )
    self:SetHealth(50)
    self:SetJumpPower(0)
    self.AlreadyWasDowned = true
    self.ReviveNumber = 0
    self:SetSVAnimation("laststand_down", true)
    self:GodEnable()
    self:SetActiveWeapon(nil)
    timer.Simple(0.5, function()
        if !IsValid(self) then return end
        self:GodDisable()
    end)
end

function meta:Revive(died)
    self:SetViewOffset( Vector(0,0,64) )
    self:SetViewOffsetDucked( Vector(0,0,32) )
    self:SetJumpPower(128)
    self:SetHealth(25)
    if died then
        self:Kill()
    else
        self:SetSVAnimation("laststand_standup", true)
    end
    self:SetNWBool('Downed', false)
    self.RevivingSelf = false
end

hook.Add("SetupMove", "TDMSetupMove1", function(ply, mv, cmd)
    if ply:IsDowned() then
        if ply:KeyDown(IN_USE) or IsValid(ply:GetNWEntity('Reviver')) then
            mv:SetForwardSpeed(1)
            mv:SetSideSpeed(1)
        else
            mv:SetMaxSpeed(25)
            mv:SetMaxClientSpeed(25)
        end
    end
    if isvector(ply.SlidingVelocity) then
        mv:SetMaxSpeed(1)
        mv:SetMaxClientSpeed(1)
    end
end)

hook.Add("Think", "TDMSliding", function()
    for _, ent in ipairs(player.GetAll()) do
        if isvector(ent.SlidingVelocity) then
            ent:SetVelocity(ent.SlidingVelocity)
        end
        if ent:KeyDown(IN_SPEED) and ent:KeyDown(IN_DUCK) and not ent:Crouching() and !ent:StopSlide() then
            ent:Sliding(true)
        end
        if !ent:KeyDown(IN_DUCK) and isvector(ent.SlidingVelocity) or ent.SlidingDuration and ent.SlidingDuration < CurTime() or ent:StopSlide() then
            ent:Sliding(false)
        end
    end
end)

hook.Add("PlayerDeath", "TDMRevive", function(ply)
    if ply:IsDowned() then
        ply:Revive()
    end
    ply.AlreadyWasDowned = false
end)

hook.Add("Think", "TDMAnimsRevive", function()
    local plys2 = player.GetAll()
    for i=1,#plys2 do
        local ply = plys2[i]
        if ply:IsDowned() and ply:GetNWFloat('DownedTime') < CurTime() and (not ply:KeyDown(IN_USE) or !COD:IsAllowedSelfRevive()) and !IsValid(ply:GetNWEntity('Reviver')) and not ply.Takedowning then
            ply:Revive(true)
        end
        if ply:Alive() and not ply:IsDowned() and ply:KeyDown(IN_USE) then
            local tr = ply:GetEyeTrace()
            local ent = tr.Entity
            local dist = ply:EyePos():DistToSqr(tr.HitPos) < 5000
            if ent:IsPlayer() and dist and ent:IsDowned() and ply:Team() == ent:Team() then
                ent:SetNWEntity('Reviver', ply)
                ply.RevivingThatEntity = ent
            end
            if !IsValid(ply.RevivingThatEntity) or !ply.RevivingThatEntity:Alive() or not ply.RevivingThatEntity:IsDowned() then
                ply.RevivingThatEntity = nil
                if ply:GetNWString('SVAnim') == "laststand_startrevive" and not ply.Takedowning then
                    ply:SetSVAnimation("")
                end
            end
        end
        if ply:IsDowned() then
            local rev = ply:GetNWEntity('Reviver')
            ply:SetActiveWeapon(nil)
            if !IsValid(rev) and ply:KeyDown(IN_USE) and not ply.Takedowning and COD:IsAllowedSelfRevive() then
                ply.ReviveNumber = ply.ReviveNumber + FrameTime()/5.5
                if not ply.RevivingSelf then
                    ply:SetSVAnimation("laststand_selfrevive", true)
                    ply.RevivingSelf = true
                end
            elseif !IsValid(rev) and not ply:KeyDown(IN_USE) and not ply.Takedowning then
                ply.ReviveNumber = 0
                if ply.RevivingSelf then
                    ply:SetSVAnimation("")
                    ply.RevivingSelf = false
                end
            end
            if IsValid(rev) then
                if rev:KeyDown(IN_USE) and rev:GetEyeTrace().Entity == ply and not ply.Takedowning then
                    ply.ReviveNumber = ply.ReviveNumber + FrameTime()/3
                    rev:SetActiveWeapon(nil)
                    if not rev.RevivingTarget then
                        rev:SetSVAnimation("laststand_startrevive")
                        rev.RevivingTarget = true
                    end
                else
                    if rev.RevivingTarget then
                        rev:SetSVAnimation("")
                        rev:SelectWeapon(rev:GetNWString('MainWep'))
                        rev.RevivingTarget = false
                    end
                    ply:SetNWEntity('Reviver', NULL)
                end
            end
            if ply.ReviveNumber >= 1 then
                ply.ReviveNumber = 0
                ply:SetSVAnimation("")
                if IsValid(rev) then
                    rev:ChangeScore(100)
                    rev:SetSVAnimation("")
                    rev:SelectWeapon(rev:GetNWString('MainWep'))
                    rev.RevivingTarget = false
                    COD:GiveMessageCenter({rev}, 5)
                end
                ply:Revive()
                ply:SelectWeapon(ply:GetNWString('MainWep'))
            end
        else
            ply:SetNWEntity('Reviver', NULL)
        end
    end
end)

hook.Add("CalcMainActivity", "TDMAnimsRevive", function(ply, vel)
    if ply:IsDowned() and ply:GetNWString('SVAnim') == "" then
        local anim1 = ply:LookupSequence("laststand_idle")
        local anim2 = ply:LookupSequence("laststand_crawl_forward")
        local anim3 = ply:LookupSequence("laststand_crawl_backward")
        local anim4 = ply:LookupSequence("laststand_crawl_left")
        local anim5 = ply:LookupSequence("laststand_crawl_right")
        local dir = ply:MovingDirection(8)
        local vel = ply:GetVelocity():Length2D() > 10
        if dir == "forward" and vel then
            return -1, anim2
        elseif dir == "backward" and vel then
            return -1, anim3
        elseif dir == "left" and vel then
            return -1, anim4
        elseif dir == "right" and vel then
            return -1, anim5
        else
            return -1, anim1
        end
    end
end)

local delay = CurTime()+5
hook.Add("Think", "TDMApplyCommands", function()
    if delay < CurTime() then
        delay = CurTime()+5
        for k, v in pairs(COD.ApplyCommands["Server"]) do
            RunConsoleCommand(k, v)
        end
    end
end)

concommand.Add("cod_jointeam", function(ply, cmd, args)
    local float = tonumber(args[1])
	if ply:IsSuperAdmin() then
		ply:SetTeam(float)
        ply:Spawn()
	end
end)

---------------------------------------------------------------------

function COD:InfilStart()
    if COD.DataTable["Gamemode"] == 4 then return end
    
    local t1s, t2s = COD.DataTable["Team1_InfilSettings"], COD.DataTable["Team2_InfilSettings"]

    for k1, v1 in pairs(t1s.positions) do
        timer.Simple(0.1*k1, function()
            local infil = ents.Create("tdm_player_infil")
            infil:SetPos(v1)
            infil:SetAngles(t1s.angles[k1])
            infil.Infil = t1s.type
            infil.TeamChoose = 1
            infil:Spawn()
        end)
    end

    for k2, v2 in pairs(t2s.positions) do
        timer.Simple(0.1*k2, function()
            local infil = ents.Create("tdm_player_infil")
            infil:SetPos(v2)
            infil:SetAngles(t2s.angles[k2])
            infil.Infil = t2s.type
            infil.TeamChoose = 2
            infil:Spawn()
        end)
    end
end

hook.Add("COD.ChangeState", "TDM_Infil", function(start)
    if COD.DataTable["Enable_InfilAnimations"] and start then
        COD:InfilStart()
    end
end)