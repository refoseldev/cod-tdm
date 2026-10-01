AddCSLuaFile()

SWEP.PrintName = "Radio"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Instructions = "LMB - Mark Position, RMB - Zoom"
SWEP.ViewModel = "models/tdmg/wep/chands_smallradio.mdl"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true

SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false

SWEP.DrawAmmo = false

function SWEP:Initialize()
    self.Called = false
    self.FOVED = false
    self.EndAfter = 0
    self.PosTable = {}
    self:SetNWBool('drawarrow', true)
    if not self.Killstreak then
        self.Killstreak = "package"
    end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType("slam")
	return true
end

function SWEP:CheckSky()
    local tr = self:GetOwner():GetEyeTrace().HitPos

    local tr2 = util.TraceLine({
        start = tr,
        endpos = tr+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    })

    return tr2.HitSky
end

function SWEP:PrimaryAttack()
    if self.Called then return end
    if not self:CheckSky() then return end
    self.Called = true
    self:SendWeaponAnim(ACT_VM_PULLBACK)
    timer.Simple(0.3, function()
        if !IsValid(self) then return end
        self:EmitSound("tdmg/radio_apply.wav")
        self:SendWeaponAnim(ACT_VM_IDLE)
    end)
    if SERVER then
        local ply = self:GetOwner()
        local pos = ply:GetEyeTrace().HitPos
        local cannext = true
        if self.ManyTimes then
            table.insert(self.PosTable, pos)
            pos = self.PosTable

            self.EndAfter = self.EndAfter - 1
            if self.EndAfter > 0 then
                cannext = false
            end
        end
        if cannext then
            ply:SetFOV(0, 0.25)
            self:SetNWBool('drawarrow', false)
            timer.Simple(0.3, function()
                if !IsValid(self) then return end
                COD:ChooseKillstreakRadio(ply, self, pos)
            end)
            timer.Simple(1.2, function()
                if !IsValid(self) then return end
                if IsValid(ply) then
                    ply:SelectWeapon(ply.RadioBeforeWep)
                end
                self:Remove()
            end)
        else
            timer.Simple(1, function()
                if !IsValid(self) then return end
                self.Called = false
            end)
        end
    end
    timer.Simple(0.4, function()
        if !IsValid(self) then return end
        if self.EndAfter == 0 then
            self:SendWeaponAnim(ACT_VM_HOLSTER)
        end
    end)
end

function SWEP:SecondaryAttack()
    if self.Called then return end
    if SERVER then
        local ply = self:GetOwner()
        if not self.FOVED then
            self.FOVED = true
            ply:SetFOV(50, 0.25)
        else
            self.FOVED = false
            ply:SetFOV(0, 0.25)
        end
    end
end

function SWEP:DrawWorldModel() end