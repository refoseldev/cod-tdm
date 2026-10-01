AddCSLuaFile()

SWEP.PrintName = "Grenade"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Instructions = ""
SWEP.ViewModel = "models/tdmg/wep/c_lethal_frag.mdl"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.DrawAmmo = false

function SWEP:Initialize()
	self:SetHoldType("grenade")
end

function SWEP:Throw()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    local ply = self:GetOwner()
    timer.Simple(0.1, function()
        if !IsValid(ply) then return end
        ply:SetAnimation(PLAYER_ATTACK1)
    end)

    if SERVER then
        timer.Simple(0.5, function()
            if !IsValid(ply) or !IsValid(self) then return end

            local class = "tdm_frag"
            if self.IsFlash then
                class = "tdm_flash"
            end
            
            local ent = ents.Create(class)
            ent:SetPos(ply:EyePos()+ply:GetForward()*16)
            ent.Player = ply
            ent:Spawn()
            ent:GetPhysicsObject():SetVelocity(ply:GetAimVector()*750+Vector(0,0,50))

            ply:ViewPunch(Angle(10,0,0))
            ply:EmitSound("tdmg/wep/knife_miss.wav")
        end)
        timer.Simple(1, function()
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