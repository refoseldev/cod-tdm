require("mw_math")
AddCSLuaFile()

function SWEP:CanChangeAimMode()
    return ((self:GetSight() != nil && self:GetSight().ReticleHybrid != nil) || (self:GetLaser() != nil && self.LaserAimAngles != nil && self.LaserAimPos != nil))
        && !self:HasFlag("Reloading") 
        && CurTime() > self:GetNextPrimaryFire()
        && self:HasFlag("Aiming")
        && CurTime() > self:GetNextAimModeTime()
end

function SWEP:ChangeAimMode()
    if (!self:CanChangeAimMode()) then
        return
    end

    self:SetAimMode(self:GetAimMode() == 1 && 0 || 1)
    
    if (self:GetAimMode() == 0) then
        --self:SetNextAimModeTime(CurTime() + 0.25)

        if (self:GetSight() != nil && self:GetSight().ReticleHybrid != nil && self:GetSight().ReticleHybrid.OnAnimation != nil) then
            self:PlayViewModelAnimation(self:GetSight().ReticleHybrid.OnAnimation)
            self:SetNextPrimaryFire(CurTime() + self:GetAnimLength(self:GetSight().ReticleHybrid.OnAnimation))
            self:SetNextAimModeTime(CurTime() + self:GetAnimLength(self:GetSight().ReticleHybrid.OnAnimation))
        end
        
        self:EmitSound("Canted.Off")
    else
        --self:SetNextAimModeTime(CurTime() + 0.25)

        if (self:GetSight() != nil && self:GetSight().ReticleHybrid != nil && self:GetSight().ReticleHybrid.OffAnimation != nil) then
            self:PlayViewModelAnimation(self:GetSight().ReticleHybrid.OffAnimation)
            self:SetNextPrimaryFire(CurTime() + self:GetAnimLength(self:GetSight().ReticleHybrid.OffAnimation))
            self:SetNextAimModeTime(CurTime() + self:GetAnimLength(self:GetSight().ReticleHybrid.OffAnimation))
        end
        
        self:EmitSound("Canted.On")
    end
end