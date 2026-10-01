AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Frag Grenade"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/cod/eqp_lethal_frag.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        timer.Simple(4, function()
            if IsValid(self) then
                self:Explode(self.Player)
            end
        end)
    end

    function ENT:PhysicsCollide( data, phys )
        if data.Speed > 50 then 
            self:EmitSound("weapons/hegrenade/he_bounce-1.wav") 
        end
    end

    function ENT:Explode(ply)
        util.BlastDamage(ply, ply, self:GetPos(), 400, 200)
        local detonate = ents.Create( "env_explosion" )
        detonate:SetPos(self.Entity:GetPos())
        detonate:SetKeyValue("iMagnitude", "0")
        detonate:Spawn()
        detonate:Activate()
        detonate:Fire("Explode", "", 0)
        self:EmitSound("ambient/explosions/explode_2.wav")
        self:Remove()
    end
end
