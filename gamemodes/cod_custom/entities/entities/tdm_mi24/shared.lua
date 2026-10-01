AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "MI24"
ENT.AutomaticFrameAdvance = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/tdmg/mi24d.mdl")
        self:SetHealth(5000)
        self.Velo = {x = 0, y = 0}
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self.MultSpeed = 100
        self.MaxSpeed = 300
        self.Height = COD.DataTable["AirVehicle_FlyHeight"]
        self.Smoking = false
        self.DisableThinkPart = false
        self.CantBeDamaged = true
        self.FireDelay = CurTime() + 1
        self.SeekDelay = CurTime() + 2
        self.ControlDelay = CurTime() + 1
        self:SetNWFloat('RemoveTime', CurTime() + 60)
        self.Removing = false
        self.Target = nil
        self.Team = 1
        self.Actions = {
            ["MoveForward"] = false,
            ["MoveBack"] = false,
            ["MoveLeft"] = false,
            ["MoveRight"] = false,
        }
        self:SetBodygroup(3, 1)
        self:SetBodygroup(4, 1)
        self:ManipulateBoneScale(10, Vector(0,0,0))
        self:ManipulateBoneScale(11, Vector(0,0,0))
        self:ManipulateBoneScale(7, Vector(0,0,0))
        self:ManipulateBoneAngles(5, Angle(0,40,0))
        timer.Simple(1, function()
            if !IsValid(self) then return end
            self:EmitSound("ambient/levels/streetwar/heli_distant1.wav", 90, 90, 1)
        end)
        self:PlaySeq("arrive", 5, function()
            self:EmitSound(")npc/attack_helicopter/aheli_rotor_loop1.wav", 90, 90, 1)
        end)

        timer.Simple(5, function()
            if !IsValid(self) then return end
            
            if self.Team == 1 then
                self.VJ_NPC_Class = {"CLASS_SPECGRU"}
            elseif self.Team == 2 then
                self.VJ_NPC_Class = {"CLASS_KORTAC"}
            end
        end)
    end

    function ENT:PlaySeq(name, long, onfinish)
        self:SetCycle(0)
        self:ResetSequence(name)
        self.CantBeDamaged = true
        self:SetNotSolid(true)

        if !isfunction(onfinish) then
            onfinish = function() end
        end

        timer.Create("MI24Anim"..self:EntIndex(), long, 1, function()
            if !IsValid(self) then return end

            self:ResetSequence("idle")
            self:SetNotSolid(false)
            self.CantBeDamaged = false
            onfinish()
        end)
    end

    function ENT:OnRemove()
        self:StopSound("npc/attack_helicopter/aheli_rotor_loop1.wav")
    end

    function ENT:GetTurretPos()
        local bone = self:GetBonePosition(8)
        return bone
    end
    
    function ENT:Attack()
        local tar = self.Target

        if !IsValid(tar) then
            local tab = ents.FindInSphere(self:GetPos(), 4096)
            table.Shuffle(tab)
            for _, ent in ipairs(tab) do
                if self:VisibleVec(ent:GetPos()) then
                    if ent:IsNPC() and ent:Health() > 0 and (ent.Team and ent.Team != self.Team or !ent.Team) then
                        self.Target = ent
                        break
                    end
                    if ent:IsPlayer() and ent:Alive() and ent:Team() != self.Team and ent:GetNWFloat('Perk2') != 4 then
                        self.Target = ent
                        break
                    end
                end
            end
        end

        if IsValid(tar) and self.FireDelay < CurTime() then
            self.FireDelay = CurTime() + 0.06

            if self:AngleToEnemy(tar) < 45 and self.SeekDelay < CurTime() then
                local dir = (tar:GetPos()-self:GetTurretPos()):GetNormalized()

                self:EmitSound("weapons/ar2/fire1.wav", 90, 80, 1, CHAN_WEAPON)
                self:FireBullets({
                    IgnoreEntity = self,
                    Spread = VectorRand(-0.06, 0.06),
                    Damage = 30,
                    Dir = dir,
                    Src = self:GetTurretPos(),
                })
            end

            if not self:VisibleVec(tar:GetPos()) or tar:Health() <= 0 then
                self.ControlDelay = CurTime() + 4
                self.SeekDelay = CurTime() + 2
                self.Target = nil
            end
        end
    end

    function ENT:AngleToEnemy(enemy)
        local selfAngles = self:GetAngles()
        local enemyPos = enemy:GetPos()
        local angleToEnemy = (enemyPos - self:GetPos()):Angle()
        angleToEnemy.x = 0
        angleToEnemy.z = 0
        local diff = math.AngleDifference(angleToEnemy.y, selfAngles.y)
        return math.abs(diff)
    end

    function ENT:RotateToEntity(ent2, divisor)
        local ent1Angles = self:GetAngles()
        local targetAngles = (ent2:GetPos() - self:GetPos()):Angle()
        local yawDiff = math.NormalizeAngle(targetAngles.y - ent1Angles.y)
        
        self:SetAngles(Angle(0, ent1Angles.y + yawDiff / divisor, 0))
    end

    function ENT:Controls()
        local tar = self.Target
        --[[self.Actions = {
            ["MoveForward"] = false,
            ["MoveBack"] = false,
            ["MoveLeft"] = false,
            ["MoveRight"] = false,
        }]]--
        if IsValid(tar) then
            if self.ControlDelay < CurTime() then
                self.ControlDelay = CurTime() + math.Rand(1,5)
                self.Actions = {
                    ["MoveForward"] = math.random(1,2) == 1,
                    ["MoveBack"] = math.random(1,6) == 1,
                    ["MoveLeft"] = math.random(1,4) == 1,
                    ["MoveRight"] = math.random(1,4) == 1,
                }
            end
            self:RotateToEntity(tar, 75)
        else
            if self.ControlDelay < CurTime() then
                self.Actions = {
                    ["MoveForward"] = false,
                    ["MoveBack"] = false,
                    ["MoveLeft"] = false,
                    ["MoveRight"] = false,
                }
            end
        end
    end

    function ENT:Think()
        local mu = self.MultSpeed
        local ms = self.MaxSpeed
        local vel = self:GetPhysicsObject():GetVelocity()
        vel.z = 0

        if not self.DisableThinkPart then
            if not self.CantBeDamaged then
                self:Attack()
                self:Controls()
                self:GetPhysicsObject():SetVelocity(-vel+self:GetForward()*self.Velo.x+self:GetRight()*self.Velo.y)
            end

            local pos = self:GetPos()
            self:SetPos(Vector(pos.x, pos.y, self.Height))
            local ang = self:GetAngles().y
            self:SetAngles(Angle(0,ang,0))
            
            if self.Actions["MoveRight"] then
                self.Velo.x = math.Clamp(self.Velo.x+FrameTime()*mu, -ms, ms)
            elseif self.Actions["MoveLeft"] then
                self.Velo.x = math.Clamp(self.Velo.x-FrameTime()*mu, -ms, ms)
            end
            if self.Actions["MoveForward"] then
                self.Velo.y = math.Clamp(self.Velo.y-FrameTime()*mu, -ms, ms)
            elseif self.Actions["MoveBack"] then
                self.Velo.y = math.Clamp(self.Velo.y+FrameTime()*mu, -ms, ms)
            end
            if not self.Actions["MoveLeft"] and not self.Actions["MoveRight"] then
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
            if not self.Actions["MoveForward"] and not self.Actions["MoveBack"] then
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
            if self:GetNWFloat('RemoveTime') < CurTime() and not self.Removing and not self.DisableThinkPart then
                self.Removing = true
                self:EmitSound("ambient/levels/streetwar/heli_distant1.wav", 90, 90, 1)
                self:StopSound("npc/attack_helicopter/aheli_rotor_loop1.wav")
                self:PlaySeq("finish", 8, function()
                    self:Remove()
                end)
            end
            if self:Health() <= 1000 and not self.Smoking then
                self.Smoking = true
                ParticleEffectAttach("Rocket_Smoke_Trail", 4, self, 2)
            end
            if self:Health() <= 0 then
                self:DestroyHeli()
            end
        end

        self:ManipulateBoneAngles(0, Angle(0,(math.sin(CurTime())*4),(math.sin(CurTime()*2)*4)))
        self:ManipulateBonePosition(0, Vector(0,0,(math.sin(CurTime())*10)))

        self:NextThink(CurTime())
        return true
    end

    function ENT:OnTakeDamage(dmgt)
        if self.CantBeDamaged then return end
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

    function ENT:DestroyHeli()
        self.DisableThinkPart = true
        self.DestroyVelocity = 2500
        self:EmitSound("tdmg/mi24/spindown.wav")
        self.PhysicsCollide = function(self)
            ParticleEffect("explosion_huge_h", self:GetPos()+Vector(0,0,32), Angle(0,0,0))
            self:EmitSound("tdmg/a10_explosion.wav", 0)
            self:StopSound("tdmg/mi24/spindown.wav")
            self:Remove()
        end
        self.Think = function(self)
            local RPM = self.DestroyVelocity
            local p = self:GetPhysicsObject()
            if IsValid(p) then
                local angvel = p:GetAngleVelocity()
                p:AddAngleVelocity(Vector(angvel.x > 100 and 0 or RPM*0.01,0,angvel.z > 200 and 0 or math.Clamp(RPM,0,4000)*0.04))

                local vel = p:GetVelocity()
                p:SetVelocity(-vel-Vector(0,0,750))
            end
            self:NextThink(CurTime())
            return true
        end 
    end
end
