--ArachnitCZ is cool and awesome and perfect and epic and he beat me and ViperCZ
AddCSLuaFile()
require("mw_utils")

function clearBaseClass(t)
    t.BaseClass = nil
    
    for i, v in pairs(t) do
        if (istable(v)) then
            clearBaseClass(v)
        end
    end
end

function SWEP:GetStoredAttachment(ind)
    if (istable(ind)) then
        PrintTable(ind)
        error("Something went wrong when loading an attachment! Probably still using old customization method (read above for info).")
    end
    
    if (MW_ATTS[ind] == nil) then
        error("Attachment "..(ind != nil && ind || "none").." is missing!")
    end
    
    return MW_ATTS[ind]
end

function SWEP:GetBreathingSwayAngle()
    local ang = self:GetBreathingAngle()
    ang.p = math.NormalizeAngle(ang.p)
    ang.y = math.NormalizeAngle(ang.y)
    ang.r = math.NormalizeAngle(ang.r)
    
    if (IsValid(self:GetOwner())) then
        ang:Mul(1 + math.min(self:GetOwner():GetVelocity():LengthSqr(), 300 * 300) * 0.0001 * (self.Zoom.MovementMultiplier || 1))
    end
    
    ang:Mul(self.Zoom.BreathingMultiplier || 1)
    
    return ang
end

SWEP.Category = "MG" 
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.PrintName = "Base Weapon"
SWEP.Base = "weapon_base" 
SWEP.BounceWeaponIcon = false
-- SWEP.m_WeaponDeploySpeed = 12 --fastest it can be because Think freezes when weapon is drawing
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.VModel = "models/weapons/v_357.mdl"

SWEP.RenderGroup = RENDERGROUP_OPAQUE
SWEP.RenderMode = RENDERMODE_NORMAL

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 64
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = false
SWEP.BobScale = 0 
SWEP.SwayScale = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.UseHands = false

SWEP.Primary.DefaultClip = 0

SWEP.Secondary.ClipSize = -1 
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = -1
SWEP.CrouchVector = Vector(-1, -1, -1)

--modules: 
-- shared
include("modules/shared/sh_think.lua")
include("modules/shared/sh_button_dispatcher.lua")
include("modules/shared/sh_sprint_behaviour.lua")
include("modules/shared/sh_safety_behavior.lua")
include("modules/shared/sh_bipod_behavior.lua")
include("modules/shared/sh_inspect_behavior.lua")
include("modules/shared/sh_datatables.lua")
include("modules/shared/sh_aim_behaviour.lua")
include("modules/shared/sh_aim_mode_behavior.lua")
include("modules/shared/sh_reload_behaviour.lua")
include("modules/shared/sh_trigger_behavior.lua")
include("modules/shared/sh_melee_behaviour.lua")
include("modules/shared/sh_firemode_behaviour.lua")
include("modules/shared/sh_primaryattack_behaviour.lua")
include("modules/shared/sh_holdtypes.lua")
include("modules/shared/sh_customization.lua")
include("modules/shared/sh_stats.lua")
-- client
include("modules/client/cl_calcview.lua") 
include("modules/client/cl_worldmodel_render.lua")  
include("modules/client/cl_hud.lua") 
include("modules/client/cl_spawnmenu.lua") 
include("modules/client/cl_new_customizemenu.lua")
-- reverb
include("modules/reverb/mw_reverb.lua")
include("modules/reverb/mw_reverbimpl.lua") 

--particles:
game.AddParticles("particles/ac_mw_handguns.pcf")
game.AddParticles("particles/mw_particles.pcf")
game.AddParticles("particles/mw19_attachments.pcf")
game.AddParticles("particles/mgbase_tracer.pcf")
game.AddParticles("particles/generic_explosions_pak.pcf")
game.AddParticles("particles/weapon_fx_mwb.pcf")

PrecacheParticleSystem("mw_ins2_shell_eject")
PrecacheParticleSystem("mw_fas2_shocksmoke")

