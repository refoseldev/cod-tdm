function COD:ConnectWeapon(ply, model, lang, lpos, scale, attachment, usebonemerge, boneang)
    local wep = ents.Create('base_anim')
    local attach = ply:GetAttachment(ply:LookupAttachment(attachment))
    wep:SetPos(attach.Pos)
    wep:SetModel(model)
    wep:SetAngles(attach.Ang)
    wep:SetParent(ply, ply:LookupAttachment(attachment))
    if usebonemerge then
        wep:AddEffects(EF_BONEMERGE)
    end
    if boneang and ply:LookupBone(boneang) then
        wep:SetAngles(select(2, ply:GetBonePosition(ply:LookupBone(boneang))))
    end
    wep:Spawn()
    wep:SetLocalAngles(lang)
    wep:SetLocalPos(lpos)
    wep:SetModelScale(scale, 0)
    function wep:Think() 
        if !IsValid(ply) or not ply.Takedowning then
            wep:Remove()
        end
    end
    return wep
end

function COD:TakeThisIntoPhys(ent, removetime)
    local wep = ents.Create("prop_physics")
    wep:SetModel(ent:GetModel())
    wep:SetAngles(ent:GetAngles())
    wep:SetPos(ent:GetPos())
    wep:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    wep:Spawn()
    wep:GetPhysicsObject():Wake()

    timer.Simple(removetime, function()
        if !IsValid(wep) then return end
        wep:Remove()
    end)

    ent:Remove()
    return wep, wep:GetPhysicsObject()
end

local knife_model = "models/tdmg/wep/combat_knife.mdl"
local pistol_model = "models/tdmg/wep/m18.mdl"
local ar_model = "models/viper/mw/weapons/w_galima.mdl"
local machete_model = "models/tdmg/wep/w_machete.mdl"
local pkm_model = "models/tdmg/wep/w_mw_pkm.mdl"
local shotgun_model = "models/tdmg/wep/w_rem870_p.mdl"
local sniper_model = "models/tdmg/wep/m82.mdl"
local sledgehammer_model = "models/tdmg/wep/w_sledgehammer.mdl"
local pickaxe_model = "models/tdmg/wep/wpn_h1_melee_pick_axe_wm.mdl"
local katana_model = "models/tdmg/wep/w_katana.mdl"
local new_pickaxe_model = "models/tdmg/wep/new/hatchet.mdl"
local new_katana_model = "models/tdmg/wep/new/katana.mdl"
local new_stick_model = "models/tdmg/wep/new/kalistick.mdl"
local modeltab = {knife_model, pistol_model, ar_model, machete_model, pkm_model, shotgun_model, sniper_model, sledgehammer_model, katana_model, new_stick_model, new_pickaxe_model, new_katana_model}
for _, v in pairs(modeltab) do
    util.PrecacheModel(v)
end

local pl = FindMetaTable("Player")
util.AddNetworkString("COD.TakedownCam")

concommand.Add("cod_givetakedown", function(ply, cmd, args)
	if args[1] then
		local num = tostring(args[1])
		ply:SetNWString('TakedownAnim', num)
	end
end)

hook.Add("PlayerButtonDown", "TakeDownTDM", function(ply, but)
    if ply:Alive() and but == KEY_E then
        ply:Takedown()
    end
end)

hook.Add("CalcMainActivity", "!TDMAnims", function(ply, vel)
    local str = ply:GetNWString('SVAnim')
    local num = ply:GetNWFloat('SVAnimDelay')
    local st = ply:GetNWFloat('SVAnimStartTime')
    if str != "" then
        ply:SetCycle((CurTime()-st)/num)
        return -1, ply:LookupSequence(str)
    end
end)

