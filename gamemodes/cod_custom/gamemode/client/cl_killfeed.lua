local killfeed = vgui.Create("DPanel")
killfeed:SetSize(500, 290)
killfeed:SetPos(10, 400)
killfeed.Paint = function(self, w, h) end

local nametab = {
    ["prop_dynamic"] = "Killstreak",
    ["env_explosion"] = "Explosion",
    ["tdm_package"] = "Care Package",
    ["vj_tdm_k9"] = "Dog",
    ["vj_tdm_npc"] = "AI Soldier",
}

killicon.Add("default", "tdmg/hud/skull", Color(255,255,255))
killicon.Add("takedown", "tdmg/hud/takedown", Color(255,255,255))
killicon.Add("knife", "tdmg/hud/knife", Color(255,255,255))
killicon.Add("explosion", "tdmg/hud/explosion", Color(255,255,255))

local function AddKillfeedEntry(attacker, inflictor, killed)
    if !IsValid(killed) then return end

    local entry = vgui.Create("DPanel", killfeed)
    entry:SetSize(200, 30)
    entry:Dock(TOP)
    entry:DockMargin(5, 5, 5, 0)
    entry.Paint = function(self, w, h) end

    local color1 = Color(255, 255, 255)
    local name = ""

    if IsValid(attacker) and attacker != killed then
        if attacker:IsPlayer() then
            name = attacker:Nick()
            color1 = team.GetColor(attacker:Team())
        elseif attacker:GetNWFloat('Team') then
            name =  nametab[attacker:GetClass()] or attacker.PrintName or attacker:GetClass()
            color1 = team.GetColor(attacker:GetNWFloat('Team'))
        else
            name = nametab[attacker:GetClass()] or attacker.PrintName or attacker:GetClass()
            color1 = Color(200,200,200)
        end
        local attackerLabel = vgui.Create("DLabel", entry)
        attackerLabel:SetText(name.." ")
        attackerLabel:SetFont("TDMG_SmallFont1")
        attackerLabel:SetColor(color1)
        attackerLabel:SizeToContents()
        attackerLabel:Dock(LEFT)
    end

    local inflictorLabel = vgui.Create("DKillIcon", entry)
    inflictorLabel:SetPos(entry:GetPos())
    inflictorLabel:SetName(inflictor)
    inflictorLabel:SizeToContents()
    inflictorLabel:Dock(LEFT)

    if killed:IsPlayer() then
        name = killed:Nick()
        color1 = team.GetColor(killed:Team())
    else
        name = killed:GetPrintName()
        color1 = Color(200,200,200)
    end
    local killedLabel = vgui.Create("DLabel", entry)
    killedLabel:SetText(" "..name)
    killedLabel:SetFont("TDMG_SmallFont1")
    killedLabel:SetColor(color1)
    killedLabel:SizeToContents()
    killedLabel:Dock(LEFT)

    timer.Simple(10, function()
        if !IsValid(entry) then return end
        entry:AlphaTo(0, 1, 0, function(ad, pnl)
            pnl:Remove()
        end)
    end)
end

net.Receive("COD.Killfeed", function()
    local tab = net.ReadTable()
    local att = tab.attacker
    local inf = tab.inflictor
    local tar = tab.target
    AddKillfeedEntry(att, inf, tar)
end)