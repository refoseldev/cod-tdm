AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 100
ENT.UsePlayerModelMovement = true
ENT.Model = {}

ENT.BloodColor = "Red"

ENT.VJ_NPC_Class = {"CLASS_SPECGRU"}

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"tdm_melee_weapon"}
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackReps = 3

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5
ENT.DropWeaponOnDeath = false

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {}
for i = 1, 54 do
	table.insert(ENT.AnimTbl_Death, "dead"..i)
end
ENT.DeathAnimationChance = 1

ENT.CanFlinch = 1
ENT.FlinchChance = 2
ENT.AnimTbl_Flinch = {}
for i = 1, 7 do
	table.insert(ENT.AnimTbl_Flinch, "tdm_stun"..i)
end

ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_Death = {}
for i = 1, 14 do
	table.insert(ENT.SoundTbl_Death, ")tdmg/ply/death"..i..".wav")
end

ENT.SoundTbl_CombatIdle = {}
for i = 1, 25 do
	table.insert(ENT.SoundTbl_CombatIdle, ")tdmg/npc/combat ("..i..").wav")
end

ENT.SoundTbl_Suppressing = {}
for i = 1, 7 do
	table.insert(ENT.SoundTbl_Suppressing, ")tdmg/npc/contact ("..i..").wav")
end

ENT.SoundTbl_OnKilledEnemy = {}
for i = 1, 13 do
	table.insert(ENT.SoundTbl_CombatIdle, ")tdmg/npc/kill ("..i..").wav")
end

ENT.SoundTbl_AllyDeath = {}
for i = 1, 17 do
	table.insert(ENT.SoundTbl_CombatIdle, ")tdmg/npc/friendlydown"..i..".wav")
end

ENT.SoundTbl_WeaponReload = {}
for i = 1, 15 do
	table.insert(ENT.SoundTbl_WeaponReload, ")tdmg/npc/reload ("..i..").wav")
end

ENT.HasItemDropsOnDeath = false

ENT.DeathCorpseFade = false

ENT.AnimTbl_Medic_GiveHealth = {"gesture_item_give_original"}
ENT.AnimTbl_CallForHelp = {"gesture_signal_forward_original"}
ENT.CallForBackUpOnDamageAnimation = {"gesture_signal_group_original"}

ENT.FollowPlayer = false

ENT.SightAngle = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if not self.Team then
		self.Team = 1
	end

	self.Type = "Light"

	if math.random(1,6) == 1 then
		self.Type = "Patrol"
	elseif math.random(1,6) == 1 then
		self.Type = "Medic"
	elseif math.random(1,8) == 1 then
		self.Type = "Sniper"
	elseif math.random(1,10) == 1 and COD_Invasion.HeavyUnits then
		self.Type = "Bomber"
	elseif math.random(1,2) == 1 and COD_Invasion.HeavyUnits then
		self.Type = "Heavy"
	end

	if math.random(1,2) == 1 then
		self.WaitForEnemyToComeOut = false
	end

	if self.Type == "Medic" then
		self.Model = {"models/humangrunt/mw2/brazilian_militia_pm.mdl"}
		self.IsMedicSNPC = true
	elseif self.Type == "Bomber" then
		self.Model = {"models/wap/callofduty/mw4/chr/operators/coalition/milsim/fireteam/body_western_fireteam_west_dmr_1_2_pm.mdl"}
	elseif self.Type == "Patrol" then
		self.Model = {"models/humangrunt/mw2/brazilian_militia_pm.mdl"}
	elseif self.Type == "Sniper" then
		self.Model = {"models/humangrunt/mw2/brazilian_militia_pm.mdl"}
	elseif self.Type == "Heavy" then
		self.Model = {"models/wap/callofduty/mw4/chr/operators/coalition/milsim/fireteam/body_western_fireteam_west_ar_1_2_pm.mdl", "models/wap/callofduty/mw4/chr/operators/coalition/milsim/fireteam/body_western_fireteam_west_lmg_1_2_pm.mdl"}
	else
		self.Model = {"models/humangrunt/mw2/tf141_brazil_pm.mdl"}
	end
end

