AddCSLuaFile()

function SWEP:CanPlayAimDownAnim()
    return !self:HasFlag("Reloading") 
        && !self:HasFlag("Drawing") 
        && !self:HasFlag("Holstering") 
        && !self:HasFlag("Sprinting") 
        && CurTime() > self:GetNextSprintTime()
        && CurTime() > self:GetNextFiremodeTime()
        && CurTime() > self:GetNextMeleeTime()
        && CurTime() > self:GetNextPrimaryFire()
        && !self:HasFlag("Customizing")    
end

function SWEP:CanPlayAimUpAnim()
    return !self:HasFlag("Reloading") 
        && !self:HasFlag("Drawing") 
        && !self:HasFlag("Holstering") 
        && !self:HasFlag("Sprinting") 
        && CurTime() > self:GetNextSprintTime()
        && CurTime() > self:GetNextFiremodeTime()
        && CurTime() > self:GetNextMeleeTime()
        && CurTime() > self:GetNextPrimaryFire()
end

function SWEP:CanAim()
    return --[[!self:HasFlag("Reloading") 
        &&!self:HasFlag("Drawing") 
        &&]] !self:HasFlag("Holstering") 
        && !self:HasFlag("Sprinting") 
        && !self:HasFlag("Customizing")
        && !self:HasFlag("PlayFirstDraw")
        --&& (!self:GetOwner():KeyDown(IN_USE) || (self:GetOwner():KeyDown(IN_USE) && self:GetAimDelta() > 0))
        && CurTime() > self:GetNextSprintTime() 
        && CurTime() > self:GetNextMeleeTime()
        --&& !self:HasFlag("Customizing")
        && !(self.CanDisableAimReload && self:HasFlag("Reloading"))
        && !(self:IsOwnerMoving() && self:GetOwner():KeyDown(IN_SPEED))
        --&& !self:GetOwner():KeyDown(IN_USE)
        --&& CurTime() > self:GetNextFiremodeTime()
end

function SWEP:AimLogic()
    if (CLIENT && game.SinglePlayer()) then
        return
    end

    if (self:GetOwner():GetInfoNum("mgbase_toggleaim", 0) >= 1) then
        if (self:GetOwner():KeyPressed(IN_ATTACK2)) then
            self:SetToggleAim(!self:GetToggleAim())
        end
    else
        self:SetToggleAim(self:GetOwner():KeyDown(IN_ATTACK2))
    end

    if (self:CanAim() && self:GetToggleAim()) then
        self:RemoveFlag("Lowered")
        self:SetNextInspectTime(0)

        if (!self:HasFlag("Aiming") && self:CanPlayAimUpAnim()) then
            self:PlayViewModelAnimation("Ads_In")
        end
    
        self:AddFlag("Aiming")
    
        local speed = 1 / self:GetAnimLength("Ads_In");
        self:SetAimDelta(math.min(self:GetAimDelta() + speed * FrameTime(), 1))
    else
        if (self:HasFlag("Aiming") && self:CanPlayAimDownAnim()) then
            self:PlayViewModelAnimation("Ads_Out")
        end

        self:RemoveFlag("Aiming")

        local speed = 1 / self:GetAnimLength("Ads_Out");
        self:SetAimDelta(math.max(self:GetAimDelta() - speed * FrameTime(), 0))
    end

    --aim mode
    if (self:GetAimMode() > 0) then
        local len = self:GetAnimLength("Ads_In") * 0.5

        if (self:GetSight() != nil && self:GetSight().ReticleHybrid != nil && self:GetSight().ReticleHybrid.OnAnimation != nil) then
            len = self:GetAnimLength(self:GetSight().ReticleHybrid.OnAnimation)
        end

        local speed = 1 / len;
        self:SetAimModeDelta(math.min(self:GetAimModeDelta() + speed * FrameTime(), 1))
    else
        local len = self:GetAnimLength("Ads_Out") * 0.5

        if (self:GetSight() != nil && self:GetSight().ReticleHybrid != nil && self:GetSight().ReticleHybrid.OffAnimation != nil) then
            len = self:GetAnimLength(self:GetSight().ReticleHybrid.OffAnimation)
        end

        local speed = 1 / len;
        self:SetAimModeDelta(math.max(self:GetAimModeDelta() - speed * FrameTime(), 0))
    end

    --breathe
    self:BreathingModule()