PrecacheParticleSystem("mw_fas2_muzzleflash_ar")
PrecacheParticleSystem("mw_fas2_muzzleflash_pistol")
PrecacheParticleSystem("mw_fas2_muzzleflash_pistol_deagle")
PrecacheParticleSystem("mw_fas2_muzzleflash_dmr")
PrecacheParticleSystem("mw_fas2_muzzleflash_lmg")
PrecacheParticleSystem("mw_fas2_muzzleflash_shotgun")
PrecacheParticleSystem("mw_fas2_muzzleflash_slug")
PrecacheParticleSystem("mw_ins2_ins_weapon_rpg_frontblast")
PrecacheParticleSystem("mw_fas2_muzzleflash_suppressed")

PrecacheParticleSystem("mw_doi_flamethrower")

PrecacheParticleSystem("AC_muzzle_pistol_suppressed")
PrecacheParticleSystem("ac_muzzle_muzzlebreak")
PrecacheParticleSystem("ac_muzzle_flashhider")
PrecacheParticleSystem("ac_muzzle_compensator")
PrecacheParticleSystem("AC_muzzle_shotgun")
PrecacheParticleSystem("AC_muzzle_rifle")
PrecacheParticleSystem("AC_muzzle_pistol")
PrecacheParticleSystem("AC_muzzle_desert")
PrecacheParticleSystem("AC_muzzle_shotgun_db")
PrecacheParticleSystem("AC_muzzle_pistol_ejection")
PrecacheParticleSystem("AC_muzzle_desert_ejection")
PrecacheParticleSystem("AC_muzzle_pistol_smoke_barrel")
PrecacheParticleSystem("AC_muzzle_minigun_smoke_barrel")

PrecacheParticleSystem("flashlight_mw19")
PrecacheParticleSystem("mw_envdust")
PrecacheParticleSystem("smoke_explosion_he")
PrecacheParticleSystem("Generic_explo_high")
PrecacheParticleSystem("mgbase_tracer")
PrecacheParticleSystem("mgbase_tracer_fast")
PrecacheParticleSystem("mgbase_tracer_slow")
PrecacheParticleSystem("mgbase_tracer_small")

