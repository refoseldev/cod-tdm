local TickTable = {}
local KillCamStore = {}
local hm_mat = Material('tdmg/hud/hitmark.png')

local function TransferBones(base, ragdoll)
	if !IsValid(base) or !IsValid(ragdoll) then return end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

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

function COD:StopKillcam()
    local ply = LocalPlayer()
    hook.Remove("HUDPaint", "!!!KillCamTDM")
    hook.Remove("Tick", "!!!KillCamTDM")
    hook.Remove("CalcView", "!!!KillCamTDM")
    ply.InKillCam = false
    COD.HideHUD = false
    ply:ConCommand("-jump")
    ply:ConCommand("+jump")
    timer.Simple(0.1, function()
        ply:ConCommand("-jump")
    end)
    ply:ScreenFade(SCREENFADE.IN, color_black, 0.5, 0)
    for _, ent in ipairs(ents.GetAll()) do
        if not ent.IsKillcamEnt and (ent:IsPlayer() or ent:IsNPC() or ent:IsWeapon() or ent:GetClass() == "prop_ragdoll" or string.match(ent:GetClass(), "tdm_")) then
            ent:SetNoDraw(false)
        end
    end
    for _, ent in pairs(KillCamStore) do
        ent:SetNoDraw(true)
        ent:Remove()
    end
    KillCamStore = {}
end

function COD:GetMeFromTable(tab)
    local tab2 = tab.other
    for k=1,#tab2.ent do
        local v = tab2.ent[k]
        if v == LocalPlayer():EntIndex() then
            return tab.other.alive[k], tab.other.pos[k], tab.other.ang[k]
        end
    end
end

function COD:PlayKillcam(tabl, islast)
    if !GetConVar("cod_killcam_enable"):GetBool() and not islast then return end

    local frame = 0
    local tab = tabl[frame]

    LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 0.5, 0)

    hook.Add("HUDPaint", "!!!KillCamTDM", function()
        if istable(tab) then
            local alive, opos = COD:GetMeFromTable(tab)

            if alive then
                local pos = (opos+Vector(0,0,72)):ToScreen()
                draw.SimpleText("YOU", "TDMG_SmallFont1", pos.x, pos.y-16, Color(200,150,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("▼", "TDMG_SmallFont1", pos.x, pos.y, Color(200,150,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        surface.SetDrawColor(0,0,0,200)
        surface.DrawRect(0, 0, ScrW(), 100)

        surface.SetDrawColor(0,0,0,200)
        surface.DrawRect(0, ScrH()-100, ScrW(), 100)

        if islast then
            draw.SimpleText(COD.Language["killcam_2"], "TDMG_LargeFont1", ScrW()/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(COD.Language["killcam_1"], "TDMG_LargeFont1", ScrW()/2, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(COD.Language["killcam_3"], "TDMG_MediumFont1", ScrW()/2, ScrH()-50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)

    hook.Add("Tick", "!!!KillCamTDM", function(ply, origin, angles, fov)
        local ply = LocalPlayer()
        local drawframes = true
        ply.InKillCam = true
        frame = frame + 1
        tab = tabl[math.ceil(frame)]
        COD.HideHUD = true

        if frame >= #tabl or ply:KeyDown(IN_JUMP) or COD.HUD_DisableSomeThink then
            COD:StopKillcam()
            drawframes = false
        end

        if drawframes then
            if istable(tab) then
                local s1 = tab.ply.snd

                if istable(s1) then
                    for _, ss in ipairs(s1) do
                        ply:EmitSound(ss)
                    end
                    tab.ply.snd = ""
                end

                local b1 = tab.ply.blt
                if b1 != {} then
                    b1.Callback = nil
                    b1.Tracer = 0
                    ply:FireBullets(b1)
                    tab.ply.blt = {}
                end

                local hit = tab.ply.hit
                if hit == 1 then
                    GiveHitMarker()
                elseif hit == 2 then
                    GiveHitMarker(true)
                end
                
                local tab2 = tab.other

                for v, ent in pairs(tab2.ent) do
                    local ent = Entity(ent)
                    if !IsValid(ent.KCModel) and tab2.model[v] != "" then
                        ent.KCModel = ClientsideModel(tab2.model[v])
                        table.insert(KillCamStore, ent.KCModel)
                    else
                        ent.KCModel.IsKillcamEnt = true
                        ent.KCModel:SetPos(tab2.pos[v])
                        ent.KCModel:SetAngles(tab2.ang[v])
                        ent.KCModel:SetModel(tab2.model[v])
                        ent.KCModel:SetSequence(tab2.seq[v])
                        ent.KCModel:SetPoseParameter("move_x", 1)
                        ent.KCModel:SetCycle(tab2.cycle[v])
                        ent.KCModel:SetNoDraw(!tab2.alive[v])
                        if tab2.alive[v] then
                            ent.SpawnRagdoll = false
                        end
                        if !tab2.alive[v] and !ent.SpawnRagdoll then
                            ent.SpawnRagdoll = true
                            local rag = ClientsideRagdoll(tab2.model[v])
                            rag:SetPos(tab2.pos[v])
                            rag.IsKillcamEnt = true
                            rag:SetNoDraw(false)
                            table.insert(KillCamStore, rag)
                            TransferBones(ent.KCModel, rag)
                        end
                    end
                end
            end

            for _, ent in ipairs(ents.GetAll()) do
                if not ent.IsKillcamEnt and (ent:IsPlayer() or ent:IsNPC() or ent:IsWeapon() or ent:GetClass() == "prop_ragdoll" or string.match(ent:GetClass(), "tdm_")) then
                    ent:SetNoDraw(true)
                end
            end
        end
    end)

    local lastang = 
    hook.Add("CalcView", "!!!KillCamTDM", function(ply, origin, angles, fov)
        if istable(tab) then
            lastang = tab.ply.ang
            if tab.ply.lock then
                local alive, pos = COD:GetMeFromTable(tab)
                if alive and isvector(pos) then
                    pos = pos+Vector(0,0,32)
                    lastang = (pos-tab.ply.pos):GetNormalized():Angle()
                end
            end

            local view = {
                origin = tab.ply.pos,
                angles = lastang,
                fov = fov,
                drawviewer = false,
                znear = 0.1,
                zfar = 10000,
            }

            return view
        end
    end)
end

net.Receive("COD.KillcamSend", function()
    local flt = net.ReadUInt(32)
    local tab = net.ReadData(flt)
    local bool = net.ReadBool()
    tab = util.Decompress(tab)
    local tab2 = util.JSONToTable(tab)

    COD:PlayKillcam(tab2, bool)
end)