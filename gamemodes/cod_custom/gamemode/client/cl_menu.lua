local butbg_mat = Material("tdmg/hud/button_bg.png")
local grad_mat = Material("tdmg/hud/gradient.png")
local rnd_mat = Material("tdmg/hud/rnd.png")
local mainpanel = nil

CreateConVar("cod_music_enable", 1, FCVAR_ARCHIVE, "", 0, 1)
CreateConVar("cod_announcer_enable", 1, FCVAR_ARCHIVE, "", 0, 1)
CreateConVar("cod_killcam_enable", 1, FCVAR_ARCHIVE, "", 0, 1)
CreateConVar("cod_custom_music_enable", 0, FCVAR_ARCHIVE, "", 0, 1)

function COD:OpenSettingsMenu()
	if IsValid(mainpanel) then return end

	mainpanel = vgui.Create("DFrame")
	mainpanel:SetSize(ScrW(), ScrH())
	mainpanel:SetTitle("")
	mainpanel:SetDraggable(false)
	mainpanel:MakePopup()
	mainpanel:ShowCloseButton(false)
	mainpanel.OnRemove = function()
		COD.HideHUD = false
	end
	mainpanel.Paint = function(self, w, h) 
		surface.SetDrawColor(0,0,0,140)
		surface.DrawRect(0, 0, w, h)

		COD.HideHUD = true
	end

	local secpanel = vgui.Create("DPanel", mainpanel)
	secpanel:SetPos(100, 0)
	secpanel:SetSize(300, ScrH())
	secpanel.Paint = function(self, w, h)
		gui.HideGameUI()

		surface.SetDrawColor(0,0,0,220)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(COD.Language["main_menu_3"], "TDMG_Other_Big2", w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local scr1 = vgui.Create("DScrollPanel", secpanel)
	scr1:Dock(FILL)

	local main_menu_buttons = {
		{
			Name = COD.Language["main_menu_settings_1"],
			ConVar = "cod_music_enable",
			CustomDock = {150,5},
			ClickFunc = function(self)
				local bool = GetConVar("cod_music_enable"):GetBool()
				if bool then
					RunConsoleCommand("cod_music_enable", 0)
				else
					RunConsoleCommand("cod_music_enable", 1)
				end
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end,
		},
		{
			Name = COD.Language["main_menu_settings_cm"],
			ConVar = "cod_custom_music_enable",
			ClickFunc = function(self)
				local bool = GetConVar("cod_custom_music_enable"):GetBool()
				if bool then
					RunConsoleCommand("cod_custom_music_enable", 0)
				else
					RunConsoleCommand("cod_custom_music_enable", 1)
				end
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end,
		},
		{
			Name = COD.Language["main_menu_settings_2"],
			ConVar = "cod_announcer_enable",
			ClickFunc = function(self)
				local bool = GetConVar("cod_announcer_enable"):GetBool()
				if bool then
					RunConsoleCommand("cod_announcer_enable", 0)
				else
					RunConsoleCommand("cod_announcer_enable", 1)
				end
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end,
		},
		{
			Name = COD.Language["main_menu_settings_3"],
			ConVar = "cod_killcam_enable",
			ClickFunc = function(self)
				local bool = GetConVar("cod_killcam_enable"):GetBool()
				if bool then
					RunConsoleCommand("cod_killcam_enable", 0)
				else
					RunConsoleCommand("cod_killcam_enable", 1)
				end
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end,
		},
		{
			Name = COD.Language["main_menu_settings_4"],
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
				gui.OpenURL("https://discord.gg/M49ewrbmFn")
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_7"],
			CustomDock = {50,5},
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
				COD:OpenMainMenu()
			end,
		},
	}
	for k, v in ipairs(main_menu_buttons) do
		local but = scr1:Add("DButton")
		but:SetText("")
		but:Dock( TOP )
		but:SetSize(0, 40)
		but:DockMargin(10, 0, 10, 5)
		if v.CustomDock then
			but:DockMargin(10, v.CustomDock[1], 10, v.CustomDock[2])
		end
		but.DoClick = v.ClickFunc
		but.Paint = function(self, w, h)
			local hov = self:IsHovered()
			if hov then
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(255,255,255,200)
				surface.DrawTexturedRect(0, 0, w, h)
			else
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(150,150,150,200)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			local convar_text = ""
			if v.ConVar then
				local bool = GetConVar(v.ConVar):GetBool()
				if bool then
					convar_text = "ON"
				else
					convar_text = "OFF"
				end
			end
			draw.SimpleText(v.Name..convar_text, "TDMG_Other_Medium2", w/2, h/2-2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but.OnCursorEntered = function()
			surface.PlaySound("tdmg/ui/ui_hover.wav")
		end
	end
end

function COD:OpenMainMenu()
	if IsValid(mainpanel) then return end

	mainpanel = vgui.Create("DFrame")
	mainpanel:SetSize(ScrW(), ScrH())
	mainpanel:SetTitle("")
	mainpanel:SetDraggable(false)
	mainpanel:MakePopup()
	mainpanel:ShowCloseButton(false)
	mainpanel.OnRemove = function()
		COD.HideHUD = false
	end
	mainpanel.Paint = function(self, w, h) 
		surface.SetDrawColor(0,0,0,140)
		surface.DrawRect(0, 0, w, h)

		COD.HideHUD = true
	end

	local secpanel = vgui.Create("DPanel", mainpanel)
	secpanel:SetPos(100, 0)
	secpanel:SetSize(300, ScrH())
	secpanel.Paint = function(self, w, h)
		gui.HideGameUI()

		surface.SetDrawColor(0,0,0,220)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText("Call of Duty", "TDMG_Other_Big2", w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local scr1 = vgui.Create("DScrollPanel", secpanel)
	scr1:Dock(FILL)

	local main_menu_buttons = {
		{
			Name = COD.Language["main_menu_1"],
			CustomDock = {150,5},
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
			end,
		},
		{
			Name = COD.Language["main_menu_2"],
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
				COD:OpenLoadoutMenu()
			end,
		},
		{
			Name = COD.Language["main_menu_3"],
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
				COD:OpenSettingsMenu()
			end,
		},
		{
			Name = COD.Language["main_menu_4"],
			CustomDock = {50,5},
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
				gui.ActivateGameUI()
			end,
		},
	}
	for k, v in ipairs(main_menu_buttons) do
		local but = scr1:Add("DButton")
		but:SetText("")
		but:Dock( TOP )
		but:SetSize(0, 40)
		but:DockMargin(10, 0, 10, 5)
		if v.CustomDock then
			but:DockMargin(10, v.CustomDock[1], 10, v.CustomDock[2])
		end
		but.DoClick = v.ClickFunc
		but.Paint = function(self, w, h)
			local hov = self:IsHovered()
			if hov then
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(255,255,255,200)
				surface.DrawTexturedRect(0, 0, w, h)
			else
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(150,150,150,200)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			draw.SimpleText(v.Name, "TDMG_Other_Medium2", w/2, h/2-2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but.OnCursorEntered = function()
			surface.PlaySound("tdmg/ui/ui_hover.wav")
		end
	end
end

local lastdata = {
	p1 = 1,
	p2 = 1,
	mweapon = {name = "Random", class = "", icon = rnd_mat},
	sweapon = {name = "Random", class = "", icon = rnd_mat},
	ks = {1, 7, 13},
	td = "02",
}
function COD:OpenLoadoutMenu()
	if IsValid(mainpanel) then return end

	mainpanel = vgui.Create("DFrame")
	mainpanel:SetSize(ScrW(), ScrH())
	mainpanel:SetTitle("")
	mainpanel:SetDraggable(false)
	mainpanel:MakePopup()
	mainpanel:ShowCloseButton(false)
	mainpanel.OnRemove = function()
		COD.HideHUD = false
	end
	mainpanel.Paint = function(self, w, h) 
		surface.SetDrawColor(0,0,0,140)
		surface.DrawRect(0, 0, w, h)

		COD.HideHUD = true
	end

	local secpanel = vgui.Create("DPanel", mainpanel)
	secpanel:SetPos(100, 0)
	secpanel:SetSize(300, ScrH())
	secpanel.Paint = function(self, w, h)
		gui.HideGameUI()

		surface.SetDrawColor(0,0,0,220)
		surface.DrawRect(0, 0, w, h)
		
		draw.SimpleText(COD.Language["main_menu_loadout"], "TDMG_Other_Big2", w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local scr1 = vgui.Create("DScrollPanel", secpanel)
	scr1:Dock(FILL)

	local mainweapon = lastdata.mweapon
	local secweapon = lastdata.sweapon
	local perk1 = lastdata.p1
	local perk2 = lastdata.p2
	local tabk = lastdata.ks
	local takedown = lastdata.td

	local function SaveDataToLast()
		lastdata = {
			p1 = perk1,
			p2 = perk2,
			mweapon = mainweapon,
			sweapon = secweapon,
			ks = tabk,
			td = takedown,
		}
	end

	local loadout_panels = {}
	local loadout_buttons = {
		{
			Name = COD.Language["main_menu_loadout_1"],
			CustomDock = {150,5},
			CreateFunc = function(self)
				local tab = {}
				table.Merge(tab, COD.Loadout["SMGs"])
				table.Merge(tab, COD.Loadout["LMGs"])
				table.Merge(tab, COD.Loadout["Assault Rifles"])
				table.Merge(tab, COD.Loadout["Sniper Rifles"])
				table.Merge(tab, COD.Loadout["Marksman Rifles"])
				table.Merge(tab, COD.Loadout["Shotguns"])
				tab["Random"] = {
					class = "",
					icon = rnd_mat,
				}

				local df1 = vgui.Create("DPanel", self)
				df1:SetPos(400, 100)
				df1:SetSize(350, 350)
				df1.Paint = function(self, w, h)
					if mainweapon.icon != "" then
						surface.SetMaterial(mainweapon.icon)
						surface.SetDrawColor(255,255,255)
						surface.DrawTexturedRect(w/2-75, 100, 150, 150)

						surface.SetDrawColor(255,255,255)
						surface.DrawOutlinedRect(w/2-75, 100, 150, 150, 2)

						draw.SimpleText(COD.Language["main_menu_loadout_wep"], "TDMG_MediumFont1", w/2, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
						draw.SimpleText(mainweapon.name, "TDMG_MediumFont1", w/2, h-10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					end
				end

				local df2 = vgui.Create("DPanel", self)
				df2:SetPos(0, 60)
				df2:SetSize(350, 540)
				df2.Paint = function(self, w, h)
					surface.SetDrawColor(20,20,20,200)
					surface.DrawRect(0, 0, w, h)
				end
			
				local DScrollPanel = vgui.Create( "DScrollPanel", df2 )
				DScrollPanel:Dock( FILL )
			
				local down = -1
				for k, v in pairs(tab) do
					down = down+1
					local DButton = DScrollPanel:Add( "DButton" )
					DButton:SetText("")
					DButton:SetSize(325, 60)
					DButton:SetPos(5, 65*down)
					DButton.Paint = function(self, w, h)
						if mainweapon.name == k then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(250,250,250,200)
							surface.DrawTexturedRect(0, 0, w, h)
						elseif self:IsHovered() then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(100,100,100,200)
							surface.DrawTexturedRect(0, 0, w, h)
						else
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(50,50,50,200)
							surface.DrawTexturedRect(0, 0, w, h)
						end

						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(v.icon)
						surface.DrawTexturedRect(12, 0, 64, 64)
				
						draw.SimpleText(k, "TDMG_MediumFont1", 96, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					DButton.DoClick = function(self)
						surface.PlaySound("tdmg/ui/ui_click.wav")
						mainweapon = {name = k, class = v.class, icon = v.icon}
					end
					DButton.OnCursorEntered = function()
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end
				end

			end,
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				for k, v in ipairs(loadout_panels) do
					if self.ID == v.ID then
						v:Show()
					else
						v:Hide()
					end
				end
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_2"],
			CreateFunc = function(self)
				local tab = {}
				table.Merge(tab, COD.Loadout["Pistols"])
				table.Merge(tab, COD.Loadout["Others"])
				tab["Random"] = {
					class = "",
					icon = Material("tdmg/hud/rnd.png"),
				}

				local df1 = vgui.Create("DPanel", self)
				df1:SetPos(400, 100)
				df1:SetSize(350, 350)
				df1.Paint = function(self, w, h)
					if secweapon.icon != "" then
						surface.SetMaterial(secweapon.icon)
						surface.SetDrawColor(255,255,255)
						surface.DrawTexturedRect(w/2-75, 100, 150, 150)

						surface.SetDrawColor(255,255,255)
						surface.DrawOutlinedRect(w/2-75, 100, 150, 150, 2)

						draw.SimpleText(COD.Language["main_menu_loadout_wep"], "TDMG_MediumFont1", w/2, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
						draw.SimpleText(secweapon.name, "TDMG_MediumFont1", w/2, h-10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					end
				end

				local df2 = vgui.Create("DPanel", self)
				df2:SetPos(0, 60)
				df2:SetSize(350, 540)
				df2.Paint = function(self, w, h)
					surface.SetDrawColor(20,20,20,200)
					surface.DrawRect(0, 0, w, h)
				end
			
				local DScrollPanel = vgui.Create( "DScrollPanel", df2 )
				DScrollPanel:Dock( FILL )
			
				local down = -1
				for k, v in pairs(tab) do
					down = down+1
					local DButton = DScrollPanel:Add( "DButton" )
					DButton:SetText("")
					DButton:SetSize(325, 60)
					DButton:SetPos(5, 65*down)
					DButton.Paint = function(self, w, h)
						if secweapon.name == k then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(250,250,250,200)
							surface.DrawTexturedRect(0, 0, w, h)
						elseif self:IsHovered() then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(100,100,100,200)
							surface.DrawTexturedRect(0, 0, w, h)
						else
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(50,50,50,200)
							surface.DrawTexturedRect(0, 0, w, h)
						end

						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(v.icon)
						surface.DrawTexturedRect(12, 0, 64, 64)
				
						draw.SimpleText(k, "TDMG_MediumFont1", 96, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					DButton.DoClick = function(self)
						surface.PlaySound("tdmg/ui/ui_click.wav")
						secweapon = {name = k, class = v.class, icon = v.icon}
					end
					DButton.OnCursorEntered = function()
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end
				end

			end,
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				for k, v in ipairs(loadout_panels) do
					if self.ID == v.ID then
						v:Show()
					else
						v:Hide()
					end
				end
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_3"],
			CreateFunc = function(self)
				local tab = COD.Killstreaks
				local choose = 3-#tabk
				local mks = 0

				local df1 = vgui.Create("DPanel", self)
				df1:SetPos(0, 300)
				df1:SetSize(800, 240)
				df1.Paint = function(self, w, h)
					if mks > 0 then
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(tab[mks].icon)
						surface.DrawTexturedRect(25, 5, 100, 100)

						draw.SimpleText(tab[mks].name, "TDMG_MediumFont1", 25, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw.SimpleText(tab[mks].desc, "TDMG_SmallFont2", 25, 140, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					end

					draw.SimpleText(COD.Language["main_menu_loadout_3_1"]..#tabk.."/3", "TDMG_SmallFont1", 25, h, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				end

				local df2 = vgui.Create("DPanel", self)
				df2:SetPos(0, 60)
				df2:SetSize(800, 240)
				df2.Paint = function(self, w, h)
					surface.SetDrawColor(20,20,20,200)
					surface.DrawRect(0, 0, w, h)
				end
			
				local dhs = vgui.Create( "DHorizontalScroller", df2 )
				dhs:Dock( FILL )
				dhs:SetOverlap(-ScreenScale(2))
				
				local tab = COD.Killstreaks
				for i=1,#tab do
					local DermaButton = dhs:Add("DButton")
					DermaButton:SetText("")
					DermaButton:SetPos( 185*i-180, 0 )
					DermaButton:SetSize( 180, 0 )
					DermaButton:Dock(LEFT)
					DermaButton:DockMargin(0, 0, 5, 20)
					dhs:AddPanel(DermaButton)
					DermaButton.ks = i
					DermaButton.enabled = false
					if table.HasValue(tabk, DermaButton.ks) then
						DermaButton.enabled = true
					end
					DermaButton.DoClick = function(self)
						if (tabk[1] and tab[tabk[1]].kills == tab[self.ks].kills or tabk[2] and tab[tabk[2]].kills == tab[self.ks].kills or tabk[3] and tab[tabk[3]].kills == tab[self.ks].kills) and not table.HasValue(tabk, self.ks) then return end 
						if not table.HasValue(tabk, self.ks) then
							if choose > 0 then
								table.insert(tabk, self.ks)
								choose = choose - 1
								self.enabled = true
								surface.PlaySound("tdmg/ui/ui_click.wav")
							end
						else
							surface.PlaySound("tdmg/ui/ui_click.wav")
							table.RemoveByValue(tabk, self.ks)
							choose = choose + 1
							self.enabled = false
						end
					end
					DermaButton.Paint = function(self, w, h)
						if self.enabled then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(250,250,250,200)
							surface.DrawTexturedRect(0, 0, w, h)
						elseif (tabk[1] and tab[tabk[1]].kills == tab[self.ks].kills or tabk[2] and tab[tabk[2]].kills == tab[self.ks].kills or tabk[3] and tab[tabk[3]].kills == tab[self.ks].kills) and not table.HasValue(tabk, self.ks) then                
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(255,0,0,200)
							surface.DrawTexturedRect(0, 0, w, h)
						else
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(50,50,50,200)
							surface.DrawTexturedRect(0, 0, w, h)
						end
			
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(tab[i].icon)
						surface.DrawTexturedRect(40, 20, 100, 100)
				
						draw.SimpleText(tab[i].name, "TDMG_SmallFont1", w/2, h-60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
						draw.SimpleText(tab[i].kills, "TDMG_SmallFont2", w/2, h-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					end
					DermaButton.OnCursorExited = function()
						mks = 0
					end
					DermaButton.OnCursorEntered = function(self)
						mks = self.ks
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end
				end

			end,
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				for k, v in ipairs(loadout_panels) do
					if self.ID == v.ID then
						v:Show()
					else
						v:Hide()
					end
				end
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_4"],
			CreateFunc = function(self)

				local tab1 = COD.Perks["Type1"]
				local tab2 = COD.Perks["Type2"]
				local mks = 0
				local mks_type = 0

				local df1 = vgui.Create("DPanel", self)
				df1:SetPos(0, 300)
				df1:SetSize(800, 240)
				df1.Paint = function(self, w, h)
					if mks > 0 then
						if mks_type == 1 then
							surface.SetDrawColor(255,255,255)
							surface.SetMaterial(tab1[mks].icon)
							surface.DrawTexturedRect(25, 5, 100, 100)

							draw.SimpleText(tab1[mks].name, "TDMG_MediumFont1", 25, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							draw.SimpleText(tab1[mks].desc, "TDMG_SmallFont2", 25, 140, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						else
							surface.SetDrawColor(255,255,255)
							surface.SetMaterial(tab2[mks].icon)
							surface.DrawTexturedRect(25, 5, 100, 100)

							draw.SimpleText(tab2[mks].name, "TDMG_MediumFont1", 25, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							draw.SimpleText(tab2[mks].desc, "TDMG_SmallFont2", 25, 140, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						end
					end
					draw.SimpleText(COD.Language["main_menu_loadout_wep"].." "..tab1[perk1].name..", "..tab2[perk2].name, "TDMG_SmallFont1", 25, h-10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				end

				local df2 = vgui.Create("DPanel", self)
				df2:SetPos(0, 60)
				df2:SetSize(800, 240)
				df2.Paint = function(self, w, h)
					surface.SetDrawColor(20,20,20,200)
					surface.DrawRect(0, 0, w, h)
				end
			
				local dhs = vgui.Create( "DHorizontalScroller", df2 )
				dhs:Dock( FILL )
				dhs:SetOverlap(-ScreenScale(4))
				
				for i=1,#tab1 do
					local DermaButton = dhs:Add("DButton")
					DermaButton:SetText("")
					DermaButton:SetPos( 185*i-180, 0 )
					DermaButton:SetSize( 180, 0 )
					DermaButton:Dock(LEFT)
					DermaButton:DockMargin(0, 0, 5, 20)
					dhs:AddPanel(DermaButton)
					DermaButton.perk = i
					DermaButton.enabled = false
					DermaButton.DoClick = function(self)
						surface.PlaySound("tdmg/ui/ui_click.wav")
						perk1 = self.perk
					end
					DermaButton.Paint = function(self, w, h)
						if perk1 == self.perk then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(250,250,250,200)
							surface.DrawTexturedRect(0, 0, w, h)
						else
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(50,50,0,200)
							surface.DrawTexturedRect(0, 0, w, h)
						end
			
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(tab1[i].icon)
						surface.DrawTexturedRect(40, 20, 100, 100)
				
						draw.SimpleText(tab1[i].name, "TDMG_SmallFont1", w/2, h-60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					end
					DermaButton.OnCursorExited = function()
						mks = 0
					end
					DermaButton.OnCursorEntered = function(self)
						mks = self.perk
						mks_type = 1
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end
				end

				for i=1,#tab2 do
					local DermaButton = dhs:Add("DButton")
					DermaButton:SetText("")
					DermaButton:SetPos( 185*i-180, 0 )
					DermaButton:SetSize( 180, 0 )
					DermaButton:Dock(LEFT)
					DermaButton:DockMargin(0, 0, 5, 20)
					if i == 1 then
						DermaButton:DockMargin(50, 0, 5, 20)
					end
					dhs:AddPanel(DermaButton)
					DermaButton.perk = i
					DermaButton.enabled = false
					DermaButton.DoClick = function(self)
						surface.PlaySound("tdmg/ui/ui_click.wav")
						perk2 = self.perk
					end
					DermaButton.Paint = function(self, w, h)
						if perk2 == self.perk then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(250,250,250,200)
							surface.DrawTexturedRect(0, 0, w, h)
						else
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(50,50,50,200)
							surface.DrawTexturedRect(0, 0, w, h)
						end
			
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(tab2[i].icon)
						surface.DrawTexturedRect(40, 20, 100, 100)
				
						draw.SimpleText(tab2[i].name, "TDMG_SmallFont1", w/2, h-60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					end
					DermaButton.OnCursorExited = function()
						mks = 0
					end
					DermaButton.OnCursorEntered = function(self)
						mks = self.perk
						mks_type = 2
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end
				end

			end,
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				for k, v in ipairs(loadout_panels) do
					if self.ID == v.ID then
						v:Show()
					else
						v:Hide()
					end
				end
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_5"],
			CreateFunc = function(self)

				local tab = COD.Takedowns

				local df2 = vgui.Create("DPanel", self)
				df2:SetPos(0, 60)
				df2:SetSize(800, 240)
				df2.Paint = function(self, w, h)
					surface.SetDrawColor(20,20,20,200)
					surface.DrawRect(0, 0, w, h)
				end

				local df1 = vgui.Create("DPanel", self)
				df1:SetPos(0, 300)
				df1:SetSize(800, 160)
				df1.Paint = function(self, w, h)
					draw.SimpleText(COD.Language["main_menu_loadout_wep"].." "..COD.Takedowns[takedown].name, "TDMG_MediumFont1", 25, h-10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				end
			
				local dhs = vgui.Create( "DHorizontalScroller", df2 )
				dhs:Dock( FILL )
				dhs:SetOverlap(-ScreenScale(2))
				
				for i, v in SortedPairs(COD.Takedowns) do
					local DermaButton = dhs:Add("DButton")
					DermaButton:SetText("")
					DermaButton:SetPos( 185*i-180, 0 )
					DermaButton:SetSize( 180, 0 )
					DermaButton:Dock(LEFT)
					DermaButton:DockMargin(0, 0, 5, 20)
					dhs:AddPanel(DermaButton)
					DermaButton.td = COD.Takedowns[i]
					DermaButton.DoClick = function(self)
						surface.PlaySound("tdmg/ui/ui_click.wav")
						takedown = i
					end
					DermaButton.Paint = function(self, w, h)
						if takedown == i then
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(250,250,250,200)
							surface.DrawTexturedRect(0, 0, w, h)
						else
							surface.SetMaterial(butbg_mat)
							surface.SetDrawColor(50,50,0,200)
							surface.DrawTexturedRect(0, 0, w, h)
						end
					end
					DermaButton.OnCursorEntered = function(self)
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end

					local icon = vgui.Create("DModelPanel", DermaButton)
					icon:Dock(FILL)
					icon:SetModel("models/tdmg/pm/kortac_1_1_pm.mdl")
					local seq = "execution_"..i.."_attacker_stand"
					function icon:LayoutEntity(ent)
						ent:SetSequence(seq)
						if ent:GetCycle() >= 1 then
							ent:SetCycle(0)
						end
						icon:RunAnimation()
					end

					local icon = vgui.Create("DModelPanel", DermaButton)
					icon:Dock(FILL)
					icon:SetModel("models/tdmg/pm/specgru_milsim_1_1_pm.mdl")
					local seq = "execution_"..i.."_victim_stand"
					function icon:LayoutEntity(ent)
						ent:SetSequence(seq)
						if ent:GetCycle() >= 1 then
							ent:SetCycle(0)
						end
						icon:RunAnimation()
					end

					local b1 = vgui.Create("DButton", DermaButton)
					b1:SetText("")
					b1:Dock(FILL)
					b1.td = COD.Takedowns[i]
					b1.DoClick = function(self)
						surface.PlaySound("tdmg/ui/ui_click.wav")
						takedown = i
					end
					b1.Paint = function(self, w, h)
						draw.SimpleText(v.name, "TDMG_SmallFont2", w/2, h-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
					b1.OnCursorEntered = function(self)
						surface.PlaySound("tdmg/ui/ui_hover.wav")
					end
				end

			end,
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				for k, v in ipairs(loadout_panels) do
					if self.ID == v.ID then
						v:Show()
					else
						v:Hide()
					end
				end
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_6"],
			CustomDock = {50,5},
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui_apply.wav")
				SaveDataToLast()

				if not tabk[1] then
					tabk[1] = 0
				end
				if not tabk[2] then
					tabk[2] = 0
				end
				if not tabk[3] then
					tabk[3] = 0
				end
				table.sort(tabk, function(a,b) return a < b end)
				surface.PlaySound("tdmg/ui_apply.wav")
		
				net.Start("COD.KillstreakChoose")
				net.WriteTable(tabk)
				net.WriteString(mainweapon.class)
				net.WriteString(secweapon.class)
				net.SendToServer()
		
				net.Start("COD.PerksChoose")
				net.WriteFloat(perk1)
				net.WriteFloat(perk2)
				net.SendToServer()

				RunConsoleCommand("cod_givetakedown", takedown)
			end,
		},
		{
			Name = COD.Language["main_menu_loadout_7"],
			ClickFunc = function(self)
				surface.PlaySound("tdmg/ui/ui_click.wav")
				mainpanel:Remove()
				COD:OpenMainMenu()
			end,
		},
	}
	for k, v in ipairs(loadout_buttons) do
		local but = scr1:Add("DButton")
		but:SetText("")
		but:Dock( TOP )
		but:SetSize(0, 40)
		but:DockMargin(10, 0, 10, 5)
		if v.CustomDock then
			but:DockMargin(10, v.CustomDock[1], 10, v.CustomDock[2])
		end
		but.ID = k
		but.DoClick = v.ClickFunc
		but.Paint = function(self, w, h)
			local hov = self:IsHovered()
			if hov then
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(255,255,255,200)
				surface.DrawTexturedRect(0, 0, w, h)
			else
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(150,150,150,200)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			draw.SimpleText(v.Name, "TDMG_Other_Medium2", w/2, h/2-2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but.OnCursorEntered = function()
			surface.PlaySound("tdmg/ui/ui_hover.wav")
		end
	end

	for k, v in ipairs(loadout_buttons) do
		if v.CreateFunc then
			local lpanel = vgui.Create("DPanel", mainpanel)
			lpanel:SetPos((ScrW()-400)/2, ScrH()/2-300)
			lpanel:SetSize(800, 600)
			lpanel.ID = k
			lpanel:Hide()
			v.CreateFunc(lpanel)
			table.insert(loadout_panels, lpanel)
			lpanel.Paint = function(self, w, h)
				surface.SetDrawColor(0,0,0,220)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(150,150,150,200)
				surface.SetMaterial(butbg_mat)
				surface.DrawTexturedRect(-50, 0, w+100, 60)
				
				draw.SimpleText(v.Name, "TDMG_Other_Big1", 10, -5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
		end
	end
end

hook.Add("Think", "TDMFuckOpenMenu", function(ply, but)
	if input.IsKeyDown(KEY_ESCAPE) then
		COD:OpenMainMenu()
	end
end)

net.Receive("COD.SendAdminStatus", function()
	COD.IsAdmin = net.ReadBool()
end)

function COD:OpenAdminMenu()
	if not COD.IsAdmin then return end
	if IsValid(mainpanel) then return end

	mainpanel = vgui.Create("DFrame")
	mainpanel:SetSize(ScrW(), ScrH())
	mainpanel:SetTitle("")
	mainpanel:SetDraggable(false)
	mainpanel:MakePopup()
	mainpanel:ShowCloseButton(false)
	mainpanel.OnRemove = function()
		COD.HideHUD = false
	end
	mainpanel.Paint = function(self, w, h) 
		surface.SetDrawColor(0,0,0,140)
		surface.DrawRect(0, 0, w, h)
		COD.HideHUD = true
	end

	local secpanel = vgui.Create("DPanel", mainpanel)
	secpanel:SetPos(100, 0)
	secpanel:SetSize(300, ScrH())
	secpanel.Paint = function(self, w, h)
		gui.HideGameUI()
		surface.SetDrawColor(0,0,0,220)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText(COD.Language["admin_menu_title"], "TDMG_Other_Big2", w/2, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local scr1 = vgui.Create("DScrollPanel", secpanel)
	scr1:Dock(FILL)

	local gamemodes = {
		{ID = 1, Name = "Team Deathmatch"},
		{ID = 2, Name = "Invasion"},
		{ID = 3, Name = "Knock Out"},
		{ID = 4, Name = "Infected"},
		{ID = 5, Name = "Domination"},
	}

	for _, v in ipairs(gamemodes) do
		local but = scr1:Add("DButton")
		but:SetText("")
		but:Dock(TOP)
		but:SetSize(0, 50)
		but:DockMargin(10, 0, 10, 5)
		but.DoClick = function(self)
			surface.PlaySound("tdmg/ui/ui_click.wav")
			RunConsoleCommand("cod_changegamemode", v.ID)
			mainpanel:Remove()
		end
		but.Paint = function(self, w, h)
			local hov = self:IsHovered()
			if hov then
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(255,200,0,200)
				surface.DrawTexturedRect(0, 0, w, h)
			else
				surface.SetMaterial(butbg_mat)
				surface.SetDrawColor(150,150,150,200)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			draw.SimpleText(v.Name, "TDMG_Other_Medium2", w/2, h/2-2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but.OnCursorEntered = function()
			surface.PlaySound("tdmg/ui/ui_hover.wav")
		end
	end

	local backbut = scr1:Add("DButton")
	backbut:SetText("")
	backbut:Dock(TOP)
	backbut:SetSize(0, 40)
	backbut:DockMargin(10, 20, 10, 5)
	backbut.DoClick = function(self)
		surface.PlaySound("tdmg/ui/ui_click.wav")
		mainpanel:Remove()
	end
	backbut.Paint = function(self, w, h)
		local hov = self:IsHovered()
		if hov then
			surface.SetMaterial(butbg_mat)
			surface.SetDrawColor(255,255,255,200)
			surface.DrawTexturedRect(0, 0, w, h)
		else
			surface.SetMaterial(butbg_mat)
			surface.SetDrawColor(150,150,150,200)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		draw.SimpleText("Back", "TDMG_Other_Medium2", w/2, h/2-2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	backbut.OnCursorEntered = function()
		surface.PlaySound("tdmg/ui/ui_hover.wav")
	end
end

hook.Add("Think", "CODAdminMenu", function()
	if input.IsKeyDown(KEY_F4) and not CODF4Pressed then
		CODF4Pressed = true
		COD:OpenAdminMenu()
	elseif not input.IsKeyDown(KEY_F4) then
		CODF4Pressed = false
	end
end)

net.Receive("COD.GameStartedStatus", function()
	COD.GameStarted = net.ReadBool()
end)

hook.Add("Initialize", "CODRequestGameStatus", function()
	net.Start("COD.RequestGameStatus")
	net.SendToServer()
end)

function COD:OpenLobbyMenu()
	if COD.GameStarted then return end
	if IsValid(mainpanel) then return end

	mainpanel = vgui.Create("DFrame")
	mainpanel:SetSize(ScrW(), ScrH())
	mainpanel:SetTitle("")
	mainpanel:SetDraggable(false)
	mainpanel:MakePopup()
	mainpanel:ShowCloseButton(false)
	mainpanel.OnRemove = function()
		COD.HideHUD = false
	end
	mainpanel.Paint = function(self, w, h) 
		surface.SetDrawColor(0,0,0,180)
		surface.DrawRect(0, 0, w, h)
		COD.HideHUD = true
	end

	local contentW = 800
	local contentH = 600
	local contentX = (ScrW() - contentW) / 2
	local contentY = (ScrH() - contentH) / 2

	local content = vgui.Create("DPanel", mainpanel)
	content:SetPos(contentX, contentY)
	content:SetSize(contentW, contentH)
	content.Paint = function(self, w, h)
		surface.SetDrawColor(20,20,20,230)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(150,150,150,200)
		surface.SetMaterial(butbg_mat)
		surface.DrawTexturedRect(-50, 0, w+100, 60)
		
		draw.SimpleText("LOBBY", "TDMG_Other_Big2", w/2, -5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local leftPanel = vgui.Create("DPanel", content)
	leftPanel:SetPos(0, 60)
	leftPanel:SetSize(380, contentH - 60)
	leftPanel.Paint = function(self, w, h)
		surface.SetDrawColor(30,30,30,200)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("Players Online", "TDMG_MediumFont1", 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local playerList = vgui.Create("DScrollPanel", leftPanel)
	playerList:SetPos(10, 40)
	playerList:SetSize(360, contentH - 160)

	local function UpdatePlayerList()
		if not IsValid(playerList) then return end
		playerList:Clear()
		for _, ply in ipairs(player.GetAll()) do
			local plyPanel = playerList:Add("DPanel")
			plyPanel:SetSize(340, 40)
			plyPanel:DockMargin(0, 0, 0, 5)
			plyPanel.Paint = function(self, w, h)
				local team = ply:Team()
				local teamColor = team == 1 and Color(85,165,95) or team == 2 and Color(195,165,85) or Color(128,128,128)
				surface.SetDrawColor(teamColor)
				surface.DrawRect(0, 0, 5, h)
				draw.SimpleText(ply:Nick(), "TDMG_SmallFont1", 15, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(team == 1 and "SpecGru" or team == 2 and "KorTac" or "Spectator", "TDMG_SmallFont2", 15, 25, teamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
		end
	end
	UpdatePlayerList()

	timer.Create("COD.UpdateLobby", 1, 0, UpdatePlayerList)

	local rightPanel = vgui.Create("DPanel", content)
	rightPanel:SetPos(390, 60)
	rightPanel:SetSize(410, contentH - 60)
	rightPanel.Paint = function(self, w, h)
		surface.SetDrawColor(30,30,30,200)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("Server Controls", "TDMG_MediumFont1", 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local buttons = {}
	
	if COD.IsAdmin then
		table.insert(buttons, {
			Name = "Add Bot",
			Click = function()
				RunConsoleCommand("refoselbots_add", "1")
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end
		})
		table.insert(buttons, {
			Name = "Add 5 Bots",
			Click = function()
				RunConsoleCommand("refoselbots_add", "5")
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end
		})
		table.insert(buttons, {
			Name = "Kick All Bots",
			Click = function()
				RunConsoleCommand("refoselbots_kick", "all")
				surface.PlaySound("tdmg/ui/ui_click.wav")
			end
		})
		table.insert(buttons, {
			Name = "Start Match",
			Click = function()
				RunConsoleCommand("cod_changegamemode", COD.DataTable["Gamemode"] or 1)
				surface.PlaySound("tdmg/ui_apply.wav")
				mainpanel:Remove()
			end,
			IsPrimary = true
		})
	end

	table.insert(buttons, {
		Name = "Close",
		Click = function()
			surface.PlaySound("tdmg/ui/ui_click.wav")
			mainpanel:Remove()
		end
	})

	local butY = 50
	for _, v in ipairs(buttons) do
		local but = vgui.Create("DButton", rightPanel)
		but:SetText("")
		but:SetPos(10, butY)
		but:SetSize(390, 45)
		but.DoClick = v.Click
		but.Paint = function(self, w, h)
			local hov = self:IsHovered()
			if v.IsPrimary then
				surface.SetMaterial(butbg_mat)
				if hov then
					surface.SetDrawColor(100,200,100,200)
				else
					surface.SetDrawColor(50,150,50,200)
				end
				surface.DrawTexturedRect(0, 0, w, h)
			else
				surface.SetMaterial(butbg_mat)
				if hov then
					surface.SetDrawColor(255,255,255,200)
				else
					surface.SetDrawColor(150,150,150,200)
				end
				surface.DrawTexturedRect(0, 0, w, h)
			end
			draw.SimpleText(v.Name, "TDMG_Other_Medium2", w/2, h/2-2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		but.OnCursorEntered = function()
			surface.PlaySound("tdmg/ui/ui_hover.wav")
		end
		butY = butY + 55
	end
end

hook.Add("Initialize", "CODLobbyInit", function()
	hook.Add("Think", "CODLobbyCheck", function()
		if not COD.GameStarted and not IsValid(mainpanel) and LocalPlayer():Team() == 0 then
			COD:OpenLobbyMenu()
		end
	end)
end)