--game.AddParticles("particles/cstm_muzzleflashes.pcf")
--game.AddParticles("particles/realistic_muzzleflashes_1.pcf")
--game.AddParticles("particles/realistic_muzzleflashes_2.pcf")
CreateConVar("mgbase_sv_pvpdamage", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "PvP damage multiplier", 0, 5)
CreateConVar("mgbase_sv_pvedamage", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "PvE damage multiplier", 0, 5)
CreateConVar("mgbase_sv_recoil", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Recoil multiplier", 0, 5)
CreateConVar("mgbase_sv_range", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Range multiplier", 0, 10)
CreateConVar("mgbase_sv_accuracy", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Accuracy multiplier", 0.01, 5)
CreateConVar("mgbase_sv_customization", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Allow gun customization.", 0, 1)
CreateConVar("mgbase_sv_customization_limit", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Attachments limit.", 0)
CreateConVar("mgbase_sv_aimassist", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Attachments limit.", 0, 1)
CreateConVar("mgbase_sv_breathing", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Scope breathing.", 0, 1)
CreateConVar("mgbase_sv_full_penetration", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables a more detailed penetration model.", 0, 1)
CreateConVar("mgbase_sv_firstdraws", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables first draws.", 0, 1)
CreateConVar("mgbase_sv_sprintreloads", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables sprint reloads.", 0, 1)
CreateConVar("mgbase_sv_shootreloads", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables shoot reloads.", 0, 1)
CreateConVar("mgbase_debug_reverb", "0", FCVAR_REPLICATED, "Show reverb.", 0, 1)
CreateConVar("mgbase_debug_range", "0", FCVAR_REPLICATED, "Show range at hit location.", 0, 1)
CreateConVar("mgbase_debug_projectiles", "0", FCVAR_REPLICATED, "Show projectiles info.", 0, 1)
CreateConVar("mgbase_debug_mag", "0", FCVAR_REPLICATED, "Forces mag to 1.", 0, 1)

function SWEP:CanAttackInterruptReload()
    return GetConVar("mgbase_sv_shootreloads"):GetInt() > 0 && self:Clip1() > 0 && !self:HasFlag("MagInserted")
end

function SWEP:MakeEnvironmentDust(radius)
    --simple func for snipers
    radius = radius || 150
    
    if (!IsValid(self:GetOwner()) || !self:GetOwner():IsOnGround()) then
        return
    end
    
    local bInWater = self:GetOwner():WaterLevel() > 0
    
    if (IsFirstTimePredicted()) then
        local data = EffectData()
        data:SetEntity(self:GetOwner())
        data:SetScale(bInWater && radius * 0.15 || radius)
        data:SetOrigin(bInWater && self:GetOwner():EyePos() || self:GetOwner():GetPos())
        
        util.Effect(bInWater && "waterripple" || "ThumperDust", data)
    end
end

function SWEP:PostAttachment(attachment)
    --do stuff on the gun
end

function SWEP:CreateAttachmentEntity(attachmentClass)
    if (CLIENT) then
        return
    end
    
    local att = ents.Create("mg_attachment")
    att:SetOwner(self)
    att:SetIndex(1)
    for slot, atts in pairs(self.Customization) do
        for ind, attachmentCls in pairs(atts) do
            if (attachmentClass == attachmentCls) then
                att:SetSlot(slot)
                att:SetIndex(ind)
                break
            end
        end
    end
    
    att:Spawn()
    att:SetPos(self:GetPos())
    att:SetParent(self)
    
    self:DeleteOnRemove(att)
end

function SWEP:RemoveAttachment(att)
    if (att != nil) then --it could be nil if we are customizing for the first time (just spawned)
        att:OnRemove(self)
        att = nil
    end
end

function SWEP:CreateAttachmentForUse(attachmentClass, custTable)
    custTable = custTable || self.Customization 
    
    if (MW_ATTS[attachmentClass] == nil) then
        return
    end
    
    local slot = nil
    
    for s, atts in pairs(custTable) do
        if (table.HasValue(atts, attachmentClass)) then --kinda slow whatever
            slot = s
            break
        end
    end
    
    if (slot == nil) then 
        return
    end
    
    local oldAtt = self:GetAttachmentInUseForSlot(slot)
    
    if (oldAtt != nil && oldAtt.ClassName == attachmentClass) then
        return
    end 
    
    self:RemoveAttachment(oldAtt)
    
    --reload the attachment for developer
    mw_utils.ReloadAttachment(attachmentClass)
    
    local att = table.Copy(self:GetStoredAttachment(attachmentClass))
    att.Slot = slot
    att.Index = 1
    
    for ind, attClass in pairs(custTable[slot]) do
        if (attClass == att.ClassName) then
            att.Index = ind
        end
    end
    
    self.m_CustomizationInUse[slot] = att
    att:Init(self)
    return att
end

--this is for bullets in mag
function SWEP:AttachmentFunction(funcname)
    for slot, attachment in pairs(self:GetAllAttachmentsInUse()) do
        if (attachment[funcname] && isfunction(attachment[funcname])) then
            attachment[funcname](attachment, self)
        end
    end
end

function SWEP:Initialize()
    if (SERVER) then
        local vm = ents.Create("mg_viewmodel")
        vm:SetParent(self)
        vm:SetOwner(self)
        vm:Spawn()
        vm:SetPos(self:GetPos())
        vm:SetModel(self.VModel)
        self:DeleteOnRemove(vm)
        self:SetViewModel(vm)
    end
    
    self:SetModel(self.WorldModel)
    self.m_bInitialized = true
    self.m_hybridSwitchThreshold = 0.4
    
    self:AddFlag("PlayFirstDraw")
    self:RemoveFlag("Holstering")
    self:SetNextHolsterTime(0)
    self:SetBreathingDelta(1)
    self:AddFlag("Rechambered")
    self:AddFlag("MagInserted")
    self:SetHasRunOutOfBreath(false)
    
    if CLIENT then
        self.Camera = {
            Shake = 0,
            Fov = 0,
            LerpReloadFov = 0,
            LerpReloadBlur = 0,
            LerpCustomization = 0,
            LerpBreathing = Angle(0, 0, 0),
            SprayEffect = 0
        }
        
        self.CantedReloadDisableDelta = 1
        self.m_AimModeDeltaLerp = Vector(0, 0, 0)
        self.m_AimModeDeltaVelocity = Vector(0, 0, 0)
        self.MouseX = ScrW() * 0.5
        self.MouseY = ScrH() * 0.5
        
        self.ViewModelMouseX = ScrW() * 0.5
        self.ViewModelMouseY = ScrH() * 0.5
        self.m_bHasLoadedPreset = false
    end
    
    self.LastReverbState = true
    self.ValuesToRemove = {}
    self.StatBreadcrumbs = {}
    
    self:SetFiremode(1)
    
    if (self.Customization != nil) then
        self.m_CustomizationInUse = {}
        
        --create objects
        for slot, atts in pairs(self.Customization) do
            self:CreateAttachmentForUse(atts[1])
        end
        --there's no need to create entities in this stage
        
        self:BuildCustomizedGun()
    end

    self:SetClip1(self:GetMaxClip1WithChamber())
end 

function SWEP:LoadSpawnPreset()
    if (SERVER || (!IsFirstTimePredicted() && !game.SinglePlayer())) then
        return
    end
    
    if (self.m_bHasLoadedPreset) then
        return
    end
    
    local method = math.Clamp(GetConVar("mgbase_presetspawnmethod"):GetInt(), 0, 3)
    
    if (method > 0) then
        local presets = mw_utils.GetPresetsForSWEP(self:GetClass())
        
        if (#presets > 0) then
            if (method == 1) then --random
                mw_utils.LoadPreset(self, presets[math.random(1, #presets)])
            elseif (method == 2) then --random curated
                local toRemove = {}
                
                for i, preset in pairs(presets) do
                    if (preset._bUserGenerated) then
                        table.insert(toRemove, preset)
                    end
                end
                
                for _, preset in pairs(toRemove) do
                    table.RemoveByValue(presets, preset) 
                end
                
                if (#presets > 0) then
                    mw_utils.LoadPreset(self, presets[math.random(1, #presets)])
                end
            elseif (method == 3) then --random fav
                local toRemove = {}
                
                for i, preset in pairs(presets) do
                    if (!mw_utils.IsAssetFavorite(self:GetClass(), preset.ClassName)) then
                        table.insert(toRemove, preset)
                    end
                end
                
                for _, preset in pairs(toRemove) do
                    table.RemoveByValue(presets, preset) 
                end
                
                if (#presets > 0) then
                    mw_utils.LoadPreset(self, presets[math.random(1, #presets)])
                end
            end
        end
    end
    
    self.m_bHasLoadedPreset = true
end

function SWEP:SecondaryAttack()
end

function SWEP:OnDrop()
    self:AddFlag("PlayFirstDraw")
end

function SWEP:GetCurrentHoldType()
    if (self:HasFlag("BipodDeployed")) then
        return "Bipod"
    end

    return self.HoldType
end

function SWEP:Deploy()
    local seqIndex = "Draw"
    
    if (self:HasFlag("PlayFirstDraw") && self:GetAnimation("Equip") != nil && GetConVar("mgbase_sv_firstdraws"):GetInt() > 0) then
        seqIndex = "Equip"
    end
    
    self:RemoveFlag("Holstering")
    self:AddFlag("Drawing")
    self:PlayViewModelAnimation(seqIndex)
    self:SetNextActionTime(CurTime() + self:GetAnimLength(seqIndex))
    self:SetBurstRounds(0)
    
    if (self:GetFlashlightAttachment() != nil) then
        local bFlashlightOn = self:GetOwner():FlashlightIsOn()

        if (SERVER) then
            self:GetOwner():Flashlight(false)
        end

        if (bFlashlightOn) then
            self:AddFlag("FlashlightOn") 
        else
            self:RemoveFlag("FlashlightOn")
        end
    end
    
    self:SetToggleAim(false)
    
    self:PlayerGesture(GESTURE_SLOT_CUSTOM, self.HoldTypes[self:GetCurrentHoldType()].Draw)
    
    self:SetBreathingDelta(1)
    self:SetHasRunOutOfBreath(false)
    self:RemoveFlag("Lowered")
    self:SetNextInspectTime(0)
    
    if SERVER then self:GetOwner():SetSaveValue("m_flNextAttack", 0) end
    
    --meme marine
    self:SetShouldHoldType(true)
    
    return true
end

function SWEP:Holster(weapon)
    if (!self:HasFlag("Holstering")) then
        self:PlayViewModelAnimation("Holster")
        self:AddFlag("Holstering")
        self:RemoveFlag("Reloading")
        self:SetBurstRounds(0)
        self:SetNextHolsterTime(CurTime() + self:GetAnimLength("Holster"))
        self:RemoveFlag("Lowered")
        self:SetNextInspectTime(0)
    end
    
    self:SetNextWeapon(weapon)
    self:StopCustomizing()
    
    self:SetToggleAim(false)
    
    if (IsValid(self:GetOwner()) && self:GetOwner():GetMoveType() == MOVETYPE_LADDER) then --ttt calls holster when dropping (but no owner)
        return false
    end
    
    return CurTime() >= self:GetNextHolsterTime() || self:HasFlag("Drawing") || !IsValid(weapon)
end

function SWEP:PreAttachments()
    --do stuff
end

function SWEP:OnRestore()
    self.m_LastRestored = CurTime()
    self:SetNextReloadTime(0)
    self:SetNextPrimaryFire(0)
    self:SetNextSprintTime(0)
    self:SetNextMagTime(0)
    self:SetAimDelta(0)
    self:SetAimModeDelta(0)
    self:SetNextInspectTime(0)
    self:SetNextFiremodeTime(0)
    self:SetNextMeleeTime(0)
    self:SetTriggerDelta(0)
    self:AddFlag("MagInserted")
    self:RemoveFlag("PlayFirstDraw")
    self:RemoveFlag("Reloading")
    self:RemoveFlag("Holstering")
    self:RemoveFlag("Aiming")
    self:RemoveFlag("Sprinting")
    self:RemoveFlag("HoldingTrigger")
    self:RemoveFlag("Customizing")
    self:SetToggleAim(false)
    self:RemoveFlag("Lowered")
    self:SetNextInspectTime(0)
    self:SetNextWeapon(NULL)
    self:SetSprayRounds(0)
    self:SetBurstRounds(0)
    self:SetPenetrationCount(0)
    self:SetNextActionTime(0)
end

local function removeChildren(ent)
    for _, c in pairs(ent:GetChildren()) do
        removeChildren(c)
    end
    
    ent:Remove()
end

function SWEP:OnRemove()
    if (CLIENT) then
        for _, att in pairs(self:GetAllAttachmentsInUse()) do
            if (att.OnRemove) then
                att:OnRemove(self)
            end
        end
    end
    
    for _, c in pairs(self:GetChildren()) do
        removeChildren(c)
    end
end

function SWEP:PlayViewModelAnimation(seqIndex)
    if (!IsFirstTimePredicted() && !game.SinglePlayer()) then
        return
    end
    
    self:GetViewModel():PlayAnimation(seqIndex)
end

function SWEP:GetAnimLength(seqIndex, length)
    local seq = self:GetAnimation(seqIndex)
    
    if (seq == nil) then
        error(seqIndex.." does not exist on the weapon's animation list!")
    end
    
    length = length || seq.Length
    
    local pb = seq.Fps / 30
    return length / pb
end

function SWEP:GetAnimation(seqIndex)
    for index, seq in pairs(self.Animations) do
        if (string.lower(index) == string.lower(seqIndex)) then
            return seq
        end
    end
    return nil
end

function SWEP:PlayerGesture(slot, anim)
    if (CLIENT && IsFirstTimePredicted()) then 
        self:GetOwner():AnimRestartGesture(slot, anim, true)
    end
    
    if SERVER then
        net.Start("mgbase_tpanim", true)
        net.WriteUInt(slot, 2)
        net.WriteInt(anim, 12)
        net.WriteEntity(self:GetOwner())
        if (game.SinglePlayer()) then
            net.Send(self:GetOwner())
        else
            net.SendOmit(self:GetOwner())
        end
    end
end

function SWEP:OnReloaded()
    if (self.Customization != nil) then
        self:BuildCustomizedGun()
    else
        if (self.Firemodes != nil) then
            self:ApplyFiremode(self:GetFiremode())
        end
    end
    
    --self:SetAimMode(1)
end



function SWEP:DeepObjectCopy(defaults, tbl)
    --self:SetHoldType("duel") --setting something people wont normally use
    
    --defaults = weapons.get(class)
    --tbl = {}
    for i, v in pairs(defaults) do
        if (!istable(v) && !isvector(v) && !isangle(v)) then
            tbl[i] = v
        elseif (isvector(v)) then
            --if (tbl[i] == nil) then
            tbl[i] = Vector(0, 0, 0)
            --end
            
            tbl[i]:Set(v)
        elseif (isangle(v)) then
            -- if (tbl[i] == nil) then
            tbl[i] = Angle(0, 0, 0)
            --end
            
            tbl[i].p = v.p
            tbl[i].y = v.y
            tbl[i].r = v.r
        else
            if (tbl[i] == nil) then
                tbl[i] = {}
            end
            
            self:DeepObjectCopy(v, tbl[i])
        end
    end
end 

--meme marine
local LastHoldType = nil

function SWEP:SetShouldHoldType(force)
    if (!IsValid(self:GetOwner())) then
        return
    end
    
    local ht = "Idle"
    if (self:HasFlag("Aiming")) then
        ht = "Aim"
    elseif (self:HasFlag("Sprinting") || self:HasFlag("Holstering") || self:HasFlag("Lowered")) then
        ht = "Down"
    end
    
    local fullht = "fist"
    
    local crouching = self:GetOwner():IsFlagSet(4)
    -- self:SetHoldType(crouching && self.HoldTypes[self:GetCurrentHoldType()][ht].Crouching || self.HoldTypes[self:GetCurrentHoldType()][ht].Standing)
    
    if crouching then
        fullht = self.HoldTypes[self:GetCurrentHoldType()][ht].Crouching
    else
        fullht = self.HoldTypes[self:GetCurrentHoldType()][ht].Standing
    end
    
    if LastHoldType != fullht || force then
        self:SetHoldType(fullht)
    end
    
    LastHoldType = fullht
end


--ttt support

SWEP.IsSuppresed = false
SWEP.IsEquipment = false

function SWEP:DampenDrop()
    -- For some reason gmod drops guns on death at a speed of 400 units, which
    -- catapults them away from the body. Here we want people to actually be able
    -- to find a given corpse's weapon, so we override the velocity here and call
    -- this when dropping guns on death.
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocityInstantaneous(Vector(0,0,-75) + phys:GetVelocity() * 0.001)
        phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
    end
end

function SWEP:IsEquipment()
    return self.IsEquipment
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
    return self.Bullet.HeadshotMultiplier || 2
end

hook.Add("PlayerButtonDown", "MW19_PlayerButtonDown", function(p, button)
    local w = p:GetActiveWeapon()
    if (IsValid(w) && w.HandleButton != nil) then
        w:HandleButton(button)
    end
end)