end

function SWEP:LauncherAimLogic()
    if (CLIENT && game.SinglePlayer()) then
        return
    end

    if (self:GetOwner():GetInfoNum("mgbase_toggleaim", 0) >= 1) then
        if (self:GetOwner():KeyPressed(IN_ATTACK2)) then
            self:SetToggleAim(!self:GetToggleAim())
        end
    else
        self:SetToggleAim(self:GetOwner():KeyDown(IN_ATTACK2))
    end

    if (self:CanAim() && (self:GetToggleAim() || (self:GetOwner():KeyDown(IN_ATTACK) && !self:HasFlag("Reloading")))) then
        self:RemoveFlag("Lowered")
        self:SetNextInspectTime(0)

        if (!self:HasFlag("Aiming") && self:CanPlayAimUpAnim()) then
            self:PlayViewModelAnimation("Ads_In")
        end
    
        self:AddFlag("Aiming")
    
        local speed = 1 / self:GetAnimLength("Ads_In");
        self:SetAimDelta(math.min(self:GetAimDelta() + speed * FrameTime(), 1))
    else
        if (self:HasFlag("Aiming") && self:CanPlayAimDownAnim()) then
            self:PlayViewModelAnimation("Ads_Out")
        end

        self:RemoveFlag("Aiming")

        local speed = 1 / self:GetAnimLength("Ads_Out");
        self:SetAimDelta(math.max(self:GetAimDelta() - speed * FrameTime(), 0))
    end

    --aim mode
    if (self:GetAimMode() > 0) then
        local len = self:GetAnimLength("Ads_In") * 0.5

        if (self:GetSight() != nil && self:GetSight().ReticleHybrid != nil && self:GetSight().ReticleHybrid.OnAnimation != nil) then
            len = self:GetAnimLength(self:GetSight().ReticleHybrid.OnAnimation)
        end

        local speed = 1 / len;
        self:SetAimModeDelta(math.min(self:GetAimModeDelta() + speed * FrameTime(), 1))
    else
        local len = self:GetAnimLength("Ads_Out") * 0.5

        if (self:GetSight() != nil && self:GetSight().ReticleHybrid != nil && self:GetSight().ReticleHybrid.OffAnimation != nil) then
            len = self:GetAnimLength(self:GetSight().ReticleHybrid.OffAnimation)
        end

        local speed = 1 / len;
        self:SetAimModeDelta(math.max(self:GetAimModeDelta() - speed * FrameTime(), 0))
    end

    --breathe
    self:BreathingModule()
    self:TrackingModule()
end

function SWEP:BreathingModule()
    if (self:GetSight() != nil && self:GetSight().Optic != nil && self:GetAimModeDelta() <= self.m_hybridSwitchThreshold && GetConVar("mgbase_sv_breathing"):GetInt() > 0) then
        local mul = 0.5

        if (self:HasFlag("Aiming")) then
            if (self:GetOwner():KeyDown(IN_SPEED) && !self:GetHasRunOutOfBreath()) then
                mul = 0.1

                self:SetBreathingDelta(math.max(self:GetBreathingDelta() - FrameTime() * 0.3, 0))

                if (self:GetBreathingDelta() <= 0) then
                    self:SetHasRunOutOfBreath(true)
                end
            end
        else
            self:SetBreathingDelta(math.min(self:GetBreathingDelta() + FrameTime() * 0.2, 1))
        end

        if (self:GetHasRunOutOfBreath()) then
            mul = 0.5 + (3 * (1 - self:GetBreathingDelta()))

            self:SetBreathingDelta(math.min(self:GetBreathingDelta() + FrameTime() * 0.2, 1))

            if (self:GetBreathingDelta() >= 1) then
                self:SetHasRunOutOfBreath(false)
            end
        end

        local pitch = math.sin(CurTime() * 3) * math.cos(CurTime() * 1.5)
        local yaw = math.cos(CurTime() * 1.5) * math.sin(CurTime() * 0.75)

        local ang = Angle(pitch * 0.2, yaw * 0.2, 0)
        ang:Mul(self:GetAimDelta() * mul)

        self:SetBreathingAngle(ang)
    else
        self:SetBreathingAngle(mw_math.ZeroAngle)
    end
