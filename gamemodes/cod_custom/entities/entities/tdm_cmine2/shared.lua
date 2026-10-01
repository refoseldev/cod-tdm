AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Mini Mine"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/tdmg/fieldupgrade_proximitymine.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:SetModelScale(0.8, 0)
        self:SetHealth(200)
        if not self.Team then
            self.Team = 1
        end
        self:SetNWFloat('Team', self.Team)
        timer.Simple(math.Rand(2,4), function()
            if IsValid(self) then
                self.Activated = true
                self:EmitSound("tdmg/themes/beep2.mp3")
            end
        end)
    end

    function ENT:Think()
        if self.Activated then
            local y = self:GetAngles().y
            self:SetAngles(Angle(0,y,0))
            if self:Health() <= 0 then
                self:Explode()
            end
            for _, ply in ipairs(ents.FindInSphere(self:GetPos(), 32)) do
                if ply:IsPlayer() and ply:Team() != self.Team or ply:IsNPC() and ply.Team and ply.Team != self.Team then
                    self:Explode()
                    break
                end
            end
        end
        self:NextThink(CurTime()+0.1)
        return true
    end

    function ENT:Explode()
        if not self.Activated then return end

        self.Activated = true
        self:EmitSound("tdmg/themes/beep1.mp3")

        timer.Simple(0.2, function()
            if !IsValid(self) then return end

            local explosion = ents.Create("env_explosion")
            explosion:SetPos(self:GetPos())
            explosion:Spawn()
            explosion:SetCreator(self)
            explosion.Team = self.Team
            explosion:SetKeyValue("iMagnitude", "150")
            explosion:Fire("Explode", 0, 0)
            self:Remove()
        end)
    end

    function ENT:OnTakeDamage(dmginfo)
        local dmg = dmginfo:GetDamage()
        local att = dmginfo:GetAttacker()
        if att:IsPlayer() and att:Team() != self.Team then
            self:SetHealth(self:Health()-dmg)
        end
    end
else
    local tm_mat = Material('tdmg/hud/teammate.png')
    function ENT:Draw()
        self:DrawModel()
        if self:GetNWFloat('Team') == LocalPlayer():Team() then
            local angle = EyeAngles()
			angle = Angle( 0, angle.y, 0 )
			angle:RotateAroundAxis( angle:Up(), -90 )
			angle:RotateAroundAxis( angle:Forward(), 90 )
            local pos = self:GetPos()+Vector(0,0,16)
            cam.Start3D2D( pos, angle, 0.1 )
                surface.SetDrawColor(5,155,255)
                surface.SetMaterial(tm_mat)
                surface.DrawTexturedRect(-12, -12, 24, 24)
            cam.End3D2D()
        end
    end
end