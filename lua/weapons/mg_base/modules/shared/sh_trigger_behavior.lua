local INVALID_TRIGGER_VALUE = -1 --this is used for semis: if its at this value theyt wont fire (otherwise they would go full auto)

AddCSLuaFile()

function SWEP:CanPressTrigger()
    if (self:HasFlag("Customizing")) then
        return false
    end

    if (CurTime() < self:GetNextFiremodeTime()) then
        return false
    end

    if ((self:HasFlag("Reloading") && !self:CanAttackInterruptReload()) || self:HasFlag("Holstering") || self:HasFlag("Drawing") || self:HasFlag("Sprinting")) then
        return false
    end

    if (CurTime() < self:GetNextMeleeTime()) then
        return false
    end

    if (CurTime() < self:GetNextSprintTime()) then
        return false
    end

    if (CurTime() < self:GetNextInspectTime()) then
        return false
    end

    return true
end

function SWEP:CanReleaseTrigger()
    return (self:GetTriggerDelta() >= 1 || self:GetTriggerDelta() == INVALID_TRIGGER_VALUE)
        && (self:GetBurstRounds() >= self.Primary.BurstRounds || self:Clip1() <= 0)
end

function SWEP:TriggerLogic()
    if (CLIENT && game.SinglePlayer()) then
        return
    end
    
    if (self.Trigger == nil || !self:CanPressTrigger()) then
        if (self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.ReleasedSound != nil) then
                self:EmitSound(self.Trigger.ReleasedSound)
            end
        end

        self:RemoveFlag("HoldingTrigger")

        if (CurTime() > self:GetNextPrimaryFire() && self:HasFlag("Rechambered")) then
            self:SetTriggerDelta(0)
        end
        
        return
    end

    local bDown = self:GetOwner():KeyDown(IN_ATTACK)

    if (bDown && CurTime() >= self:GetNextPrimaryFire()) then
        if (!self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.PressedSound != nil) then
                self:EmitSound(self.Trigger.PressedSound)
            end

            if (self.Trigger.PressedAnimation) then
                self:PlayViewModelAnimation(self.Trigger.PressedAnimation) 
            elseif (self:Clip1() <= 0) then
                self:PlayViewModelAnimation("Land") 
            end
        end
        
        self:AddFlag("HoldingTrigger")
        self:RemoveFlag("Lowered")
    elseif (!bDown && self:CanReleaseTrigger()) then
        if (self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.ReleasedSound != nil) then
                self:EmitSound(self.Trigger.ReleasedSound)
            end

            if (self.Trigger.ReleasedAnimation != nil && self:CanPlayTriggerOut()) then
                self:PlayViewModelAnimation(self.Trigger.ReleasedAnimation)
            end
        end

        self:RemoveFlag("HoldingTrigger")
    end

    if (self:HasFlag("HoldingTrigger")) then
        if (self:GetTriggerDelta() == INVALID_TRIGGER_VALUE) then
            return
        end

        self:SetTriggerDelta(math.min(self:GetTriggerDelta() + (FrameTime() / self.Trigger.Time), 1))
        
        if (self:GetTriggerDelta() >= 1) then
            self:PrimaryAttack()

            if (!self.Primary.Automatic && (self:GetBurstRounds() >= self.Primary.BurstRounds || self:Clip1() <= 0)) then
                self:SetTriggerDelta(INVALID_TRIGGER_VALUE)
            end
        end 
    else
        self:SetTriggerDelta(0)
        self:SetBurstRounds(0)
    end
end

function SWEP:LauncherTriggerLogic()
    if (CLIENT && game.SinglePlayer()) then
        return
    end
    
    if (self.Trigger == nil || !self:CanPressTrigger()) then
        if (self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.ReleasedSound != nil) then
                self:EmitSound(self.Trigger.ReleasedSound)
            end
        end

        self:RemoveFlag("HoldingTrigger")

        if (CurTime() > self:GetNextPrimaryFire() && self:HasFlag("Rechambered")) then
            self:SetTriggerDelta(0)
        end
        
        return
    end

    local bDown = self:GetOwner():KeyDown(IN_ATTACK)

    if (bDown && CurTime() >= self:GetNextPrimaryFire()) then
        if (!self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.PressedSound != nil) then
                self:EmitSound(self.Trigger.PressedSound)
            end
            
            --self:PlayViewModelAnimation(self.Trigger.PressedAnimation || "Land")
        end
        
        self:AddFlag("HoldingTrigger")
        self:RemoveFlag("Lowered")
    elseif (!bDown && self:CanReleaseTrigger()) then
        if (self:HasFlag("HoldingTrigger")) then
            if (self.Trigger.ReleasedSound != nil) then
                self:EmitSound(self.Trigger.ReleasedSound)
            end

            if (self.Trigger.ReleasedAnimation != nil && self:CanPlayTriggerOut()) then
                self:PlayViewModelAnimation(self.Trigger.ReleasedAnimation)
            end
        end

        self:RemoveFlag("HoldingTrigger")
    end

    if (self:HasFlag("HoldingTrigger")) then
        if (self:GetTriggerDelta() == INVALID_TRIGGER_VALUE) then
            return
        end

        self:SetTriggerDelta(math.min(self:GetTriggerDelta() + (FrameTime() / self.Trigger.Time), 1))
        
        if (self:GetTriggerDelta() >= 1) then
            self:PrimaryAttack()

            --if (!self.Primary.Automatic && (self:GetBurstRounds() >= self.Primary.BurstRounds || self:Clip1() <= 0)) then
                --self:SetTriggerDelta(INVALID_TRIGGER_VALUE)
            --end
        end 
    else
        self:SetTriggerDelta(0)
        self:SetBurstRounds(0)
    end
end