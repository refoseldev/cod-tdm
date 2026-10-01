COD.HideHUD = false
COD.HUD_DisableSomeThink = false
COD.TimeMatch = 0
COD.UAV_Active = false
COD.Adv_UAV_Active = false
COD.Counter_UAV_Active = false

local hide = {
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudBattery"] = true,
	["CHudDamageIndicator"] = true
}

hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if hide[name] then
		return false
	end
end)

hook.Add("DrawDeathNotice", "DisableKillfeed", function()
	return 0,0
end)

hook.Add("HUDDrawTargetID", "HidePlayerInfo", function()
	return false
end)

function GM:HUDDrawPickupHistory() end

--------------------------------------------


local color_white1 = Color(255,255,255)
local color_white2 = Color(255,255,255,150)
local color_grey1 = Color(220,220,220)
local color_grey2 = Color(40,40,40,150)
local color_yellow1 = Color(200,150,0)
local color_red1 = Color(220,40,40)
local color_red2 = Color(240,60,60)
local color_red3 = Color(250,50,50)
local color_blue1 = Color(60,60,240)
local color_blue2 = Color(20,20,200)
local color_blue3 = Color(150,150,250)
local color_green1 = Color(20,120,20,200)

local team_color1 = Color(85,165,95)
local team_color2 = Color(195,165,85)

local gradient_mat = Material('tdmg/hud/gradient.png')
local gradient_mat2 = Material('tdmg/hud/gradient2.png')
local hm_mat = Material('tdmg/hud/hitmark.png')
local blood_mat = Material('tdmg/hud/bloodoverlay.png')
local team1_mat = Material('tdmg/hud/teams/specgru.png')
local team2_mat = Material('tdmg/hud/teams/kortac.png')
local tm_mat = Material('tdmg/hud/teammate.png')
local rev_mat = Material('tdmg/hud/revive.png')
local jug_mat = Material('tdmg/hud/jugoverlay.png')
local ar1_mat = Material('tdmg/hud/armor-full.png')
local ar2_mat = Material('tdmg/hud/armor-broken.png')
local arrow_mat = Material('tdmg/hud/arrows.png')
local dwn_mat = Material('tdmg/hud/downed.png')
local he_mat = Material('tdmg/hud/he.png')
local flash_mat = Material('tdmg/hud/flash.png')

local revtime = 0

surface.CreateFont("TDMG_SmallFont1",{
	font = "Doloman Pavljenko Light",
	extended = true,
	size = 20,
	antialias = true,
})

surface.CreateFont("TDMG_SmallFont2",{
	font = "Doloman Pavljenko Light",
	extended = true,
	size = 16,
	antialias = true,
})

surface.CreateFont("TDMG_MediumFont1",{
	font = "Doloman Pavljenko Light",
	extended = true,
	size = 28,
	antialias = true,
})

surface.CreateFont("TDMG_MediumFont2",{
	font = "Doloman Pavljenko Light",
	extended = true,
	size = 32,
	antialias = true,
})

surface.CreateFont("TDMG_LargeFont1",{
	font = "Doloman Pavljenko Light",
	extended = true,
	size = 48,
	antialias = true,
})

surface.CreateFont("TDMG_LargeFont2",{
	font = "Doloman Pavljenko Light",
	extended = true,
	size = 64,
	antialias = true,
})

surface.CreateFont("TDMG_Other_Big1",{
	font = "Boxed Round SemiBold",
	extended = true,
	size = 64,
	antialias = true,
})

surface.CreateFont("TDMG_Other_Big2",{
	font = "Boxed Round SemiBold",
	extended = true,
	size = 72,
	antialias = true,
})

surface.CreateFont("TDMG_Other_Medium1",{
	font = "Boxed Round SemiBold",
	extended = true,
	size = 24,
	antialias = true,
})

surface.CreateFont("TDMG_Other_Medium2",{
	font = "Boxed Round SemiBold",
	extended = true,
	size = 32,
	antialias = true,
})

function COD:GiveThemeName(type)
	local snd = ""
	local custom = GetConVar("cod_custom_music_enable"):GetBool()

	if type == "infil" then
		snd = "tdmg/themes/start"..math.random(1,6)..".wav"
	elseif type == "win" then
		snd = "tdmg/themes/victory.wav"
	elseif type == "defeat" then
		snd = "tdmg/themes/defeat.wav"
	end

	if custom then
		local files = file.Find("sound/cod_gamemode/themes/"..type.."/*", "GAME")
		if #files > 0 then
			snd = "cod_gamemode/themes/"..type.."/"..table.Random(files)
		end
	end

	return snd
end

