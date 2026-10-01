AddCSLuaFile("shared.lua")
include("shared.lua")

local function TransferBones(base, ragdoll)
	if !IsValid(base) or !IsValid(ragdoll) then return end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

function ENT:ToRagdoll()
    if IsValid(self) then
        local rag = ents.Create("prop_ragdoll")
        rag:SetModel(self:GetModel())
        rag:SetPos(self:GetPos())
        rag:Spawn()
        rag:SetCollisionGroup(1)
        for i=1,math.random(2,8) do
            timer.Simple(i/math.Rand(2,4), function()
                if IsValid(rag) then
                    util.Decal("Blood", rag:GetPos()+Vector(0,0,8), rag:GetPos()-Vector(math.random(-32,32), math.random(-32,32), 16))
                end
            end)
        end
        timer.Simple(42, function()
            if IsValid(rag) then
                rag:SetRenderFX(kRenderFxFadeSlow)
            end
        end)
        timer.Simple(45, function()
            if IsValid(rag) then
                rag:Remove()
            end
        end)
        if IsValid(self.Transform) then
            TransferBones(self.Transform, rag)
            if self.Transform.HeadBlow == true then
                self.Transform.HeadBlow = false
                rag:ManipulateBoneScale(rag:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
                for i=1,4 do
                    local pos = rag:GetBonePosition(rag:LookupBone("ValveBiped.Bip01_Head1"))
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
        else
            TransferBones(self, rag)
        end
        self:Remove()
    end
end

function ENT:Initialize()
    if !IsValid(self.Transform) then
        local anim = "dead"..math.random(1,54)

        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            net.Start("tdm.giveanim")
            net.WriteEntity(self)
            net.WriteString(anim)
            net.Broadcast()
        end)

        self:ResetSequence(anim)
        self:EmitSound("tdmg/ply/death"..math.random(1,14)..".wav")

        local mod = select(2, self:LookupSequence(anim))
        timer.Simple(mod, function()
            if !IsValid(self) then return end
            self:ToRagdoll()
        end)
    else
        self:ToRagdoll()
    end
end

function ENT:Think()
    local tr1 = util.TraceLine({
        start = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Head1')),
        endpos = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Head1'))-self:GetForward()*4,
        filter = function( ent ) return ( ent:GetClass() == "prop_static" or ent:GetClass() == "prop_dynamic" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating"  ) end
    })
    local tr2 = util.TraceLine({
        start = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Pelvis')),
        endpos = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Pelvis'))-self:GetForward()*4,
        filter = function( ent ) return ( ent:GetClass() == "prop_static" or ent:GetClass() == "prop_dynamic" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating"  ) end
    })
    local tr3 = util.TraceLine({
        start = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Head1')),
        endpos = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Head1'))+self:GetForward()*4,
        filter = function( ent ) return ( ent:GetClass() == "prop_static" or ent:GetClass() == "prop_dynamic" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating"  ) end
    })
    local tr4 = util.TraceLine({
        start = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Pelvis')),
        endpos = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_Pelvis'))+self:GetForward()*4,
        filter = function( ent ) return ( ent:GetClass() == "prop_static" or ent:GetClass() == "prop_dynamic" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating"  ) end
    })

    if tr1.Hit or tr2.Hit or tr3.Hit or tr4.Hit then
        self:ToRagdoll()
    end

    self:NextThink(CurTime())
    return true
end