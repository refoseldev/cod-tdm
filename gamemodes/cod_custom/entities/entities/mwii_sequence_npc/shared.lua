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
        self:SetModel("models/player/barney.mdl")
        self:SetNoDraw(true)
        self:DrawShadow(false)
        self.NPC:SetNoDraw(true)
        self:SetNWFloat('DTeam', self.NPC.Team)
        self.NPC.InSeqMWII = true

        if IsValid(self.Target) then
            self.HaveTarget = true
        end

        local anim = ""
        if self.Sequence == "revive" then
            anim = "laststand_startrevive"
            timer.Simple(4, function()
                if IsValid(self) then
                    local tar = self.Target
                    if !IsValid(tar) then return end
                    if tar:IsPlayer() then
                        tar:Revive()
                    else
                        if !IsValid(tar.DownedEnt) then return end
                        tar.DownedEnt:Revive(true)
                    end
                end
            end)
            timer.Simple(5, function()
                if IsValid(self) then
                    self:Stop()
                    local tar = self.Target
                    if !IsValid(tar) then return end
                    tar.TargetReviver = nil
                end
            end)
        end

        self:ResetSequence(anim)

        local bd = ents.Create("base_anim")
        bd:SetParent(self)
        bd:AddEffects(1)
        bd:Spawn()
        self.bd = bd
        TransferModelData(bd, self.NPC)
        self:DeleteOnRemove(bd)
    end

    function ENT:Stop()
        local ow = self.NPC

        if !IsValid(ow) then return end

        self.NPC = nil
        ow:SetNoDraw(false)
        ow:SetRenderMode(RENDERMODE_NORMAL)
        ow:DrawShadow(true)
        ow:RemoveEFlags(EFL_NO_THINK_FUNCTION)
        ow.InSeqMWII = false
        local wep = ow:GetActiveWeapon()
        if IsValid(wep) then
            wep:SetNoDraw(false)
        end
        ow:SetNWEntity('MWIIRag', NULL)
    end

    function ENT:Think()
        local ow = self.NPC

        if !IsValid(ow) or ow:Health() <= 0 or ow.Takedowning or ow.Downed or self.HaveTarget and !IsValid(self.Target) then
            self:Stop()
            self:Remove()
        else
            ow:SetNoDraw(true)
            ow:SetRenderMode(RENDERMODE_NONE)
            ow:DrawShadow(false)
            if ow.IsVJBaseSNPC then
                ow.HasDeathAnimation = false
            end
            ow:AddEFlags(EFL_NO_THINK_FUNCTION)
            ow:SetNWEntity('MWIIRag', self.bd)
            local wep = ow:GetActiveWeapon()
            if IsValid(wep) then
                wep:SetNoDraw(true)
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
