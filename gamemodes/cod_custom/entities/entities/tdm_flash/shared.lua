AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Flash Grenade"

if SERVER then
    util.AddNetworkString("COD.FlashLight")
    function ENT:Initialize()
        self:SetModel("models/weapons/w_eq_flashbang.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        timer.Simple(3, function()
            if IsValid(self) then
                self:Explode(self.Player)
            end
        end)
    end

    function ENT:PhysicsCollide( data, phys )
        if data.Speed > 50 then 
            self:EmitSound("weapons/flashbang/grenade_hit1.wav") 
        end
    end

    function ENT:Explode(ply)
        local givehitmarker = false
        for _, p in ipairs(ents.FindInSphere(self:GetPos(), 400)) do
            if p:IsPlayer() and (p:Team() != ply:Team() or p == ply) and p:IsLineOfSightClear(self) then
                p:SetDSP(32)
                p:ScreenFade(SCREENFADE.IN, color_white, 4, 4)
                givehitmarker = true
            end
            if p.FlashEntity and p.Team != ply:Team() and p:IsLineOfSightClear(self) then
                p:FlashEntity()
            end
        end

        if givehitmarker then
            net.Start("COD.HitMarkEnemy")
            net.WriteBool(false)
            net.WriteBool(false)
            net.Send(ply)
        end

        net.Start("COD.FlashLight")
        net.WriteEntity(self)
        net.Broadcast()

        self:EmitSound("weapons/flashbang/flashbang_explode2.wav")
        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            self:Remove()
        end)
    end
else
    net.Receive("COD.FlashLight", function()
        local ent = net.ReadEntity()
        if IsValid(ent) then
            local dl = DynamicLight(ent)
            if dl then
                dl.pos = ent:GetPos()
                dl.r = 255
                dl.g = 255
                dl.b = 255
                dl.brightness = 2
                dl.Decay = 1000
                dl.Size = 256
                dl.DieTime = CurTime() + 1
            end
        end
    end)
end
