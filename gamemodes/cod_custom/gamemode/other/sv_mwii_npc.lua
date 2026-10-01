local meta = FindMetaTable("Player")
local enb = FindMetaTable("Entity")

function enb:IsMWIINPC()
    return self:IsNPC() or self:IsNextBot()
end

local function GetLongOfSequence(model, sequence)
    local t = ents.Create("base_anim")
    t:SetModel(model)
    t:SetRenderMode(10)
    t:Spawn()
    local id, long = t:LookupSequence(sequence)
    t:Remove()
    return long, id
end

function enb:Freeze(bool)
    if self:IsMWIINPC() then
        if bool then
            self:AddEFlags(EFL_NO_THINK_FUNCTION)
        else
            self:RemoveEFlags(EFL_NO_THINK_FUNCTION)
        end        
    end
end

function enb:MWII_BE(bonename)
    local bone = self:LookupBone(bonename)
    if bone then
        local ef = EffectData()
        ef:SetOrigin(self:GetBonePosition(bone))
        ef:SetColor(0)
        util.Effect("BloodImpact", ef)
    end
end

function enb:HeadBlow()
    for i=1,4 do
        local pos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
        local m = ents.Create("prop_physics")
        m:SetModel("models/Gibs/HGIBS_scapula.mdl")
        m:SetPos(pos)
        m:SetAngles(AngleRand())
        m:Spawn()
        m:SetMaterial("models/flesh")
        m:SetCollisionGroup(1)
        m:GetPhysicsObject():SetVelocity(VectorRand(-64,64))
        
        local ef = EffectData()
        ef:SetOrigin(pos)
        util.Effect("BloodImpact", ef)

        timer.Simple(15, function()
            if !IsValid(m) then return end
            m:Remove()
        end)
    end 
end

function MWIITransferBones( base, ragdoll )
    if !IsValid( base ) or !IsValid( ragdoll ) then return end
    for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
        local bone = ragdoll:GetPhysicsObjectNum( i )
        if ( IsValid( bone ) ) then
            local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
            if ( pos ) then bone:SetPos( pos ) end
            if ( ang ) then bone:SetAngles( ang ) end
        end
    end
end
    
downNPCsClassList = {
    ["vj_tdm_invasion_soldier1"] = true, 
    ["vj_tdm_invasion_soldier2"] = true, 
}
reviveNPCsClassList = {
    ["vj_tdm_invasion_soldier1"] = true, 
    ["vj_tdm_invasion_soldier2"] = true, 
} 
takedownedNPCsClassList = {
    ["vj_tdm_invasion_soldier1"] = true, 
    ["vj_tdm_invasion_soldier2"] = true, 
}
takedownNPCsClassList = {
    ["vj_tdm_invasion_soldier1"] = true, 
    ["vj_tdm_invasion_soldier2"] = true, 
}

function enb:IsDowned()
    if self:IsPlayer() then
        return self:GetNWBool('Downed')
    else
        return self.Downed
    end
end

function enb:MWIIsFriend(tar, neutral_too)
    local dis = self:Disposition(tar)
    if neutral_too then
        return dis == 3 or dis == 4
    else
        return dis == 3
    end
end

function enb:IsInFOVEnt(ent2)
    local ent1Pos = self:GetPos()
    local ent2Pos = ent2:GetPos()
    local ent1Ang = self:GetAngles():Forward()
    
    local direction = (ent1Pos - ent2Pos):GetNormalized()
    local dot = direction:Dot(ent1Ang)
    
    local fov = math.cos(math.rad(90))

    if dot < fov then
        return true
    else
        return false
    end
end

