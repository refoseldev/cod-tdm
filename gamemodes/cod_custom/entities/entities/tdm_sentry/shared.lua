AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Sentry Gun"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/tdmg/sentry.mdl")
        self:SetHealth(1500)
        self:SetSolid(SOLID_VPHYSICS)
        self.DestroyedAng = 0
        self.DisableThinkPart = false
        self.FireDelay = CurTime() + 1
        self.RemoveDelay = CurTime() + 120
        self.Target = nil
        self.Smoking = false
        self.StartingShoot = false
        self.StartingShootDelay = 0
        self.StartedShoot = false
        self.Team = 1
        self.DelayRespin = 2
        self.BeepDelay = CurTime() + 3
        self:SetSequence("rotation_barrels2x")

        local t = ents.Create("base_anim")
        t:SetModel('models/props_junk/PopCan01a.mdl')
        t:SetPos(self:GetTurretPos())
        t:SetAngles(self:GetAngles())
        t:SetParent(self)
        t:SetOwner(self)
        t:SetNoDraw(true)
        t:Spawn()
        self.ShootEntity = t

        self:ManipulateBoneAngles(3, Angle(-70, 0, 0))
        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            self:EmitSound("tdmg/sentry/mw2_sentryplace.wav")
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

    function ENT:OnRemove()
        --self:StopSound("npc/attack_helicopter/aheli_rotor_loop1.wav")
    end

    function ENT:GetTurretPos()
        local pos, ang = self:GetBonePosition(4)
        return pos, ang
    end

    function ENT:IsInFOV(entity)
        local direction = (entity:GetPos() - self:GetTurretPos()):GetNormalized()
        local viewAngle = self:GetForward()
        local dot = direction:Dot(viewAngle)
        
        if dot >= math.cos(math.rad(180 / 2)) then
            return true
        else
            return false
        end
    end

    function ENT:GetNextTarget()
        local target = nil
        local tab = ents.FindInSphere(self:GetPos(), 8000)
        table.Shuffle(tab)
        for _, ent in ipairs(tab) do
            if self:IsInFOV(ent) and self:VisibleVec(ent:WorldSpaceCenter()) then
                if ent:IsNPC() and ent:Health() > 0 and (ent.Team and ent.Team != self.Team or !ent.Team) then
                    target = ent
                    break
                end
                if ent:IsPlayer() and ent:Alive() and ent:Team() != self.Team and ent:GetNWFloat('Perk2') != 4 then
                    target = ent
                    break
                end
            end
        end
        return target
    end
    
    function ENT:Attack()
        local tar = self.Target

        if !IsValid(tar) then
            self.Target = self:GetNextTarget()
            self:RotateToEntity(self:GetAngles(), 45)
            if self.BeepDelay < CurTime() then
                self.BeepDelay = CurTime() + 3
                self:EmitSound("tdmg/sentry/mw2_sentrybeep.wav")
            end
        else
            if self.StartedShoot then
                self:RotateToEntity(tar, 10)
            else
                self:RotateToEntity(tar, 30)
            end
        end

        if IsValid(tar) then
            self:Shoot(true)

            if not self:VisibleVec(tar:GetPos()) or not self:IsInFOV(tar) or tar:Health() <= 0 then
                self.ControlDelay = CurTime() + 4
                self.Target = self:GetNextTarget()
            end
        else
            self:Shoot(false)
        end
    end

    function ENT:Shoot(bool)          
        if not bool then
            self.StartedShoot = false
            if self.StartingShoot and not bool and self.StartingShootDelay < CurTime() then
                self.StartingShootDelay = CurTime() + self.DelayRespin
                self:EmitSound("tdmg/sentry/mw2_sentryspindown.wav")
                if self.FireSound then
                    self:StopLoopingSound(self.FireSound)
                    self.FireSound = -1
                end
            end
        else
            if not self.StartingShoot and bool and self.StartingShootDelay < CurTime() then
                self.StartingShootDelay = CurTime() + self.DelayRespin
                self:EmitSound("tdmg/sentry/mw2_sentryspinup.wav")
            end
        end

        self.StartingShoot = bool

        if not self.StartingShoot then
            local num = math.max(1*(self.StartingShootDelay-CurTime())/self.DelayRespin, 0)
            self:SetPlaybackRate(num)
        end

        if self.StartingShoot then
            local num = math.min(((1*(self.StartingShootDelay-CurTime())/self.DelayRespin)-1)*-1, 1)
            self:SetPlaybackRate(num)
        end

        if self.StartingShoot and self.StartingShootDelay < CurTime() then
            self.StartedShoot = true
            self:SetPlaybackRate(1)
            if not self.FireSound or self.FireSound < 0 then
                self.FireSound = self:StartLoopingSound("tdmg/sentry/mw2_sentryfirebullet.wav")
            end
            if self.FireDelay < CurTime() then
                self.FireDelay = CurTime() + 0.04

                local pos1, ang1 = self:GetTurretPos()

                self.ShootEntity:FireBullets({
                    Src = pos1,
                    Dir = ang1:Forward(),
                    Spread = VectorRand(-0.10, 0.10),
                    Damage = 20,
                    IgnoreEntity = self,
                })
            end
        end
    end

    function ENT:AngleToEnemy(enemy)
        local selfPos, selfAngles = self:GetBonePosition(3)
        selfAngles = selfAngles
        local enemyPos = enemy:GetPos()
        local angleToEnemy = (enemyPos - self:GetTurretPos()):Angle()
        angleToEnemy.z = 0
        local diff = math.AngleDifference(angleToEnemy.y, selfAngles.y)
        return math.abs(diff)
    end

    function ENT:RotateToEntity(ent2, divisor)
        local selfPos, selfAngles = self:GetBonePosition(3)
        selfAngles = selfAngles
        local targetAngles = Angle(0,0,0)
        if isangle(ent2) then
            targetAngles = ent2
        else
            targetAngles = (ent2:WorldSpaceCenter() - self:GetTurretPos()):Angle()
        end
        local yawDiff = math.NormalizeAngle(targetAngles.y - selfAngles.y)
        local xDiff = math.NormalizeAngle(targetAngles.x - selfAngles.x)

        self:ManipulateBoneAngles(3, Angle(self:GetManipulateBoneAngles(3).x + xDiff / divisor, self:GetManipulateBoneAngles(3).y + yawDiff / divisor, 0))
    end

    function ENT:Think()
        if not self.DisableThinkPart then
            self:Attack()
            self.DestroyedAng = 0

            local id, long = self:LookupSequence(self:GetSequenceName(self:GetSequence()))
            local addframe = FrameTime()/long*self:GetPlaybackRate()   
            if self:GetCycle() >= 1 then
                self:SetCycle(0)
            else
                self:SetCycle(self:GetCycle()+addframe)
            end

            if self:Health() <= 0 or self.RemoveDelay < CurTime() then
                self:Destroy()
            end
        else
            print(self.DestroyedAng)
            self.DestroyedAng = math.min(45, self.DestroyedAng+FrameTime()/0.01)
            self:ManipulateBoneAngles(3, Angle(self.DestroyedAng, 0, 0))
        end

        self:NextThink(CurTime())
        return true
    end

    function ENT:OnTakeDamage(dmgt)
        local dmg = dmgt:GetDamage()
        local att = dmgt:GetAttacker()
        if att != self or att:IsPlayer() and att:Team() != self.Team then
            self:SetHealth(self:Health()-dmg)
            self:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav")
        end
    end

    function ENT:Destroy()
        if self.DisableThinkPart then return end

        if self.FireSound then
            self:StopLoopingSound(self.FireSound)
            self.FireSound = -1
        end
        self.DisableThinkPart = true
        ParticleEffectAttach("Rocket_Smoke_Trail", 4, self, 0)
        self:EmitSound("tdmg/sentry/mw2_sentrydestroyed.wav")

        timer.Simple(15, function()
            if !IsValid(self) then return end
            self:Remove()
        end)
    end
end
