AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Hydra Missle"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_phx/amraam.mdl")
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

        ParticleEffect("explosion_huge_h", pos2, Angle(0,0,0))
        sound.Play("tdmg/a10_explosion.wav", pos2, 0)
        util.BlastDamage(self, self, pos2, 512, 256)

        self:Remove()
    end

    function ENT:PhysicsCollide(data)
        if data.Speed > 50 then 
            self:Explode()
        end
    end
end
