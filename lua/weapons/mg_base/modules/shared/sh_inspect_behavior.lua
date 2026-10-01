AddCSLuaFile()

function SWEP:CanInspect()
    if (self:HasFlag("Customizing")) then
        return false
    end

    if (CurTime() < self:GetNextPrimaryFire()) then
        return false
    end

    if (self:HasFlag("Reloading") || self:HasFlag("Holstering") || self:HasFlag("Drawing") || self:HasFlag("Sprinting")) then
        return false
    end

    if (CurTime() < self:GetNextSprintTime()) then
        return false
    end

    if (CurTime() < self:GetNextMeleeTime()) then
        return false
    end

    if (CurTime() < self:GetNextFiremodeTime()) then
        return false
    end

    if (self:GetAimDelta() > 0) then
        return false
    end

    if (self:HasFlag("Sprinting")) then
        return
    end

    if (self:HasFlag("Drawing")) then
        return false
    end
    
    return CurTime() > self:GetNextInspectTime()
end

function SWEP:Inspect()
    if (CurTime() >= self:GetNextInspectTime()) then
        self:RemoveFlag("StoppedInspectAnimation")
    else
        self:ToggleFlag("StoppedInspectAnimation")
    end

    if (self:CanInspect()) then
        local inspIndex = (self:Clip1() <= 0 && self:GetAnimation("Inspect_Empty") != nil) && "Inspect_Empty" || "Inspect"
        self:PlayViewModelAnimation(inspIndex)
        self:SetNextInspectTime(CurTime() + self:GetAnimLength(inspIndex))
        self:RemoveFlag("Lowered")
    end
end

function SWEP:InspectLogic()
    if (self:HasFlag("StoppedInspectAnimation")) then
        self:SetNextInspectTime(self:GetNextInspectTime() + FrameTime())
    end
    
    if (CurTime() >= self:GetNextInspectTime()) then
        self:RemoveFlag("StoppedInspectAnimation")
    else
        if (self:GetOwner():KeyDown(IN_ATTACK) && self:Clip1() > 0) then
            self:SetNextInspectTime(0)
        end
    end
end