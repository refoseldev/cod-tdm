AddCSLuaFile()

function SWEP:IsOwnerMoving()
    return self:GetOwner():KeyDown(IN_FORWARD) || self:GetOwner():KeyDown(IN_BACK) || self:GetOwner():KeyDown(IN_MOVERIGHT) || self:GetOwner():KeyDown(IN_MOVELEFT)
end

function SWEP:CanSprint()
    local sprintReloads = GetConVar("mgbase_sv_sprintreloads"):GetInt()

    return !self:HasFlag("Drawing") 
        && !self:HasFlag("Holstering") 
        && CurTime() > self:GetNextPrimaryFire()
        && self:IsOwnerMoving() --checking velocity can sometimes cause desyncs (touching server entities while sprinting)
        && !self:GetOwner():Crouching()
        && CurTime() > self:GetNextFiremodeTime()
        && CurTime() > self:GetNextMeleeTime()
        && (sprintReloads <= 0 || (sprintReloads > 0 && !self:HasFlag("Reloading")))
end

function SWEP:CanPlaySprintOutAnim()
    return !self:HasFlag("Drawing") 
        && !self:HasFlag("Holstering") 
        && CurTime() > self:GetNextPrimaryFire()
        && CurTime() > self:GetNextFiremodeTime()
        && !self:HasFlag("Customizing")
        && !self:HasFlag("Reloading")
        && !self:HasFlag("Lowered")
end

function SWEP:DoSprintIn()
    self:StopCustomizing()
    self:SetNextInspectTime(0)

    if (!self:HasFlag("Sprinting") && !self:HasFlag("Lowered")) then
        self:PlayViewModelAnimation("Sprint_In")
        self:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, 0)
    end

    self:AddFlag("Sprinting")
    self:RemoveFlag("Reloading")
end

function SWEP:DoSprintOut()
    if (self:HasFlag("Sprinting")) then
        self:SetNextSprintTime(CurTime() + self:GetAnimLength("Sprint_Out"))

        if (self:CanPlaySprintOutAnim()) then
            self:PlayViewModelAnimation("Sprint_Out")
        end
    end

    self:RemoveFlag("Sprinting")
end

function SWEP:SprintLogic()
    if (CLIENT && game.SinglePlayer()) then
        return
    end
    
    if (self:GetOwner():KeyDown(IN_SPEED) && self:CanSprint()) then
        self:DoSprintIn()
    else
        self:DoSprintOut()
    end
end
