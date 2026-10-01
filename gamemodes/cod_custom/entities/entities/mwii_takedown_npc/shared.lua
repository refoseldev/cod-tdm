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

    function ENT:Initialize()
        self:SetModel("models/player/breen.mdl")
        self.Takedowning = true
        self:ResetSequence(self.Sequence)
        self:SetNoDraw(true)
        self:DrawShadow(false)
        local delay = select(2, self:LookupSequence(self.Sequence))
        self:SetCycle( ( ( (delay-0.1)/delay )-1)*-1 )
        if self.AttackerTime then
            self.Attacker = true
        end

        local bd = ents.Create("base_anim")
        bd:SetParent(self)
        bd:AddEffects(1)
        bd:Spawn()
        self.bd = bd
        self:DeleteOnRemove(bd)
        TransferModelData(self.bd, self.NPC)
        self.NPC.HasDeathAnimation = false
        self:SetNWFloat('DTeam', self.NPC.Team)
 
        if self.Attacker then
            timer.Simple(self.AttackerTime, function()
                local ent = self.ToKill
                if IsValid(ent) and IsValid(self) then
                    self.TakedownIsFinished = true
                    ent:Freeze(false)
                    local armor = 0
                    if ent:IsPlayer() then
                        armor = ent:Armor()
                        ent:SetSVAnimation("")
                    else
                        ent.CantUseTakedown = true
                    end
                    ent:TakeDamage(ent:Health()+armor, self.NPC)
                    timer.Simple(0.001, function()
                        if !IsValid(ent) then return end
                        ent.Takedowning = false
                        ent.TakedowningTarget = nil
                    end)
                end
            end)
        end

        self.NPC.CantDamageMWII = true

        timer.Simple(self.Delay, function()
            if !IsValid(self) then return end

            if self.Attacker then
                self:Finish()
            else
                self:Finish(true)
            end
        end)
    end

    function ENT:Finish(kill)
        local ow = self.NPC
        if IsValid(ow) then
            self.NPC = nil
            ow:SetNoDraw(false)
            ow:SetRenderMode(RENDERMODE_NORMAL)
            ow:DrawShadow(true)
            ow:RemoveEFlags(EFL_NO_THINK_FUNCTION)
            ow:ManipulateBonePosition(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Vector(0, 0, 0))
            ow:ManipulateBoneAngles(ow:LookupBone("ValveBiped.Bip01_Pelvis"), Angle(0, 0, 0))
            local wep = ow:GetActiveWeapon()
            if IsValid(wep) then
                wep:SetNoDraw(false)
            end
            if kill then
                if ow.IsDrGNextbot then
                    function ow:OnDeath() 
                        local rag = self:BecomeRagdoll()
                        MWIITransferBones(self.bd, rag)
                    end
                    function ow:LastStand() end
                elseif ow.IsVJBaseSNPC then
                    ow.HasDeathAnimation = false
                end
                self.Finisher.TakedownIsFinished = true
                ow.CantDamageMWII = false
                ow:TakeDamage(ow:Health(), self.Finisher, self.Finisher)
                ow:TakeDamage(999999999, self.Finisher, self.Finisher)
            else
                ow.CantDamageMWII = false
                ow.HasDeathAnimation = true
                ow:SetNWEntity('MWIIRag', NULL)
                ow.Takedowning = false
            end
        end
    end

    function ENT:Think()
        local ow = self.NPC
        if !IsValid(ow) then
            self:Remove()
        else
            ow.Takedowning = true
            ow:SetNoDraw(true)
            ow:SetRenderMode(RENDERMODE_NONE)
            ow:DrawShadow(false)
            ow:AddEFlags(EFL_NO_THINK_FUNCTION)
            ow:SetNWEntity('MWIIRag', self.bd)
            local wep = ow:GetActiveWeapon()
            if IsValid(wep) then
                wep:SetNoDraw(true)
            end

            if !IsValid(self.ToKill) and self.KillingEntityMode and !self.Finisher.TakedownIsFinished then
                self:Finish()
            end

            local att = self.Finisher
            if !IsValid(att) or att:Health() <= 0 or !att.Takedowning then
                self:Finish()
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
