AddCSLuaFile()

function SWEP:Think()
    self:LoadSpawnPreset()

    --fallback initialize
    if (!self.m_bInitialized && IsFirstTimePredicted()) then
        self:Initialize()
    end

    --holster
    if (self:HasFlag("Holstering") && CurTime() >= self:GetNextHolsterTime() && IsValid(self:GetNextWeapon()) && self:GetNextWeapon() != self && self:GetNextWeapon() != self:GetOwner()) then
        if (CLIENT && (IsFirstTimePredicted() || game.SinglePlayer())) then 
            input.SelectWeapon(self:GetNextWeapon()) 
        end
        
        return
    end

    --equip
    if (self:HasFlag("Drawing") && CurTime() >= self:GetNextActionTime()) then
        self:RemoveFlag("Drawing")
        self:RemoveFlag("PlayFirstDraw")
    end

    --spray
    if (CurTime() > self:GetNextPrimaryFire() + 0.15) then
        self:SetSprayRounds(0)
    end

    --cone
    self:SetCone(math.Approach(self:GetCone(), self:GetConeMin(), 4 * FrameTime()))

    if (CurTime() <= self:GetNextMeleeTime()) then
        self:SetCone(self:GetConeMax())
    end

    --burst logic
    if (!game.SinglePlayer() || SERVER) then
        if (self.Primary.BurstRounds > 1 && self:GetBurstRounds() < self.Primary.BurstRounds && self:GetBurstRounds() > 0) then
            self:PrimaryAttack()
        end
    end

    --auto reload
    if (self:GetOwner():GetInfoNum("mgbase_autoreload", 1)) >= 1 then
        if (self:Clip1() <= 0 && self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) > 0) then
            self:Reload()
        end
    end

    self:TriggerLogic()

    --pumping, it has to go under trigger logic
    if (CurTime() >= self:GetNextPrimaryFire() && self:CanPump()) then
        if (!self:HasFlag("Rechambered")) then
            self:PlayViewModelAnimation("Rechamber")
            self:SetNextPrimaryFire(CurTime() + self:GetAnimLength("Rechamber"))
            self:AddFlag("Rechambered")
        end
    end

    self:ReloadLogic()
    self:AimLogic()
    self:SprintLogic()
    self:BipodLogic()
    self:InspectLogic()

    --ladder
    if (self:GetOwner():GetMoveType() == MOVETYPE_LADDER || self:GetOwner():WaterLevel() == 3) then
        self:Holster(self:GetOwner())
    else
        if (self:HasFlag("Holstering") && self:GetNextWeapon() == self:GetOwner()) then
            self:Deploy()
        end
    end

    --holdtypes
    --new meme marine way
    self:SetShouldHoldType()

    if (CLIENT && game.SinglePlayer()) then
        return
    end

    if (self:Clip1() > 0 && !self:HasFlag("Reloading") && !self:HasFlag("Sprinting")) then
        self:CreateAndResumeReverbJob()
    end
end