function ENT:CustomOnInitialize()
	if self.Type == "Medic" then
		self:SetBodygroup(6, math.random(0,4))
		self:SetBodygroup(5, math.random(0,12))
		self:SetBodygroup(4, math.random(0,3))
		self:SetBodygroup(3, math.random(0,1))
		self:SetBodygroup(3, math.random(0,1))
		self:SetBodygroup(2, math.random(0,1))
		self:SetBodygroup(1, math.random(0,3))
		self:SetSkin(math.random(0,1))

		self:Give("weapon_vj_tdm_r870")
		self:SetHealth(125)
	elseif self.Type == "Sniper" then
		self:SetBodygroup(6, math.random(0,4))
		self:SetBodygroup(5, math.random(0,12))
		self:SetBodygroup(4, math.random(0,3))
		self:SetBodygroup(3, math.random(0,1))
		self:SetBodygroup(3, math.random(0,1))
		self:SetBodygroup(2, math.random(0,1))
		self:SetBodygroup(1, math.random(0,3))
		self:SetSkin(math.random(0,1))

		self:Give("weapon_vj_tdm_m24")
	elseif self.Type == "Patrol" then
		self:SetBodygroup(6, math.random(0,4))
		self:SetBodygroup(5, math.random(0,12))
		self:SetBodygroup(4, math.random(0,3))
		self:SetBodygroup(3, math.random(0,1))
		self:SetBodygroup(3, math.random(0,1))
		self:SetBodygroup(2, math.random(0,1))
		self:SetBodygroup(1, math.random(0,3))
		self:SetSkin(math.random(0,1))

		self:Give("weapon_vj_tdm_m9")
		self:SetHealth(75)
	elseif self.Type == "Bomber" then
		self:Give("weapon_vj_rpg")
		self:SetHealth(175)
	elseif self.Type == "Heavy" then
		if math.random(1,3) == 1 then
			self:Give("weapon_vj_tdm_m249")
		else
			self:Give("weapon_vj_tdm_m4a1")
		end
		self:SetHealth(200)
	else
		self:SetBodygroup(6, math.random(0,1))
		self:SetBodygroup(5, math.random(0,1))
		self:SetBodygroup(4, math.random(0,2))
		self:SetBodygroup(3, math.random(0,2))
		self:SetBodygroup(2, math.random(0,1))
		self:SetBodygroup(1, math.random(0,4))
		self:SetBodygroup(0, math.random(0,3))
		self:SetSkin(math.random(0,1))
		
		if math.random(1,3) == 1 then
			self:Give("weapon_vj_tdm_m14")
		else
			self:Give("weapon_vj_tdm_ump")
		end
	end

	self:SetNWFloat('Team', self.Team)
	self.SearchCooldown = 0
	self.StuckCooldown = CurTime()+60
end

function ENT:FlashEntity()
	self.Flinching = true
	self:StopAttacks(true)
	self.PlayingAttackAnimation = false
	local animTbl = self.AnimTbl_Flinch
	local anim = VJ_PICK(animTbl)
	local animDur = self.NextMoveAfterFlinchTime == false and self:DecideAnimationLength(anim, false, self.FlinchAnimationDecreaseLengthAmount) or self.NextMoveAfterFlinchTime
	self:VJ_ACT_PLAYACTIVITY(anim, true, animDur, false, 0, {SequenceDuration=animDur, PlayBackRateCalculated=true})
	timer.Create("timer_act_flinching"..self:EntIndex(), animDur, 1, function() self.Flinching = false end)
	self:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
	self.NextFlinchT = CurTime() + self.NextFlinchTime
end

function ENT:CustomOnThink()
	if self.SearchCooldown < CurTime() then
		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 5000)) do
			if ent:IsPlayer() and ent:Team() != self.Team or ent:IsNPC() and ent.Team != self.Team and math.random(1,4) == 1 then
				self:SetLastPosition(ent:GetPos())
				self:VJ_TASK_GOTO_LASTPOS()
				break
			end
		end
		self.SearchCooldown = CurTime()+math.random(15,45)
	end

	if IsValid(self:GetEnemy()) then
		self.SearchCooldown = CurTime()+math.random(15,45)
	end

	local colmins, colmaxs = self:GetCollisionBounds()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos(),
		filter = self,
		mins = colmins,
		maxs = colmaxs,
		mask = MASK_SHOT_HULL
	})
	if not tr.Hit then
		self.StuckCooldown = CurTime()+15
	end

	if self.StuckCooldown < CurTime() then
		self:TakeDamage(self:Health())
	end
end

function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp) 
	return self.Takedowning 
end