end

local function GetAngleDifference(AngA, AngB) 

    local difference = 0

    difference = difference + math.AngleDifference(AngA.p, AngB.p)
    difference = difference + math.AngleDifference(AngA.r, AngB.r)
    difference = difference + math.AngleDifference(AngA.y, AngB.y)

    return difference

end

function SWEP:TrackingModule() 

    if !self.TrackingInfo then return end

    local angleForgiveness = 2.5

    local dir
    if self.PingedEntity && self.PingedEntity:IsValid() then
        dir = self.PingedEntity:WorldSpaceAABB() - self:GetOwner():WorldSpaceAABB()
        dir = dir:Angle() 
    end


    if self:GetAimDelta() <= 0.8 then 
        self:StopPingingEntity()
        self:StopTrackingEntity()
    else

        local tr = self:GetOwner():GetEyeTrace()

        if tr.HitWorld || !self:CanTrackEntity(tr.Entity) then

            if self.PingedEntity && self.PingedEntity:IsValid() then
                local dir = self.PingedEntity:WorldSpaceAABB() - self:GetOwner():WorldSpaceAABB()
                dir = dir:Angle()
                if GetAngleDifference(self:GetOwner():EyeAngles(), dir) > angleForgiveness then 
                    self:StopPingingEntity()
                    self:StopTrackingEntity()
                end
            end

            if self.TrackingInfo.TrackWorldPositions && !self.PingedEntity then
                self.TrackedPosition = tr.HitPos
                self.TrackedEntity = nil 
            end

        elseif tr.Entity || GetAngleDifference(self:GetOwner():EyeAngles(), dir) > angleForgiveness then 

            if !self.PingData then 
                self:StartPingingEntity(tr.Entity)
            else 

                if !self.TrackedEntity then

                    if CurTime() >= self.PingData.TrackTime then 
                        self:StartTrackingEntity(tr.Entity)
                    else 
                        for k, v in pairs(self.PingData.Pings) do 
                            if !v.WasActivated && CurTime() >= v.Time then 
                                self:EmitSound(self.TrackingInfo.PingSound)
                                v.WasActivated = true
                            end
                        end 
                    end

                end
            end
            
        else 
            self:StopTrackingEntity()
        end 

    end
end

function SWEP:StartTrackingEntity(ent) 
    if !self:CanTrackEntity(ent) then return end
    self.TrackedEntity = ent
    self.TrackingSound = self:StartLoopingSound(self.TrackingInfo.Sound) --self.TrackingInfo.Sound
end

function SWEP:StopTrackingEntity() 
    self.TrackedEntity = nil
    if self.TrackingSound then
        self:StopLoopingSound(self.TrackingSound) 
    end
end

function SWEP:StartPingingEntity(ent) 
    if !self:CanTrackEntity(ent) then return end
    self.PingedEntity = ent
    self.PingData = {
        TrackTime = CurTime() + self.TrackingInfo.PingTime * (self.TrackingInfo.PingCount + 1) - self.TrackingInfo.PingTime,
        Pings = {}
    }

    for i = 1, self.TrackingInfo.PingCount, 1 do 
        self.PingData.Pings[i] = {
            Time = (CurTime() + self.TrackingInfo.PingTime * i) - self.TrackingInfo.PingTime,
            WasActivated = false,
        }
    end
end

function SWEP:StopPingingEntity() 
    self.PingedEntity = nil
    self.PingData = nil
end

function SWEP:CanTrackEntity(ent) 
    return ent:IsNPC() || ent:IsNextBot() || ent:IsVehicle() || ent:IsPlayer()
end

function SWEP:AdjustMouseSensitivity()
    local mul = Lerp(self:GetAimModeDelta(), self.Zoom.FovMultiplier, 0.9)

    --[[if (self:GetSight() != nil && self:GetSight().Optic != nil && self:GetAimMode() <= 0) then
        mul = mul / (self:GetSight().Optic.FOV * 0.95) * GetConVar("mgbase_scopesens"):GetFloat()
    end]]

	return Lerp(self:GetAimDelta(), 1, mul)
end