ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "NPC"

if CLIENT then
    local tm_mat = Material('tdmg/hud/teammate.png')
    function ENT:Draw()
        self:DrawModel()
        if self:GetNWFloat('Team') == LocalPlayer():Team() then
            local angle = EyeAngles()
			angle = Angle( 0, angle.y, 0 )
			angle:RotateAroundAxis( angle:Up(), -90 )
			angle:RotateAroundAxis( angle:Forward(), 90 )
            local pos = self:GetBonePosition(24)+Vector(0,0,16)
            cam.Start3D2D( pos, angle, 0.1 )
                surface.SetDrawColor(5,155,255)
                surface.SetMaterial(tm_mat)
                surface.DrawTexturedRect(-12, -12, 24, 24)
            cam.End3D2D()
        end
    end
end