local pl = FindMetaTable("Player")

util.AddNetworkString("COD.UAVStart")
util.AddNetworkString("COD.CounterUAVStart")
util.AddNetworkString("COD.KillstreaksHUD2")
util.AddNetworkString("COD.NukeEffect")
util.AddNetworkString("COD.AirPatrol")

function pl:SelectKillStreaks(first, second, third)
	local max = #COD.Killstreaks
	if first < 0 or first > max then 
		first = 0
	end
	if second < 0 or second > max then 
		second = 0
	end
	if third < 0 or third > max then 
		third = 0
	end
	self:SetNWFloat('KillStreak1', first)
	self:SetNWFloat('KillStreak2', second)
	self:SetNWFloat('KillStreak3', third)
end

function pl:SelectKillstreaksRandom()
    if self:IsBot() then
        local tab = {}
        local tab2 = {}

        for i=1,14 do
            table.insert(tab2, i)
        end

        local num1 = math.random(1,#tab2)
        tab[1] = tab2[num1]
        table.remove(tab2, num1)

        local num2 = math.random(1,#tab2)
        tab[2] = tab2[num2]
        table.remove(tab2, num2)

        local num3 = math.random(1,#tab2)
        tab[3] = tab2[num3]
        table.sort(tab, function(a, b) return a < b end)

        
        self:SelectKillStreaks(tab[1], tab[2], tab[3])
    else
        self:SelectKillStreaks(1, 7, 13)
    end
end

function pl:CheckKillstreaks()
	local tab = COD.Killstreaks
	local ks1, ks2, ks3 = self:GetNWFloat('KillStreak1'), self:GetNWFloat('KillStreak2'), self:GetNWFloat('KillStreak3')
	local frags = self:GetNWFloat('KillsP')
    if ks1 > 0 then
        if tab[ks1].kills <= frags and not self:GetNWBool('KillStreak1_Gave') and not self:GetNWBool('KillStreak1_Used') then
            self:SetNWBool('KillStreak1_Gave', true)
            net.Start("COD.KillstreaksHUD")
            net.WriteFloat(ks1)
            net.Send(self)
        end
    end
    if ks2 > 0 then
        if tab[ks2].kills <= frags and not self:GetNWBool('KillStreak2_Gave') and not self:GetNWBool('KillStreak2_Used') then
            self:SetNWBool('KillStreak2_Gave', true)
            net.Start("COD.KillstreaksHUD")
            net.WriteFloat(ks2)
            net.Send(self)
        end
    end
    if ks3 > 0 then
        if tab[ks3].kills <= frags and not self:GetNWBool('KillStreak3_Gave') and not self:GetNWBool('KillStreak3_Used') then
            self:SetNWBool('KillStreak3_Gave', true)
            net.Start("COD.KillstreaksHUD")
            net.WriteFloat(ks3)
            net.Send(self)
        end
    end
end

function pl:UseKillstreak(type)
    local tab = COD.Killstreaks
	local ks1, ks2, ks3, ks4 = self:GetNWFloat('KillStreak1'), self:GetNWFloat('KillStreak2'), self:GetNWFloat('KillStreak3'), self.KillstreakOthers
    if self:GetNWBool('KillStreak1_Gave') and not self:GetNWBool('KillStreak1_Used') and type == 1 then
        self:SetNWBool('KillStreak1_Used', true)
        self:SetNWBool('KillStreak1_Gave', false)
        tab[ks1].func(self)
    elseif self:GetNWBool('KillStreak2_Gave') and not self:GetNWBool('KillStreak2_Used') and type == 2 then
        self:SetNWBool('KillStreak2_Used', true)
        self:SetNWBool('KillStreak2_Gave', false)
        tab[ks2].func(self)
    elseif self:GetNWBool('KillStreak3_Gave') and not self:GetNWBool('KillStreak3_Used') and type == 3 then
        self:SetNWBool('KillStreak3_Used', true)
        self:SetNWBool('KillStreak3_Gave', false)
        tab[ks3].func(self)
    elseif istable(ks4) and #ks4 > 0 and type == 4 then
        ks4 = ks4[#ks4]
        tab[ks4].func(self)
        COD:KillstreakAddOther(self, true)
    end
end

function pl:GiveRadioWep(str)
    local wep = self:Give("tdm_radio")
    wep.Killstreak = str
    if str == "strating_run" then
        wep.ManyTimes = true
        wep.EndAfter = 3
    end
    self:SelectWeapon("tdm_radio")
    
    local aw = self:GetActiveWeapon() 
    if IsValid(aw) then
        self.RadioBeforeWep = aw:GetClass()
    else
        self.RadioBeforeWep = ""
    end
end

function COD:GiveKSAnn(float, ply)
    net.Start("COD.KillstreaksHUD2")
    net.WriteFloat(float)
    net.WriteEntity(ply)
    net.Broadcast()
end

function COD:ChooseKillstreakRadio(ply, weapon, pos)
    local str = weapon.Killstreak
    if str == "package" then
        COD:DropPackage(pos, ply)
    elseif str == "airstrike" then
        COD:AirstrikeCall(ply, pos)
    elseif str == "mortar" then
        COD:MortarCall(ply, pos)
    elseif str == "airstrike_line" then
        COD:LineAirstrikeCall(ply, pos)
    elseif str == "emergencypackage" then
        COD:DropEmergencyPackage(pos, ply)
    elseif str == "helicopterrun" then
        COD:HelicopterRun(ply, pos)
    elseif str == "helicopter" then
        COD:SpawnHelicopter(ply, pos)
    elseif str == "strating_run" then
        COD:StratingRun(ply, pos)
    elseif str == "harrier" then
        COD:SpawnHarrier(ply, pos)
    end
end

function COD:CheckSky(ent) 
    local tr = ent
    if !isvector(ent) then
        tr = tr:GetPos()
    end

    local tr2 = util.TraceLine({
        start = tr,
        endpos = tr+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    })

    return tr2.HitSky
end

-------------------------------------------------------------------------------------------------------------
function COD:AirPatrol(ply)
    local team = ply:Team()
    local pos = ply:GetPos()

    COD:GiveKSAnn(10, ply)

    local tr2 = util.TraceLine({
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    })

    local height = math.Clamp(tr2.HitPos:Distance(pos), 100, 600)

    for i = 1,3 do
        timer.Simple(i, function()
            local airm = ents.Create('prop_dynamic')
            airm:SetModel('models/tdmg/a10.mdl')
            airm:SetPos(ply:GetPos()+Vector(0,0,height))
            airm:SetAngles(Angle(0,rnd,0))
            airm:Spawn()
            airm:ResetSequence('strafing run')

            if i == 3 then
                sound.Play("ambient/explosions/exp1.wav", pos, 0)
                for k, pl in ipairs(player.GetAll()) do
                    if pl:Team() != ply:Team() then
                        net.Start("COD.AirPatrol")
                        net.WriteBool(true)
                        net.Send(pl)
                    else
                        net.Start("COD.AirPatrol")
                        net.WriteBool(false)
                        net.Send(pl)
                    end
                end
                for _, p in ipairs(ents.GetAll()) do
                    if p.KillstreakModel and p.Team and p.Team != ply:Team() then
                        p:EmitSound("ambient/explosions/explode_1.wav")
                        ParticleEffect("explosion_huge_h", p:GetPos(), Angle(0,0,0))
                        p:Remove()
                    end
                    if (p:GetClass() == "tdm_ah64" or p:GetClass() == "tdm_mi24" or p:GetClass() == "tdm_harrier") and team != p.Team then
                        p:DestroyHeli(true)
                    end
                end
            end

            timer.Simple(6, function()
                if !IsValid(airm) then return end
                sound.Play("tdmg/a10.wav", pos, 0)
            end)

            timer.Simple(15, function()
                if !IsValid(airm) then return end
                airm:Remove()
            end)
        end)
    end

    sound.Play("ambient/machines/aircraft_distant_flyby3.wav", pos, 0)
end

function COD:StratingRun(ply, pos)
    if istable(pos) then
        COD:GiveKSAnn(12, ply)

        local ang = Angle(0,rnd,0)
        for k, v in ipairs(pos) do
            local airm = ents.Create('prop_dynamic')
            timer.Simple(4+k, function()
                airm:SetModel('models/tdmg/saebomber.mdl')
                airm:SetPos(v)
                airm:SetAngles(ang)
                airm:Spawn()
                airm:ResetSequence('fly')
                airm.Team = ply:Team()
                airm.KillstreakModel = true
                airm:EmitSound("ambient/machines/aircraft_distant_flyby3.wav")
            end)
            timer.Simple(5.5+k/2, function()
                if !IsValid(airm) then return end

                util.ScreenShake( v, 5, 2, 2, 5000 )
                local explosion = ents.Create("env_explosion")
                explosion:SetPos(v)
                explosion:Spawn()
                explosion:SetCreator(airm)
                explosion.Team = ply:Team()
                explosion:SetKeyValue("iMagnitude", "300")
                explosion:Fire("Explode", 0, 0)
                ParticleEffect("explosion_huge_h", v, Angle(0,0,0))
                sound.Play("tdmg/a10_explosion.wav", v, 0)
            end)
            timer.Simple(7+k/2, function()
                if !IsValid(airm) then return end

                airm:Remove()
            end)
        end

        for k, pl in ipairs(player.GetAll()) do
            if pl:Team() == ply:Team() then
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_friendly.wav')]])
            else
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_enemy.wav')]])
            end
        end
    end
end

function COD:CallReinforcment(ply)
    local pos, dist = nil, 999999
    local team = ply:Team()
    local tab = COD.DataTable["backup_Spawns"]

    COD:GiveKSAnn(15, ply)
    
    for _, v in ipairs(tab) do
        if isvector(pos) then
            local dis1 = v:Distance(ply:GetPos())
            if dis1 <= dist then
                pos, dist = v, dis1
            end
        else
            pos = v
        end
    end

    if isvector(pos) then
        local heli = ents.Create("tdm_infil")
        heli:SetPos(pos)
        heli.Team2Team = ply:Team() == 2
        heli:Spawn()
        heli.Team = ply:Team()
        heli:SetNWFloat('Team', heli.Team)
        heli.KillstreakModel = true

        for k, pl in ipairs(player.GetAll()) do
            if pl:Team() == ply:Team() then
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/cover_friendly.wav')]])
            else
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/cover_enemy.wav')]])
            end
        end
    end
end

function COD:SpawnSentry(ply)
    local team = ply:Team()
    local pos = ply:GetForward()*56+ply:GetPos()
    COD:GiveKSAnn(9, ply)

    if pos then
        local sen = ents.Create("tdm_sentry")
        sen:SetPos(pos)
        sen:SetAngles(ply:GetAngles())
        sen:Spawn()
        sen.Team = ply:Team()
        sen:SetNWFloat('Team', sen.Team)

        for k, pl in ipairs(player.GetAll()) do
            if pl:Team() == ply:Team() then
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/turret_friendly.wav')]])
            else
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/turret_enemy.wav')]])
            end
        end
    end
end

function COD:SpawnHelicopter(ply, pos)
    local team = ply:Team()

    if pos then
        COD:GiveKSAnn(13, ply)
        local mi = ents.Create("tdm_mi24")
        mi:SetPos(pos)
        mi:SetAngles(Angle(0,math.random(0,360),0))
        mi:Spawn()
        mi.Team = ply:Team()
        mi:SetNWFloat('Team', mi.Team)

        for k, pl in ipairs(player.GetAll()) do
            if pl:Team() == ply:Team() then
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/heli_friendly.wav')]])
            else
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/heli_friendly.wav')]])
            end
        end
    end
end

function COD:UAVCall(team, mobile)
	for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == team then
			net.Start("COD.UAVStart")
			net.WriteBool(mobile)
			net.Send(ply)
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/uav_friendly.wav')]])
        else
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/uav_enemy.wav')]])
		end
	end
end

function COD:CounterUAVCall(plys)
    COD:GiveKSAnn(5, plys)
	for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == plys:Team() then
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/counter_uav_friendly.wav')]])
        else
            net.Start("COD.CounterUAVStart")
			net.Send(ply)
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/counter_uav_enemy.wav')]])
		end
	end
end

function COD:CallAC130(pl)
    local team = pl:Team()

    local ac = ents.Create("prop_dynamic")
    ac:SetModel("models/tdmg/ac130hipienfly.mdl")
    ac:SetPos(pl:GetPos())
    ac.KillstreakModel = true
    ac.Team = pl:Team()
    ac:Spawn()
    ac:SetMaterial("phoenix_storms/grey_steel")
    ac:ResetSequence("fly")
    ac:SetPlaybackRate(0.5)
    ac.PenetrationPower = 25

    local plane = ac

    for k, pl in ipairs(player.GetAll()) do
        if pl:Team() == team then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/ac130_friendly.wav')]])
        else
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/ac130_enemy.wav')]])
        end
    end

    local bulletdelay = CurTime()+math.random(5,10)
    local rocketdelay = CurTime()+math.random(10,20)
    local rnd = math.random(1,666666666)

    hook.Add("Think", "AC130"..rnd, function()
        local targets = {}
        if !IsValid(ac) then
            hook.Remove("Think", "AC130"..rnd)
        end
        if bulletdelay < CurTime() then
            bulletdelay = CurTime()+math.random(5,10)
            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and ply:Team() != team and COD:CheckSky(ply) and ply:GetNWFloat('Perk2') != 4 then
                    table.insert(targets, ply)
                end
            end
            if #targets > 0 then
                local target = targets[math.random(1,#targets)]
                for i=1,75 do
                    timer.Simple(i/30, function()
                        if !IsValid(plane) then return end
                        local pos = target:GetPos()
                        util.ScreenShake(pos, 1, 2, 2, 5000)
                        plane.CurrentPenetrationPower = plane.PenetrationPower
                        plane:FireBullets({
                            Damage = 250,
                            Src = pos+Vector(0,0,64),
                            Dir = Vector(0,0,-1),
                            Spread = VectorRand(-0.5,0.5),
                            Force = 50,
                            Attacker = ply,
                            Tracer = 0,
                        })
                        if i == 1 then
                            sound.Play("tdmg/killstreaks/ac130_gun.wav", pos, 0)
                        end
                    end)
                end
            end
        elseif rocketdelay < CurTime() then
            rocketdelay = CurTime()+math.random(10,20)
            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and ply:Team() != team and COD:CheckSky(ply) then
                    table.insert(targets, ply)
                end
            end
            if #targets > 0 then
                local target = targets[math.random(1,#targets)]
                for i=1,math.random(2,4) do
                    timer.Simple(i/2, function()
                        if !IsValid(plane) then return end
                        local pos2 = target:GetPos() + Vector(math.random(-200,200),math.random(-200,200),0)
                        util.ScreenShake(pos2, 5, 2, 2, 5000)
                        util.BlastDamage(plane, plane, pos2, 512, 256)
                        ParticleEffect("explosion_huge_h", pos2, Angle(0,0,0))
                        util.Decal("ExplosiveGunshot", pos2, pos2-Vector(0,0,4))
                        sound.Play("tdmg/killstreaks/ac130_rocket.wav", pos2, 0)
                    end)
                end
            end
        end
    end)

    timer.Simple(60, function()
        if IsValid(ac) then
            ac:Remove()
        end
    end)
end

function COD:SpawnHarrier(plys, pos)
    if pos then
        COD:GiveKSAnn(14, plys)
        local h = ents.Create("tdm_harrier")
        h:SetPos(pos)
        h:SetAngles(Angle(0,math.random(0,360),0))
        h:Spawn()
        h.Team = plys:Team()
        h:SetNWFloat('Team', h.Team)

        timer.Simple(2.5, function()
            if !IsValid(h) then return end

            util.ScreenShake( pos, 5, 2, 2, 5000 )
            local explosion = ents.Create("env_explosion")
            explosion:SetCreator(h)
            explosion:SetPos(pos)
            explosion:Spawn()
            explosion.Team = plys:Team()
            explosion:SetKeyValue("iMagnitude", "300")
            explosion:Fire("Explode", 0, 0)
            ParticleEffect("explosion_huge_h", pos, Angle(0,0,0))
            sound.Play("tdmg/a10_explosion.wav", pos, 0)
        end)

        for k, ply in ipairs(player.GetAll()) do
            if ply:Team() == plys:Team() then
                ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/harrier_friendly.wav')]])
            else
                net.Start("COD.CounterUAVStart")
                net.Send(ply)
                ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/harrier_enemy.wav')]])
            end
        end
    end
end

function COD:DropPackage(pos, ply)
    local tr2 = util.TraceLine( {
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    } )

    if not tr2.HitSky then return end
    COD:GiveKSAnn(4, ply)
    for k, pl in ipairs(player.GetAll()) do
		if pl:Team() == ply:Team() then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_friendly.wav')]])
        else
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_enemy.wav')]])
		end
	end

    local height = math.Clamp(tr2.HitPos:Distance(pos), 100, 600)

    local heli = ents.Create("prop_dynamic")
    heli:SetModel("models/tdmg/heli.mdl")
    heli:SetPos(pos+Vector(0,0,4))
    heli:SetAngles(Angle(0,math.random(0,360),0))
    heli:Spawn()
    heli:ResetSequence("spawn")
    heli:SetBodygroup(3, 1)
    heli.Team = ply:Team()
    heli.KillstreakModel = true

    timer.Simple(1, function()
        for i=1,10 do
            local sproxy = ents.Create("tdm_infil_soundproxy")
            sproxy:SetOwner(heli:GetOwner())
            sproxy:SetPos(heli:GetPos())
            sproxy:SetAngles(heli:GetAngles())
            sproxy:SetParent(heli)
            sproxy.Sound = "tdmg/sas1_veh1_int_quad_front_stat.wav"
            sproxy.Bone = "tag_main_rotor_static"
            sproxy.Vol = 100
            sproxy:Spawn()
        end
    end)

    timer.Simple(12, function()
        if !IsValid(heli) then return end
        local care = ents.Create("tdm_package")
        care:SetPos(pos+Vector(0,0,height-64))
        care:Spawn()
        care:SetNWEntity('Owner', ply)
        care:SetAngles(heli:GetAngles())
    end)

    timer.Simple(30, function()
        if IsValid(heli) then
            heli:Remove()
        end
    end)
end

function COD:DropEmergencyPackage(pos, ply)
    local tr2 = util.TraceLine( {
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    } )

    if not tr2.HitSky then return end
    COD:GiveKSAnn(19, ply)
    for k, pl in ipairs(player.GetAll()) do
		if pl:Team() == ply:Team() then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_friendly.wav')]])
        else
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_enemy.wav')]])
		end
	end

    local height = math.Clamp(tr2.HitPos:Distance(pos), 100, 600)

    local heli = ents.Create("prop_dynamic")
    heli:SetModel("models/tdmg/heli.mdl")
    heli:SetPos(pos+Vector(0,0,4))
    heli:SetAngles(Angle(0,math.random(0,360),0))
    heli:Spawn()
    heli:ResetSequence("spawn")
    heli:SetBodygroup(3, 1)
    heli.Team = ply:Team()
    heli.KillstreakModel = true

    timer.Simple(1, function()
        for i=1,10 do
            local sproxy = ents.Create("tdm_infil_soundproxy")
            sproxy:SetOwner(heli:GetOwner())
            sproxy:SetPos(heli:GetPos())
            sproxy:SetAngles(heli:GetAngles())
            sproxy:SetParent(heli)
            sproxy.Sound = "tdmg/sas1_veh1_int_quad_front_stat.wav"
            sproxy.Bone = "tag_main_rotor_static"
            sproxy.Vol = 100
            sproxy:Spawn()
        end
    end)


    for i=1,3 do
        timer.Simple(10+(i*1.5), function()
            if !IsValid(heli) then return end
            local care = ents.Create("tdm_package")
            care:SetPos(pos+Vector(math.random(-64,64),math.random(-64,64),height-64))
            care:Spawn()
            care:SetNWEntity('Owner', ply)
            care:SetAngles(heli:GetAngles())
        end)
    end

    timer.Simple(30, function()
        if IsValid(heli) then
            heli:Remove()
        end
    end)
end

function COD:SpawnCMine(ply)
    COD:GiveKSAnn(6, ply)

    local mine = ents.Create('tdm_cmine')
    mine:SetPos(ply:EyePos())
    mine.Team = ply:Team()
    mine:Spawn()
    mine:GetPhysicsObject():SetVelocity(ply:GetAimVector()*256)
end

function COD:DroneSpawn(ply)
    local team = ply:Team()

    COD:GiveKSAnn(2, ply)

    if not ply:IsBot() then
        local ch = ents.Create("tdm_drone")
        ch:SetPos(ply:EyePos()+Vector(0,0,16))
        ch:SetCreator(ply)
        ch:SetAngles(ply:GetAngles())
        ch:Spawn()
        ch.Team = ply:Team()
        ch:SetNWFloat('Team', ch.Team)

        return
    end
end

function COD:HelicopterRun(ply, pos)
    local team = ply:Team()

    COD:GiveKSAnn(17, ply)
    for k, pl in ipairs(player.GetAll()) do
        if pl:Team() == ply:Team() and pl != ply then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/heli_friendly.wav')]])
        elseif pl:Team() != ply:Team() and pl != ply then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/heli_enemy.wav')]])
        end
    end

    if COD.DataTable["Enable_ManualControl_ChopperGunner"] and not ply:IsBot() then
        local pos = table.Random(COD.DataTable["ChopperGunner_Spawns"])
        local ch = ents.Create("tdm_ah64")
        ch:SetPos(pos)
        ch:SetCreator(ply)
        ch.Team = ply:Team()
        ch:SetNWFloat('Team', ch.Team)
        ch:Spawn()

        return
    end
    local tr2 = util.TraceLine({
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    })

    local height = math.Clamp(tr2.HitPos:Distance(pos), 0, 600)

    local airm = ents.Create('prop_dynamic')
    airm:SetModel('models/tdmg/ah64.mdl')
    airm:SetPos(pos+Vector(0,0,height))
    airm:SetAngles(Angle(0,math.random(0,360),0))
    airm:Spawn()
    airm:ResetSequence('action')
    airm:SetPlaybackRate(0.5)
    airm.Attacking = false
    airm.Team = ply:Team()
    airm.KillstreakModel = true
    sound.Play("tdmg/killstreaks/ah64_flyby.ogg", pos, 0)

    timer.Simple(6, function()
        if !IsValid(airm) then return end
        timer.Create("TargetChecker"..airm:EntIndex(), 1, 24, function()
            if !IsValid(airm) then return end
            if not airm.Attacking then
                for _, ent in ipairs(ents.FindInSphere(pos, 1500)) do
                    if ent:IsPlayer() and ent:Alive() and ent:Team() != airm.Team and COD:CheckSky(ent) and ent:GetNWFloat('Perk2') != 4 then
                        local max = math.random(4,8)
                        for i=1, max do
                            timer.Simple(i/5, function()
                                if !IsValid(airm) then return end
                                local pos2 = ent:GetPos()+Vector(math.random(-64,64), math.random(-64,64),0)
                                sound.Play("tdmg/killstreaks/apache_cannon.wav", pos, 0)
                                timer.Simple(0.2, function()
                                    local explosion = ents.Create("env_explosion")
                                    explosion:SetCreator(airm)
                                    explosion:SetPos(pos2)
                                    explosion:Spawn()
                                    explosion.Team = ply:Team()
                                    explosion:SetKeyValue("iMagnitude", "75")
                                    explosion:Fire("Explode", 0, 0)
                                end)
                                airm.Attacking = true
                                if i == max then
                                    timer.Simple(1, function()
                                        if !IsValid(airm) then return end
                                        airm.Attacking = false
                                    end)
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end)
 
    timer.Simple(42, function()
        if !IsValid(airm) then return end
        airm:Remove()
    end)
end

function COD:MortarCall(ply, pos)
    local team = ply:Team()

    local tr2 = util.TraceLine( {
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    } )

    if not tr2.HitSky then return end
    COD:GiveKSAnn(11, ply)

    for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == team then
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_friendly.wav')]])
        else
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_enemy.wav')]])
		end
	end

    local height = math.Clamp(tr2.HitPos:Distance(pos)-100, 512, 4096)

    local rnd = math.random(0,360)
    
    sound.Play("ambient/explosions/exp3.wav", pos, 0)

    local cooldown = 6
    for i=1,16 do
        if i == 5 or i == 9 or i == 13 then
            cooldown = cooldown + 4
        end
        timer.Simple(cooldown+i, function()
            local pos2 = pos + Vector(math.random(-300,300),math.random(-300,300),0)
            sound.Play("weapons/mortar/mortar_shell_incomming1.wav", pos2, 0)
            timer.Simple(0.8, function()
                util.ScreenShake( pos2, 5, 2, 2, 5000 )
                local explosion = ents.Create("env_explosion")
                explosion:SetCreator(game.GetWorld())
                explosion:SetPos(pos2)
                explosion:Spawn()
                explosion.Team = ply:Team()
                explosion:SetKeyValue("iMagnitude", "250")
                explosion:Fire("Explode", 0, 0)
                ParticleEffect("explosion_huge_h", pos2, Angle(0,0,0))
                sound.Play("tdmg/a10_explosion.wav", pos2, 0)
            end)
        end)
    end

    timer.Simple(15, function()
        if !IsValid(airm) then return end
        airm:Remove()
        airm2:Remove()
    end)
end

function COD:LineAirstrikeCall(ply, pos)
    local team = ply:Team()

    COD:GiveKSAnn(16, ply)

    for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == team then
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_friendly.wav') COD:SpeakerSay('tdmg/killstreaks/airstrike_siren.wav')]])
        else
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_enemy.wav') COD:SpeakerSay('tdmg/killstreaks/airstrike_siren.wav')]])
		end
	end

    local rnd = math.random(0,360)
    local airm = ents.Create('prop_dynamic')
    airm:SetModel('models/tdmg/b2.mdl')
    airm:SetPos(pos)
    airm:SetAngles(Angle(0,rnd,0))
    airm:Spawn()
    airm:ResetSequence('action')
    airm:SetPlaybackRate(0.25)
    airm.Team = ply:Team()
    airm.KillstreakModel = true

    sound.Play("ambient/machines/aircraft_distant_flyby3.wav", pos, 0)

    local offset = 3000
    timer.Simple(8, function()
        if !IsValid(airm) then return end
        for i=1,100 do
            timer.Simple(0.1*i, function()
                if !IsValid(airm) then return end
                offset = offset - 60
                local pos2 = pos+airm:GetForward()*(offset)
                if COD:CheckSky(pos2) then 
                    local explosion = ents.Create("env_explosion")
                    explosion:SetCreator(airm)
                    explosion:SetPos(pos2+airm:GetRight()*32)
                    explosion:Spawn()
                    explosion.Team = ply:Team()
                    explosion:SetKeyValue("iMagnitude", "300")
                    explosion:Fire("Explode", 0, 0)

                    local explosion = ents.Create("env_explosion")
                    explosion:SetCreator(airm)
                    explosion:SetPos(pos2-airm:GetRight()*32)
                    explosion:Spawn()
                    explosion.Team = ply:Team()
                    explosion:SetKeyValue("iMagnitude", "300")
                    explosion:Fire("Explode", 0, 0)

                    ParticleEffect("explosion_huge_h", pos2-airm:GetRight()*32, Angle(0,0,0))
                    ParticleEffect("explosion_huge_h", pos2+airm:GetRight()*32, Angle(0,0,0))

                    util.ScreenShake( pos2, 5, 2, 2, 5000 )
                    sound.Play("tdmg/a10_explosion.wav", pos2, 0)
                end
            end)
        end
    end)

    timer.Simple(20, function()
        if !IsValid(airm) then return end
        airm:Remove()
    end)
end

function COD:AirstrikeCall(ply, pos)
    local team = ply:Team()

    local tr2 = util.TraceLine( {
        start = pos,
        endpos = pos+Vector(0,0,99999),
        filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
    } )

    --if not tr2.HitSky then return end
    COD:GiveKSAnn(7, ply)

    for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == team then
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_friendly.wav')]])
        else
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/airstrike_enemy.wav')]])
		end
	end

    local height = math.Clamp(tr2.HitPos:Distance(pos)-100, 512, 4096)

    local rnd = math.random(0,360)

    local airm = ents.Create('prop_dynamic')
    airm:SetModel('models/tdmg/a10.mdl')
    airm:SetPos(pos)
    airm:SetAngles(Angle(0,rnd,0))
    airm:Spawn()
    airm:ResetSequence('strafing run')
    airm.Team = ply:Team()
    airm.KillstreakModel = true
    airm.PenetrationPower = 25

    local airm2 = ents.Create('prop_dynamic')
    airm2:SetModel('models/tdmg/a10.mdl')
    airm2:SetPos(pos)
    airm2:SetAngles(Angle(0,rnd,0))
    airm2:Spawn()
    airm2:SetNoDraw(true)
    airm2.Team = ply:Team()
    airm2.KillstreakModel = true
    airm2.PenetrationPower = 25

    timer.Simple(3, function()
        if !IsValid(airm2) then return end
        airm2:ResetSequence('strafing run')
        airm2:SetNoDraw(false)
    end)

    sound.Play("ambient/machines/aircraft_distant_flyby3.wav", pos, 0)
    timer.Simple(6, function()
        if !IsValid(airm) then return end
        sound.Play("tdmg/a10.wav", pos, 0)
    end)
    timer.Simple(9, function()
        if !IsValid(airm2) then return end
        sound.Play("tdmg/a10.wav", pos, 0)
    end)

    for i=1,1000 do
        timer.Simple(6+(i/500), function()
            if !IsValid(airm) then return end
            util.ScreenShake( pos, 1, 2, 2, 5000 )
            airm.CurrentPenetrationPower = airm.PenetrationPower
            local add = Vector(math.random(-256,256),math.random(-256,256),0)
            airm:FireBullets({
                Damage = 500,
                Src = add+tr2.HitPos-Vector(0,0,4),
                Dir = Vector(0,0,-1),
                Spread = VectorRand(-1,1),
                Force = 50,
                Tracer = 0,
            })
            if math.random(1,100) <= 1 then
                local explosion = ents.Create("env_explosion")
                explosion:SetCreator(airm)
                local vec = VectorRand(-128,128)
                vec.z = 0
                explosion:SetPos(pos+vec)
                explosion:Spawn()
                explosion.Team = ply:Team()
                explosion:SetKeyValue("iMagnitude", "100")
                explosion:Fire("Explode", 0, 0)
            end
            if i == 1 then
                sound.Play("tdmg/a10_shooting.wav", pos, 0)
            end
        end)
        timer.Simple(9+(i/500), function()
            if !IsValid(airm2) then return end
            util.ScreenShake( pos, 1, 2, 2, 5000 )
            airm2.CurrentPenetrationPower = airm2.PenetrationPower
            local add = Vector(math.random(-256,256),math.random(-256,256),0)
            airm2:FireBullets({
                Damage = 500,
                Src = add+tr2.HitPos-Vector(0,0,4),
                Dir = Vector(0,0,-1),
                Spread = VectorRand(-1,1),
                Force = 50,
                Tracer = 0,
            })
            if math.random(1,100) <= 1 then
                local explosion = ents.Create("env_explosion")
                explosion:SetCreator(airm)
                local vec = VectorRand(-128,128)
                vec.z = 0
                explosion:SetPos(pos+vec)
                explosion:Spawn()
                explosion.Team = ply:Team()
                explosion:SetKeyValue("iMagnitude", "100")
                explosion:Fire("Explode", 0, 0)
            end
            if i == 1 then
                sound.Play("tdmg/a10_shooting.wav", pos, 0)
            end
        end)
    end

    timer.Simple(15, function()
        if !IsValid(airm) then return end
        airm:Remove()
        airm2:Remove()
    end)
end

function COD:GiveJuggernaut(ply)
    ply:SetModel('models/tfusion/playermodels/mw3/mp_fullbody_ally_juggernaut.mdl')
    ply:SetWalkSpeed(80)
    ply:SetRunSpeed(160)
    ply:SetMaxArmor(2500)
    ply:SetArmor(2500)
    ply:SetNWBool('jugger', true)
    local wep = ply:Give('mg_dblmg')
    wep:SetClip1(2000)
    ply:SelectWeapon('mg_dblmg')
    for k, pl in ipairs(player.GetAll()) do
		if pl:Team() == ply:Team() then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_friendly.wav')]])
        else
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_enemy.wav')]])
		end
	end
end

function COD:CallK9(ply)
    local team = ply:Team()
    local pos = ply:GetForward()*48+ply:GetPos()

    if pos then
        local dog = ents.Create("vj_tdm_k9")
        dog:SetPos(pos)
        dog.Team = ply:Team()
        dog:Spawn()

        for k, pl in ipairs(player.GetAll()) do
            if pl:Team() == ply:Team() then
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/cover_friendly.wav')]])
            else
                pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/cover_enemy.wav')]])
            end
        end
    end
end

function COD:GiveWeaponKillstreak(ply, class)
    local wep = ply:Give(class)
    ply:SelectWeapon(wep)
    function wep:Reload() end
    for k, pl in ipairs(player.GetAll()) do
		if pl:Team() == ply:Team() then
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_friendly.wav')]])
        else
            pl:SendLua([[COD:SpeakerSay('tdmg/killstreaks/care_enemy.wav')]])
		end
	end
    local rnd = math.random(0,1000000)
    hook.Add("Think", "WK"..rnd, function()
        if !IsValid(wep) then
            hook.Remove("Think", "WK"..rnd)
        else
            local owner = wep:GetOwner()
            if !IsValid(owner) then
                wep:Remove()
            else
                local clip = wep:Clip1()
                if clip == 0 then
                    wep:Remove()
                end
            end
        end
    end)
end

function COD:Nuke(team)
    if COD.TimeBeforeEnd < CurTime()+30 then return end
    net.Start("COD.NukeEffect")
    net.Broadcast()
    for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == team then
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/nuke_friendly.wav')]])
        else
            ply:SendLua([[COD:SpeakerSay('tdmg/killstreaks/nuke_enemy.wav')]])
		end
	end
    timer.Simple(15, function()
        util.ScreenShake(Vector(0,0,0), 10, 5, 15, 50000)
        timer.Simple(7, function()
            if team == 1 then
                COD.DataTable["Team1_Kills"] = COD.DataTable["MaxKills"]
            else
                COD.DataTable["Team2_Kills"] = COD.DataTable["MaxKills"]
            end
        end)
    end)
end