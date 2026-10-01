AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

local SpeedMultiplier = 5

function ENT:GetLetter(small)
    local type = self:GetNWFloat('Point')
    local letter = ""
    if type == 1 then
        letter = "A"
    elseif type == 2 then
        letter = "B"
    elseif type == 3 then
        letter = "C"
    end
    if small then
        letter = string.lower(letter)
    end
    return letter
end

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/tdmg/anim_flag_rework.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMaterial('models/debug/debugwhite')
        self:ResetSequence("idle")
        self:SetModelScale(0.4, 0)
        self:SetNWFloat('Point', #ents.FindByClass("tdm_domination_flag"))
        self:SetNWFloat('Team', 0)
        self:SetNWFloat('Progress', 0)
        self:SetCollisionGroup(1)
        self.PreviousTakingTeam = 0
        self.CurrentTakingTeam = 0
    end

    function ENT:PlayPhrase(type, team)
        for k, pl in ipairs(player.GetAll()) do
            if pl:Team() == team then
                if type == "capture" then
                    pl:SendLua([[
                        COD:SpeakerSay('tdmg/speaker/domination/friendly_captured_]]..self:GetLetter(true)..[[.wav')
                    ]])
                elseif type == "all_captured" then
                    pl:SendLua([[
                        COD:SpeakerSay('tdmg/speaker/domination/friendly_captured_all.wav')
                    ]])
                elseif type == "taking" then
                    pl:SendLua([[
                        COD:SpeakerSay('tdmg/speaker/domination/friendly_taking_]]..self:GetLetter(true)..[[ ('..math.random(1,3)..').wav')
                    ]])
                end
            else
                if type == "capture" then
                    pl:SendLua([[
                        COD:SpeakerSay('tdmg/speaker/domination/hostile_captured_]]..self:GetLetter(true)..[[ ('..math.random(1,2)..').wav')
                    ]])
                elseif type == "all_captured" then
                    pl:SendLua([[
                        COD:SpeakerSay('tdmg/speaker/domination/hostile_captured_all.wav')
                    ]])
                elseif type == "taking" then
                    pl:SendLua([[
                        COD:SpeakerSay('tdmg/speaker/domination/hostile_taking_]]..self:GetLetter(true)..[[ ('..math.random(1,3)..').wav')
                    ]])
                end
            end
        end
    end

    function ENT:Capture(team, plytab)
        if plytab then
            if self:GetNWFloat('Team') == 0 then
                COD:GiveMessageCenter(plytab, 10)
                for _, p in ipairs(plytab) do
                    p:ChangeScore(200)
                end
            else
                COD:GiveMessageCenter(plytab, 11)
                for _, p in ipairs(plytab) do
                    p:ChangeScore(100)
                end
            end
        end

        local type = self:GetLetter()
        self:SetNWFloat('Team', team)
        self:SetNWFloat('Progress', 0)
        self:PlayPhrase("capture", team)

        local all = true
        for _, f in ipairs(ents.FindByClass("tdm_domination_flag")) do
            if f:GetNWFloat('Team') != team then
                all = false
                break
            end
        end
        if all then
            self:PlayPhrase("all_captured", team)
        end
    end

    function ENT:Think()
        local t = self:GetNWFloat('Team')
        local prog = self:GetNWFloat('Progress')
        local haveplayers = false
        local teamcapture = 0
        local count = 0
        local plytab = {}

        for k, v in ipairs(ents.FindInSphere(self:GetPos(), 72)) do
            if v:IsPlayer() and v:Alive() then
                if teamcapture == 0 then
                    teamcapture = v:Team()
                    count = count+1
                else
                    if v:Team() == teamcapture then
                        count = count+1
                    elseif v:Team() != teamcapture then
                        teamcapture = 0
                    end
                end
                if teamcapture == v:Team() then
                    table.insert(plytab, v)
                end
            end
        end

        self.PreviousTakingTeam = teamcapture

        if teamcapture > 0 then
            if teamcapture == t then
                self:SetNWFloat('Progress', math.max(self:GetNWFloat('Progress')-FrameTime()/100*count*SpeedMultiplier, 0))
            else
                self:SetNWFloat('Progress', math.min(self:GetNWFloat('Progress')+FrameTime()/100*count*SpeedMultiplier, 1))
                if self.CurrentTakingTeam != self.PreviousTakingTeam then
                    self:PlayPhrase("taking", teamcapture)
                end
            end
            if prog >= 1 then
                self:Capture(teamcapture, plytab)
            end       
            self.CurrentTakingTeam = self.PreviousTakingTeam
        else
            self.CurrentTakingTeam = 0
        end

        self:NextThink(CurTime())
        return true
    end
else
    function ENT:Draw()
        self:DrawModel()
        local ply = LocalPlayer()
        local pteam = ply:Team()
        local fteam = self:GetNWFloat('Team')
        if fteam > 0 then
            if pteam == fteam then
                self:SetColor(Color(40,140,240))
            else
                self:SetColor(Color(240,0,0))
            end
        else
            self:SetColor(Color(200,200,200))
        end
    end
    hook.Add("HUDPaint", "TDM_DominationFlags", function()
        if COD.DataTable["Gamemode"] == 5 and not COD.HideHUD then
            for k, ent in ipairs(ents.FindByClass("tdm_domination_flag")) do
                if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 5184 then
                    LocalPlayer().DrawDominationFlag = ent
                    break
                else
                    LocalPlayer().DrawDominationFlag = NULL
                end
            end
            local df = LocalPlayer().DrawDominationFlag
            for k, v in ipairs(ents.FindByClass("tdm_domination_flag")) do
                local t = v:GetNWFloat('Team')
                local type = v:GetNWFloat('Point')
                local prog = v:GetNWFloat('Progress')
                local myteam = LocalPlayer():Team() == t
                local pos = (v:GetPos()+Vector(0,0,180)):ToScreen()

                if t > 0 then
                    if myteam then
                        surface.SetDrawColor(40,140,240)
                        surface.DrawRect(pos.x-16, pos.y-16, 32, 32)

                        surface.SetDrawColor(240,0,0)
                        surface.DrawRect(pos.x-16, pos.y-16, 32, 32*prog)

                        draw.SimpleText(COD.Language["hud_domination_2"], "Trebuchet18", pos.x, pos.y-32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    else
                        surface.SetDrawColor(240,0,0)
                        surface.DrawRect(pos.x-16, pos.y-16, 32, 32)

                        surface.SetDrawColor(40,140,240)
                        surface.DrawRect(pos.x-16, pos.y-16, 32, 32*prog)

                        draw.SimpleText(COD.Language["hud_domination_1"], "Trebuchet18", pos.x, pos.y-32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                else
                    surface.SetDrawColor(200,200,200)
                    surface.DrawRect(pos.x-16, pos.y-16, 32, 32)

                    surface.SetDrawColor(100,100,100)
                    surface.DrawRect(pos.x-16, pos.y-16, 32, 32*prog)

                    draw.SimpleText(COD.Language["hud_domination_1"], "Trebuchet18", pos.x, pos.y-32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                draw.SimpleText(math.floor(LocalPlayer():GetPos():Distance(v:GetPos())/40).." m", "Trebuchet18", pos.x, pos.y+32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                local letter = v:GetLetter()
                draw.SimpleText(letter, "DermaLarge", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            if IsValid(df) and LocalPlayer():Alive() then
                local prog = df:GetNWFloat('Progress')
                local lt = df:GetLetter()
                local t = df:GetNWFloat('Team') == LocalPlayer():Team()

                if prog > 0 then
                    surface.SetDrawColor(50,50,50)
                    surface.DrawRect(ScrW()/2-150, 250, 300, 6)

                    surface.SetDrawColor(200,200,200)
                    surface.DrawRect(ScrW()/2-150, 220, 24, 24)

                    draw.SimpleText(lt, "Trebuchet18", ScrW()/2-137, 233, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                    if t then
                        draw.SimpleText(COD.Language["hud_domination_2"], "Trebuchet18", ScrW()/2+150, 245, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

                        surface.SetDrawColor(250,0,0)
                        surface.DrawRect(ScrW()/2-149, 251, 298*prog, 4)
                    else
                        COD:BeatsPlay("flag", prog)
                        draw.SimpleText(COD.Language["hud_domination_3"], "Trebuchet18", ScrW()/2+150, 245, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

                        surface.SetDrawColor(50,150,250)
                        surface.DrawRect(ScrW()/2-149, 251, 298*prog, 4)
                    end
                else
                    if t then
                        draw.SimpleText(COD.Language["hud_domination_2"], "DermaLarge", ScrW()/2, 245, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        surface.SetDrawColor(0,100,200)
                        surface.DrawRect(ScrW()/2-12, 265, 24, 24)
        
                        draw.SimpleText(lt, "Trebuchet18", ScrW()/2, 277, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end
            end
        end
    end)

    local beatdelay = 0
    function COD:BeatsPlay(type, float)
        if beatdelay > CurTime() or !GetConVar("cod_music_enable"):GetBool() then return end

        local snd = ""
        if type == "flag" then
            if float > 0.9 then
                snd = "tdmg/themes/flag4.wav"
            elseif float > 0.7 then
                snd = "tdmg/themes/flag3.wav"
            elseif float > 0.4 then
                snd = "tdmg/themes/flag2.wav"
            else
                snd = "tdmg/themes/flag1.wav"
            end
        end

        surface.PlaySound(snd)
        beatdelay = CurTime() + SoundDuration(snd)
    end
end
