local pl = FindMetaTable("Player")

util.AddNetworkString("COD.HitMarkEnemy")
util.AddNetworkString("COD.HitMarkEnemy2")
util.AddNetworkString("COD.ScoreMarkEnemy")
util.AddNetworkString("COD.KillstreaksHUD")
util.AddNetworkString("COD.EndingHUD")
util.AddNetworkString("COD.StartMatchHUD")
util.AddNetworkString("COD.PickupCarePackage")
util.AddNetworkString("COD.KillNick")
util.AddNetworkString("COD.KillstreakChoose")
util.AddNetworkString("COD.PerksShow")
util.AddNetworkString("COD.PerksChoose")
util.AddNetworkString("COD.Killfeed")
util.AddNetworkString("COD.Cutscene")
util.AddNetworkString("COD.SendData")
util.AddNetworkString("COD.TimerShow")
util.AddNetworkString("COD.OtherKillstreak")
util.AddNetworkString("COD.ShowAnnouncment")
util.AddNetworkString("COD.SendAdminStatus")
util.AddNetworkString("COD.GameStartedStatus")
util.AddNetworkString("COD.RequestGameStatus")

COD.TimeBeforeEnd = 0
COD.TimeBefore1PerkUnlock = 0
COD.Perk1Unlocked = false
COD.TimeBefore2PerkUnlock = 0
COD.Perk2Unlocked = false
COD.Ending = false
COD.GameStarted = false
COD.EnabledDynamicSpawnPoints = false
COD.DisableSpawn = false
COD.TimeBeforeStart = 0
COD.DisableEndGameByNoTeam = false

local KillstreakTeamEntities = {
	["tdm_ah64"] = true,
	["tdm_mi24"] = true,
	["tdm_sentry"] = true,
	["tdm_harrier"] = true,
	["tdm_drone"] = true,
}

net.Receive("COD.KillstreakChoose", function(len, ply)
	local tab = net.ReadTable()
	local mw = net.ReadString()
	local sw = net.ReadString()
	ply.KillstreakFuture = tab
	ply.WeaponData = {mw, sw}
end)

net.Receive("COD.PerksChoose", function(len, ply)
	local p1 = net.ReadFloat()
	local p2 = net.ReadFloat()
	ply.Perk1Choosed = p1
	ply.Perk2Choosed = p2
end)

hook.Add("CanPlayerSuicide", "AllowOwnerSuicide", function( ply )
	return false
end)

function COD:AddFragsToData(team, count)
	if team == 1 then
		COD.DataTable["Team1_Kills"] = COD.DataTable["Team1_Kills"]+count
	elseif team == 2 then
		COD.DataTable["Team2_Kills"] = COD.DataTable["Team2_Kills"]+count
	end
	BroadcastLua([[
		COD.DataTable["Team2_Kills"] = ]]..COD.DataTable["Team2_Kills"]..[[
		COD.DataTable["Team1_Kills"] = ]]..COD.DataTable["Team1_Kills"]..[[
	]])
end

function COD:GetInfoData(ply)
	local tab = COD.DataTable

	if ply != "all" and IsValid(ply) then
		net.Start("COD.SendData")
		net.WriteTable(tab)
		net.Send(ply)
	end

	if ply == "all" then
		net.Start("COD.SendData")
		net.WriteTable(tab)
		net.Broadcast()
	end
end

function COD:ShowAnnouncment(type)
	net.Start("COD.ShowAnnouncment")
	net.WriteFloat(type)
	net.Broadcast()
end

function COD:ShowEndScreen()
	local t1, t2 = COD.DataTable["Team1_Kills"], COD.DataTable["Team2_Kills"]
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == 1 and t1 > t2 then
			net.Start("COD.EndingHUD")
			net.WriteBool(true)
			net.Send(ply)
		elseif ply:Team() == 2 and t2 > t1 then
			net.Start("COD.EndingHUD")
			net.WriteBool(true)
			net.Send(ply)
		else
			net.Start("COD.EndingHUD")
			net.WriteBool(false)
			net.Send(ply)
		end
	end
end

function COD:CountTeamPlayers(team)
	local tab = {}
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == team then
			table.insert(tab, ply)
		end
	end
	return #tab
end

function COD:SpawnPlayerAtSafePosition(ply)
	if !IsValid(ply) then return end

	local enemy_players = player.GetAll()
	if ply:Team() == 1 then
		enemy_players = team.GetPlayers(2) 
	elseif ply:Team() == 2 then
		enemy_players = team.GetPlayers(1)
	end

	local positions = {}
	for _, pos in ipairs(COD.DataTable["simple_Spawns"]) do
		local can = true
		local gdist = 0
		for _, en in ipairs(enemy_players) do
			local dist = en:GetPos():DistToSqr(pos)
			if en:IsLineOfSightClear(pos) or dist < 50000 then
				can = false
			end
			if dist > gdist then
				gdist = dist
			end
		end
		if can then
			table.insert(positions, {vec = pos, dist = gdist})
		end
	end
	if #positions > 0 then
		local position, dist = Vector(), 0
		for _, p in ipairs(positions) do
			if p.dist > dist then
				dist = p.dist
				position = p.vec
			end
		end
		ply:SetPos(position)
	else
		ply:SetPos(table.Random(COD.DataTable["simple_Spawns"]))
	end
