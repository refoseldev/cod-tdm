AddCSLuaFile()

require("mw_math")
require("mw_utils")

if (SERVER) then
    return
end

local shotgunXhairTickMaterial = Material("mg/shotgunxhairtick")
local normalXhairTickMaterial = Material("mg/normalxhairtick")
local crosshairDotMaterial = Material("mg/crosshairdot")

local function drawBinding(x, y, bind)
	local key = string.upper(input.LookupBinding(bind) || MWBLTL.Get("HUD_Key_NotBound")..bind)
	local scale = ScrH() / 1080
	local size = 26 * scale

	surface.SetFont("mgbase_command")
	local w = math.max(surface.GetTextSize(key) + 10 * scale, size)

	draw.RoundedBox(4, x - (w * 0.5 - 1), y - (size * 0.5 * scale - 1), w, size * scale, Color(0, 0, 0, 150))
	draw.SimpleText(key, "mgbase_command", x, y, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	return w * 0.5 + (5 * scale)
end

local function drawBaseBinding(x, y, bind)
	local bindValue = GetConVar(bind):GetInt()
	local key = string.upper(bindValue != 0 && input.GetKeyName(bindValue) || MWBLTL.Get("HUD_Key_NotBound")..bind)
	local scale = ScrH() / 1080
	local size = 26 * scale

	surface.SetFont("mgbase_command")
	local w = math.max(surface.GetTextSize(key) + 10 * scale, size)

	draw.RoundedBox(4, x - (w * 0.5 - 1), y - (size * 0.5 * scale - 1), w, size * scale, Color(0, 0, 0, 150))
	draw.SimpleText(key, "mgbase_command", x, y, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	return w * 0.5 + (5 * scale)
end


function SWEP:DrawHUD()
	if (self:GetOwner():InVehicle()) then
		return
	end

	if (GetConVar("mgbase_debug_crosshair"):GetBool()) then
		--draw.SimpleText("+", "DermaDefault", ScrW() * 0.5, ScrH() * 0.5, Color(0, 255, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(0, 255, 0, 127)
		surface.DrawLine(ScrW() * 0.5 - 50, ScrH() * 0.5, ScrW() * 0.5 + 50, ScrH() * 0.5)
		surface.DrawLine(ScrW() * 0.5, ScrH() * 0.5 - 50, ScrW() * 0.5, ScrH() * 0.5 + 50)

		--[[--3x
		draw.SimpleText("3x", "DermaDefault", ScrW() * 0.5 - (90 * 1.44), ScrH() * 0.5 - (90 * 1.44), Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		surface.DrawCircle(ScrW() * 0.5, ScrH() * 0.5, 180, 0, 255, 0, 127)

		--4x
		draw.SimpleText("4x", "DermaDefault", ScrW() * 0.5 - (125 * 1.44), ScrH() * 0.5 - (125 * 1.44), Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		surface.DrawCircle(ScrW() * 0.5, ScrH() * 0.5, 250, 0, 255, 0, 127)

		--10x
		draw.SimpleText("10x", "DermaDefault", ScrW() * 0.5 - (165 * 1.44), ScrH() * 0.5 - (165 * 1.44), Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		surface.DrawCircle(ScrW() * 0.5, ScrH() * 0.5, 330, 0, 255, 0, 127)]]

		local att = self:GetViewModel():GetAttachment(mw_utils.LookupAttachmentCached(self:GetViewModel(), self.ViewModelOffsets.Aim.AlignAttachment || "align"))
		
		if (att != nil) then
			local pos = att.Pos:ToScreen()
			surface.SetDrawColor(255, 0, 0, 127)
			surface.DrawLine(pos.x - 50, pos.y, pos.x + 50, pos.y)
			surface.DrawLine(pos.x, pos.y - 50, pos.x, pos.y + 50)

			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text1"), "DermaDefault", ScrW() * 0.5, ScrH() * 0.75, Color(255, 50, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text2"), "DermaDefault", ScrW() * 0.5, ScrH() * 0.75 + 30, Color(255, 50, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end

		if (self:GetSight() != nil) then
			att = self:GetSight().m_Model:GetAttachment(mw_utils.LookupAttachmentCached(self:GetSight().m_Model, self:GetSight().Reticle.Attachment))
			pos = att.Pos:ToScreen()
			surface.SetDrawColor(0, 150, 255, 255)
			surface.DrawLine(pos.x - 25, pos.y, pos.x + 25, pos.y)
			surface.DrawLine(pos.x, pos.y - 25, pos.x, pos.y + 25)

			if (self:GetSight().ReticleHybrid != nil) then
				att = self:GetSight().m_Model:GetAttachment(mw_utils.LookupAttachmentCached(self:GetSight().m_Model, self:GetSight().ReticleHybrid.Attachment))
				pos = att.Pos:ToScreen()
				surface.SetDrawColor(0, 150, 255, 255)
				surface.DrawLine(pos.x - 25, pos.y, pos.x + 25, pos.y)
				surface.DrawLine(pos.x, pos.y - 25, pos.x, pos.y + 25)
			end
		end

		att = self:GetViewModel():GetAttachment(mw_utils.LookupAttachmentCached(self:GetViewModel(), self.ViewModelOffsets.Aim.AlignAttachment || "align"))
		
		if (att != nil) then
			--pixel difference
			local pos = (att.Pos + att.Ang:Forward() * 1000):ToScreen()
				
			local diffX, diffY = (pos.x - (ScrW() * 0.5)), (pos.y - (ScrH() * 0.5))
			local centerX, centerY = ScrW() * 0.5, ScrH() * 0.5
			surface.SetDrawColor(255, 0, 255, 255)
			surface.DrawLine(centerX, centerY, centerX + (diffX * 10), centerY + (diffY * 10))

			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text3")..math.Round(diffX, 2)..", "..math.Round(diffY, 2), "DermaDefault", ScrW() * 0.25, ScrH() * 0.25, Color(255, 0, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text4"), "DermaDefault", ScrW() * 0.25, ScrH() * 0.25 + 20, Color(255, 0, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end
	else
		if (GetConVar("mgbase_hud_xhair"):GetBool() && !self:HasFlag("Customizing")) then
			self:Crosshair()
		end
	end

	if (GetConVar("mgbase_hud_firemode"):GetBool() && !self:HasFlag("Customizing")) then
		self:DrawFiremode()
	end

	self:DrawCommands()
end

local lastIndex = 0
local transitionAnimation = 0

function SWEP:DrawFiremode()
	if (self:HasFlag("Holstering")) then
		return
	end
	
	-- current firemode (outline commented out)
	local x,y = ScrW() * 0.5, ScrH() * 0.8
	local scale = ScrH() / 1080

	if (!self:HasFlag("Lowered")) then
		local index = self:GetFiremode()

		transitionAnimation = math.min(transitionAnimation + 10 * RealFrameTime(), 1)

		if (lastIndex != index) then
			transitionAnimation = 0
			lastIndex = index
		end

		local name = string.upper(self.Firemodes[index].Name)
		draw.SimpleTextOutlined(name, "mgbase_firemode", x, y + (24 * (1 - transitionAnimation) * scale), Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))

		-- next firemode
		if (self.Firemodes[index + 1]) then
			index = index + 1
		else
			index = 1
		end

		if (#self.Firemodes > 1) then
			drawBaseBinding(x, y - 30, "mgbase_binds_firemode")
		end
		
		if (self:GetFiremode() != index) then
			name = string.upper(self.Firemodes[index].Name)
			draw.SimpleText(name, "mgbase_firemode_alt", x, y + (24 * transitionAnimation * scale), Color(127, 127, 127, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		drawBaseBinding(x, y - 30, "mgbase_binds_safety")
		draw.SimpleTextOutlined("LOWERED", "mgbase_firemode", x, y, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
	end
end

local bipodIcon = Material("bipodicon")
local bipodDelta = 0

function SWEP:DrawBipod()
	if (!self:HasFlag("BipodDeployed")) then
		bipodDelta = 0
		return
	end

	bipodDelta = math.min(bipodDelta + RealFrameTime() * 5, 1)

	surface.SetAlphaMultiplier(bipodDelta)

	local mat = self:GetBipod().Icon
	surface.SetMaterial(bipodIcon)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(ScrW() * 0.5 - 15, ScrH() * 0.5 + 88 + (bipodDelta * 12), 32, 30)

	surface.SetAlphaMultiplier(1)
end

function SWEP:DrawCommands()
	local scale = ScrH() / 1080
	local x,y = ScrW() * 0.7, ScrH() * 0.5

	if (GetConVar("mgbase_hud_sights"):GetBool()) then
		surface.SetAlphaMultiplier(self:GetAimDelta())

		if ((self:GetSight() != nil && self:GetSight().ReticleHybrid != nil) || self:GetLaser() != nil) then
			local w = drawBaseBinding(x, y, "mgbase_binds_switchsights")
			draw.SimpleTextOutlined(": SWITCH AIM", "mgbase_commandSecondary", x + w, y, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
		end

		x,y = ScrW() * 0.5, ScrH() * 0.7

		if (self:GetSight() != nil && self:GetSight().Optic != nil && self:GetAimModeDelta() <= self.m_hybridSwitchThreshold && !self:GetOwner():KeyDown(IN_SPEED) && GetConVar("mgbase_sv_breathing"):GetInt() > 0) then
			local w = drawBinding(x, y, "+speed")
			draw.SimpleTextOutlined(MWBLTL.Get("HUD_Commands_Text2"), "mgbase_commandSecondary", x, y + (30 * scale), Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
		end

		surface.SetAlphaMultiplier(1)
	end

	if (GetConVar("mgbase_hud_flashlight"):GetBool() && self:GetFlashlightAttachment() != nil && !self:HasFlag("Customizing")) then
		surface.SetFont("mgbase_commandSecondary")
		local tw = surface.GetTextSize(MWBLTL.Get("HUD_Commands_Text3")) * 0.5
		x,y = ScrW() * 0.5 - tw - 7, ScrH() * 0.9 - 150

		--if (self:CanChangeAimMode()) then
		local w = drawBinding(x, y + 100, "impulse 100")
		draw.SimpleTextOutlined(MWBLTL.Get("HUD_Commands_Text3"), "mgbase_commandSecondary", x + w, y + 100, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
		--end
	end
end

function SWEP:CanDrawCrosshair()
	return !self:HasFlag("Reloading")
		&& !self:HasFlag("Sprinting")
		&& !self:HasFlag("Holstering")
		&& !self:HasFlag("Drawing")
		&& !self:HasFlag("Lowered")
		&& CurTime() >= self:GetNextInspectTime()
		--&& CurTime() > self:GetNextMeleeTime()
end

function SWEP:HUDShouldDraw(name)
	if (self:HasFlag("Customizing")) then
		return false
	end

	if (self:HasFlag("Aiming") && name == "CHUDQuickInfo") then
		return false
	end

	if (CurTime() < self:GetNextInspectTime() || self:HasFlag("StoppedInspectAnimation")) then
		return false
	end

	return true
end

function SWEP:DrawCrosshairSticks(x, y, cone)
	local aimDelta = 1 - self:GetAimDelta()

	surface.SetAlphaMultiplier(aimDelta)

	local crosshairAlpha = 200

	--dot
	local c = self:GetCone()
	local m = self.Cone.Max
	local h = self.Cone.Hip
	local dotDelta = (c - h) / (m - h) 
	if (m - h <= 0) then
		dotDelta = 0
	end

	local color = string.ToColor(GetConVar("mgbase_hud_xhaircolor"):GetString())
	surface.SetDrawColor(color.r, color.g, color.b, 200)
	local scale = math.ceil(ScreenScale(2)) -- leadup to appropriate scaling for crosshairs
	local size = math.max(scale - bit.band(scale, 1), 4)
	surface.SetAlphaMultiplier(aimDelta * (1 - dotDelta))
	surface.SetMaterial(crosshairDotMaterial)
	surface.DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)
	surface.SetAlphaMultiplier(aimDelta)

	if (self:CanDrawCrosshair()) then
		local dist = x - cone -- must be done here for accurate cone representation
		local drawRect = surface.DrawTexturedRectRotated
		local sizeW = size * 5
		local sizeH = size * 5

		surface.SetMaterial(normalXhairTickMaterial)

		if (self.Bullet.NumBullets > 1) then
			surface.SetMaterial(shotgunXhairTickMaterial)
		end

		--right stick
		drawRect(x - dist, y, sizeW, sizeH, 90)

		--left stick
		drawRect(x + dist, y, sizeW, sizeH, 270)

		--down stick
		drawRect(x, y - dist, sizeH, sizeW, 0)

		if (self.Primary.Automatic || self.Bullet.NumBullets > 1) then
			--up stick
			drawRect(x, y + dist, sizeH, sizeW, 180)
		end
	end

	surface.SetAlphaMultiplier(1)
	surface.SetDrawColor(255, 255, 255, 255)
end

function SWEP:Crosshair()
	local x, y = ScrW() * 0.5, ScrH() * 0.5
	local vec = EyePos() + (self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles()):Forward()
	local cone = math.floor((vec + ( self:GetCone() * 0.1 * (self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles()):Right() ) ):ToScreen().x)
	local pos = vec:ToScreen()

	if (Vector(x, 0, y):DistToSqr(Vector(pos.x, 0, pos.y)) > 2.25) then
		x,y = math.floor(pos.x), math.floor(pos.y)
	end

	self:DrawCrosshairSticks(x, y, cone)
	self:DrawBipod(x, y)
end
--FONTS

local function CreateFonts()
	local scale = ScrH() / 1080

	surface.CreateFont("mgbase_firemode", {
		font = "BioSansW05-Light",
		size = 30 * scale,
		weight = 0
	})

	surface.CreateFont("mgbase_statName", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0
	})

	surface.CreateFont("mgbase_stat", {
		font = "BioSansW05-Light",
		size = 22,
		weight = 0
	})

	surface.CreateFont("mgbase_control", {
		font = "BioSansW05-Light",
		size = 22,
		weight = 0
	})

	surface.CreateFont("mgbase_statPositive", {
		font = "BioSansW05-Light",
		size = 22,
		weight = 0,
		blursize = 2
	})

	surface.CreateFont("mgbase_firemode_alt", {
		font = "BioSansW05-Light",
		size = 24 * scale,
		weight = 0
	})

	surface.CreateFont("mgbase_attSlot", {
		font = "Conduit ITC",
		size = 24 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_attSlotMenu", {
		font = "Conduit ITC",
		size = 24,
		weight = 500
	})

	surface.CreateFont("mgbase_attSlotAttachmentInUse", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0
	})

	surface.CreateFont("mgbase_attSlotAttachmentInUse_IsCosmetic", {
		font = "Conduit ITC",
		size = 20,
		weight = 500
	})

	surface.CreateFont("mgbase_attSlotAttachmentInUse:hover", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0,
		blursize = 1
	})

	surface.CreateFont("mgbase_attSlotMenu:hover", {
		font = "Conduit ITC",
		size = 24,
		weight = 500,
		blursize  = 2
	})

	surface.CreateFont("mgbase_utilityButton", {
		font = "BioSansW05-Light",
		size = 32,
		weight = 0
	})

	surface.CreateFont("mgbase_utilityButton:hover", {
		font = "BioSansW05-Light",
		size = 32,
		weight = 0,
		blursize = 1
	})

	surface.CreateFont("mgbase_attSlotMenu", {
		font = "Conduit ITC",
		size = 24,
		weight = 500
	})

	surface.CreateFont("mgbase_attName", {
		font = "Conduit ITC",
		size = 24 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_attTitle", {
		font = "BioSansW05-Light",
		size = 60 * scale,
		weight = 0
	})

	surface.CreateFont("mgbase_attTitle_blur", {
		font = "BioSansW05-Light",
		size = 60 * scale,
		weight = 0,
		blursize = 3
	})

	surface.CreateFont("mgbase_attWeaponName", {
		font = "Conduit ITC",
		size = 36 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_command", {
		font = "BioSansW05-Light",
		size = 26 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_commandSecondary", {
		font = "BioSansW05-Light",
		size = 22 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_presetSpawnMethod", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0
	})

	surface.CreateFont("mgbase_presetSpawnMethod_child", {
		font = "BioSansW05-Light",
		size = 20,
		weight = 0
	})
end
hook.Add("OnScreenSizeChanged", "MW_UpdateFonts", CreateFonts)
CreateFonts()
