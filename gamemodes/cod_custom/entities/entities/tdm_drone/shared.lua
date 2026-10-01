AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Bomb Drone"

if SERVER then
    util.AddNetworkString("COD.DroneCam")

    function ENT:Initialize()
        self:SetModel("models/tdmg/drone_ex.mdl")
        self:ResetSequence("idle")
        self:SetHealth(100)
        self.Velo = {x = 0, y = 0, z = 0}
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self.MultSpeed = 200
        self.MaxSpeed = 200
        self.Smoking = false
        self.DeltaTime = 0
        self:SetNWFloat('RemoveTime', CurTime()+30)
        self:EmitSound("ambient/machines/spin_loop.wav", 80, 120, 1, CHAN_BODY)

        timer.Simple(0.1, function()
            local ply = self:GetCreator()
            if !IsValid(ply) then return end

            net.Start("COD.DroneCam")
            net.WriteEntity(self)
            net.Send(ply)

            ply.ControllingKillstreak = true
        end)
    end

    function ENT:OnRemove()
        self:StopSound("ambient/machines/spin_loop.wav")

        local ply = self:GetCreator()
        if !IsValid(ply) then return end
        ply.ControllingKillstreak = false
    end

    function ENT:PathNotBlock()
        local tr = util.TraceLine( {
            start = self:GetPos(),
            endpos = self:GetPos() - self:GetRight() * 16,
            filter = function(ent) 
                if ent != self then 
                    return true 
                end 
            end
        })
        return not tr.Hit
    end

    function ENT:Think()
        local ply = self:GetCreator()
        if !IsValid(ply) then
            self:Remove() 
        else
            local mu = self.MultSpeed
            local ms = self.MaxSpeed
            local phys = self:GetPhysicsObject()
            local vel = phys:GetVelocity()

            local pos = self:GetPos()
            local ang = ply:EyeAngles().y
            ply:SetActiveWeapon(nil)
            if self:PathNotBlock() then
                phys:SetVelocityInstantaneous(self:GetForward()*self.Velo.x+self:GetRight()*self.Velo.y+self:GetUp()*self.Velo.z+Vector(0,0,10))
            else
                phys:SetVelocityInstantaneous(Vector(0,0,10))
            end
            if ply:KeyDown(IN_FORWARD) then
                self.Velo.x = math.Clamp(self.Velo.x+FrameTime()*mu, -ms, ms)
            elseif ply:KeyDown(IN_BACK) then
                self.Velo.x = math.Clamp(self.Velo.x-FrameTime()*mu, -ms, ms)
            end
            if ply:KeyDown(IN_MOVELEFT) then
                self.Velo.y = math.Clamp(self.Velo.y-FrameTime()*mu, -ms, ms)
            elseif ply:KeyDown(IN_MOVERIGHT) then
                self.Velo.y = math.Clamp(self.Velo.y+FrameTime()*mu, -ms, ms)
            end
            if ply:KeyDown(IN_DUCK) then
                self.Velo.z = math.Clamp(self.Velo.z-FrameTime()*mu, -ms, ms)
            elseif ply:KeyDown(IN_SPEED) then
                self.Velo.z = math.Clamp(self.Velo.z+FrameTime()*mu, -ms, ms)
            end
            if not ply:KeyDown(IN_FORWARD) and not ply:KeyDown(IN_BACK) then
                if self.Velo.x > 5 or self.Velo.x < -5 then
                    if self.Velo.x > 0 then
                        self.Velo.x = math.Clamp(self.Velo.x-FrameTime()*mu, -ms, ms)
                    elseif self.Velo.x < 0 then
                        self.Velo.x = math.Clamp(self.Velo.x+FrameTime()*mu, -ms, ms)
                    end
                else
                    self.Velo.x = 0
                end
            end
            if not ply:KeyDown(IN_SPEED) and not ply:KeyDown(IN_DUCK) then
                if self.Velo.z > 5 or self.Velo.z < -5 then
                    if self.Velo.z > 0 then
                        self.Velo.z = math.Clamp(self.Velo.z-FrameTime()*mu, -ms, ms)
                    elseif self.Velo.z < 0 then
                        self.Velo.z = math.Clamp(self.Velo.z+FrameTime()*mu, -ms, ms)
                    end
                else
                    self.Velo.z = 0
                end
            end
            if not ply:KeyDown(IN_MOVELEFT) and not ply:KeyDown(IN_MOVERIGHT) then
                if self.Velo.y > 5 or self.Velo.y < -5 then
                    if self.Velo.y > 0 then
                        self.Velo.y = math.Clamp(self.Velo.y-FrameTime()*mu, -ms, ms)
                    elseif self.Velo.y < 0 then
                        self.Velo.y = math.Clamp(self.Velo.y+FrameTime()*mu, -ms, ms)
                    end
                else
                    self.Velo.y = 0
                end
            end
            if ply:KeyDown(IN_ATTACK) or self:Health() < 0 or self:GetNWFloat('RemoveTime') < CurTime() then
                self:Explode()
            end

            local b = {}
            b.secondstoarrive = 1
            b.pos = self:GetPos()
            b.angle = Angle(0,ang,0)
            b.maxangular = 20
            b.maxangulardamp = 5
            b.maxspeed = 10
            b.maxspeeddamp = 5
            b.dampfactor = 0.8
            b.teleportdistance = 0
            b.deltatime = CurTime()-self.DeltaTime
            phys:ComputeShadowControl(b)

            self.DeltaTime = CurTime()
            self:NextThink(CurTime())
            return true
        end
    end

    function ENT:Explode()
        local explosion = ents.Create("env_explosion")
        explosion:SetPos(self:GetPos())
        explosion:Spawn()
        explosion:SetCreator(self)
        explosion.Team = self.Team
        explosion:SetKeyValue("iMagnitude", "300")
        explosion:Fire("Explode", 0, 0)
        self:Remove()
    end

    function ENT:OnTakeDamage(dmgt)
        local dmg = dmgt:GetDamage()
        local att = dmgt:GetAttacker()
        if att != self or att:IsPlayer() and att:Team() != self.Team then
            self:SetHealth(self:Health()-dmg)
            if IsValid(self:GetCreator()) then
                self:GetCreator():ViewPunch(AngleRand(-1,1))
                self:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav")
            end
        end 
    end