end

function COD:KillstreakAddOther(ply, removing, number)
	local tab = ply.KillstreakOthers
	if removing then
		if number == -1 then
			ply.KillstreakOthers = {}
			tab = {}
		else
			table.remove(tab, #tab)
		end
	else
		table.insert(tab, number)
	end
	net.Start("COD.OtherKillstreak")
	net.WriteTable(tab)
	net.Send(ply)
end

hook.Add("Think", "TDMGmodStartMatch", function()
	local count = player.GetCount()
	if count > 1 then
		if not COD.GameStarted then
			if COD.TimeBeforeStart < CurTime() then
				COD:ChangeState(true)
			end
		else
			if (#team.GetPlayers(1) == 0 or #team.GetPlayers(2) == 0) and not COD.DisableEndGameByNoTeam then
				COD:ChangeState(false)
				COD.TimeBeforeStart = CurTime()+COD.DataTable["Delay_Before_Start"]
			end
			if ( COD.TimeBeforeEnd-CurTime() <= 0 or COD.DataTable["Team1_Kills"] >= COD.DataTable["MaxKills"] or COD.DataTable["Team2_Kills"] >= COD.DataTable["MaxKills"] ) and not COD.Ending then
				COD.Ending = true
				COD:ShowEndScreen()
				if COD.LastKillData.length > 0 then
					COD:ShowLastKillCam(6)
					COD.LastKillData = {
						length = 0,
						data = ""
					}
				end
				timer.Simple(12, function()
					COD:ChangeState(false)
				end)
			end
			if COD.Ending then
				COD:RemoveAllPlayers()
			end
			if COD.TimeBefore1PerkUnlock < CurTime() and not COD.Perk1Unlocked then
				COD.Perk1Unlocked = true
				for _, ply in ipairs(player.GetAll()) do
					ply:UnlockPerks(1)
				end
			end
			if COD.TimeBefore2PerkUnlock < CurTime() and not COD.Perk2Unlocked then
				COD.Perk2Unlocked = true
				for _, ply in ipairs(player.GetAll()) do
					ply:UnlockPerks(2)
				end
			end
		end
		for _, ply in ipairs(player.GetAll()) do
			if ply:Health() >= 100 or not ply:Alive() then
				ply.HealCooldown = CurTime() + 8
				if ply:GetNWFloat('Perk2') == 1 then
					ply.HealCooldown = CurTime() + 3
				end
			else
				if ply.HealCooldown < CurTime() and not ply:IsDowned() then
					ply:SetHealth(math.Clamp(ply:Health()+1, 1, 100))
				end
			end
			if ply:GetNWFloat('Perk1') == 4 then
				if ply.CooldownPerkEquip < CurTime() then
					ply.CooldownPerkEquip = CurTime()+30
					local wep = ply:GetActiveWeapon()
					if IsValid(wep) then
						local at = wep:GetPrimaryAmmoType()
						local clip = wep:GetMaxClip1()
						ply:GiveAmmo(clip, at, true)
					end
				end
			end
		end
	else
		COD.TimeBeforeStart = CurTime()+COD.DataTable["Delay_Before_Start"]
		if COD.GameStarted then
			COD:ChangeState(false)
		end
	end
end)

function COD:ChangeState(bool)
	game.CleanUpMap()
	COD.DataTable["Team1_Kills"] = 0
	COD.DataTable["Team2_Kills"] = 0
	if bool then
		COD.DataTable["MaxKills"] = COD.GamemodeSettings[COD.DataTable["Gamemode"]]["MaxKills"]
		COD.EnabledDynamicSpawnPoints = false
		COD.TimeBeforeEnd = CurTime()+COD.GamemodeSettings[COD.DataTable["Gamemode"]]["MaxTime"]+COD.DataTable["Delay_Before_Start"]
		COD.TimeBefore1PerkUnlock = CurTime()+90
		COD.TimeBefore2PerkUnlock = CurTime()+180
		COD.Perk1Unlocked = false
		COD.Perk2Unlocked = false
		COD.GameStarted = true
		COD.Ending = false
		net.Start("COD.GameStartedStatus")
		net.WriteBool(true)
		net.Broadcast()
		COD.LastKillData = {
			length = 0,
			data = ""
		}
		BroadcastLua([[
			COD.DataTable["Team2_Kills"] = ]]..COD.DataTable["Team2_Kills"]..[[
			COD.DataTable["Team1_Kills"] = ]]..COD.DataTable["Team1_Kills"]..[[
			COD.DataTable["MaxKills"] = ]]..COD.DataTable["MaxKills"]..[[
			COD.TimeMatch = ]]..COD.TimeBeforeEnd..[[
		]])
		for _, ply in ipairs(player.GetAll()) do
			ply:ResetParametrsCOD()
		end
		COD:AutoTeamMix()
		net.Start("COD.StartMatchHUD")
		net.Broadcast()
		COD.EnabledDynamicSpawnPoints = true
		COD.DisableEndGameByNoTeam = false
	else
		COD.TimeBefore1PerkUnlock = math.huge
		COD.TimeBefore2PerkUnlock = math.huge
		COD.TimeBeforeEnd = 0
		COD.GameStarted = false
		COD.Ending = false
		net.Start("COD.GameStartedStatus")
		net.WriteBool(false)
		net.Broadcast()
		COD.EnabledDynamicSpawnPoints = false
		if COD.DataTable["Enable_RandomGamemode"] then
			COD.DataTable["Gamemode"] = math.random(1,5)
			COD:GetInfoData("all")
		end
		COD:RemoveAllPlayers()
		BroadcastLua([[
			COD.DataTable["Team2_Kills"] = 0
			COD.DataTable["Team1_Kills"] = 0
			COD.TimeMatch = 0
		]])
	end
	hook.Run("COD.ChangeState", bool)
end

function COD:RemoveAllPlayers()
	local players = player.GetAll()
	for k, ply in ipairs(players) do
		if ply:Alive() then
			ply:KillSilent()
		end
	end
end

function COD:AutoTeamMix()
	local players = player.GetAll()
	table.Shuffle(players)
	local plcount = math.floor(player.GetCount()/2)
	local teambool = tobool(math.random(0,1))
	for k, ply in ipairs(players) do
		if plcount > 0 then
			plcount = plcount - 1
			if teambool then
				ply:SetTeam(1)
			else
				ply:SetTeam(2)
			end
		else
			if teambool then
				ply:SetTeam(2)
			else
				ply:SetTeam(1)
			end
		end
		ply:KillSilent()
		ply:Spawn()
	end
end

function pl:ChangeScore(float, reset)
	self:SetNWFloat('Score', self:GetNWFloat('Score')+float)
	if reset then
		self:SetNWFloat('Score', 0)
	end
end

function pl:ResetParametrsCOD()
	self:ChangeScore(0, true)	
	self:SetFrags(0)
	self:SetDeaths(0)
	self:SetNWFloat('KillsP', 0)
	self:SetNWString('KillStreak_Other', '')
	self:SetNWBool('KillStreak1_Used', false)
	self:SetNWBool('KillStreak2_Used', false)
	self:SetNWBool('KillStreak3_Used', false)
	self:SetNWBool('KillStreak1_Gave', false)
	self:SetNWBool('KillStreak2_Gave', false)
	self:SetNWBool('KillStreak3_Gave', false)
	COD:KillstreakAddOther(self, true, -1)
	self:UnlockPerks(0)
	local tab = self.KillstreakFuture
	if tab then
		self:SetNWFloat('KillStreak1', tab[1])
		self:SetNWFloat('KillStreak2', tab[2])
		self:SetNWFloat('KillStreak3', tab[3])
	else
		self:SelectKillstreaksRandom()
	end
end

function pl:ThrowFrag()
	if self.Knifing or self:GetNWFloat('FragGrenades') <= 0 then return end

	local wep = self:Give('tdm_grenade')
	local aw = self:GetActiveWeapon()
	if IsValid(aw) then
		self.FastKnifeBeforeWep = aw:GetClass()
	else
		self.FastKnifeBeforeWep = ""
	end

	self:SetNWFloat('FragGrenades', self:GetNWFloat('FragGrenades')-1)

	self.Knifing = true
	self:SetActiveWeapon(nil)
	self:SelectWeapon(wep)
	wep:Throw()

	timer.Simple(1, function()
		if !IsValid(self) then return end
		self.Knifing = false
	end)
end

function pl:ThrowFlash()
	if self.Knifing or self:GetNWFloat('FlashGrenades') <= 0 then return end

	local wep = self:Give('tdm_grenade')
	wep.IsFlash = true
	local aw = self:GetActiveWeapon()
	if IsValid(aw) then
		self.FastKnifeBeforeWep = aw:GetClass()
	else
		self.FastKnifeBeforeWep = ""
	end

	self:SetNWFloat('FlashGrenades', self:GetNWFloat('FlashGrenades')-1)

	self.Knifing = true
	self:SetActiveWeapon(nil)
	self:SelectWeapon(wep)
	wep:Throw()

	timer.Simple(1, function()
		if !IsValid(self) then return end
		self.Knifing = false
	end)
end

function pl:FastKnife()
	if self.Knifing then return end

	local wep = self:Give('tdm_knife')
	local aw = self:GetActiveWeapon()
	if IsValid(aw) then
		self.FastKnifeBeforeWep = aw:GetClass()
	else
		self.FastKnifeBeforeWep = ""
	end

	self.Knifing = true
	self:SetActiveWeapon(nil)
	self:SelectWeapon(wep)
	wep:Knifing()

	timer.Simple(0.5, function()
		if !IsValid(self) then return end
		self.Knifing = false
	end)
end

function pl:SetPrimaryWep(class)
	if not class or class == "" then
		local tab = {}

		table.Merge(tab, COD.Loadout["SMGs"])
		table.Merge(tab, COD.Loadout["LMGs"])
		table.Merge(tab, COD.Loadout["Assault Rifles"])
		table.Merge(tab, COD.Loadout["Sniper Rifles"])
		table.Merge(tab, COD.Loadout["Marksman Rifles"])
		table.Merge(tab, COD.Loadout["Shotguns"])

		local tab2 = {}
		for k, v in pairs(tab) do
			table.insert(tab2, v.class)
		end

		class = tab2[math.random(1,#tab2)]
	end
	local wep = self:Give(class)
	self:SetNWString('MainWep', class)
	if IsValid(wep) then
		self:GiveAmmo(wep:GetMaxClip1()*6, wep:GetPrimaryAmmoType(), true)
	end 
end

function pl:SetSecondaryWep(class)
	if not class or class == "" then
		local tab = {}
		table.Merge(tab, COD.Loadout["Pistols"])
		table.Merge(tab, COD.Loadout["Others"])

		local tab2 = {}
		for k, v in pairs(tab) do
			table.insert(tab2, v.class)
		end

		class = tab2[math.random(1,#tab2)]
	end
	local wep = self:Give(class)
	self:SetNWString('SecWep', class)
	if IsValid(wep) then
		self:GiveAmmo(wep:GetMaxClip1()*3, wep:GetPrimaryAmmoType(), true)
	end 
end

function pl:UnlockPerks(type)
	if type == 1 then	
		self:SetNWFloat('Perk1', self:GetNWFloat('Perk1_Choose'))
		if self:GetNWFloat('Perk1_Choose') == 3 and self:Alive() then
			self:SetNWFloat('KillsP', self:GetNWFloat('KillsP')+1)
			self:CheckKillstreaks()
		end
	elseif type == 2 then
		self:SetNWFloat('Perk2', self:GetNWFloat('Perk2_Choose'))
	else
		self:SetNWFloat('Perk1', 0)
		self:SetNWFloat('Perk2', 0)
	end
	net.Start("COD.PerksShow")
	net.WriteFloat(type)
	net.Send(self)
end

hook.Add("PlayerButtonDown", "TDMGUseAbilities", function(ply, but)
	if ply:Alive() and not ply:IsTyping() and not ply.ControllingKillstreak then
		if but == KEY_7 then
			ply:UseKillstreak(1)
		elseif but == KEY_8 then
			ply:UseKillstreak(2)
		elseif but == KEY_9 then
			ply:UseKillstreak(3)
		elseif but == KEY_0 then
			ply:UseKillstreak(4)
		elseif but == KEY_V then
			ply:FastKnife()
		elseif but == KEY_G then
			ply:ThrowFrag()
		elseif but == KEY_Q then
			ply:ThrowFlash()
		end
	end
	if but == KEY_F1 then
		ply:ConCommand("open_choose_menu")
	end
end)

hook.Add("PlayerInitialSpawn", "TDMPlayer", function(ply)
	ply:SetNWString('TakedownAnim', '02')
	ply:SetNWFloat('Perk1', 0)
	ply:SetNWFloat('Perk2', 0)
	ply:SetNWFloat('Perk1_Choose', 1)
	ply:SetNWFloat('Perk2_Choose', 1)
	COD:GetInfoData(ply)
	ply.KillstreakOthers = {}
	ply.Perk1Choosed = 1
	ply.Perk2Choosed = 1
	
	timer.Simple(1, function()
		if not IsValid(ply) then return end
		net.Start("COD.SendAdminStatus")
		net.WriteBool(ply:IsAdmin())
		net.Send(ply)
		
		net.Start("COD.GameStartedStatus")
		net.WriteBool(COD.GameStarted)
		net.Send(ply)
	end)

	net.Receive("COD.RequestGameStatus", function(_, ply)
		net.Start("COD.GameStartedStatus")
		net.WriteBool(COD.GameStarted)
		net.Send(ply)
	end)
	if COD.GameStarted then
		timer.Simple(1, function()
			if !IsValid(ply) then return end
			if COD.DataTable["Gamemode"] != 4 then
				local t1c = COD:CountTeamPlayers(1)
				local t2c = COD:CountTeamPlayers(2)
				if t1c == t2c then
					ply:SetTeam(math.random(1,2))
				elseif t1c > t2c then
					ply:SetTeam(2)
				elseif t1c < t2c then
					ply:SetTeam(1)
				end
			else
				ply:SetTeam(1)
			end
			ply:ResetParametrsCOD()
			ply:Spawn()
		end)
	end
end)

hook.Add("SetupPlayerVisibility", "AddPlayersOnCameraTDM", function()
	for _, plys in ipairs(player.GetAll()) do
		AddOriginToPVS(plys:GetPos())
	end
end)

hook.Add("PlayerDeathThink", "TDMPlayer", function(ply)
	if not COD.GameStarted or COD.Ending or COD.DisableSpawn then
		ply:Spectate(6)
	end
	if COD.GameStarted then
		if ply:Team() != 1 and ply:Team() != 2 then
			ply:Spectate(6)
		end
		if ply.DeathTime > CurTime() or ply.ControllingKillstreak then
			return false
		end
	end
end)

hook.Add("PlayerSpawn", "TDMPlayerSpawn", function(ply)
	if not COD.GameStarted or COD.DisableSpawn then
		ply:KillSilent()
	else
		if ply:Team() != 1 and ply:Team() != 2 then
			ply:KillSilent()
		end
	end
	if ply:Team() == 1 then
		ply:SetModel("models/tdmg/pm/specgru_milsim_"..math.random(1,4).."_1_pm.mdl")
		ply:SetPos(table.Random(COD.DataTable["Team1_Spawns"]))
		ply.VJ_NPC_Class = {"CLASS_SPECGRU"}
	elseif ply:Team() == 2 then
		ply:SetModel("models/tdmg/pm/kortac_1_"..math.random(1,4).."_pm.mdl")
		ply:SetPos(table.Random(COD.DataTable["Team2_Spawns"]))
		ply.VJ_NPC_Class = {"CLASS_KORTAC"}
	end
	ply.HeadBlow = false
	if COD.EnabledDynamicSpawnPoints then
		COD:SpawnPlayerAtSafePosition(ply)
	end
	ply:GodEnable()
	timer.Simple(2, function()
		if IsValid(ply) then
			ply:GodDisable()
		end
	end)
	ply:SetNWBool('Downed', false)
	ply:SetupHands()
	ply:SetWalkSpeed(160)
	ply:SetRunSpeed(280)
	ply:SetJumpPower(128)
	ply:UnSpectate()
	ply:SetNWFloat('KillsP', 0)
	ply.DeathTime = 0

	if COD.Perk1Unlocked then
		ply:SetNWFloat('Perk1', ply.Perk1Choosed)
	end

	if COD.Perk2Unlocked then
		ply:SetNWFloat('Perk2', ply.Perk2Choosed)
	end

	ply:SetNWFloat('Perk1_Choose', ply.Perk1Choosed)
	ply:SetNWFloat('Perk2_Choose', ply.Perk2Choosed)

	ply.CooldownPerkEquip = CurTime()+15
	if ply:GetNWFloat('Perk1') == 3 then
		ply:SetNWFloat('KillsP', 1)
	end
	ply:SetNoCollideWithTeammates(true)
	local wdata = ply.WeaponData
	if wdata and wdata[1] != "" then
		ply:SetPrimaryWep(wdata[1])
	else
		ply:SetPrimaryWep()
	end
	if wdata and wdata[2] != "" then
		ply:SetSecondaryWep(wdata[2])
	else
		ply:SetSecondaryWep()
	end
	ply:SetNWFloat('FragGrenades', 2)
	ply:SetNWFloat('FlashGrenades', 2)
	ply:SetNWBool('jugger', false)
	ply:SetNWBool('KillStreak1_Used', false)
	ply:SetNWBool('KillStreak2_Used', false)
	ply:SetNWBool('KillStreak3_Used', false)
	if ply:Alive() then
		net.Start("COD.PerksShow")
		net.Send(ply)
	end
end)

function COD:GiveMessageCenter(plytab, type)
	if istable(plytab) and #plytab > 0 or IsEntity(plytab) then
		net.Start("COD.ScoreMarkEnemy")
		net.WriteFloat(type)
		net.Send(plytab)
	end
end

hook.Add("InitPostEntity", "TDMLoadCommands", function()
	RunConsoleCommand("sbox_playershurtplayers", 1)
	RunConsoleCommand("mp_falldamage", 1)
end)

hook.Add("PlayerDeathSound", "TDMSilent", function()
	return true
end)

hook.Add("PlayerDeath", "!TDMHook", function(ply, inf, att)
	ply.DeathTime = CurTime()+3
	local name = "default"
	local att2 = att
	if IsValid(inf) then
		name = inf:GetClass()
		if name == "env_explosion" or name == "tdm_ah64_rocket1" or name == "tdm_ah64_rocket2" then
			if IsValid(inf:GetCreator()) then
				att2 = inf:GetCreator()
			end
			name = "explosion"
		end
		if name == "tdm_knife" or name == "tdm_infection_knife" then
			name = "knife"
		end
		if name == "player" then
			if IsValid(att:GetActiveWeapon()) then
				name = att:GetActiveWeapon():GetClass()
			end
		end
	end
	if ply.Takedowning and att.Takedowning then
		name = "takedown"
	end
	net.Start("COD.Killfeed")
	net.WriteTable({
		attacker = att2,
		inflictor = name,
		target = ply,
	})
	net.Broadcast()

	local rag = ply:GetRagdollEntity()
	if IsValid(rag) then
		rag:Remove()

		local ent = ents.Create("tdm_deathanim")
		ent:SetModel(ply:GetModel())
		ent:SetPos(ply:GetPos())
		ent:SetAngles(ply:GetAngles())
		if !ply:OnGround() or ply:IsDowned() then
			ent.Transform = ply
		end
		ent:Spawn()
	end
	if att:IsPlayer() and ply != att then
		net.Start("COD.HitMarkEnemy")
		net.WriteBool(true)
		net.WriteBool(false)
		net.Send(att)
		att:SetNWFloat('KillsP', att:GetNWFloat('KillsP')+1)

		net.Start("COD.KillNick")
		net.WriteEntity(ply)
		net.Send(att)

		if att.Takedowning then
			att:ChangeScore(150)
			COD:GiveMessageCenter(att, 2)
		elseif ply.HeadKill then
			att:ChangeScore(110)
			COD:GiveMessageCenter(att, 1)
		elseif IsValid(inf) and inf:GetClass() == "tdm_knife" then
			att:ChangeScore(125)
			COD:GiveMessageCenter(att, 4)
		else
			att:ChangeScore(100)
			COD:GiveMessageCenter(att, 0)
		end
		att:CheckKillstreaks()
	end
	if ply != att then
		timer.Simple(1, function()
			if !IsValid(ply) or !IsValid(att) then return end
			COD:ShowKillCam(ply, att)
		end)
	end
	if ply:Team() == 1 then
		COD:AddFragsToData(2, 1)
	elseif ply:Team() == 2 then
		COD:AddFragsToData(1, 1)
	end
	ply:SetNWBool('jugger', false)
	ply.AttackerPlayer = att
end)

hook.Add("EntityTakeDamage", "TDMHook", function(ply, dmg)
	local att = dmg:GetAttacker()

	if ply:IsPlayer() and ply:GetNWFloat('Perk1') == 1 and dmg:IsExplosionDamage() then
		dmg:ScaleDamage(0.4)
	end
	if ply:IsPlayer() and dmg:IsBulletDamage() then
		dmg:ScaleDamage(0.8)
	end

	if att:IsPlayer() and ply != att and ply:IsPlayer() then
		if att:Team() == ply:Team() then return true end
		net.Start("COD.HitMarkEnemy")
		net.WriteBool(false)
		net.WriteBool(false)
		net.Send(att)
		if ply:Armor() > 0 then
			net.Start("COD.HitMarkEnemy2")
			net.WriteBool(ply:Armor()<=dmg:GetDamage())
			net.WriteBool(false)
			net.Send(att)
		end
	end

	if ply:IsPlayer() and dmg:GetDamage() >= ply:Health()+ply:Armor() and ply:GetNWFloat('Perk2') == 2 and not dmg:IsExplosionDamage() and not ply.AlreadyWasDowned and not ply.Takedowning then
		dmg:ScaleDamage(0)
		ply:Down()

		if att:IsPlayer() then
			net.Start("COD.HitMarkEnemy2")
			net.WriteBool(false)
			net.WriteBool(true)
			net.Send(att)
		end

		return true
	end

	if att:IsPlayer() and (ply:IsNPC() or KillstreakTeamEntities[ply:GetClass()]) then
		if ply.Team == att:Team() then
			return true
		else
			net.Start("COD.HitMarkEnemy")
			net.WriteBool(false)
			net.WriteBool(false)
			net.Send(att)
			if dmg:GetDamage() >= ply:Health() and not ply.AlreadyHaveDeathMark then
				if ply:IsNPC() or ply:GetClass() == "tdm_drone" or ply:GetClass() == "tdm_sentry" then
					COD:GiveMessageCenter(att, 3)
					att:ChangeScore(50)
				else
					COD:GiveMessageCenter(att, 6)
					att:ChangeScore(250)
				end
				ply.AlreadyHaveDeathMark = true
			end
		end
	end	
	if ply:IsPlayer() then
		net.Start("COD.HitMarkEnemy")
		net.WriteBool(false)
		net.WriteBool(true)
		net.Send(ply)
		ply.HealCooldown = CurTime() + 8
		if ply:GetNWFloat('Perk2') == 1 then
			ply.HealCooldown = CurTime() + 3
		end
		if ply:Armor() > 0 then
			local dmgs = dmg:GetDamage()
			ply:SetArmor(math.max(ply:Armor()-dmgs, 0))
			return true
		end
	end
	if ply:IsPlayer() and att.Team == ply:Team() then return true end
end)

hook.Add("ScalePlayerDamage", "TDMHook", function(ply, hit, dmg)
	if hit == HITGROUP_HEAD then
		ply.HeadKill = true
		timer.Create("HeadshotFalseTDM"..ply:EntIndex(), 0.01, 1, function()
			if !IsValid(ply) then return end
			ply.HeadKill = false
		end)
	end
end)

concommand.Add("cod_changegamemode", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		local arg1 = args[1]
		if not arg1 then
			arg1 = COD.DataTable["Gamemode"]
		end
		local num = math.floor(tonumber(arg1))
		if num >= 1 and num <= 5 then
			COD.DataTable["Gamemode"] = num
			COD:GetInfoData("all")
			COD:ChangeState(true)
		end
	end
end)

concommand.Add("cod_givekillstreak", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		if args[1] then
			local num = math.floor(tonumber(args[1]))
			if num >= 1 and num <= 22 then
				COD:KillstreakAddOther(ply, false, num)
			end
		end
	end
end)

local function CanSeeEnt(ent1, ent2)
	local pos1 = ent1:GetPos()
	local pos2 = ent2:GetPos()
	local tr = util.TraceLine( {
		start = pos1,
		endpos = pos2,
		filter = function(ent) 
			if ent:IsWorld() or string.match(ent:GetClass(), "prop_") then 
				return true 
			end 
		end,
	})
	local pos3 = pos2 - pos1
	local diff = ent1:GetAimVector():Dot(pos3)
	return !tr.Hit and diff > 0.2
end

timer.Simple(1, function()
	if LeadBot then	
		local delay = CurTime()+2
		hook.Add("Think", "BrainBotTDM", function()
			if delay < CurTime() then
				delay = CurTime()+2
				for _, bot in ipairs(player.GetBots()) do
					bot:UseKillstreak(math.random(1,3))
				end
			end
		end)

		hook.Add("PlayerSpawn", "BrainBotTDM2", function(ply)
			if ply:IsBot() then
				ply.Perk1Choosed = math.random(1,4)
				ply.Perk2Choosed = math.random(1,4)
			end
		end)

		function LeadBot.StartCommand(bot, cmd)
			if COD.TimeBeforeEnd > CurTime()+COD.GamemodeSettings[COD.DataTable["Gamemode"]]["MaxTime"] then return end
			
			local buttons = IN_SPEED
			local botWeapon = bot:GetActiveWeapon()
			local controller = bot.ControllerBot
			local target = controller.Target
			local val = IsValid(target)
		
			if !IsValid(controller) then return end
		
			if LeadBot.NoSprint or bot.DelaySprint and bot.DelaySprint > CurTime() then
				buttons = 0
			end

			if val then
				if bot.StopDelayTime < CurTime() then
					bot.StopDelayTime = CurTime()+math.random(1,5)
					bot.StopWalkingTarget = !bot.StopWalkingTarget
				end
			else
				bot.StopDelayTime = CurTime()+math.random(1,3)
				bot.StopWalkingTarget = false
			end
		
			if val and math.random(2) == 1 and not bot.ReadyToTakedown then
				buttons = buttons + IN_ATTACK
				bot.DelaySprint = CurTime()+math.Rand(2,8)
			end

			if IsValid(botWeapon) and (botWeapon:Clip1() == 0 or !val and botWeapon:Clip1() <= botWeapon:GetMaxClip1() / 2) then
				timer.Simple(3, function()
					if IsValid(botWeapon) and botWeapon:Clip1() == 0 then
						botWeapon:SetClip1(botWeapon:GetMaxClip1())
					end
				end)
			end
		
			if bot:GetMoveType() == MOVETYPE_LADDER then
				local pos = controller.goalPos
				local ang = ((pos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()
		
				if pos.z > controller:GetPos().z then
					controller.LookAt = Angle(-30, ang.y, 0)
				else
					controller.LookAt = Angle(30, ang.y, 0)
				end
		
				controller.LookAtTime = CurTime() + 0.1
				controller.NextJump = -1
				if not bot.StopWalkingTarget then
					buttons = buttons + IN_FORWARD
				end
			end
		
			if controller.NextDuck > CurTime() then
				buttons = buttons + IN_DUCK
			elseif controller.NextJump == 0 and not bot.Takedowning then
				controller.NextJump = CurTime() + 1
				buttons = buttons + IN_JUMP
			end

			if bot.Takedowning then
				controller.NextJump = CurTime() + 1
			end
		
			if !bot:IsOnGround() and controller.NextJump > CurTime() then
				buttons = buttons + IN_DUCK
			end

			if bot:IsDowned() then
				if bot.ReviveTimeDelay < CurTime() then
					buttons = IN_USE
				end
			else
				bot.ReviveTimeDelay = CurTime()+math.Rand(0,15)
			end

			
			if val and not bot:IsDowned() and bot:IsAtBack(controller.Target) and bot:GetPos():DistToSqr(controller.Target:GetPos()) < 100000 then
				bot.ReadyToTakedown = true
			else
				bot.ReadyToTakedown = false
			end

			if bot.ReadyToTakedown then
				if bot:GetPos():DistToSqr(controller.Target:GetPos()) < 4000 then
					bot:Takedown(controller.Target)
				end
			end
		
			cmd:ClearButtons()
			cmd:ClearMovement()
			cmd:SetButtons(buttons)
		end

		function LeadBot.PlayerMove(bot, cmd, mv)
			if COD.TimeBeforeEnd > CurTime()+COD.DataTable["MaxTime"] then return end

			local controller = bot.ControllerBot
			local botWeapon = bot:GetActiveWeapon()
			local havemelee = false
			if not bot.FlagDelay then
				bot.FlagDelay = CurTime()+0.2
			end

			if IsValid(botWeapon) then
				if botWeapon:GetMaxClip1() <= 0 then
					havemelee = true
					bot.StopWalkingTarget = false
					bot.DelaySprint = 0
				end
			end

			if COD.DataTable["Gamemode"] == 5 and !IsValid(controller.Target) and bot.FlagDelay < CurTime() then
				bot.FlagDelay = CurTime()+0.2
				local pos, mindist = nil, math.huge
				for k, v in ipairs(ents.FindByClass("tdm_domination_flag")) do
					local vpos = v:GetPos()
					local vdist = vpos:DistToSqr(bot:GetPos())
					if v:GetNWFloat('Team') != bot:Team() and vdist < mindist then
						mindist = vdist
						pos = vpos
					end
				end
				if isvector(pos) then
					controller.PosGen = pos
				end
			end
		
			if !IsValid(controller) then
				bot.ControllerBot = ents.Create("leadbot_navigator")
				bot.ControllerBot:Spawn()
				bot.ControllerBot:SetOwner(bot)
				controller = bot.ControllerBot
			end
		
			if controller.PosGen and controller.P and controller.TPos ~= controller.PosGen then
				controller.TPos = controller.PosGen
				controller.P:Compute(controller, controller.PosGen)
			end

			mv:SetForwardSpeed(1200)
		
			if controller:GetPos() ~= bot:GetPos() then
				controller:SetPos(bot:GetPos())
			end
		
			if controller:GetAngles() ~= bot:EyeAngles() then
				controller:SetAngles(bot:EyeAngles())
			end
		
			if (bot.NextSpawnTime and bot.NextSpawnTime + 1 > CurTime()) or !IsValid(controller.Target) or controller.ForgetTarget < CurTime() or controller.Target:Health() < 1 then
				if IsValid(controller.Target) then
					controller.PosGen = controller.Target:GetPos()
					controller.LastSegmented = CurTime() + 30
				end
				controller.Target = nil
			end
			if !IsValid(controller.Target) then
				for _, ply in ipairs(ents.GetAll()) do
					if ply ~= bot and ((ply:IsPlayer() and (!LeadBot.TeamPlay or (LeadBot.TeamPlay and (ply:Team() ~= bot:Team()))))) and ply:GetPos():DistToSqr(bot:GetPos()) < 2250000 then
						if ply:Alive() and not ply:IsDowned() and CanSeeEnt(bot, ply) then
							controller.Target = ply
							controller.ForgetTarget = CurTime() + 2
						end
						if ply:Alive() and ply:IsDowned() and not ply.Takedowning and ply:GetPos():DistToSqr(bot:GetPos()) < 250000 and bot:IsAtBack(ply) then
							controller.Target = ply
							controller.ForgetTarget = CurTime() + 1
						end
					end
					if ply ~= bot and ( ply:IsNPC() and ply.Team and ply.Team != bot:Team() or KillstreakTeamEntities[ply:GetClass()] and ply.Team != bot:Team() ) and CanSeeEnt(bot, ply) then
						controller.Target = ply
						controller.ForgetTarget = CurTime() + 2
					end
				end
			elseif controller.ForgetTarget < CurTime() and CanSeeEnt(bot, controller.Target) then
				controller.ForgetTarget = CurTime() + 2
			end
		
			local dt = util.QuickTrace(bot:EyePos(), bot:GetForward() * 45, bot)
		
			if IsValid(dt.Entity) and dt.Entity:GetClass() == "prop_door_rotating" then
				dt.Entity:Fire("OpenAwayFrom", bot, 0)
			end
		
			if !IsValid(controller.Target) and (!controller.PosGen or bot:GetPos():DistToSqr(controller.PosGen) < 32 or controller.LastSegmented < CurTime()) then
				controller.PosGen = controller:FindSpot("random", {radius = 12500})
				controller.LastSegmented = CurTime() + 10
			elseif IsValid(controller.Target) then
				local distance = controller.Target:GetPos():DistToSqr(bot:GetPos())
				controller.PosGen = controller.Target:GetPos()
		
				if distance <= 90000 and not bot.ReadyToTakedown and not havemelee then
					mv:SetForwardSpeed(-1200)
				end
			end
		
			if !controller.P then
				return
			end
		
			local segments = controller.P:GetAllSegments()
		
			if !segments then return end
		
			local cur_segment = controller.cur_segment
			local curgoal = segments[cur_segment]
		
			if !curgoal then
				mv:SetForwardSpeed(0)
				return
			end
		
			if segments[cur_segment + 1] and Vector(bot:GetPos().x, bot:GetPos().y, 0):DistToSqr(Vector(curgoal.pos.x, curgoal.pos.y)) < 100 then
				controller.cur_segment = controller.cur_segment + 1
				curgoal = segments[controller.cur_segment]
			end
		
			local goalpos = curgoal.pos

			if bot:GetVelocity():Length2DSqr() <= 225 then
				if controller.NextCenter < CurTime() then
					controller.strafeAngle = ((controller.strafeAngle == 1 and 2) or 1)
					controller.NextCenter = CurTime() + math.Rand(0.3, 0.65)
				elseif controller.nextStuckJump < CurTime() then
					if !bot:Crouching() then
						controller.NextJump = 0
					end
					controller.nextStuckJump = CurTime() + math.Rand(1, 2)
				end
			end
		
			if controller.NextCenter > CurTime() and not bot.StopWalkingTarget then
				if controller.strafeAngle == 1 then
					mv:SetSideSpeed(1500)
				elseif controller.strafeAngle == 2 then
					mv:SetSideSpeed(-1500)
				else
					mv:SetForwardSpeed(-1500)
				end
			end
		
			if controller.NextJump ~= 0 and curgoal.type > 1 and controller.NextJump < CurTime() then
				controller.NextJump = 0
			end
		
			if curgoal.area:GetAttributes() == NAV_MESH_CROUCH then
				controller.NextDuck = CurTime() + 0.1
			end
		
			controller.goalPos = goalpos
		
			if GetConVar("developer"):GetBool() then
				controller.P:Draw()
			end
		
			local lerp = FrameTime() * math.random(8, 10)
			local lerpc = FrameTime() * 8
		
			if !LeadBot.LerpAim then
				lerp = 1
				lerpc = 1
			end
		
			local mva = ((goalpos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()
		
			mv:SetMoveAngles(mva)
		
			if IsValid(controller.Target) then
				if not bot.Takedowning then
					bot:SetEyeAngles(LerpAngle(lerp, bot:EyeAngles(), (controller.Target:EyePos() - bot:GetShootPos()):Angle()))
				end
				return
			else
				if not bot.Takedowning then
					if controller.LookAtTime > CurTime() then
						local ang = LerpAngle(lerpc, bot:EyeAngles(), controller.LookAt)
						bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
					else
						local ang = LerpAngle(lerpc, bot:EyeAngles(), mva)
						bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
					end
				end
			end
		end
	end
end)