local function DrawKiller(ply)
	if ply == LocalPlayer() then return end
	local alpha = 255	
	local cando = false
	timer.Simple(2.5, function()
		cando = true
	end)
	hook.Add("HUDPaint", "TDMGKillPlayerMark", function()
		if IsValid(ply) then
			local nick = ply:GetClass()
			if ply:IsPlayer() then
				nick = ply:Nick()
			end
			draw.SimpleText(COD.Language["hud_killer"]..nick, "TDMG_LargeFont1", ScrW()/2, ScrH()/1.5, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if cando then
			alpha = alpha - FrameTime()/0.0025
		end
		if alpha <= 0 then
			hook.Remove("HUDPaint", "TDMGKillPlayerMark")
		end
	end)
end

local function DrawKilled()
	local ply = net.ReadEntity()
	if ply == LocalPlayer() or !ply:IsPlayer() then return end
	local alpha = 0	
	local cando = false
	local nick = ply:Nick()
	timer.Simple(5, function()
		cando = true
	end)
	local parsed = markup.Parse("<font=TDMG_SmallFont1>"..COD.Language["hud_killed"].."<colour=200,0,0>"..nick.."</colour>")
	hook.Add("HUDPaint", "TDMGKillPlayerMark", function()
		if IsValid(ply) then
			parsed:Draw(ScrW()/2, ScrH()/2+275, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, alpha)
		end
		if cando then
			alpha = alpha - FrameTime()/0.0025
		else
			alpha = math.min(alpha + FrameTime()/0.0025, 255)
		end
		if alpha <= 0 and cando then
			hook.Remove("HUDPaint", "TDMGKillPlayerMark")
		end
	end)
end

local function DrawScoreGiving(text)
	local alpha = 255	
	local cando = false
	timer.Simple(1, function()
		cando = true
	end)
	hook.Add("HUDPaint", "TDMGScoreMark", function()
		draw.SimpleText(text, "TDMG_SmallFont1", ScrW()/2+50, ScrH()/2, Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if cando then
			alpha = alpha - FrameTime()/0.0025
		end
		if alpha <= 0 then
			hook.Remove("HUDPaint", "TDMGScoreMark")
		end
	end)
end

local annMat = Material("tdmg/hud/announcment_bg.png")
local titleMat = Material("tdmg/hud/modes/title.png")
local gMat = {
    [1] = Material("tdmg/hud/modes/deathmatch.png"),
    [2] = Material("tdmg/hud/modes/invasion.png"),
    [3] = Material("tdmg/hud/modes/knockout.png"),
	[4] = Material("tdmg/hud/modes/infected.png"),
	[5] = Material("tdmg/hud/modes/domination.png"),
}

local function ShowStartTitleOfGamemode()
	local gm = COD.DataTable["Gamemode"]
	local modemat = gMat[gm]
    local title = COD.Language["gamemode_"..gm]
    local lower = COD.Language["gamemode_"..gm.."_desc"]
    local scale = 0
    local showing = true

    COD:SpeakerSay("tdmg/speaker/gamemode"..gm..".wav")
	if gm < 4 then
		COD:SpeakerSay("tdmg/speaker/main_intro.wav")
	elseif gm == 4 then
		COD:SpeakerSay("tdmg/speaker/infected_intro.wav")
	elseif gm == 5 then
		COD:SpeakerSay("tdmg/speaker/domination_intro.wav")
	end

    timer.Simple(5, function()
        showing = false
    end)

    local w, h = ScrW(), ScrH()

    hook.Add("HUDPaint", "StartModeShow", function()
        if showing then
            scale = math.min(scale+FrameTime()*5, 1)
        else
            scale = math.max(scale-FrameTime()*5, 0)
            if scale == 0 then
                hook.Remove("HUDPaint", "StartModeShow")
            end
        end
        surface.SetDrawColor(color_white)
        surface.SetMaterial(modemat)
        surface.DrawTexturedRect(w/2-(100*scale), 100, 200*scale, 200*scale)

        surface.SetDrawColor(200,200,200,250)
        surface.SetMaterial(titleMat)
        surface.DrawTexturedRect(w/2-(350*scale), 300, 700*scale, 150*scale)

        if scale == 1 then
            surface.SetDrawColor(225,150,0)
            surface.DrawRect(w/2-314, 372, 628, 4)

            draw.SimpleText(title, "TDMG_Other_Big1", w/2, 335, Color(225,175,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(lower, "TDMG_Other_Medium2", w/2, 410, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)
end

local function ShowStartOperationOfGamemode()
    local showing = true

    timer.Simple(10, function()
        showing = false
    end)

	local alpha = 255
    local w, h = ScrW(), ScrH()
	local wid = -200
	local day = math.random(1,999)
	local time = math.random(10,20)..":"..math.random(10,59)

    hook.Add("HUDPaint", "StartOperationShow", function()
        if showing then
            wid = math.min(wid+FrameTime()*500, 100)
        else
            alpha = math.max(alpha-FrameTime()*500, -200)
            if alpha == 0 then
                hook.Remove("HUDPaint", "StartOperationShow")
            end
        end
		surface.SetDrawColor(255,255,255,alpha)
		surface.DrawRect(wid-6, h-200, 4, 90)
		
        draw.SimpleText("OPERATION/", "TDMG_Other_Medium1", wid, h-190, Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(string.upper(game.GetMap()), "TDMG_Other_Medium2", wid, h-170, Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("CLASSIFIED", "TDMG_Other_Medium1", wid, h-140, Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("DAY "..day.." "..time, "TDMG_Other_Medium1", wid, h-120, Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end)
end

local function DrawTimerScreen(num, show)
	local nums = num
	for i=1,nums do
		timer.Simple(i, function()
			num = num - 1
			if i == nums then
				hook.Remove("HUDPaint", "ShowStartScreenTDM")
				hook.Remove("CreateMove", "ShowStartScreenTDM")
				COD.HideHUD = false
				if show then
					timer.Simple(1, function()
						ShowStartTitleOfGamemode()
					end)
				else
					surface.PlaySound("tdmg/alert.wav")
				end
			else
				surface.PlaySound("tdmg/timer.wav")
			end
		end)
	end
	hook.Add("HUDPaint", "ShowStartScreenTDM", function( ply, pos, angles, fov )	
		draw.SimpleText(num, "TDMG_LargeFont2", ScrW()/2, 300, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end

local function DrawStartScreen()
	LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 2, 3)
	ShowStartOperationOfGamemode()
	if GetConVar("cod_music_enable"):GetBool() then
		surface.PlaySound(COD:GiveThemeName("infil"))
	end
	COD.HideHUD = true
	timer.Simple(COD.DataTable["Delay_Before_Start"]-5, function()
		DrawTimerScreen(5, true)
	end)
    hook.Add("CreateMove", "ShowStartScreenTDM", function(cmd)
        cmd:RemoveKey(IN_JUMP)
        cmd:RemoveKey(IN_DUCK)
        cmd:RemoveKey(IN_ATTACK)
		cmd:SetForwardMove(0)
        cmd:SetSideMove(0)
    end)
end

local function DrawWinScreen(win)
	local alpha = 0
	local alphadeg = false
	timer.Simple(5, function()
		alphadeg = true
	end)
	COD.HideHUD = true

	if GetConVar("cod_music_enable"):GetBool() then
		if win then
			surface.PlaySound(COD:GiveThemeName("win"))
		else
			surface.PlaySound(COD:GiveThemeName("defeat"))
		end
	end

	hook.Add("HUDPaint", "TDMGEndScr", function()
		if alphadeg then
			alpha = alpha-FrameTime()/0.005
		else
			alpha = math.Clamp(alpha+FrameTime()/0.002, 0, 255)
		end

		if win then
			surface.SetDrawColor(55,105,55,alpha/2)
			surface.DrawRect(0, 0, ScrW(), ScrH())

			surface.SetDrawColor(0,0,0,alpha/2)
			surface.DrawRect(ScrW()/2-125, ScrH()/1.5-25, 250, 50)

			draw.SimpleText(COD.Language["hud_win"], "TDMG_LargeFont1", ScrW()/2, ScrH()/1.5, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(team1_mat)
			surface.DrawTexturedRect(350, 120, 230, 256)

			draw.SimpleText(COD.DataTable["Team1_Kills"], "TDMG_LargeFont1", 465, 420, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(team2_mat)
			surface.DrawTexturedRect(ScrW()-600, 120, 256, 256)

			draw.SimpleText(COD.DataTable["Team2_Kills"], "TDMG_LargeFont1", ScrW()-470, 420, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			surface.SetDrawColor(105,5,5,alpha/2)
			surface.DrawRect(0, 0, ScrW(), ScrH())

			surface.SetDrawColor(0,0,0,alpha/2)
			surface.DrawRect(ScrW()/2-150, ScrH()/1.5-25, 300, 50)

			draw.SimpleText(COD.Language["hud_lose"], "TDMG_LargeFont1", ScrW()/2, ScrH()/1.5, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(team1_mat)
			surface.DrawTexturedRect(350, 120, 230, 256)

			draw.SimpleText(COD.DataTable["Team1_Kills"], "TDMG_LargeFont1", 465, 420, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(team2_mat)
			surface.DrawTexturedRect(ScrW()-600, 120, 256, 256)

			draw.SimpleText(COD.DataTable["Team2_Kills"], "TDMG_LargeFont1", ScrW()-470, 420, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		if alpha <= 0 and alphadeg then
			hook.Remove("HUDPaint", "TDMGEndScr")
			COD.HideHUD = false
		end
	end)
end

local function DrawPerks(unlocks)
	local ply = LocalPlayer()
	local alpha = 0
	local up = true
	local time = 5

	if unlocks >= 1 then
		time = 8
		if GetConVar("cod_music_enable"):GetBool() then
			surface.PlaySound("tdmg/themes/perk_earned.wav")
		end
	end

	timer.Simple(time, function()
		up = false
	end)

	hook.Add("HUDPaint", "TDMPerksShow", function()
		if up and not COD.HideHUD then
			alpha = math.Clamp(alpha+FrameTime()*500, 0, 255)
		else
			if alpha == 0 or COD.HideHUD then
				hook.Remove("HUDPaint", "TDMPerksShow")
			end
			alpha = math.Clamp(alpha-FrameTime()*500, 0, 255)
		end
		if ply:GetNWFloat('Perk1_Choose') > 0 then
			surface.SetDrawColor(Color(120,100,30,alpha/2.5))
			surface.DrawRect(ScrW()/2-175, ScrH()-100, 150, 75)
	
			local wh = 255
			if ply:GetNWFloat('Perk1_Choose') != ply:GetNWFloat('Perk1') then
				wh = 0
			end
			surface.SetDrawColor(Color(wh,wh,wh,alpha))
			surface.SetMaterial(COD.Perks["Type1"][ply:GetNWFloat('Perk1_Choose')].icon)
			surface.DrawTexturedRect(ScrW()/2-140, ScrH()-100, 75, 75)

			draw.SimpleText(COD.Perks["Type1"][ply:GetNWFloat('Perk1_Choose')].name, "TDMG_SmallFont1", ScrW()/2-102, ScrH()-125, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	
		if ply:GetNWFloat('Perk2_Choose') > 0 then		
			surface.SetDrawColor(Color(60,120,60,alpha/2.5))
			surface.DrawRect(ScrW()/2+25, ScrH()-100, 150, 75)

			local wh = 255
			if ply:GetNWFloat('Perk2_Choose') != ply:GetNWFloat('Perk2') then
				wh = 0
			end
			surface.SetDrawColor(Color(wh,wh,wh,alpha))
			surface.SetMaterial(COD.Perks["Type2"][ply:GetNWFloat('Perk2_Choose')].icon)
			surface.DrawTexturedRect(ScrW()/2+62, ScrH()-100, 75, 75)

			draw.SimpleText(COD.Perks["Type2"][ply:GetNWFloat('Perk2_Choose')].name, "TDMG_SmallFont1", ScrW()/2+100, ScrH()-125, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		if unlocks == 1 then
			surface.SetDrawColor(Color(255,255,255,alpha))
			surface.SetMaterial(COD.Perks["Type1"][ply:GetNWFloat('Perk1_Choose')].icon)
			surface.DrawTexturedRect(ScrW()/2-50, ScrH()/2-300, 100, 100)

			draw.SimpleText(COD.Perks["Type1"][ply:GetNWFloat('Perk1_Choose')].name..COD.Language["hud_unlockmainperk"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2-200, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(COD.Perks["Type1"][ply:GetNWFloat('Perk1_Choose')].desc, "TDMG_SmallFont2", ScrW()/2, ScrH()/2-180, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		elseif unlocks == 2 then
			surface.SetDrawColor(Color(255,255,255,alpha))
			surface.SetMaterial(COD.Perks["Type2"][ply:GetNWFloat('Perk2_Choose')].icon)
			surface.DrawTexturedRect(ScrW()/2-50, ScrH()/2-300, 100, 100)

			draw.SimpleText(COD.Perks["Type2"][ply:GetNWFloat('Perk2_Choose')].name..COD.Language["hud_unlockhighperk"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2-200, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(COD.Perks["Type2"][ply:GetNWFloat('Perk2_Choose')].desc, "TDMG_SmallFont2", ScrW()/2, ScrH()/2-180, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end)
end

local function ShowAnnouncment(type)
	local str = ""
	local scale = 0
	local showing = true
	local origtext = 400
	if type == 1 then
		str = COD.Language["hud_invasion_1"]
	elseif type == 2 then
		str = COD.Language["hud_invasion_2"]
	end

	surface.SetFont("TDMG_Other_Big2")
	local width, height = surface.GetTextSize(str)

	origtext = origtext+(width-150)


	surface.PlaySound("tdmg/alert2.wav")

    timer.Simple(4, function()
        showing = false
    end)

    local w, h = ScrW(), ScrH()

    hook.Add("HUDPaint", "StartAnnShow", function()
        if showing then
            scale = math.min(scale+FrameTime()*5, 1)
        else
            scale = math.max(scale-FrameTime()*5, 0)
            if scale == 0 then
                hook.Remove("HUDPaint", "StartAnnShow")
            end
        end

        surface.SetDrawColor(0,150,0,200)
        surface.SetMaterial(annMat)
        surface.DrawTexturedRect(w/2-(origtext/2*scale), 200, origtext*scale, 150*scale)

        if scale == 1 then
			draw.SimpleText(str, "TDMG_Other_Big2", w/2-3, 265-3, Color(0,0,0,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str, "TDMG_Other_Big2", w/2, 265, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)
end

local speakerdelay = 0
function COD:SpeakerSay(sound)
	if !GetConVar("cod_announcer_enable"):GetBool() then return end

	local delay = speakerdelay
	local dur = SoundDuration(sound)+0.1

	speakerdelay = speakerdelay + dur

	timer.Simple(delay, function()
		surface.PlaySound(sound)
	end)
	timer.Simple(delay+dur, function()
		speakerdelay = speakerdelay - dur
	end)
end

local function DrawNewKillStreak(ksn)
	local alpha = 0
	local alphadeg = false
	timer.Simple(5, function()
		alphadeg = true
	end)

	COD:SpeakerSay(COD.Killstreaks[ksn].sound)

	hook.Add("HUDPaint", "TDMGKillstreakShow", function()
		if alphadeg then
			alpha = alpha-FrameTime()/0.005
		else
			alpha = math.Clamp(alpha+FrameTime()/0.002, 0, 255)
		end

		surface.SetDrawColor(20,150,20,alpha/2)
        surface.SetMaterial(gradient_mat2)
        surface.DrawTexturedRect(ScrW()/2-400, 250	, 800, 40)

		
		draw.SimpleText(COD.Killstreaks[ksn].name, "TDMG_MediumFont2", ScrW()/2, 255, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(COD.Language["hud_unlockkillstreak"], "TDMG_SmallFont1", ScrW()/2, 300, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(255,255,255,alpha)
        surface.SetMaterial(COD.Killstreaks[ksn].icon)
        surface.DrawTexturedRect(ScrW()/2-64, 120, 128, 128)

		if alpha <= 0 and alphadeg then
			hook.Remove("HUDPaint", "TDMGKillstreakShow")
		end
	end)
end

local function CanSee(pos1, pos2)
	local tr = util.TraceLine( {
		start = pos1,
		endpos = pos2,
		filter = function(ent) if ent:IsWorld() then return true end end,
	})
	return !tr.Hit
end

hook.Add("RenderScreenspaceEffects", "TDMHealth", function()
	local ply = LocalPlayer()
	local alpha = math.Clamp((ply:Health()/ply:GetMaxHealth())+0.2, 0.2, 1)

	if !ply:Alive() then
		alpha = 1
	end

	local tab = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = alpha,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}

	DrawColorModify(tab)
end)

hook.Add("HUDPaint", "TDMGHudTeammates", function()
	if not COD.HideHUD then
		for _, ply in ipairs(player.GetAll()) do
			if ply:Team() == LocalPlayer():Team() and !ply:GetNoDraw() and ply != LocalPlayer() and ply:Alive() then
				if ply:LookupBone("ValveBiped.Bip01_Head1") and CanSee(LocalPlayer():EyePos(), ply:EyePos()) then
					local pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))+Vector(0,0,20)
					pos = pos:ToScreen()

					surface.SetDrawColor(5,155,255)
					surface.SetMaterial(tm_mat)
					surface.DrawTexturedRect(pos.x-12, pos.y-12, 24, 24)
					draw.SimpleText(ply:Nick(), "TDMG_SmallFont2", pos.x, pos.y-32, Color(5,105,205), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					if ply:IsDowned() then
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(rev_mat)
						surface.DrawTexturedRect(pos.x-16, pos.y-16, 32, 32)
					end
				end
			end
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables", "TDMGHudPackages", function()
	for _, p in ipairs(ents.FindByClass("tdm_package")) do
		local float = p:GetNWFloat('Item')
        if float > 0 and p:GetNWEntity('Owner') == LocalPlayer() then
            render.SetMaterial(COD.Killstreaks[float].icon)
            render.DrawSprite(p:GetPos()+Vector(0,0,40), 16, 16, color_white)
        end
	end
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ply:Alive() and IsValid(wep) and wep:GetClass() == "tdm_radio" and wep:GetNWBool('drawarrow') then
		local tr = ply:GetEyeTrace().HitPos

		local tr2 = util.TraceLine({
			start = tr,
			endpos = tr+Vector(0,0,99999),
			filter = function( ent ) return ( ent:GetClass() == "prop_static" ) end,
		})
		if tr2.HitSky then
			render.SetMaterial(arrow_mat)
			render.DrawQuadEasy(tr+Vector(0,0,32), -ply:GetAimVector(), 16, 16, color_white1, 180)
			local dlight = DynamicLight(ply:EntIndex())
			if dlight then
				dlight.pos = tr
				dlight.r = 255
				dlight.g = 255
				dlight.b = 255
				dlight.brightness = 0.5
				dlight.Decay = 256
				dlight.Size = 64
				dlight.DieTime = CurTime() + 0.1
			end
		else
			render.SetMaterial(arrow_mat)
			render.DrawQuadEasy(tr+Vector(0,0,32), -ply:GetAimVector(), 16, 16, color_red2, 180)
			local dlight = DynamicLight(ply:EntIndex())
			if dlight then
				dlight.pos = tr
				dlight.r = 200
				dlight.g = 0
				dlight.b = 0
				dlight.brightness = 0.5
				dlight.Decay = 256
				dlight.Size = 64
				dlight.DieTime = CurTime() + 0.1
			end
		end
	end
end)

local carepackagepickupprogress = 0
hook.Add("HUDPaint", "TDMGHud", function()
    local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()

	--care package pickup--
	
	if IsValid(tr.Entity) and ply:Alive() and tr.Entity:GetClass() == "tdm_package" and tr.HitPos:Distance(ply:GetPos()) < 64 then
		if ply:KeyDown(IN_USE) and tr.Entity:GetNWEntity('Owner') != ply then
			carepackagepickupprogress = carepackagepickupprogress + FrameTime()/5
		elseif ply:KeyDown(IN_USE) and tr.Entity:GetNWEntity('Owner') == ply then
			carepackagepickupprogress = carepackagepickupprogress + FrameTime()/1
		else
			carepackagepickupprogress = 0
		end
		if carepackagepickupprogress > 0 then
			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(ScrW()/2-125, ScrH()/1.75, 250, 15)

			surface.SetDrawColor(220,220,220,200)
			surface.DrawRect(ScrW()/2-125+2, ScrH()/1.75+2, 246*(carepackagepickupprogress/1), 11)
			if carepackagepickupprogress > 1 then
				carepackagepickupprogress = 0
				net.Start("COD.PickupCarePackage")
				net.WriteEntity(tr.Entity)
				net.SendToServer()
			end
		else
			local float = tr.Entity:GetNWFloat('Item')
			if float > 0 and tr.Entity:GetNWEntity('Owner') == LocalPlayer() then
				draw.SimpleText(COD.Language["hud_package"]..COD.Killstreaks[float].name, "TDMG_MediumFont1", ScrW()/2, ScrH()/1.75, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(COD.Language["hud_fullpackage"], "TDMG_MediumFont1", ScrW()/2, ScrH()/1.75, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	else
		carepackagepickupprogress = 0
	end

	if COD.HideHUD then return end

    if ply:Alive() then
		---blood overlay---
		
		if ply:GetNWBool('jugger') then
			surface.SetDrawColor(color_white1)
			surface.SetMaterial(jug_mat)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end

		if not ply:IsDowned() and ply:Alive() then
			local tr = ply:GetEyeTrace()
			local ent = tr.Entity
			local dist = ply:EyePos():DistToSqr(tr.HitPos) < 5000
			if ent:IsPlayer() and dist and ent:IsDowned() and ply:Team() == ent:Team() then
				if ply:KeyDown(IN_USE) then
					draw.SimpleText(COD.Language["hud_revive"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2+100, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					revtime = revtime + FrameTime()/3
					surface.SetDrawColor(color_grey2)
					surface.DrawRect(ScrW()/2-100, ScrH()/2+110, 200, 24)
			
					surface.SetDrawColor(color_grey1)
					surface.DrawRect(ScrW()/2-98, ScrH()/2+112, 196*(math.min(revtime, 1)/1), 20)
				else
					draw.SimpleText(COD.Language["hud_torevive"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2+115, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					revtime = 0
				end
			end
		end

		if ply:Health() < 80 and not ply:IsDowned() then
			local alpha = (255*(ply:Health()/ply:GetMaxHealth())*-1)+255
			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(blood_mat)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

			surface.SetDrawColor(100,0,0,alpha/4)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		elseif ply:IsDowned() then
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(blood_mat)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

			surface.SetDrawColor(100,0,0,50)
			surface.DrawRect(0, 0, ScrW(), ScrH())

			local times = ply:GetNWFloat('DownedTime')-CurTime()+0.5
			local allowedselfrevive = COD.DataTable["Gamemode"] != 3
			if ply:IsDowned() and IsValid(ply:GetNWEntity('Reviver')) then
				draw.SimpleText(COD.Language["hud_reviver"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2+100, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				revtime = revtime + FrameTime()/3
				surface.SetDrawColor(color_grey2)
				surface.DrawRect(ScrW()/2-100, ScrH()/2+110, 200, 24)
		
				surface.SetDrawColor(color_grey1)
				surface.DrawRect(ScrW()/2-98, ScrH()/2+112, 196*(math.min(revtime, 1)/1), 20)
			elseif ply:KeyDown(IN_USE) and ply:IsDowned() and !IsValid(ply:GetNWEntity('Reviver')) and allowedselfrevive then
				draw.SimpleText(COD.Language["hud_selfrevive"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2+100, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				revtime = revtime + FrameTime()/5.5
				surface.SetDrawColor(color_grey2)
				surface.DrawRect(ScrW()/2-100, ScrH()/2+110, 200, 24)
		
				surface.SetDrawColor(color_grey1)
				surface.DrawRect(ScrW()/2-98, ScrH()/2+112, 196*(math.min(revtime, 1)/1), 20)
			elseif !ply:KeyDown(IN_USE) and ply:IsDowned() and !IsValid(ply:GetNWEntity('Reviver')) and allowedselfrevive then
				draw.SimpleText(COD.Language["hud_toselfrevive"], "TDMG_SmallFont1", ScrW()/2, ScrH()/2+115, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				revtime = 0
			end
			if ply:IsDowned() then
				draw.SimpleText(string.FormattedTime(math.max(times, 0), "%02i:%02i" ), "TDMG_MediumFont2", ScrW()/2, ScrH()/2+250, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
		end
		
        ---left bottom corner---

        surface.SetDrawColor(color_white2)
        surface.SetMaterial(gradient_mat)
        surface.DrawTexturedRect(35, ScrH()-135, 400, 80)

        surface.SetDrawColor(color_grey2)
        surface.DrawRect(50, ScrH()-100, 200, 6)

        surface.SetDrawColor(color_grey1)
        surface.DrawRect(50, ScrH()-100, 200*(ply:Health()/ply:GetMaxHealth()), 6)

		if ply:Armor() > 0 then
			surface.SetDrawColor(color_blue2)
			surface.DrawRect(50, ScrH()-105, 200*(ply:Armor()/ply:GetMaxArmor()), 6)
		end

        draw.SimpleText("+"..ply:Health(), "TDMG_MediumFont1", 48, ScrH()-90, color_grey1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local teamcolor = color_grey1
		if ply:Team() == 2 then
			teamcolor = team_color2
		elseif ply:Team() == 1 then
			teamcolor = team_color1
		end

        draw.SimpleText(ply:Nick(), "TDMG_SmallFont1", 48, ScrH()-110, teamcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

        ---right bottom corner---

        surface.SetDrawColor(color_white2)
        surface.SetMaterial(gradient_mat)
        surface.DrawTexturedRectRotated(ScrW()-160, ScrH()-95, 240, 80, 180)

        local wep = ply:GetActiveWeapon()

        if IsValid(wep) then
            draw.SimpleText(wep:GetPrintName(), "TDMG_SmallFont1", ScrW()-50, ScrH()-110, color_yellow1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

			if wep.DrawAmmo then
				local clip = wep:Clip1()
				local ammocount = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
				local clipcolor = color_grey1
				local ammocolor = color_grey1
				if clip < 1 then
					clipcolor = color_red1
				end
				if ammocount < 1 then
					ammocolor = color_red1
				end
				draw.SimpleText(clip, "TDMG_MediumFont1", ScrW()-75, ScrH()-75, clipcolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(ammocount, "TDMG_SmallFont2", ScrW()-50, ScrH()-75, ammocolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end
        else
            draw.SimpleText("Hands", "TDMG_SmallFont1", ScrW()-50, ScrH()-110, color_yellow1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end

		for i = 1, ply:GetNWFloat('FragGrenades') do
			surface.SetDrawColor(color_white)
			surface.SetMaterial(he_mat)
			surface.DrawTexturedRect(ScrW()-75-(8*i), ScrH()-42, 32, 32)
		end

		for i = 1, ply:GetNWFloat('FlashGrenades') do
			surface.SetDrawColor(color_white)
			surface.SetMaterial(flash_mat)
			surface.DrawTexturedRect(ScrW()-150-(8*i), ScrH()-42, 32, 32)
		end

        ---killstreaks panel---

		local tab = COD.Killstreaks 
		local ks1 = ply:GetNWFloat('KillStreak1')
		local ks2 = ply:GetNWFloat('KillStreak2')
		local ks3 = ply:GetNWFloat('KillStreak3')
		local ks4 = ply.KillstreakOthers

		if ks1 > 0 or ks2 > 0 or ks3 > 0 then
			surface.SetDrawColor(color_white2)
			surface.SetMaterial(gradient_mat)
			surface.DrawTexturedRectRotated(ScrW()-90, ScrH()/2, 100, 360, 180)

			if ks1 > 0 then		
				if ply:GetNWBool('KillStreak1_Gave') and not ply:GetNWBool('KillStreak1_Used') then
					surface.SetDrawColor(color_green1)
					surface.DrawRect(ScrW()-95, ScrH()/2-150, 48, 48)
				end

				surface.SetDrawColor(color_white1)
				surface.SetMaterial(tab[ks1].icon)
				surface.DrawTexturedRect(ScrW()-95, ScrH()/2-150, 48, 48)

				if tab[ks1].kills <= ply:GetNWFloat('KillsP') or ply:GetNWBool('KillStreak1_Gave') then
					draw.SimpleText("✔", "TDMG_SmallFont1", ScrW()-70, ScrH()/2-100, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText(tab[ks1].kills - ply:GetNWFloat('KillsP') , "TDMG_SmallFont1", ScrW()-70, ScrH()/2-100, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			if ks2 > 0 then
				if ply:GetNWBool('KillStreak2_Gave') and not ply:GetNWBool('KillStreak2_Used') then
					surface.SetDrawColor(color_green1)
					surface.DrawRect(ScrW()-95, ScrH()/2-24, 48, 48)
				end

				surface.SetDrawColor(color_white1)
				surface.SetMaterial(tab[ks2].icon)
				surface.DrawTexturedRect(ScrW()-95, ScrH()/2-24, 48, 48)

				if tab[ks2].kills <= ply:GetNWFloat('KillsP') or ply:GetNWBool('KillStreak2_Gave') then
					draw.SimpleText("✔", "TDMG_SmallFont1", ScrW()-70, ScrH()/2+24, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText(tab[ks2].kills - ply:GetNWFloat('KillsP') , "TDMG_SmallFont1", ScrW()-70, ScrH()/2+24, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			if ks3 > 0 then
				if ply:GetNWBool('KillStreak3_Gave') and not ply:GetNWBool('KillStreak3_Used') then
					surface.SetDrawColor(color_green1)
					surface.DrawRect(ScrW()-95, ScrH()/2+105, 48, 48)
				end

				surface.SetDrawColor(color_white1)
				surface.SetMaterial(tab[ks3].icon)
				surface.DrawTexturedRect(ScrW()-95, ScrH()/2+105, 48, 48)

				if tab[ks3].kills <= ply:GetNWFloat('KillsP') or ply:GetNWBool('KillStreak3_Gave') then
					draw.SimpleText("✔", "TDMG_SmallFont1", ScrW()-70, ScrH()/2+155, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					draw.SimpleText(tab[ks3].kills - ply:GetNWFloat('KillsP') , "TDMG_SmallFont1", ScrW()-70, ScrH()/2+155, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			if istable(ks4) and #ks4 > 0 then
				local num = ks4[#ks4]

				surface.SetDrawColor(color_green1)
				surface.DrawRect(ScrW()-95, ScrH()/2-240, 48, 48)

				surface.SetDrawColor(color_white1)
				surface.SetMaterial(tab[num].icon)
				surface.DrawTexturedRect(ScrW()-95, ScrH()/2-240, 48, 48)
			end

			draw.SimpleText(COD.Language["hud_kills"]..ply:GetNWFloat('KillsP'), "TDMG_SmallFont2", ScrW()-45, ScrH()/2-175, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end
	else
		revtime = 0
    end

	
    ---left upper corner---

    local teamred, teamblue, teammax = COD.DataTable["Team1_Kills"], COD.DataTable["Team2_Kills"], COD.DataTable["MaxKills"]
	local offset = 250
	if !ply:Alive() then
		offset = 0
	end

	if ply:Team() == 1 then
		surface.SetDrawColor(color_grey2)
		surface.DrawRect(50, 50+offset, 210, 60)
	
		surface.SetDrawColor(color_grey2) --Team RED
		surface.DrawRect(60, 60+offset, 190, 10)
	
		surface.SetDrawColor(team_color1) --Team RED
		surface.DrawRect(60, 60+offset, 190*(teamred/teammax), 10)
	
		surface.SetDrawColor(color_grey2) --Team BLUE
		surface.DrawRect(60, 90+offset, 190, 10)
		
		surface.SetDrawColor(team_color2) --Team BLUE
		surface.DrawRect(60, 90+offset, 190*(teamblue/teammax), 10)
	
		draw.SimpleText(COD.Language["scoreboard_score"], "TDMG_SmallFont1", 260, 25+offset, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
		draw.SimpleText(teamred, "TDMG_MediumFont1", 48, 50+offset, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
		draw.SimpleText(teamblue, "TDMG_MediumFont1", 48, 84+offset, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
	elseif ply:Team() == 2 then
		surface.SetDrawColor(color_grey2)
		surface.DrawRect(50, 50+offset, 210, 60)
	
		surface.SetDrawColor(color_grey2) --Team RED
		surface.DrawRect(60, 60+offset, 190, 10)
	
		surface.SetDrawColor(team_color2) --Team RED
		surface.DrawRect(60, 60+offset, 190*(teamblue/teammax), 10)
	
		surface.SetDrawColor(color_grey2) --Team BLUE
		surface.DrawRect(60, 90+offset, 190, 10)
		
		surface.SetDrawColor(team_color1) --Team BLUE
		surface.DrawRect(60, 90+offset, 190*(teamred/teammax), 10)
	
		draw.SimpleText(COD.Language["scoreboard_score"], "TDMG_SmallFont1", 260, 25+offset, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
		draw.SimpleText(teamblue, "TDMG_MediumFont1", 48, 50+offset, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
		draw.SimpleText(teamred, "TDMG_MediumFont1", 48, 84+offset, color_grey1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
	end

    ---upper center---

    local timesec = COD.TimeMatch-CurTime()
    local time = string.FormattedTime( timesec, "%02i:%02i" )
    if timesec > 0 then
        draw.SimpleText(time, "TDMG_SmallFont1", ScrW()/2, 25, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
end)

local function GiveHitMarker(kill)
	local alpha = 255	
	if not kill then
		surface.PlaySound("tdmg/impacts/hit.wav")
		hook.Add("HUDPaint", "TDMGHitsMark", function()
			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(hm_mat)
			surface.DrawTexturedRect(ScrW()/2-32, ScrH()/2-32, 64, 64)
			alpha = alpha - FrameTime()*500
			if alpha <= 0 then
				hook.Remove("HUDPaint", "TDMGHitsMark")
			end
		end)
	else
		surface.PlaySound("tdmg/impacts/kill.wav")
		hook.Add("HUDPaint", "TDMGHitsMark", function()
			surface.SetDrawColor(220,40,40,alpha)
			surface.SetMaterial(hm_mat)
			surface.DrawTexturedRect(ScrW()/2-32, ScrH()/2-32, 64, 64)
			alpha = alpha - FrameTime()*500
			if alpha <= 0 then
				hook.Remove("HUDPaint", "TDMGHitsMark")
			end
		end)
	end
end

local function GiveHitMarkerArmor(break1)
	local alpha = 255	
	if not break1 then
		surface.PlaySound("tdmg/impacts/hitarmor ("..math.random(1,2)..").wav")
		hook.Add("HUDPaint", "TDMGHitsMark2", function()
			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(ar1_mat)
			surface.DrawTexturedRect(ScrW()/2+40, ScrH()/2+40, 32, 32)
			alpha = alpha - FrameTime()*600
			if alpha <= 0 then
				hook.Remove("HUDPaint", "TDMGHitsMark2")
			end
		end)
	else
		surface.PlaySound("tdmg/impacts/armorbreak.wav")
		hook.Add("HUDPaint", "TDMGHitsMark2", function()
			surface.SetDrawColor(255,255,255,alpha)
			surface.SetMaterial(ar2_mat)
			surface.DrawTexturedRect(ScrW()/2+50, ScrH()/2+50, 32, 32)
			alpha = alpha - FrameTime()*600
			if alpha <= 0 then
				hook.Remove("HUDPaint", "TDMGHitsMark2")
			end
		end)
	end
end

local function GiveHitMarkerDowned()
	local alpha = 255	
	hook.Add("HUDPaint", "TDMGHitsMark2", function()
		surface.SetDrawColor(255,255,255,alpha)
		surface.SetMaterial(dwn_mat)
		surface.DrawTexturedRect(ScrW()/2+24, ScrH()/2+16, 64, 64)
		alpha = alpha - FrameTime()*400
		if alpha <= 0 then
			hook.Remove("HUDPaint", "TDMGHitsMark2")
		end
	end)
end

local function bpla()
	COD.UAV_Active = true
    timer.Create("BPLADeleteTime", 45, 1, function()
		COD.UAV_Active = false
    end)
end

local function mbpla()
	COD.Adv_UAV_Active = true
    timer.Create("BPLADeleteTime2", 90, 1, function()
		COD.Adv_UAV_Active = false
    end)
end

local function cbpla()
	COD.Counter_UAV_Active = true
    timer.Create("BPLADeleteTime3", 60, 1, function()
		COD.Counter_UAV_Active = false
    end)
end

local function AirPatrol(bool)
	if bool then
		timer.Remove("BPLADeleteTime")
		timer.Remove("BPLADeleteTime2")
		COD.Adv_UAV_Active = false
		COD.UAV_Active = false
	else
		timer.Remove("BPLADeleteTime3")
		COD.Counter_UAV_Active = false
	end
end

local function DrawPlayerKillStreakUse(killstreak, ply)
	local tab = COD.Killstreaks[killstreak]
	local w = 0
	local upper = true
	local nick = ply:Nick()
	timer.Simple(4, function()
		upper = false
	end)
	hook.Add("HUDPaint", "DrawPlayerKillStreakUse", function()
		if upper then
			w = math.Clamp(w-FrameTime()/0.001, -450, 0)
		else
			w = math.Clamp(w+FrameTime()/0.001, -450, 0)
			if w >= 0 then
				hook.Remove("HUDPaint", "DrawPlayerKillStreakUse")
			end
		end
		if IsValid(ply) then
			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(ScrW()+w, 100, 350, 100)
			
			surface.SetDrawColor(25,150,0,200)
			surface.DrawRect(ScrW()+w, 125, 350, 40)

			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(tab.icon)
			surface.DrawTexturedRect(ScrW()+15+w, 125, 40, 40)
			
			draw.SimpleText(COD.Language["hud_killstreak"], "TDMG_SmallFont2", ScrW()+175+w, 112, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(tab.name, "TDMG_MediumFont1", ScrW()+70+w, 160, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(nick, "TDMG_SmallFont1", ScrW()+10+w, 190, team.GetColor(ply:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end
    end)
end

local function ExplodeNuke()
	local sec = 10

	timer.Simple(5, function()
		hook.Add("HUDPaint", "DrawPlayerKillStreakUseNuke", function( ply, pos, angles, fov )
			sec = sec-FrameTime()

			surface.SetDrawColor(0,0,0,240)
			surface.DrawRect(0, 200, ScrW(), 100)

			draw.SimpleText(COD.Language["hud_nuke"], "TDMG_MediumFont2", ScrW()/2, 225, Color(200,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(math.Round(sec, 1), "TDMG_LargeFont1", ScrW()/2, 275, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end)
	end)

	LocalPlayer():EmitSound("ambient/alarms/combine_bank_alarm_loop1.wav")

	timer.Simple(15, function()
		LocalPlayer():StopSound("ambient/alarms/combine_bank_alarm_loop1.wav")
		hook.Remove("HUDPaint", "DrawPlayerKillStreakUseNuke")
		local plusthis = 0
		hook.Add("RenderScreenspaceEffects", "NukeFuckTDM", function()	
			plusthis = math.min(plusthis+FrameTime()*0.1, 1)
			local tab = {
				[ "$pp_colour_addr" ] = plusthis,
				[ "$pp_colour_addg" ] = plusthis/2,
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = plusthis/4,
				[ "$pp_colour_contrast" ] = 1,
				[ "$pp_colour_colour" ] = 1+plusthis/3,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
			}
			DrawColorModify( tab )
		end)
		timer.Simple(4, function()
			hook.Remove("RenderScreenspaceEffects", "NukeFuckTDM")
			COD:PlayCutscene(4, "tdmg/nuke/cutscene.wav", 30, true)
		end)
		surface.PlaySound("ambient/explosions/explode_6.wav")
	end)
end

net.Receive("COD.ShowAnnouncment", function()
	local type = net.ReadFloat()
	ShowAnnouncment(type)
end)

net.Receive("COD.OtherKillstreak", function()
	local tab = net.ReadTable()
	LocalPlayer().KillstreakOthers = tab
end)

net.Receive("COD.HitMarkEnemy", function()
	local bool = net.ReadBool()
	local isself = net.ReadBool()
	if not isself then
		GiveHitMarker(bool)
	else
		LocalPlayer():EmitSound("tdmg/impacts/dmgp ("..math.random(1,6)..").wav")
	end
end)

net.Receive("COD.HitMarkEnemy2", function()
	local break1 = net.ReadBool()
	local downed = net.ReadBool()
	if not downed then
		GiveHitMarkerArmor(break1)
	else
		GiveHitMarkerDowned()
	end
end)

net.Receive("COD.ScoreMarkEnemy", function()
	local type = net.ReadFloat()
	local message = COD.Language["hud_scoreadd_1"]
	if type == 1 then
		message = COD.Language["hud_scoreadd_2"]
	elseif type == 2 then
		message = COD.Language["hud_scoreadd_3"]
	elseif type == 3 then
		message = COD.Language["hud_scoreadd_4"]
	elseif type == 4 then
		message = COD.Language["hud_scoreadd_5"]
	elseif type == 5 then
		message = COD.Language["hud_scoreadd_6"]
	elseif type == 6 then
		message = COD.Language["hud_scoreadd_7"]
	elseif type == 7 then
		message = COD.Language["hud_message_1"]
	elseif type == 8 then
		message = COD.Language["hud_message_2"]
	elseif type == 9 then
		message = COD.Language["hud_message_3"]
	elseif type == 10 then
		message = COD.Language["hud_domination_4"]
	elseif type == 11 then
		message = COD.Language["hud_domination_5"]
	end
	DrawScoreGiving(message)
end)

net.Receive("COD.AirPatrol", function()
	local bool = net.ReadBool()
	AirPatrol(bool)
end)

net.Receive("COD.KillstreaksHUD", function()
	local type = net.ReadFloat()
	DrawNewKillStreak(type)
end)

net.Receive("COD.KillstreaksHUD2", function()
	local type = net.ReadFloat()
	local ent = net.ReadEntity()
	DrawPlayerKillStreakUse(type, ent)
end)

net.Receive("COD.EndingHUD", function()
	local bool = net.ReadBool()
	DrawWinScreen(bool)
end)

net.Receive("COD.CounterUAVStart", cbpla)

net.Receive("COD.UAVStart", function()
	local bool = net.ReadBool()
	if bool then
		mbpla()
	else
		bpla()
	end
end)

net.Receive("COD.StartMatchHUD", DrawStartScreen)

net.Receive("COD.TimerShow", function()
	local float = net.ReadFloat()
	DrawTimerScreen(float)
end)

net.Receive("COD.NukeEffect", ExplodeNuke)

net.Receive("COD.KillNick", DrawKilled)

net.Receive("COD.PerksShow", function()
	local type = net.ReadFloat()
	DrawPerks(type)
end)

net.Receive("COD.SendData", function()
	local tab = net.ReadTable()
	COD.DataTable = tab
end)

hook.Add("PreDrawOutlines", "Perk1Vis", function()
	local ply = LocalPlayer()
	if ply:GetNWFloat('Perk1') == 2 then
		local tab = {}
		for _, ent in ipairs(ents.GetAll()) do
			if !ent:IsPlayer() and ent:GetNWFloat('Team') > 0 and ent:GetNWFloat('Team') != ply:Team() or ent:GetClass() == "tdm_package" and ent:GetPos():DistToSqr(ply:GetPos()) < 750000 then
				table.insert(tab, ent)
			end
		end
		outline.Add(tab, Color(240,40,20), 1)
	end
end)

local menus = false
local showhint1 = true
local time1 = CurTime()+30
hook.Add("HUDPaint", "CheckControlGUI", function()
	local ply = LocalPlayer()
	menus = input.IsKeyDown(KEY_INSERT)
	if ply:KeyDown(IN_FORWARD) and time1 < CurTime() or menus then
		showhint1 = false
	end
	if menus then
		surface.SetDrawColor(0,0,0,230)
		surface.DrawRect(ScrW()/2-200, ScrH()-195, 400, 200)

		surface.SetDrawColor(255,255,255)
		surface.DrawOutlinedRect(ScrW()/2-200, ScrH()-195, 400, 200, 2)

		draw.SimpleText(COD.Language["contols_main"], "TDMG_MediumFont2", ScrW()/2, ScrH()-190, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText(COD.Language["contols_f1"], "TDMG_SmallFont1", ScrW()/2, ScrH()-150, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(COD.Language["contols_e"], "TDMG_SmallFont1", ScrW()/2, ScrH()-130, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(COD.Language["contols_q"], "TDMG_SmallFont1", ScrW()/2, ScrH()-110, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(COD.Language["contols_v"], "TDMG_SmallFont1", ScrW()/2, ScrH()-90, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(COD.Language["contols_0"], "TDMG_SmallFont1", ScrW()/2, ScrH()-70, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(COD.Language["contols_tab"], "TDMG_SmallFont1", ScrW()/2, ScrH()-50, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	if showhint1 then
		surface.SetDrawColor(0,0,0,230)
		surface.DrawRect(ScrW()/2-250, ScrH()/1.5, 500, 40)

		draw.SimpleText(COD.Language["contols_open"], "TDMG_MediumFont1", ScrW()/2, ScrH()/1.5+4, color_grey1, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
end)