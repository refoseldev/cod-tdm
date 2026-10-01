AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "AH64 Cannon"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/weapons/w_missile_closed.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
    end

    function ENT:Think()
        local phys = self:GetPhysicsObject()
        phys:SetVelocity(self:GetForward()*2500)
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        util.Effect("AR2Impact", effectdata)
    end

    function ENT:Explode()
        local pos2 = self:GetPos()

        local ef = EffectData()
        ef:SetOrigin(pos2)
        util.Effect("HelicopterMegaBomb", ef)
        util.BlastDamage(self, self, pos2, 128, 48)
        sound.Play("ambient/explosions/explode_4.wav", pos2, 0, math.random(80,120), 0.2)

        self:Remove()
    end

    function ENT:PhysicsCollide(data)
        if data.Speed > 50 then 
            self:Explode()
        end
    end
end
