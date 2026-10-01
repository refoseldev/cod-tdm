AddCSLuaFile()

function SWEP:CanChangeSafety()
    return !self:HasFlag("Reloading")
        && !self:HasFlag("Drawing")
        && !self:HasFlag("Holstering")
        && !self:HasFlag("Sprinting") --to avoid having fucked anims
        && CurTime() > self:GetNextSprintTime()
        && CurTime() > self:GetNextPrimaryFire()
        && CurTime() > self:GetNextMeleeTime()
        && CurTime() > self:GetNextFiremodeTime()
        && !self:HasFlag("Customizing")
        && !self:HasFlag("Aiming")
end

function SWEP:ChangeSafety()
    if (!self:CanChangeSafety()) then
        return
    end

    self:ToggleFlag("Lowered")
    self:SetNextInspectTime(0)
    self:PlayViewModelAnimation(self:HasFlag("Lowered") && "Sprint_In" || "Sprint_Out")
    self:EmitSound("ViewModel.Medium")
end