local optimize_delay = 0
hook.Add("Think", "STDMFindNPCs", function()
    if optimize_delay < CurTime() then
        optimize_delay = CurTime()+1
        local enttab = ents.FindByClass("*tdm_*") 
        for i=1,#enttab do
            local ent = enttab[i] 
            if ent:IsNPC() and reviveNPCsClassList[ent:GetClass()] and !ent.Downed and !ent.Takedowning then
                local tar = ent.ReviveThisTarget
                if !IsValid(tar) then 
                    local targets = ents.FindInSphere( ent:GetPos(), 512 )
                    for _, fri in ipairs(targets) do
                        if (fri:IsPlayer() or fri.IsMWIINPC and fri:IsMWIINPC()) and ent:MWIIsFriend(fri, true) then
                            if (fri:IsDowned() or fri.Downed) and !IsValid(fri.TargetReviver) then
                                fri.TargetReviver = ent
                                ent.ReviveThisTarget = fri
                                break
                            end
                        end
                    end
                else
                    local pos = tar:GetPos()
                    local dist = pos:DistToSqr(ent:GetPos())
                    if not timer.Exists("HelpNPCToMWII"..ent:EntIndex()) then
                        timer.Create("HelpNPCToMWII"..ent:EntIndex(), 2, 1, function()
                            if !IsValid(ent) then return end
                            ent:SetLastPosition( pos )
                            ent:SetSchedule( SCHED_FORCED_GO_RUN )
                            if ent.IsVJBaseSNPC then
                                ent:VJ_TASK_GOTO_LASTPOS()
                            end
                        end)
                    end
                    if dist < 2500 and not ent.InSeqMWII then
                        local tk = ents.Create("mwii_sequence_npc")
                        tk.NPC = ent
                        tk.Target = tar
                        tk.Sequence = "revive"
                        tk:SetPos(ent:GetPos())
                        local ang1 = (pos - ent:GetPos()):Angle()
                        ang1.x, ang1.z = 0, 0
                        tk:SetAngles(ang1)
                        tk:Spawn()
                        ent.ReviveThisTarget = nil
                    end
                    if !tar:IsDowned() then
                        ent.ReviveThisTarget = nil
                        tar.TargetReviver = nil
                    end
                end 
            end
            if ent:IsNPC() and takedownNPCsClassList[ent:GetClass()] and !ent.Downed and !ent.Takedowning and !ent.CantUseTakedown and math.random(1,4) >= 2 then
                local targets = ents.FindInSphere( ent:GetPos(), 200 )
                for _, en in ipairs(targets) do
                    if (en:IsMWIINPC() and en:Health() > 0) and ent:IsInFOVEnt(en) and !ent:MWIIsFriend(en, true) and !en.CantUseTakedown then
                        if ent:EyePos():DistToSqr(en:EyePos()) < 5000 then
                            ent:NPC_Takedown(en)
                            break
                        else
                            if not timer.Exists("TakedownNPCToMWII"..ent:EntIndex()) then
                                timer.Create("TakedownNPCToMWII"..ent:EntIndex(), 2, 1, function()
                                    if !IsValid(ent) or !IsValid(en) or en.Takedowning then return end
                                    ent:SetLastPosition( en:GetPos() )
                                    ent:SetSchedule( SCHED_FORCED_GO_RUN )
                                    if ent.IsVJBaseSNPC then
                                        ent:VJ_TASK_GOTO_LASTPOS()
                                    end
                                end)
                            end
                            break
                        end
                    end
                end 
            end 
        end
    end 
end) 

hook.Add("OnNPCKilled", "STDMHook", function(ent)
    if ent.Downed or ent.InSeqMWII then
        ent:SetRenderMode(RENDERMODE_NORMAL)
    end
end)

hook.Add("EntityTakeDamage", "!!!!!NPC_STDMHook", function(ply, dmg)
    local att = dmg:GetAttacker()
    local allowthis = ply:IsMWIINPC()

    if allowthis and dmg:GetDamage() < ply:Health() and math.random(1,100) == 1 and not dmg:IsExplosionDamage() and not ply.AlreadyWasDowned and not ply.Takedowning and not ply:IsDowned() then
        if ply:IsMWIINPC() and downNPCsClassList[ply:GetClass()] then
            dmg:ScaleDamage(0)
            ply.Downed = true
            ply:SetHealth(50)

            local tk = ents.Create("mwii_down_npc")
            tk.NPC = ply
            tk:SetPos(ply:GetPos())
            tk:SetAngles(ply:GetAngles())
            tk:Spawn()
            ply.DownedEnt = tk

            return true
        end
    end
    if ply.CantDamageMWII then
        dmg:ScaleDamage(0)
        return true
    end
end)

----------------------------------------------------------

