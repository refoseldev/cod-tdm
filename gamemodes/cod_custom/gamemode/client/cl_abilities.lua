local meta = FindMetaTable("Player")

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

hook.Add("CalcMainActivity", "TDMAnimsRevive", function(ply, vel)
    if ply:IsDowned() and ply:GetNWString('SVAnim') == "" then
        local anim1 = ply:LookupSequence("laststand_idle")
        local anim2 = ply:LookupSequence("laststand_crawl_forward")
        local anim3 = ply:LookupSequence("laststand_crawl_backward")
        local anim4 = ply:LookupSequence("laststand_crawl_left")
        local anim5 = ply:LookupSequence("laststand_crawl_right")
        local dir = ply:MovingDirection(4)
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

hook.Add("Think", "TDMRevive", function()
    local ply = LocalPlayer()
    if ply:IsDowned() and ply:Alive() and !ply:ShouldDrawLocalPlayer() then
        if not model then
            model = ClientsideModel(ply:GetModel())
        end
        model:SetNoDraw(false)
        model:SetAngles(Angle(0,ply:GetAngles().y+10,0))
        model:ManipulateBoneAngles(model:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0,270,0))
        model:ManipulateBoneAngles(model:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0,270,0))
        model:ManipulateBoneAngles(model:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0,270,0))
        model:SetCycle(ply:GetCycle())
        model:SetModel(ply:GetModel())

        local vel = ply:GetVelocity()
        local anim1 = ply:LookupSequence("laststand_idle")
        local anim2 = ply:LookupSequence("laststand_crawl_forward")
        local anim3 = ply:LookupSequence("laststand_crawl_backward")
        local anim4 = ply:LookupSequence("laststand_crawl_left")
        local anim5 = ply:LookupSequence("laststand_crawl_right")
        local speed = vel:Length2D() > 5
        local dir = ply:MovingDirection(8)

        if ply:EyeAngles().x > 25 then
            ply:SetEyeAngles(Angle(25, ply:EyeAngles().y, 0))
        end
        if ply:EyeAngles().x < -25 then
            ply:SetEyeAngles(Angle(-25, ply:EyeAngles().y, 0))
        end
        if dir == "forward" and speed then
            model:ResetSequence(anim2)
        elseif dir == "backward" and speed then
            model:ResetSequence(anim3)
        elseif dir == "left" and speed then
            model:ResetSequence(anim4)
        elseif dir == "right" and speed then
            model:ResetSequence(anim5)
        else
            model:ResetSequence(anim1)
        end
        model:SetPos(ply:GetPos()+Vector(0,0,4)+ply:GetForward()*8+ply:GetRight()*8)
    else
        if model then
            model:SetNoDraw(true)
        end
    end
end)

local delay = CurTime()+5
hook.Add("Think", "TDMApplyCommands", function()
    if delay < CurTime() then
        delay = CurTime()+5
        for k, v in pairs(COD.ApplyCommands["Client"]) do
            RunConsoleCommand(k, v)
        end
    end
end)