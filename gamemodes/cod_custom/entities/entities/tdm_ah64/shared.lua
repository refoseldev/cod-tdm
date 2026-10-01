AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "AH-64"

if SERVER then
    util.AddNetworkString("COD.AH64Cam")
    net.Receive("COD.AH64Cam", function(len, ply)
        ply.AH64_Cam_Pos = net.ReadVector()
        ply.AH64_Cam_Ang = net.ReadAngle()
    end)

    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube2x8x1.mdl")
        self:SetHealth(999999999)
        self.Velo = {x = 0, y = 0}
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self.MultSpeed = 500
        self.MaxSpeed = 750
        self.Height = COD.DataTable["AirVehicle_FlyHeight"]
        self.Smoking = false
        self.DeltaTime = 0
        self.FireDelay = CurTime()+1
        self.FireDelay2 = CurTime()+1
        self:SetNWFloat('Rockets', 8)
        self:SetNWFloat('RemoveTime', CurTime()+50)
        self:SetNoDraw(true)
        self:EmitSound(")npc/attack_helicopter/aheli_rotor_loop1.wav", 100, 100, 1, CHAN_BODY)

        timer.Simple(3, function()
            if !IsValid(self) then return end
            self:SetHealth(3000)
        end)

        timer.Simple(0.1, function()
            local ply = self:GetCreator()
            if !IsValid(ply) then return end

            net.Start("COD.Cutscene")
            net.WriteTable({
                num_of_cutscene = 1,
                path_of_sound = "tdmg/heli/spawn.wav",
                fps = 30,
                screenfade = true,
            })
            net.Send(ply)

            net.Start("COD.AH64Cam")
            net.WriteEntity(self)
            net.Send(ply)
            ply.ControllingKillstreak = true
        end)

        local mod = ents.Create("base_anim")
        mod:SetModel("models/tdmg/ah64.mdl")
        mod:SetPos(self:GetPos())
        mod:SetAngles(self:GetAngles()+Angle(0,90,0))
        mod:SetParent(self)
        mod:Spawn()
        self:DeleteOnRemove(mod)

        timer.Simple(5, function()
            if !IsValid(self) then return end
            
            if self.Team == 1 then
                self.VJ_NPC_Class = {"CLASS_SPECGRU"}
            elseif self.Team == 2 then
                self.VJ_NPC_Class = {"CLASS_KORTAC"}
            end
        end)
    end

    function ENT:OnRemove()
        self:StopSound(")npc/attack_helicopter/aheli_rotor_loop1.wav")

        local ply = self:GetCreator()
        if !IsValid(ply) then return end
        ply.ControllingKillstreak = false
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
            vel.z = 0

            local pos = self:GetPos()
            local ang = ply:EyeAngles().y
            ply:SetActiveWeapon(nil)
            self:SetPos(Vector(pos.x, pos.y, self.Height))
            phys:SetVelocityInstantaneous(-vel+self:GetForward()*self.Velo.x+self:GetRight()*self.Velo.y)
            if ply:KeyDown(IN_MOVERIGHT) then
                self.Velo.x = math.Clamp(self.Velo.x+FrameTime()*mu, -ms, ms)
            elseif ply:KeyDown(IN_MOVELEFT) then
                self.Velo.x = math.Clamp(self.Velo.x-FrameTime()*mu, -ms, ms)
            end
            if ply:KeyDown(IN_FORWARD) then
                self.Velo.y = math.Clamp(self.Velo.y-FrameTime()*mu, -ms, ms)
            elseif ply:KeyDown(IN_BACK) then
                self.Velo.y = math.Clamp(self.Velo.y+FrameTime()*mu, -ms, ms)
            end
            if not ply:KeyDown(IN_MOVELEFT) and not ply:KeyDown(IN_MOVERIGHT) then
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
            if not ply:KeyDown(IN_FORWARD) and not ply:KeyDown(IN_BACK) then
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
            if ply:KeyDown(IN_ATTACK) and self.FireDelay < CurTime() then
                self.FireDelay = CurTime()+0.15
                self:EmitSound("tdmg/killstreaks/apache_cannon.wav", 100, math.random(90,110), 1, CHAN_WEAPON)
                ply:ViewPunch(Angle(1,0,0))

                local pos = ply.AH64_Cam_Pos+Vector(0,0,12)
                local ang = ply.AH64_Cam_Ang

                local explosion = ents.Create("tdm_ah64_rocket1")
                explosion:SetPos(pos)
                explosion:SetOwner(self)
                explosion:SetNWFloat('Team', self.Team)
                explosion.Team = self.Team
                explosion:SetAngles(ang)
                explosion:Spawn()
            end
            if ply:KeyDown(IN_ATTACK2) and self.FireDelay2 < CurTime() and self:GetNWFloat('Rockets') > 0 then
                self.FireDelay2 = CurTime()+0.5
                self:SetNWFloat('Rockets', self:GetNWFloat('Rockets')-1)
                self:EmitSound("tdmg/killstreaks/ac130_rocket.wav", 100, math.random(90,110), 1, CHAN_WEAPON)
                ply:ViewPunch(Angle(5,0,0))

                local pos = ply.AH64_Cam_Pos+Vector(0,0,12)
                local ang = ply.AH64_Cam_Ang

                local explosion = ents.Create("tdm_ah64_rocket2")
                explosion:SetPos(pos)
                explosion:SetOwner(self)
                explosion:SetNWFloat('Team', self.Team)
                explosion.Team = self.Team
                explosion:SetAngles(ang)
                explosion:Spawn()
            end
            if self:GetNWFloat('RemoveTime') < CurTime() then
                self:Remove()
            end
            if self:Health() <= 1000 and not self.Smoking then
                self.Smoking = true
                ParticleEffectAttach("Rocket_Smoke_Trail", 1, self, 0)
            end
            if self:Health() <= 0 then
                self:DestroyHeli(self.IsDExplosionDamage)
            end

            local b = {}
            b.secondstoarrive = 1
            b.pos = self:GetPos()
            b.angle = Angle(0,ang,0)
            b.maxangular = 10
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

    function ENT:OnTakeDamage(dmgt)
        local dmg = dmgt:GetDamage()
        local att = dmgt:GetAttacker()
        if att != self or att:IsPlayer() and att:Team() != self.Team then
            self:SetHealth(self:Health()-dmg)
            self.IsDExplosionDamage = dmgt:IsExplosionDamage()
            if IsValid(self:GetCreator()) then
                self:GetCreator():ViewPunch(AngleRand(-1,1))
                self:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav")
            end
        end 
    end

    function ENT:DestroyHeli(isrocket)
        local ply = self:GetCreator()

        if IsValid(ply) then
            if isrocket then
                net.Start("COD.Cutscene")
                net.WriteTable({
                    num_of_cutscene = 3,
                    path_of_sound = "tdmg/heli/shotrocket.wav",
                    fps = 30,
                    screenfade = true,
                })
                net.Send(ply)
            else
                net.Start("COD.Cutscene")
                net.WriteTable({
                    num_of_cutscene = 2,
                    path_of_sound = "tdmg/heli/shotbullet.wav",
                    fps = 30,
                    screenfade = true,
                })
                net.Send(ply)
            end
        end

        ParticleEffect("explosion_huge_h", self:GetPos(), Angle(0,0,0))
        sound.Play("tdmg/a10_explosion.wav", self:GetPos(), 0)
        self:Remove()
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

    net.Receive("COD.AH64Cam", function()
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
        
        hook.Add("RenderScreenspaceEffects", "AH64Cam", function()
            DrawColorModify(tab)
        end)

        hook.Add("HUDPaint", "AH64Cam", function()
            surface.SetDrawColor(50,50,50,100)
            surface.SetMaterial(glitchMat)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

            surface.SetDrawColor(255,255,255)
            surface.DrawOutlinedRect(50, 50, ScrW()-100, ScrH()-100, 2)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-200, ScrH()/2, 150, 2)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-200, ScrH()/2-10, 2, 20)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2+50, ScrH()/2, 150, 2)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2+200, ScrH()/2-10, 2, 20)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2, ScrH()/2+50, 2, 150)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-10, ScrH()/2-200, 20, 2)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2, ScrH()/2-200, 2, 150)

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-10, ScrH()/2+200, 20, 2)

            --------------------------------------------------------------------------------

            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-15, ScrH()/2-1, 30, 2)

            
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(ScrW()/2-1, ScrH()/2-16, 2, 30)

            --------------------------------------------------------------------------------

            draw.SimpleText("✷ CHOPPER GUNNER", "DermaLarge", 100, 100, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("ACTIVE", "DermaLarge", 100, 130, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText("∾   CANNON ROUNDS", "DermaLarge", ScrW()-100, ScrH()-130, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText(ent:GetNWFloat('Rockets').."    HYDRA ROCKETS", "DermaLarge", ScrW()-100, ScrH()-100, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            if ent:Health() < 1000 then
                draw.SimpleText("WARNING: CRITICAL DAMAGE", "DermaLarge", ScrW()/2, ScrH()/2+300, Color(200,20,20,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

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
            surface.DrawRect(75, ScrH()-220, 300*((ent:GetNWFloat('RemoveTime')-CurTime())/45), 15) 

            surface.SetDrawColor(255,255,255,255)
            surface.DrawOutlinedRect(75, ScrH()-220, 300, 15, 2)

            draw.SimpleText("FUEL", "DermaLarge", 75, ScrH()-250, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            surface.SetDrawColor(220,220,220,255)
            surface.DrawRect(75, ScrH()-120, 300*(ent:Health()/3000), 15)

            surface.SetDrawColor(255,255,255)
            surface.DrawOutlinedRect(75, ScrH()-120, 300, 15, 2)

            draw.SimpleText("HEALTH", "DermaLarge", 75, ScrH()-150, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            ---------------------------------------------------------------------------------

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and ply:Team() != LocalPlayer():Team() and ply:GetNWFloat('Perk2') != 4 then
                    local pos = ply:WorldSpaceCenter():ToScreen()

                    if CanSee(EyePos(), ply:WorldSpaceCenter()) then
                        surface.SetDrawColor(200,0,0,200)
                    elseif ply:WorldSpaceCenter():DistToSqr(EyePos()) < 2500000 then
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

        hook.Add("CreateMove", "AH64Cam", function(cmd)
            cmd:SetForwardMove(0)
            cmd:SetSideMove(0)
            cmd:RemoveKey(IN_JUMP)
            cmd:RemoveKey(IN_USE)
        end)

        hook.Add("CalcView", "AH64Cam", function( ply, pos, angles, fov )
            if IsValid(ent) then
                COD.HideHUD = true
                COD.HUD_DisableSomeThink = true
                local pos1 = ent:GetPos()-ent:GetRight()*128-ent:GetUp()*48
                local ang1 = angles+Angle(0,90,0)
                local view = {
                    origin = pos1,
                    angles = ang1,
                    fov = fov,
                    drawviewer = true
                }

                net.Start("COD.AH64Cam")
                net.WriteVector(pos1)
                net.WriteAngle(ang1)
                net.SendToServer()
            
                return view
            else
                COD.HideHUD = false
                COD.HUD_DisableSomeThink = false
                hook.Remove("CalcView", "AH64Cam")
                hook.Remove("CreateMove", "AH64Cam")
                hook.Remove("RenderScreenspaceEffects", "AH64Cam")
                hook.Remove("HUDPaint", "AH64Cam")
            end
        end)
    end)
end