function meta:IsAtBack(enemy) --This function was made by OpenAI ChatGPT
    if !IsValid(enemy) then return end
    local enemyForward = enemy:GetForward()
    local enemyToPlayer = self:GetPos() - enemy:GetPos()
    local angle = enemyForward:Angle():Forward():Dot(enemyToPlayer:GetNormalized())
    local degrees = math.deg(math.acos(angle))
    return degrees > 100
end

function meta:Takedown()
    local tr = self:GetEyeTrace()
    local ent = tr.Entity
    local dist = tr.StartPos:Distance(tr.HitPos) < 96
    local isnpc = ent:IsMWIINPC()
    if (!ent:IsPlayer() and !isnpc) or (!isnpc and ent:Team() == self:Team()) or (isnpc and ent:MWIIsFriend(self)) or self:IsDowned() or ent.Takedowning or self.Takedowning or !ent:OnGround() or !self:OnGround() or !self:IsAtBack(ent) or not dist then
        return
    end
    if isnpc and !ent:LookupBone("ValveBiped.Bip01_Spine") then
        return
    end

    local downed = ent:IsDowned()
    local _, rnd = table.Random(COD.Takedowns)
    local float = rnd
    
    if self:IsPlayer() and not self:IsBot() and self:GetNWString('TakedownAnim') != "00" then
        float = self:GetNWString('TakedownAnim')
    end
    if not COD.Takedowns[float] then return end
    if !isnumber(float) then
        anim1, anim2 = "execution_"..float.."_attacker_stand", "execution_"..float.."_victim_stand"
        if downed then
            anim1, anim2 = "execution_"..float.."_attacker_laststand", "execution_"..float.."_victim_laststand"
        end
    end
    print(float, anim1, anim2)
    local zpos = self:GetPos()
    local delay1 = select(2, self:LookupSequence(anim1))
    local delay2 = COD.Takedowns[float].deathtime
    if downed then
        delay2 = COD.Takedowns[float].deathtime_laststand
    end
    local ang1 = ent:EyeAngles()
    self:Freeze(true)
    self:SetEyeAngles(Angle(ang1.x,ang1.y,0))
    self:SetPos(ent:GetPos())
    self:SetSVAnimation(anim1)
    local wep = self:GetActiveWeapon()
    if IsValid(wep) then
        self.TakedowningGun = wep:GetClass()
    else
        self.TakedowningGun = ""
    end
    local wep = ent:GetActiveWeapon()
    if IsValid(wep) then
        ent.TakedowningGun = wep:GetClass()
    else
        ent.TakedowningGun = ""
    end
    self.TakedowningTarget = ent
    self.Takedowning = true
    self.TakedownIsFinished = false
    self:SetActiveWeapon(nil)
    local tk
    if isnpc then
        ent.Takedowning = true
        tk = ents.Create("mwii_takedown_npc")
        tk.NPC = ent
        tk.Finisher = self
        tk.Delay = delay2
        tk.Sequence = anim2
        tk:SetPos(ent:GetPos())
        tk:SetAngles(ent:GetAngles())
        tk:Spawn()
    else
        ent:SetActiveWeapon(nil)
        ent.TakedowningTarget = self
        ent.Takedowning = true
        ent.TakedownIsFinished = false
        ent:SetSVAnimation(anim2)
        ent:Freeze(true)
        ent:SetEyeAngles(Angle(ang1.x,ang1.y,0))

        net.Start("COD.TakedownCam")
        net.WriteBool(true)
        net.WriteFloat(delay2)
        net.WriteBool(false)
        net.Send(ent)

        timer.Simple(delay2, function()
            if IsValid(ent) and IsValid(self) and self.Takedowning then
                self.TakedownIsFinished = true
                ent:Freeze(false)
                ent:TakeDamage(ent:Health()+ent:Armor(), self)
                ent.Takedowning = false
                ent.TakedowningTarget = nil
                ent:SetSVAnimation("")
            end
        end)
    end
    net.Start("COD.TakedownCam")
    net.WriteBool(true)
    net.WriteFloat(delay1)
    net.WriteBool(true)
    net.Send(self)

    local bm = ent
    if ent:IsMWIINPC() then
        bm = tk
    end

    if downed then
        COD.Takedowns[float].effect_laststand(self, ent, bm)
    else
        COD.Takedowns[float].effect(self, ent, bm)
    end
    timer.Simple(delay1, function()
        if IsValid(self) and self.Takedowning then
            self:Freeze(false)
            self.Takedowning = false
            self:SetSVAnimation("")
            self:SelectWeapon(self.TakedowningGun)
            if IsValid(ent) and ent:Health() > 0 then
                self:SetPos(zpos)
            end
        end
    end)
