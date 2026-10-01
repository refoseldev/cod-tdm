AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 300
ENT.Model = {"models/tdmg/dog_enemy.mdl"}

ENT.BloodColor = "Red"

ENT.VJ_NPC_Class = {""}

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"attack"}
ENT.MeleeAttackDamage = 150

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {"death"}
ENT.DeathAnimationChance = 1
ENT.SoundTbl_Death = {""}
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 2 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"run_pain"} -- If it uses normal based animation, use this
for i=1,8 do
	table.insert(ENT.SoundTbl_Death, "tdmg/dog/pain ("..math.random(1,8)..").wav")
end

ENT.HasItemDropsOnDeath = false
ENT.MeleeAttackDistance = 96
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNWFloat('Team', self.Team)
	self.BarkDelay = CurTime()+1
	if self.Team == 1 then
		self.VJ_NPC_Class = {"CLASS_SPECGRU"}
	else
		self.VJ_NPC_Class = {"CLASS_KORTAC"}
	end
end

function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup) 
	if dmginfo:GetDamage() >= self:Health() then
		self.BarkDelay = CurTime()+5
	end
end

function ENT:FindTargets()
	local enemy = self:GetEnemy()
	if IsValid(enemy) and self.BarkDelay < CurTime() then
		self.BarkDelay = CurTime()+math.Rand(0.4,1.2)
		self:EmitSound("tdmg/dog/bark ("..math.random(1,8)..").wav")
	end
end

function ENT:CustomOnThink()
	self:FindTargets()
end