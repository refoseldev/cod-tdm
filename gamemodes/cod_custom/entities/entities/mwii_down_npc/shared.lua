AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

if SERVER then
    local function TransferModelData(ent, from)
        local ent1Model = from:GetModel()
        local ent1Skin = from:GetSkin()
        local ent1BodyGroups = from:GetNumBodyGroups()
        ent:SetModel(ent1Model)
        ent:SetSkin(ent1Skin)
        for i = 0, ent1BodyGroups - 1 do
            ent:SetBodygroup(i, from:GetBodygroup(i))
        end
    end

    function ENT:CrawlBack(go)
        local tr = util.TraceLine({
            start = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1")),
            endpos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))-self:GetForward()*4,
            filter = function( ent ) if ent != self.NPC then return true end end
        })
        local tr2 = util.TraceLine({
            start = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Spine")),
            endpos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Spine"))-Vector(0,0,8),
            filter = function( ent ) if ent != self.NPC then return true end end
        })
        local tr3 = util.TraceLine({
            start = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Spine")),
            endpos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Spine"))-Vector(0,0,4),
            filter = function( ent ) if ent != self.NPC then return true end end
        })
        if tr3.Hit then
            self:SetPos(self:GetPos()+Vector(0,0,1))
        end
        if not tr2.Hit then
            self:SetPos(self:GetPos()-Vector(0,0,1))
        end
        local anim = "laststand_crawl_backward"
        if go then 
            if self.CanShoot then
                anim = anim.."_wep"
            end
            if not tr.Hit then
                self:SetPos(self:GetPos()-self:GetForward()*0.3)
                self:SetSequence(anim)
            else
                anim = "laststand_idle"
                if self.CanShoot then
                    anim = anim.."_wep"
                end
                self:SetSequence(anim)
            end
        else
            anim = "laststand_idle"
            if self.CanShoot then
                anim = anim.."_wep"
            end
            self:SetSequence(anim)
        end
    end

    function ENT:Initialize()
        self:SetModel("models/player/barney.mdl")
        self:ResetSequence("laststand_down")
        self:SetNoDraw(true)
        self:DrawShadow(false)
        self.Reviving = false
        self.TimeBeforeReviving = CurTime() + math.random(5,15)
        self.NPC:SetNoDraw(true)
        self.NPC.CantDamageMWII = true
        self:SetNWFloat("DTeam", self.NPC.Team)
        local wep = self.NPC:GetActiveWeapon()
        if IsValid(wep) then
            wep:SetClip1(0)
        end

        local tar = self.NPC
        timer.Simple(0.5, function()
            if !IsValid(tar) then return end
            tar.CantDamageMWII = false
        end)
        timer.Simple(1.5, function()
            if !IsValid(self) then return end
            self.Ready = true

            self:ResetSequence("laststand_idle_wep")
            self.ShootDelay = CurTime() + 1
            self.TimeBeforeReviving = CurTime() + math.random(10,20)
            self.CanShoot = true

            local bd = ents.Create("base_anim")
            bd:SetModel("models/weapons/w_pistol.mdl")
            bd:SetParent(self)
            bd:AddEffects(1)
            bd:Spawn()
            self:DeleteOnRemove(bd)

            timer.Simple(20, function()
                if !IsValid(self) then return end
                self.NPC:SetHealth(1)
                self.NPC:TakeDamage(self.NPC:Health())
                self.NPC:TakeDamage(999999999)
            end)
        end)

        local bd = ents.Create("base_anim")
        bd:SetParent(self)
        bd:AddEffects(1)
        bd:Spawn()
        self.bd = bd
        TransferModelData(bd, self.NPC)
        self:DeleteOnRemove(bd)
    end

    function ENT:Revive(fast)
        local ow = self.NPC
        self.Reviving = true
        self:SetCycle(0)
        if not fast then
            self:ResetSequence("laststand_selfrevive")
            timer.Simple(5, function()
                if !IsValid(self) then return end

                self:SetCycle(0)
                self:ResetSequence("laststand_standup")
            end)
            timer.Simple(6, function()
                if !IsValid(ow) then return end

                self.NPC = nil
                ow:ManipulateBonePosition(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Vector(0, 0, 0))
                ow:ManipulateBoneAngles(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Angle(0, 0, 0))
                ow:SetNoDraw(false)
                ow:SetRenderMode(RENDERMODE_NORMAL)
                ow:DrawShadow(true)
                ow.Downed = false
                ow:RemoveEFlags(EFL_NO_THINK_FUNCTION)
                local wep = ow:GetActiveWeapon()
                if IsValid(wep) then
                    wep:SetNoDraw(false)
                end
                ow:SetNWEntity('MWIIRag', NULL)
            end)
        else
            self:ResetSequence("laststand_standup")
            timer.Simple(1, function()
                if !IsValid(ow) then return end

                self.NPC = nil
                ow:ManipulateBonePosition(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Vector(0, 0, 0))
                ow:ManipulateBoneAngles(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Angle(0, 0, 0))
                ow:SetNoDraw(false)
                ow:SetRenderMode(RENDERMODE_NORMAL)
                ow:DrawShadow(true)
                ow.Downed = false
                ow:RemoveEFlags(EFL_NO_THINK_FUNCTION)
                local wep = ow:GetActiveWeapon()
                if IsValid(wep) then
                    wep:SetNoDraw(false)
                end
                ow:SetNWEntity('MWIIRag', NULL)
            end)
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

    function ENT:Think()
        local ow = self.NPC
        if !IsValid(ow) or ow:Health() <= 0 or ow.Takedowning then
            self:Remove()
        else
            ow:SetNoDraw(true)
            ow:SetRenderMode(RENDERMODE_NONE)
            ow.AlreadyWasDowned = true
            ow:DrawShadow(false)
            if ow.IsVJBaseSNPC then
                ow.HasDeathAnimation = false
            end
            ow:AddEFlags(EFL_NO_THINK_FUNCTION)
            ow:SetNWEntity('MWIIRag', self.bd)
            ow:ManipulateBonePosition(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Vector(0, 0, -20))
            ow:ManipulateBoneAngles(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Angle(0, 0, -90))
            local wep = ow:GetActiveWeapon()
            if IsValid(wep) then
                wep:SetNoDraw(true)
            end

            local att = self.Finisher

            if not self.Reviving then
                local near, dist = nil, math.huge
                for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 2048)) do
                    if (ent:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool() or ent.IsMWIINPC and ent:IsMWIINPC()) and !ow:MWIIsFriend(ent, true) and ent:Health() > 0 and ow:Visible(ent) then
                        local dis = ent:GetPos():DistToSqr(self:GetPos())
                        if dis < dist then
                            near = ent
                            dist = dis
                        end
                    end
                end
                if IsValid(near) then
                    local sang = self:GetAngles()
                    local direction = (near:GetPos()-self:GetPos()):GetNormalized():Angle()
                    direction.x = 0
                    direction.z = 0
                    local add, notadd = (direction.y-sang.y)/50, (direction.y-sang.y)/20
                    local add2 = math.AngleDifference( direction.y, sang.y )
                    local adding = sang+(Angle(0,add2/50,0))
                    self:SetAngles(adding)
                    ow:SetAngles(self:GetAngles())
                    ow:SetPos(self:GetPos())

                    if self.Ready and (IsValid(ow.TargetReviver) and not ow.TargetReviver.InSeqMWII or !IsValid(ow.TargetReviver)) then
                        self:CrawlBack(dist < 200000 and self:AngleToEnemy(near) < 30)
                    else
                        if self.Ready then
                            self:CrawlBack(false)
                        end
                    end

                    if self.CanShoot and self.ShootDelay < CurTime() and self:AngleToEnemy(near) < 15 then
                        self.ShootDelay = CurTime() + math.Rand(0.2,2)
                        ow:EmitSound("weapons/pistol/pistol_fire3.wav", 90, math.random(90,110), 1, CHAN_WEAPON)
                        ow:FireBullets({
                            Damage = 10,
                            Spread = VectorRand(0.00, 0.20),
                            Dir = (near:GetPos()-self:EyePos()):GetNormalized(),
                            Src = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_R_Hand")),
                        })
                    end
                end 
            end
        end
        self:SetNoDraw(true)
        self:DrawShadow(false)
        self:NextThink(CurTime())
        return true
    end
else
    local tm_mat = Material('tdmg/hud/teammate.png')
    function ENT:Draw()
        if self:GetNWFloat('DTeam') == LocalPlayer():Team() then
            local angle = EyeAngles()
            angle = Angle( 0, angle.y, 0 )
            angle:RotateAroundAxis( angle:Up(), -90 )
            angle:RotateAroundAxis( angle:Forward(), 90 )
            local pos = self:GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))+Vector(0,0,16)
            cam.Start3D2D( pos, angle, 0.1 )
                surface.SetDrawColor(5,155,255)
                surface.SetMaterial(tm_mat)
                surface.DrawTexturedRect(-12, -12, 24, 24)
            cam.End3D2D()
        end
    end
end
