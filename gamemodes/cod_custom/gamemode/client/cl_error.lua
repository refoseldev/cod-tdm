
local noafk = false
hook.Add("Think", "ButtonCheckErrors", function()
	local ply = LocalPlayer()
	if ply:KeyDown(IN_FORWARD) then
		noafk = true
	end
	if noafk then
		hook.Remove("Think", "ButtonCheckErrors")

		local mod = ClientsideModel("models/player/breen.mdl")
		timer.Simple(1, function()
			local seq = mod:LookupSequence("laststand_idle")
			mod:Remove()

			if seq == -1 then
				local frame = vgui.Create("DFrame")
				frame:SetSize( 300, 150 )
				frame:Center()
				frame:SetTitle("CUSTOM ANIMS DONT WORK!")
				frame:MakePopup()

				local Labels = vgui.Create("DLabel", frame)
				Labels:SetText("Animations don't work! You can try to fix them using this button. If you still see T-Pose animations or game crashing, then try restarting the game and removing the animation mods.")
				Labels:SetWrap(true)
				Labels:SetPos( 25, 25 )
				Labels:SetSize( 250, 75 )

				local DermaButton = vgui.Create("DButton", frame)
				DermaButton:SetText("Try Fix")
				DermaButton:SetPos( 25, 100 )
				DermaButton:SetSize( 250, 30 )
				DermaButton.DoClick = function()
					RunConsoleCommand("wos_dynabase_fixconflicts")
                    RunConsoleCommand("wos_dynabase_reloadmodels")
					frame:Remove()
				end
			end

            if jit.version_num != 20100 then
                surface.PlaySound("npc/turret_floor/ping.wav")
                chat.AddText(Color(255,0,0), "[WARNING] ", Color(255,255,255), "I advise you to install the x64 version to avoid errors and improve performance.")
            end
		end)
	end
end)