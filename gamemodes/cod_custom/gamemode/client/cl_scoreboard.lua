surface.CreateFont( "mw2score_servername", {
    font = "ChatFont", 
    extended = false,
    size = 20,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface.CreateFont( "mw2score_gamemodename", {
    font = "ChatFont", 
    extended = false,
    size = 40,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface.CreateFont( "mw2score_playername", {
    font = "ChatFont", 
    extended = false,
    size = 20,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

local Scoredefault_black = Color(0,0,0,200)
local plycolor = Color(255,255,255)
local servername = GetHostName()
local gamemodename = COD.Language["gamemode_"..COD.DataTable["Gamemode"]]
local servernamedata = {
    text = servername,
    xalign = TEXT_ALIGN_CENTER,
    font = "mw2score_servername"
}

local gamemodenamedata = {
    text = gamemodename,
    xalign = TEXT_ALIGN_CENTER,
    font = "mw2score_gamemodename"
}

local playertextdata= {
    xalign = TEXT_ALIGN_LEFT,
    font = "mw2score_playername"
}

local detaildata = {
    xalign = TEXT_ALIGN_LEFT,
    font = "ChatFont"
}

local avtab = {}
local function CreatePlayerAvatar(ply,x,y)
    if !ply.mw2avatar then
        local avatar = vgui.Create("AvatarImage")
        avatar:SetPos(x,y)
        avatar:SetSize(27,27)
        avatar:SetPlayer(ply)
        ply.mw2avatar = avatar
        table.insert(avtab, avatar)
    end
end

local function RemoveAvatars()
    local players = player.GetAll()
    for k, ply in ipairs(players) do
        if ply.mw2avatar then
            ply.mw2avatar:Remove()
            ply.mw2avatar = nil
            table.RemoveByValue(avtab, ply.mw2avatar)
        end
    end
    for k, v in ipairs(avtab) do
        v:Remove()
        table.remove(avtab, k)
    end
end

local team1_mat = Material('tdmg/hud/teams/specgru.png')
local team2_mat = Material('tdmg/hud/teams/kortac.png')

local function MW2SCORE_RenderScoreboard()
    gamemodename = COD.Language["gamemode_"..COD.DataTable["Gamemode"]]
    gamemodenamedata = {
        text = gamemodename,
        xalign = TEXT_ALIGN_CENTER,
        font = "mw2score_gamemodename"
    }
    hook.Add("HUDPaint","MW2SCORE_RENDER",function()
        local w,h = ScrW(),ScrH()
        local xoffset = 50
        local players = team.GetPlayers(1)
        local players2 = team.GetPlayers(2)
        table.sort(players, function(a,b)
            return a:GetNWFloat('Score') > b:GetNWFloat('Score')
        end)
        table.sort(players2, function(a,b)
            return a:GetNWFloat('Score') > b:GetNWFloat('Score')
        end)
        
        -- Server Name
        surface.SetDrawColor(Scoredefault_black)
        surface.DrawRect(0, h/15, w, 50)
        servernamedata.pos = {w/2,h/8.5}
        draw.TextShadow(servernamedata,2,255)
        gamemodenamedata.pos = {w/2,h/14}
        draw.TextShadow(gamemodenamedata,2,255)
        
        detaildata.xalign = 1
        detaildata.pos = {w-245,h/5.7}
        detaildata.text = COD.Language["scoreboard_score"]
        draw.TextShadow(detaildata,2,255)
        detaildata.xalign = 1
        detaildata.pos = {w-145,h/5.7}
        detaildata.text = COD.Language["scoreboard_kd"]
        draw.TextShadow(detaildata,2,255)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(team2_mat)
        surface.DrawTexturedRect(w-600, h/5.7-25, 72, 72)
        draw.SimpleText(COD.Language["team2_name"], "mw2score_gamemodename", w-512, h/5.7+10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        detaildata.xalign = 1
        detaildata.pos = {400+xoffset,h/5.7}
        detaildata.text = COD.Language["scoreboard_score"]
        draw.TextShadow(detaildata,2,255)
        detaildata.xalign = 1
        detaildata.pos = {550,h/5.7}
        detaildata.text = COD.Language["scoreboard_kd"]
        draw.TextShadow(detaildata,2,255)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(team1_mat)
        surface.DrawTexturedRect(80, h/5.7-40, 80, 96)
        draw.SimpleText(COD.Language["team1_name"], "mw2score_gamemodename", 170, h/5.7+10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        for index, ply in ipairs(players) do
            if !IsValid(ply) then continue end
            if ply:IsPlayer() then
                local name = ply:GetName()
                local kills = ply:Frags()
                local deaths = ply:Deaths()
                local curteam = ply:Team()
                local teamcolor = team.GetColor(curteam)
                local row = (h/5)+(index*40)
                CreatePlayerAvatar(ply, 100,row)
                plycolor.r = teamcolor.r
                plycolor.g = teamcolor.g
                plycolor.b = teamcolor.b
                surface.SetDrawColor(Scoredefault_black)
                surface.DrawRect(95, row-5, 500, 35)
                playertextdata.text = name
                playertextdata.pos = {150,row}
                playertextdata.color = plycolor
                draw.TextShadow(playertextdata,2,255)
                detaildata.pos = {450,row}
                detaildata.text = tostring(ply:GetNWFloat('Score'))
                draw.TextShadow(detaildata,2,255)
                detaildata.pos = {550,row}
                detaildata.text = tostring(kills.."/"..deaths)
                draw.TextShadow(detaildata,2,255)
            end 
        end
    
        for index, ply in ipairs(players2) do
            if !IsValid(ply) then continue end
            if ply:IsPlayer() then
                local name = ply:GetName()
                local kills = ply:Frags()
                local deaths = ply:Deaths()
                local curteam = ply:Team()
                local teamcolor = team.GetColor(curteam)
                local row = (h/5)+(index*40)
                CreatePlayerAvatar(ply, w-590 ,row)
                plycolor.r = teamcolor.r
                plycolor.g = teamcolor.g
                plycolor.b = teamcolor.b
                surface.SetDrawColor(Scoredefault_black)
                surface.DrawRect(w-595, row-5, 500, 35)
                playertextdata.text = name
                playertextdata.pos = {w-540,row}
                playertextdata.color = plycolor
                draw.TextShadow(playertextdata,2,255)
                detaildata.pos = {w-245,row}
                detaildata.text = tostring(ply:GetNWFloat('Score'))
                draw.TextShadow(detaildata,2,255)
                detaildata.pos = {w-145,row}
                detaildata.text = tostring(kills.."/"..deaths)
                draw.TextShadow(detaildata,2,255)
            end 
        end
    end)
end

local function MW2SCORE_HideScoreboard()
    hook.Remove("HUDPaint","MW2SCORE_RENDER")
    RemoveAvatars()
end

hook.Add("ScoreboardShow","MW2SCORE_NoDefault",function()
    MW2SCORE_RenderScoreboard()
    COD.HideHUD = true
    return true
end)

hook.Add("ScoreboardHide","MW2SCORE_HideScore",function()
    MW2SCORE_HideScoreboard()
    COD.HideHUD = false
end)

--original by StarFrost, i edited it for gamemode