hook.Add("Think", "TDMGmodTakedown", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply.Takedowning and (not ply:Alive() or !ply.TakedownIsFinished and (!IsValid(ply.TakedowningTarget) or ply.TakedowningTarget:Health() <= 0)) then
            ply.Takedowning = false
            ply:SetSVAnimation("")
            ply:Freeze(false)
            net.Start("COD.TakedownCam")
            net.WriteBool(false)
            net.Send(ply)
            if ply.TakedowningGun then
                ply:SelectWeapon(ply.TakedowningGun)
            end
        elseif ply:IsBot() and ply.Takedowning and IsValid(ply.TakedowningTarget) then
            ply:SetPos(ply.TakedowningTarget:GetPos())
            ply:SetEyeAngles(ply.TakedowningTarget:EyeAngles())
		end
	end
end)

function pl:SetSVAnimation(anim, autostop)
    self:SetNWString('SVAnim', anim)
    self:SetNWFloat('SVAnimDelay', select(2, self:LookupSequence(anim)))
    self:SetNWFloat('SVAnimStartTime', CurTime())
    self:SetCycle(0)
    if autostop then
        local delay = select(2, self:LookupSequence(anim))
        timer.Simple(delay, function()
            if !IsValid(self) then return end

            local anim2 = self:GetNWString('SVAnim')

            if anim == anim2 then
                self:SetSVAnimation("")
            end
        end)
    end
end

function pl:IsAtBack(enemy) --This function was made by OpenAI ChatGPT
    if !IsValid(enemy) then return end
	local enemyForward = enemy:GetForward()
	local enemyToPlayer = self:GetPos() - enemy:GetPos()
	local angle = enemyForward:Angle():Forward():Dot(enemyToPlayer:GetNormalized())
	local degrees = math.deg(math.acos(angle))
	return degrees > 100
end

function pl:Takedown(forceentity)
    local tr = self:GetEyeTrace()
    local ent = tr.Entity
    local dist = tr.StartPos:Distance(tr.HitPos) < 96
    if forceentity then
        dist = true
        ent = forceentity
    end

    if !ent:IsPlayer() or ent:Team() == self:Team() or self:IsDowned() or ent.Takedowning or self.Takedowning or !ent:OnGround() or !self:OnGround() or !self:IsAtBack(ent) or not dist then
        return
    end


    local float = self:GetNWString('TakedownAnim')
    if float == "00" then
        local _, rnd = table.Random(COD.Takedowns)
        float = rnd
    end
    if not COD.Takedowns[float] or float == "00" then return end

    if not COD.Takedowns[float] then return end
    if !isnumber(float) then
        anim1, anim2 = "execution_"..float.."_attacker_stand", "execution_"..float.."_victim_stand"
        if ent:IsDowned() then
            anim1, anim2 = "execution_"..float.."_attacker_laststand", "execution_"..float.."_victim_laststand"
        end
    end

    local delay1 = select(2, self:LookupSequence(anim1))
    local delay2 = COD.Takedowns[float].deathtime
    if ent:IsDowned() then
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
    ent:SetActiveWeapon(nil)
    ent.TakedowningTarget = self
    ent.Takedowning = true
    ent.TakedownIsFinished = false
    ent:SetSVAnimation(anim2)
    ent:Freeze(true)
    ent:SetEyeAngles(Angle(ang1.x,ang1.y,0))

    net.Start("COD.TakedownCam")
    net.WriteBool(true)
    net.WriteFloat(delay1)
    net.WriteBool(true)
    net.Send(self)

    net.Start("COD.TakedownCam")
    net.WriteBool(true)
    net.WriteFloat(delay2)
    net.WriteBool(false)
    net.Send(ent)

    if ent:IsDowned() then
        COD.Takedowns[float].effect_laststand(self, ent)
    else
        COD.Takedowns[float].effect(self, ent)
    end

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

    timer.Simple(delay1, function()
        if IsValid(self) and self.Takedowning then
            self:Freeze(false)
            self:SetEyeAngles(Angle(ang1.x,ang1.y,0))
            self.Takedowning = false
            self:SetSVAnimation("")
            self:SelectWeapon(self.TakedowningGun)
        end
    end)
end