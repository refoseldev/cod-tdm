AddCSLuaFile()

SWEP.PrintName = "Knife"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Instructions = ""
SWEP.ViewModel = "models/tdmg/wep/c_combat_knife.mdl"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.HitDistance = 56

SWEP.DrawAmmo = false

function SWEP:Initialize()
	self:SetHoldType("knife")
end

function SWEP:Knifing()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    local ply = self:GetOwner()
    ply:ViewPunch(Angle(0,-20,10))
    timer.Simple(0.1, function()
        if !IsValid(ply) then return end
        ply:SetAnimation(PLAYER_ATTACK1)
    end)

    if SERVER then
        ply:EmitSound("tdmg/wep/knife_miss.wav")
        timer.Simple(0.15, function()
            if !IsValid(ply) or !IsValid(self) then return end

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
                    mins = Vector( -16, -16, -8 ),
                    maxs = Vector( 16, 16, 8 ),
                    mask = MASK_SHOT_HULL
                } )
            end
    
            local ent = tr.Entity

            if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
                ent:TakeDamage(250, ply, self)
                ply:EmitSound("tdmg/wep/knife_hit"..math.random(1,3)..".wav")
            elseif tr.Hit then
                ply:EmitSound("physics/concrete/rock_impact_hard"..math.random(1,6)..".wav")
            end
        end)
        timer.Simple(0.5, function()
            if !IsValid(ply) or !IsValid(self) then return end

            ply:SetActiveWeapon(nil)
            ply:SelectWeapon(ply.FastKnifeBeforeWep)
            self:Remove()
        end)
    end

	return true
end

function SWEP:PrimaryAttack() end

function SWEP:SecondaryAttack() end

function SWEP:Reload() end

function SWEP:DrawWorldModel() end