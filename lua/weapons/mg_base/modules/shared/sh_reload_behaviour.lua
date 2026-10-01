AddCSLuaFile()

function SWEP:CanReload()
    if (self:HasFlag("Customizing")) then
        return false
    end

    if (CurTime() < self:GetNextPrimaryFire()) then
        return false
    end

    if (self:HasFlag("Reloading") || self:HasFlag("Holstering") || self:HasFlag("Drawing")) then
        return false
    end

    if (GetConVar("mgbase_sv_sprintreloads"):GetInt() <= 0) then
        if (self:HasFlag("Sprinting") || CurTime() < self:GetNextSprintTime()) then
            return false
        end
    end

    if (CurTime() < self:GetNextMeleeTime()) then
        return false
    end

    if (CurTime() < self:GetNextFiremodeTime()) then
        return false
    end

    if (CurTime() < self:GetNextReloadTime() && self:HasFlag("MagInserted")) then --avoid people from reloading after they canceled their reloads
        return false
    end
 
    if (self:Ammo1() <= 0) then
        return false
    end

    --[[if (self:GetOwner():KeyDown(IN_USE)) then
        return false
    end]]

    if (self:HasFlag("Drawing")) then
        return false
    end

    if (self:Clip1() >= self:GetMaxClip1WithChamber()) then
        return false
    end

    return true
end

function SWEP:GetMaxClip1WithChamber()
    if (self.CanChamberRound && self:HasFlag("Rechambered")) then
        return self:GetMaxClip1() + 1
    end

    return self:GetMaxClip1()
end

function SWEP:Reload()
    if (!self:CanReload()) then
        return
    end

    self:AddFlag("Reloading")
    local seqIndex = self:ChooseReloadAnim()
    local length = self:GetAnimLength(seqIndex)
    local magLength = self:GetAnimLength(seqIndex, self:GetAnimation(seqIndex).MagLength)

    self:SetNextReloadTime(CurTime() + length)
    self:SetNextMagTime(CurTime() + magLength)
    self:RemoveFlag("MagInserted")
    self:SetBurstRounds(0)
    self:RemoveFlag("Lowered")
    self:SetNextInspectTime(0)

    if (self.ReloadRechambers) then
        self:AddFlag("Rechambered")
    end

    if (self.EmptyReloadRechambers && seqIndex == "Reload_Empty") then
        self:AddFlag("Rechambered")
    end

    if (self.Animations.Rechamber == nil) then
        self:AddFlag("Rechambered")
    end
    
    self:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self.HoldTypes[self:GetCurrentHoldType()].Reload)
    self:PlayViewModelAnimation(seqIndex)
end

function SWEP:ChooseReloadAnim()
    if (self:GetAnimation("Reload_Start") != nil) then
        return "Reload_Start"
    end

    if (self:Clip1() <= 0 && self:GetAnimation("Reload_Empty")) then
        return "Reload_Empty"
    end

    return "Reload"
end

function SWEP:ReloadLogic()
    if (!self:HasFlag("Reloading")) then
        return
    end

    if (self:GetAnimation("Reload_Loop") != nil) then
        if (CurTime() > self:GetNextMagTime() && !self:HasFlag("MagInserted")) then
            self:SetClip1(self:Clip1() + 1)
            self:GetOwner():SetAmmo(self:Ammo1() - 1, self:GetPrimaryAmmoType())
            
            self:AddFlag("MagInserted")
        end
        
        if (CurTime() > self:GetNextReloadTime()) then
            local maxClip = self.Primary.ClipSize
            
            if (GetConVar("mgbase_debug_mag"):GetInt() > 0) then
                maxClip = 1
            end
            
            if (self:HasFlag("Rechambered")) then
                maxClip = self:GetMaxClip1WithChamber()
            end
            
            if (self:Clip1() >= maxClip || self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) <= 0) then
                self:EndReload()
                return
            end
            
            self:PlayViewModelAnimation("Reload_Loop")
            
            self:SetNextReloadTime(CurTime() + self:GetAnimLength("Reload_Loop"))
            self:SetNextMagTime(CurTime() + self:GetAnimLength("Reload_Loop", self:GetAnimation("Reload_Loop").MagLength))
            self:RemoveFlag("MagInserted")
            
            self:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self.HoldTypes[self:GetCurrentHoldType()].Reload)
        end
    else
        if (CurTime() > self:GetNextMagTime() && !self:HasFlag("MagInserted")) then
            local maxClip = self:GetMaxClip1()
            
            if (self:Clip1() > 0) then
                maxClip = self:GetMaxClip1WithChamber()
            end
            
            if (GetConVar("mgbase_debug_mag"):GetInt() > 0) then
                maxClip = 1
                if (self:Clip1() > 0) then
                    maxClip = 2
                end
            end
            
            local ammoNeeded = math.min(maxClip - self:Clip1(), self:Ammo1())
            self:SetClip1(self:Clip1() + ammoNeeded)
            
            self:GetOwner():SetAmmo(self:Ammo1() - ammoNeeded, self:GetPrimaryAmmoType())
            --self:AddFlag("Rechambered")
            self:AddFlag("MagInserted")
        end
        
        if (CurTime() > self:GetNextReloadTime()) then
            self:RemoveFlag("Reloading")
        end
    end
end

function SWEP:EndReload()
    if (self:Clip1() <= 0) then --dont want to cancel reload if im out of ammo
        return
    end

    if (self:GetAnimation("Reload_End") != nil) then
        if (!self:HasFlag("Rechambered") && self:Clip1() > 0 && self:GetAnimation("Reload_End_Empty") != nil) then
            self:PlayViewModelAnimation("Reload_End_Empty")
            self:SetNextPrimaryFire(CurTime() + self:GetAnimLength("Reload_End_Empty"))
            self:AddFlag("Rechambered")
        else
            self:PlayViewModelAnimation("Reload_End")
            self:SetNextPrimaryFire(CurTime() + self:GetAnimLength("Reload_End"))
        end
        self:RemoveFlag("Reloading")
    end

    if (self:GetAnimation("Reload_Loop") == nil && GetConVar("mgbase_sv_shootreloads"):GetInt() > 0) then
        self:RemoveFlag("Reloading")
    end
end

function SWEP:CanPump()
    return !self:HasFlag("Holstering")
        && !self:HasFlag("Drawing")
        && self:Clip1() > 0
        && !self:HasFlag("Reloading")
        && CurTime() > self:GetNextMeleeTime()
        && self:GetAnimation("Rechamber") != nil
        && (self:GetOwner():GetInfoNum("mgbase_manualrechamber", 0) <= 0 || self:GetOwner():KeyDown(IN_RELOAD))
end