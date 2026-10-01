local cutscene_table = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
}

function COD:PrecacheCutscene(path, frames, dest) 
    for i=1,frames do
        local num = i
        if num < 10 then
            num = "000"..num
        elseif num < 100 then
            num = "00"..num
        elseif num < 1000 then
            num = "0"..num
        end
        local mat = Material(path..num..".jpg")
        table.insert(dest, mat)
    end
end

function COD:PlayCutscene(tab, sound, fps, screenfade)
    local time = 0
    local tab = cutscene_table[tab]
    surface.PlaySound(sound)
    hook.Add("HUDPaint", "!!!CODCutscene", function()
        time = time + FrameTime()
        local frame = math.ceil(time/(1/fps))

        if frame > #tab then
            hook.Remove("HUDPaint", "!!!CODCutscene")
            COD.HideHUD = false
            if screenfade then
                LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 1, 1)
            end
        else
            surface.SetMaterial(tab[frame])
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
            COD.HideHUD = true
        end
    end)
end

COD:PrecacheCutscene("tdmg/heli/spawn_cutscene/", 111, cutscene_table[1])
COD:PrecacheCutscene("tdmg/heli/shotdown_bullet_cutscene/", 117, cutscene_table[2])
COD:PrecacheCutscene("tdmg/heli/shotdown_rocket_cutscene/", 100, cutscene_table[3])
COD:PrecacheCutscene("tdmg/nuke/explode_cutscene/", 296, cutscene_table[4])

net.Receive("COD.Cutscene", function()
    local tab = net.ReadTable()
    local num = tab.num_of_cutscene
    local snd = tab.path_of_sound
    local fps = tab.fps
    local scr = tab.screenfade
    COD:PlayCutscene(num, snd, fps, scr)
end)