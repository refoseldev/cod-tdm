AddCSLuaFile()

function SWEP:CanMelee()
    return !self:HasFlag("Sprinting")
        && !self:HasFlag("Holstering")
        && !self:HasFlag("Drawing")
        && CurTime() > self:GetNextPrimaryFire()
        && CurTime() > self:GetNextSprintTime()
        && !self:HasFlag("Customizing")
        && CurTime() > self:GetNextMeleeTime()
end

function SWEP:Melee()
    if (game.SinglePlayer() && CLIENT) then return end
    
    if (!self:CanMelee()) then
        return
    end

    self:RemoveFlag("Lowered")
    self:SetNextInspectTime(0)
    self:RemoveFlag("Reloading")
    self:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self.HoldTypes[self:GetCurrentHoldType()].Melee)
                
    local size = self:GetAnimation("Melee").Size
    local range = self:GetAnimation("Melee").Range      
    local bHit = false

    self:GetOwner():FireBullets({
        Src = self:GetOwner():EyePos(),
        Dir = self:GetOwner():EyeAngles():Forward(),
        Distance = range,
        HullSize = size,
        Tracer = 0,
        Callback = function(attacker, btr, dmgInfo)
            dmgInfo:SetDamage(self:GetAnimation("Melee_Hit").Damage)
            dmgInfo:SetInflictor(self)
            dmgInfo:SetAttacker(self:GetOwner())
            dmgInfo:SetDamagePosition(btr.HitPos)
            dmgInfo:SetDamageForce(self:GetOwner():EyeAngles():Forward() * (self:GetAnimation("Melee_Hit").Damage * 100))
            dmgInfo:SetDamageType(DMG_CLUB + DMG_ALWAYSGIB)
            
            bHit = true
        end
    })

    if (bHit) then
        self:SetNextMeleeTime(CurTime() + self:GetAnimLength("Melee_Hit", self:GetAnimation("Melee_Hit").Length))
        self:PlayViewModelAnimation("Melee_Hit")
    else
        self:SetNextMeleeTime(CurTime() + self:GetAnimLength("Melee", self:GetAnimation("Melee").Length))
        self:PlayViewModelAnimation("Melee")
    end 
end