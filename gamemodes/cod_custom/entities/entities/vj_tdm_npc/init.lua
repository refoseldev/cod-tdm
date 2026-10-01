AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 250
ENT.UsePlayerModelMovement = true
ENT.Model = {}

ENT.BloodColor = "Red"

ENT.VJ_NPC_Class = {""}

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"vjseq_seq_meleeattack01"}
ENT.AnimTbl_CallForHelp = {}
ENT.MeleeAttackDamage = 50

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.5
ENT.DropWeaponOnDeath = false

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {}
for i = 1, 54 do
	table.insert(ENT.AnimTbl_Death, "dead"..i)
end
ENT.DeathAnimationChance = 1

ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}

ENT.HasItemDropsOnDeath = false

ENT.DeathCorpseFade = false

ENT.CallForBackUpOnDamageAnimation = {}

ENT.SoundTbl_Death = {}
for i = 1, 14 do
	table.insert(ENT.SoundTbl_Death, "tdmg/ply/death"..i..".wav")
end

ENT.SoundTbl_WeaponReload = {}
for i = 1, 15 do
	table.insert(ENT.SoundTbl_WeaponReload, "tdmg/npc/reloading"..i..".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
    if self.Team == 2 then
        self.Model = {"models/tdmg/pm/kortac_1_"..math.random(1,4).."_pm.mdl"}
    else
        self.Model = {"models/tdmg/pm/specgru_milsim_"..math.random(1,4).."_1_pm.mdl"}
    end
end

function ENT:CustomOnInitialize()
    if self.Team == 2 then
        self:Give("weapon_vj_tdm_ak47")
    else
        self:Give("weapon_vj_tdm_m4a1")
    end
	self:SetNWFloat('Team', self.Team)
	if self.Team == 1 then
		self.VJ_NPC_Class = {"CLASS_SPECGRU"}
	else
		self.VJ_NPC_Class = {"CLASS_KORTAC"}
	end
end