else
    local function CanSee(pos1, pos2)
        local tr = util.TraceLine( {
            start = pos1,
            endpos = pos2,
            filter = function(ent) if ent:IsWorld() then return true end end,
        })
        return !tr.Hit
    end

    local enemyMat = Material("tdmg/hud/radar/enemy.png", "noclamp")
    local glitchMat = Material("tdmg/hud/screenglitch.jpg", "noclamp")

    net.Receive("COD.DroneCam", function()
        local ent = net.ReadEntity()
        local alpha = 0
        local downa = false
        local tab = {
            [ "$pp_colour_addr" ] = 0,
            [ "$pp_colour_addg" ] = 0,
            [ "$pp_colour_addb" ] = 0,
            [ "$pp_colour_brightness" ] = 0,
            [ "$pp_colour_contrast" ] = 0.9,
            [ "$pp_colour_colour" ] = 0.1,
            [ "$pp_colour_mulr" ] = 0,
            [ "$pp_colour_mulg" ] = 0,
            [ "$pp_colour_mulb" ] = 0
        }
        
        hook.Add("RenderScreenspaceEffects", "DroneCam", function()
            DrawColorModify(tab)
        end)

        hook.Add("HUDPaint", "DroneCam", function()
            surface.SetDrawColor(50,50,50,100)
            surface.SetMaterial(glitchMat)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

            surface.SetDrawColor(255,255,255)
            surface.DrawOutlinedRect(50, 50, ScrW()-100, ScrH()-100, 2)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-15, ScrH()/2-1, 30, 2)

            
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-1, ScrH()/2-16, 2, 30)

            --------------------------------------------------------------------------------

            draw.SimpleText("✷ BOMB DRONE", "DermaLarge", 100, 100, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("ACTIVE", "DermaLarge", 100, 130, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText("PRESS LMB TO EXPLODE", "DermaLarge", ScrW()-100, ScrH()-130, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText("SHIFT TO UPPER", "DermaLarge", ScrW()-100, ScrH()-160, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText("CTRL TO LOWER", "DermaLarge", ScrW()-100, ScrH()-190, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            if downa then
                alpha = alpha - FrameTime()*512
                if alpha <= 0 then
                    downa = false
                end
            else
                alpha = alpha + FrameTime()*512
                if alpha >= 255 then
                    downa = true
                end
            end
            --------------------------------------------------------------------------------

            surface.SetDrawColor(220,220,220,255)
            surface.DrawRect(75, ScrH()-220, 300*((ent:GetNWFloat('RemoveTime')-CurTime())/30), 15) 

            surface.SetDrawColor(255,255,255,255)
            surface.DrawOutlinedRect(75, ScrH()-220, 300, 15, 2)

            draw.SimpleText("BATTERY", "DermaLarge", 75, ScrH()-250, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            surface.SetDrawColor(220,220,220,255)
            surface.DrawRect(75, ScrH()-120, 300*(ent:Health()/100), 15)

            surface.SetDrawColor(255,255,255)
            surface.DrawOutlinedRect(75, ScrH()-120, 300, 15, 2)

            draw.SimpleText("HEALTH", "DermaLarge", 75, ScrH()-150, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            ---------------------------------------------------------------------------------

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and ply:Team() != LocalPlayer():Team() and ply:GetNWFloat('Perk2') != 4 then
                    local pos = ply:WorldSpaceCenter():ToScreen()

                    if CanSee(EyePos(), ply:WorldSpaceCenter()) then
                        surface.SetDrawColor(200,0,0,200)
                    elseif ply:WorldSpaceCenter():DistToSqr(EyePos()) < 1500000 then
                        surface.SetDrawColor(255,255,255,100)
                        surface.DrawRect(pos.x-1, pos.y-5, 1, 10)
                        surface.SetDrawColor(255,255,255,100)
                        surface.DrawRect(pos.x-5, pos.y-1, 10, 1)

                        surface.SetDrawColor(200,200,200,50)
                    else
                        surface.SetDrawColor(0,0,0,0)
                    end
                    surface.SetMaterial(enemyMat)
                    surface.DrawTexturedRect(pos.x-20, pos.y-20, 40, 40)
                end
            end
        end)

        hook.Add("CreateMove", "DroneCam", function(cmd)
            cmd:SetForwardMove(0)
            cmd:SetSideMove(0)
            cmd:RemoveKey(IN_JUMP)
            cmd:RemoveKey(IN_USE)
        end)

        hook.Add("CalcView", "DroneCam", function( ply, pos, angles, fov )
            if IsValid(ent) then
                COD.HideHUD = true
                COD.HUD_DisableSomeThink = true
                local pos1 = ent:GetPos()-ent:GetUp()*1-ent:GetForward()*4
                local ang1 = angles
                local view = {
                    origin = pos1,
                    angles = ang1,
                    fov = fov,
                    drawviewer = true
                }
            
                return view
            else
                COD.HideHUD = false
                COD.HUD_DisableSomeThink = false
                hook.Remove("CalcView", "DroneCam")
                hook.Remove("CreateMove", "DroneCam")
                hook.Remove("RenderScreenspaceEffects", "DroneCam")
                hook.Remove("HUDPaint", "DroneCam")
            end
        end)
    end)
end