end

function enb:NPC_Takedown(ent)
    local isnpc = ent:IsMWIINPC()

    if (isnpc and !takedownedNPCsClassList[ent:GetClass()]) or self:IsDowned() or ent.Takedowning or self.Takedowning or !ent:OnGround() or !self:OnGround() then
        return
    end

    if isnpc and !ent:LookupBone("ValveBiped.Bip01_Spine") then
        return
    end

    local downed = ent:IsDowned()
    local float = "00"
    local rnd = math.random(1,33)
    if rnd >= 10 then
        float = ""..rnd
    else
        float = "0"..rnd
    end

    if not COD.Takedowns[float] then return end
    if !isnumber(float) then
        anim1, anim2 = "execution_"..float.."_attacker_stand", "execution_"..float.."_victim_stand"
        if downed then
            anim1, anim2 = "execution_"..float.."_attacker_laststand", "execution_"..float.."_victim_laststand"
        end
    end

    local zpos = self:GetPos()
    local delay1 = GetLongOfSequence("models/player/breen.mdl", anim1)
    local delay2 = COD.Takedowns[float].deathtime
    if downed then
        delay2 = COD.Takedowns[float].deathtime_laststand
    end

    local ang1 = self:EyeAngles()
    self:Freeze(true)
    ent:SetAngles(Angle(0,ang1.y,0))
    self:SetPos(ent:GetPos())
    local wep = self:GetActiveWeapon()
    if IsValid(wep) then
        wep:SetClip1(0)
    end
    self.TakedowningTarget = ent
    self.Takedowning = true
    self.TakedownIsFinished = false
    local tk = ents.Create("mwii_takedown_npc")
    tk.NPC = self
    tk.AttackerTime = delay2
    tk.KillingEntityMode = true
    tk.ToKill = ent
    tk.Finisher = self
    tk.Delay = delay1
    tk.Sequence = anim1
    tk:SetPos(ent:GetPos())
    tk:SetAngles(ent:GetAngles())
    tk:Spawn()

    local tk2
    if ent:IsPlayer() then
        ent:SetActiveWeapon(nil)
        ent.TakedowningTarget = self
        ent.Takedowning = true
        ent.TakedownIsFinished = false
        ent:SetSVAnimation(anim2)
        ent:Freeze(true)
        ent:SetEyeAngles(Angle(ang1.x,ang1.y,0))
     
        net.Start("COD.TakedownCam")
        net.WriteBool(true)
        net.WriteFloat(delay2)
        net.WriteBool(false)
        net.Send(ent)
    else
        ent.Takedowning = true
        ent:SetAngles(Angle(0,ang1.y,0))
        tk2 = ents.Create("mwii_takedown_npc")
        tk2.NPC = ent
        tk2.Finisher = self
        tk2.Delay = delay2
        tk2.Sequence = anim2
        tk2:SetPos(ent:GetPos())
        tk2:SetAngles(ent:GetAngles())
        tk2:Spawn()
    end

    if !ent:IsPlayer() then
        ent = tk2
    end
    local bm = ent
    if ent:IsMWIINPC() then
        bm = tk2
    end
    if downed then
        COD.Takedowns[float].effect_laststand(tk, ent, bm)
    else
        COD.Takedowns[float].effect(tk, ent, bm)
    end

    timer.Simple(delay1, function()
        if IsValid(self) and self.Takedowning then
            self.Takedowning = false
            if IsValid(ent) and ent:Health() > 0 then
                self:SetPos(zpos)
            end
        end
    end)
end

hook.Add("CreateEntityRagdoll", "MWIITDCreateRagdoll", function(owner, ragdoll)
    local rag = owner:GetNWEntity('MWIIRag')
    if IsValid(rag) then
        MWIITransferBones( rag, ragdoll )
        ragdoll:SetNoDraw(false)
        if owner.HeadBlow then
            ragdoll:ManipulateBoneScale(ragdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
        end
    end
    if owner:IsPlayer() and owner.HeadBlow then
        ragdoll:ManipulateBoneScale(ragdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
    end
end)