
AddCSLuaFile()

SWEP.PrintName = "Knife"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/tdmg/wep/c_knife.mdl" )
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	self:SetHoldType( "fist" )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime()+0.75)
    self:SendWeaponAnim(ACT_VM_HITRIGHT)
    self:SetAnimation(PLAYER_ATTACK1)
    if SERVER then
        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            self:DealDamage()
        end)
    end
    timer.Simple(0.6, function()
        if !IsValid(self) then return end
        self:SendWeaponAnim(ACT_VM_IDLE)
    end)
end

function SWEP:SecondaryAttack() end

function SWEP:DealDamage()
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

    local tar = tr.Entity
    if IsValid(tar) then
        tar:TakeDamage(100, self:GetOwner(), self)
        if tar:IsPlayer() or tar:IsNPC() then
            self:EmitSound("tdmg/wep/melee_knife_0"..math.random(1,2)..".wav")
        else
            self:EmitSound("tdmg/wep/knife_impact_world"..math.random(1,2)..".wav")
        end
    else
        self:EmitSound("tdmg/wep/knife_swing_miss"..math.random(1,2)..".wav")
    end
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Deploy()
    self:EmitSound("tdmg/wep/knife_deploy.wav")
    self:SendWeaponAnim(ACT_VM_DRAW)
    timer.Simple(1, function()
        if !IsValid(self) then return end
        self:SendWeaponAnim(ACT_VM_IDLE)
    end)
	return true
end

function SWEP:Holster()
	return true
end
