local knife_model = "models/tdmg/wep/combat_knife.mdl"
local pistol_model = "models/tdmg/wep/m18.mdl"
local ar_model = "models/viper/mw/weapons/w_galima.mdl"
local machete_model = "models/tdmg/wep/w_machete.mdl"
local pkm_model = "models/tdmg/wep/w_mw_pkm.mdl"
local shotgun_model = "models/tdmg/wep/w_rem870_p.mdl"
local sniper_model = "models/tdmg/wep/m82.mdl"
local sledgehammer_model = "models/tdmg/wep/w_sledgehammer.mdl"
local pickaxe_model = "models/tdmg/wep/wpn_h1_melee_pick_axe_wm.mdl"
local katana_model = "models/tdmg/wep/w_katana.mdl"
local new_pickaxe_model = "models/tdmg/wep/new/hatchet.mdl"
local new_katana_model = "models/tdmg/wep/new/katana.mdl"
local new_stick_model = "models/tdmg/wep/new/kalistick.mdl"

local function lasers(ply, bool)
    if bool then
        lasers(ply, false)
        ply.Lasers = {}

        local id = ply:LookupAttachment("eyes")
        local tab = ply:GetAttachment(id)
        if not tab then return end

        local ent = ents.Create("prop_dynamic")
        ent:SetModel("models/hunter/plates/plate4.mdl")
        ent:SetMaterial("models/debug/debugwhite")
        ent:SetColor(Color(255,0,0,200))
        ent:SetRenderMode(RENDERMODE_WORLDGLOW)
        ent:DrawShadow(false)
        ent:SetPos(tab.Pos)
        ent:SetAngles(tab.Ang)
        ent:SetParent(ply, id)
        ent:Spawn()
        ent:SetLocalPos(Vector(36,-1.2,5))
        ent:SetLocalAngles(Angle(0,90,-10))
        ent:SetModelScale(0.4)
        table.insert(ply.Lasers, ent)

        local ent = ents.Create("prop_dynamic")
        ent:SetModel("models/hunter/plates/plate4.mdl")
        ent:SetMaterial("models/debug/debugwhite")
        ent:SetColor(Color(255,0,0,200))
        ent:SetRenderMode(RENDERMODE_WORLDGLOW)
        ent:DrawShadow(false)
        ent:SetPos(tab.Pos)
        ent:SetAngles(tab.Ang)
        ent:SetParent(ply, id)
        ent:Spawn()
        ent:SetLocalPos(Vector(36,1.2,5))
        ent:SetLocalAngles(Angle(0,90,-10))
        ent:SetModelScale(0.4)
        table.insert(ply.Lasers, ent)
    else
        if istable(ply.Lasers) then
            for _, ent in ipairs(ply.Lasers) do
                ent:Remove()
            end
            ply.Lasers = nil
        end
    end
end

local function lights(ply, bool, onlyright, isred)
    if bool then
        lights(ply, false)
        ply.Lasers = {}

        local id = ply:LookupAttachment("anim_attachment_LH")
        local tab = ply:GetAttachment(id)
        local id2 = ply:LookupAttachment("anim_attachment_RH")
        local tab2 = ply:GetAttachment(id)

        if not tab or not tab2 then return end

        if not onlyright then
            if isred then
                local ent = ents.Create("prop_dynamic")
                ent:SetModel("models/effects/vol_light128x512.mdl")
                ent:SetColor(Color(255,0,0,200))
                ent:SetRenderMode(RENDERMODE_TRANSALPHA)
                ent:DrawShadow(false)
                ent:SetPos(tab.Pos)
                ent:SetAngles(tab.Ang)
                ent:SetParent(ply, id)
                ent:Spawn()
                ent:SetLocalPos(Vector(0,0,0))
                ent:SetLocalAngles(Angle(0,40,270))
                ent:SetModelScale(0.05)
                table.insert(ply.Lasers, ent)
            else
                local ent = ents.Create("prop_dynamic")
                ent:SetModel("models/effects/vol_light128x512.mdl")
                ent:SetColor(Color(255,255,0,200))
                ent:SetRenderMode(RENDERMODE_TRANSALPHA)
                ent:DrawShadow(false)
                ent:SetPos(tab.Pos)
                ent:SetAngles(tab.Ang)
                ent:SetParent(ply, id)
                ent:Spawn()
                ent:SetLocalPos(Vector(0,0,0))
                ent:SetLocalAngles(Angle(0,40,270))
                ent:SetModelScale(0.1)
                table.insert(ply.Lasers, ent)
            end
        end

        if isred then
            local ent = ents.Create("prop_dynamic")
            ent:SetModel("models/effects/vol_light128x512.mdl")
            ent:SetColor(Color(255,0,0,200))
            ent:SetRenderMode(RENDERMODE_TRANSALPHA)
            ent:DrawShadow(false)
            ent:SetPos(tab2.Pos)
            ent:SetAngles(tab2.Ang)
            ent:SetParent(ply, id2)
            ent:Spawn()
            ent:SetLocalPos(Vector(0,0,0))
            ent:SetLocalAngles(Angle(0,-40,90))
            ent:SetModelScale(0.05)
            table.insert(ply.Lasers, ent)
        else
            local ent = ents.Create("prop_dynamic")
            ent:SetModel("models/effects/vol_light128x512.mdl")
            ent:SetColor(Color(255,255,0,200))
            ent:SetRenderMode(RENDERMODE_TRANSALPHA)
            ent:DrawShadow(false)
            ent:SetPos(tab2.Pos)
            ent:SetAngles(tab2.Ang)
            ent:SetParent(ply, id2)
            ent:Spawn()
            ent:SetLocalPos(Vector(0,0,0))
            ent:SetLocalAngles(Angle(0,-40,90))
            ent:SetModelScale(0.1)
            table.insert(ply.Lasers, ent)
        end
    else
        if istable(ply.Lasers) then
            for _, ent in ipairs(ply.Lasers) do
                ent:Remove()
            end
            ply.Lasers = nil
        end
    end
end

COD.Takedowns = {
    ["00"] = {
        name = "Random",
    },
    ["01"] = {
        name = "Making Holes",
        deathtime = 3,
        deathtime_laststand = 2.6,
        effect = function(att, tar, bm) 
            COD:ConnectWeapon(att, knife_model, Angle(0,90,0), Vector(0,-3,0), 1.5, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                bm:EmitSound(")tdmg/takedown/execution_001_stand.ogg", tar:GetBloodColor())
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(1.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            COD:ConnectWeapon(att, knife_model, Angle(0,90,0), Vector(0,-3,0), 1.5, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                bm:EmitSound(")tdmg/takedown/execution_001_laststand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
    },
    ["02"] = {
        name = "Punctual Puncture",
        deathtime = 3,
        deathtime_laststand = 2.6,
        effect = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,-1,3), 1.5, "anim_attachment_RH")
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                bm:EmitSound(")tdmg/takedown/execution_002_stand.ogg")
            end)
            timer.Simple(1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Thigh", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(0,90,0), Vector(0,-3,0), 1.5, "anim_attachment_RH")
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_002_laststand.ogg")
            end)
            timer.Simple(1.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["03"] = {
        name = "Sidearm Hustle",
        deathtime = 3,
        deathtime_laststand = 2.6,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(-50,0,40), Vector(-1,-0,-4), 1.1, "anim_attachment_RH")  
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_003_stand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(-50,0,40), Vector(-1,-0,-4), 1.1, "anim_attachment_RH")  
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_003_laststand.ogg")
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
    },
    ["04"] = {
        name = "Kneecaps And Brainpans",
        deathtime = 2.7,
        deathtime_laststand = 3.4,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(-50,0,40), Vector(-1,-0,-4), 1.1, "anim_attachment_RH") 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_004_stand.ogg")
            end)
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Calf", tar:GetBloodColor())
            end)
            timer.Simple(0.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(-50,0,40), Vector(-1,-0,-4), 1.1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_004_laststand.ogg")
            end)
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
    },
    ["05"] = {
        name = "Smooth Cuts",
        deathtime = 2.7,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, katana_model, Angle(0,0,40), Vector(0,-4,3), 0.8, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_005_stand.ogg")
            end)
            timer.Simple(1.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, katana_model, Angle(-60,0,40), Vector(0,-3,-1), 0.8, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_005_laststand.ogg")
            end)
            timer.Simple(1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Clavicle", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Clavicle", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
            end)
        end,
    },
    ["06"] = {
        name = "Slice And Easy",
        deathtime = 2.6,
        deathtime_laststand = 2.4,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, machete_model, Angle(-40,0,50), Vector(-0,-1,1), 1.2, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_006_stand.ogg")
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Thigh", tar:GetBloodColor())
            end)
            timer.Simple(1.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, machete_model, Angle(-40,0,50), Vector(-0,-1,1), 1.2, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_006_laststand.ogg")
            end)
            timer.Simple(0.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
    },
    ["07"] = {
        name = "Main Man",
        deathtime = 2.8,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(bm, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_007_stand.ogg")
            end)
            timer.Simple(0.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                local wep3, wep3_p = COD:TakeThisIntoPhys(wep2, 10)
                wep3_p:SetVelocity(tar:GetForward()*64-tar:GetRight()*64)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            timer.Simple(0.15, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_007_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["08"] = {
        name = "Lights Out",
        deathtime = 2.8,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_008_stand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_008_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["09"] = {
        name = "Blowout",
        deathtime = 3.2,
        deathtime_laststand = 2.6,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(-220,-25,-240), Vector(9.5,-5,7.8), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                att:EmitSound(")tdmg/takedown/execution_009_stand.ogg")
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(-220,-25,-240), Vector(9.5,-5,7.8), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_009_laststand.ogg")
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["10"] = {
        name = "Racked And Wrecked",
        deathtime = 2.7,
        deathtime_laststand = 2.7,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(-220,-25,-240), Vector(9.5,-5,7.8), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                att:EmitSound(")tdmg/takedown/execution_010_stand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
                wep = COD:ConnectWeapon(att, shotgun_model, Angle(-270,-25,45), Vector(0,2,-3), 1, "anim_attachment_LH")
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
                wep = COD:ConnectWeapon(att, shotgun_model, Angle(-220,-25,-240), Vector(9.5,-5,7.8), 1, "anim_attachment_RH")
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(-220,-25,-240), Vector(9.5,-5,7.8), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_010_laststand.ogg")
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["11"] = {
        name = "LMG KIA",
        deathtime = 2.8,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-160,-90,-25), Vector(10,-3,1), 1.1, "anim_attachment_RH")
            timer.Simple(0.6, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_011_stand.ogg")
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-160,-90,-25), Vector(10,-3,1), 1.1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_011_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
    },
    ["12"] = {
        name = "Up Close And High Caliber",
        deathtime = 2.8,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-160,-90,-25), Vector(10,-3,1), 1.1, "anim_attachment_RH")
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_012_stand.ogg")
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-160,-90,-25), Vector(10,-3,1), 1.1, "anim_attachment_RH")
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_012_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
    },
    ["13"] = {
        name = "Sighted In",
        deathtime = 1.8,
        deathtime_laststand = 2,
        effect = function(att, tar, bm)
            if true then
                tar:SetNWBool('HeadBlowMWII', true)
            end
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(45,-40,70), Vector(7,-5,9), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            local wep2 = COD:ConnectWeapon(bm, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_013_stand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
                if true then
                    tar:HeadBlow()
                end
                local wep3, wep3_p = COD:TakeThisIntoPhys(wep2, 10)
                wep3_p:SetVelocity(tar:GetForward()*64)
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(45,-40,70), Vector(7,-5,9), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            if true then
                tar:SetNWBool('HeadBlowMWII', true)
            end
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_013_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
                if true then
                    tar:HeadBlow()
                end
            end)
        end,
    },
    ["14"] = {
        name = "Point And Shoot",
        
        deathtime = 1.7,
        deathtime_laststand = 2,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(45,-40,70), Vector(7,-5,9), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            local wep2 = COD:ConnectWeapon(bm, ar_model, Angle(-40,0,50), Vector(-2,-1,-4), 1, "anim_attachment_RH")
            if true then
                tar:SetNWBool('HeadBlowMWII', true)
            end
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_014_stand.ogg")
            end)
            timer.Simple(1.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
                if true then
                    tar:HeadBlow()
                end
                local wep3, wep3_p = COD:TakeThisIntoPhys(wep2, 10)
                wep3_p:SetVelocity(tar:GetForward()*64)
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(45,-40,70), Vector(7,-5,9), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            if true then
                tar:SetNWBool('HeadBlowMWII', true)
            end
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_014_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
                if true then
                    tar:HeadBlow()
                end
            end)
        end,
    },
    ["15"] = {
        name = "Hammer Meet Skull",
        
        deathtime = 2.8,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sledgehammer_model, Angle(45,-50,50), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_015_stand.ogg")
            end)
            timer.Simple(0.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sledgehammer_model, Angle(45,-50,50), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_015_laststand.ogg")
            end)
            timer.Simple(1.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
    },
    ["16"] = {
        name = "Breach And Fear",
        
        deathtime = 2.2,
        deathtime_laststand = 2.2,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sledgehammer_model, Angle(45,-50,50), Vector(-3,-8,4), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_016_stand.ogg")
            end)
            timer.Simple(0.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, sledgehammer_model, Angle(45,-50,50), Vector(-3,-8,4), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_016_laststand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)
        end,
    },
    ["17"] = {
        name = "Resident Drummer",
        
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/wpn_h1_melee_mace_wm.mdl", Angle(-10,0,0), Vector(1.5,0,0), 1.1, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, "models/tdmg/wep/wpn_h1_melee_mace_wm.mdl", Angle(10,0,0), Vector(0,1.5,0), 1.1, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_017_stand.ogg")
            end)
            timer.Simple(0.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/wpn_h1_melee_mace_wm.mdl", Angle(-10,0,0), Vector(1.5,0,0), 1.1, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, "models/tdmg/wep/wpn_h1_melee_mace_wm.mdl", Angle(10,0,0), Vector(0,1.5,0), 1.1, "anim_attachment_LH")
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_017_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["18"] = {
        name = "Bloody Percussionist",
        
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            local wep1 = COD:ConnectWeapon(att, katana_model, Angle(-10,0,0), Vector(0,-1,4), 0.6, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, katana_model, Angle(10,0,0), Vector(1,0,4), 0.6, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_018_stand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep1 = COD:ConnectWeapon(att, katana_model, Angle(-10,0,0), Vector(0,-1,4), 0.6, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, katana_model, Angle(10,0,0), Vector(1,0,4), 0.6, "anim_attachment_LH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_018_laststand.ogg")
            end)
            timer.Simple(0.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["19"] = {
        name = "Lumber Smack",
        deathtime = 3.2,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pickaxe_model, Angle(10,0,0), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_019_stand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pickaxe_model, Angle(-50,0,50), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_019_laststand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
    },
    ["20"] = {
        name = "Chopping Block",
        
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pickaxe_model, Angle(0,0,0), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_020_stand.ogg")
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pickaxe_model, Angle(10,0,-30), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_020_laststand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
        end,
    },
    ["21"] = {
        name = "Don't Struggle",
        
        deathtime = 2.4,
        deathtime_laststand = 2.4,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-1,-1), 1.1, "anim_attachment_RH")
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                att:EmitSound(")tdmg/takedown/execution_021_stand.ogg")
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)  
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)   
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-1,-1), 1.1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_021_laststand.ogg")
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)   
        end,
    },
    ["22"] = {
        name = "A Friendly Hello",
        
        deathtime = 2.8,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-1,-1), 1.1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_022_stand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Thigh", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)    
        end,
        effect_laststand = function(att, tar, bm) 
            local wep = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-1,-1), 1.1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_022_laststand.ogg")
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                wep:Remove()
            end)   
        end,
    },
    ["23"] = {
        name = "Slingblade",
        
        deathtime = 2.6,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm) 
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,-1,3), 1.5, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_023_stand.ogg")
            end)
            timer.Simple(0.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,-1,3), 1.5, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_023_laststand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
    },
    ["24"] = {
        name = "Planting Steel",
        
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            COD:ConnectWeapon(att, knife_model, Angle(270,90,0), Vector(0,-1,-2), 1.5, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_024_stand.ogg")
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Thigh", tar:GetBloodColor())
            end)
            timer.Simple(1.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,-1,3), 1.5, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_024_laststand.ogg")
            end)
            timer.Simple(1.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["25"] = {
        name = "Knuckle Up",
        
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_025_stand.ogg")
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_025_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["26"] = {
        name = "No Firearms Needed",
        
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_026_stand.ogg")
            end)
            timer.Simple(1.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_026_laststand.ogg")
            end)
        end,
    },
    ["27"] = {
        name = "Jaw Buster",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_027_stand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_027_laststand.ogg")
            end)
            timer.Simple(0.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["28"] = {
        name = "All Kicks",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_028_stand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_028_laststand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["29"] = {
        name = "Cage Match",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_029_stand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_029_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["30"] = {
        name = "Sweet Dreams",
        deathtime = 2.3,
        deathtime_laststand = 2.3,
        effect = function(att, tar, bm) 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_030_stand.ogg")
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_030_laststand.ogg")
            end)
        end,
    },
    ["31"] = {
        name = "Suplex Deluxe",
        deathtime = 2.4,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm) 
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_031_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0.6, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_031_laststand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["32"] = {
        name = "Gravity Assist",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm) 
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_032_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm) 
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_032_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["33"] = {
        name = "A Bit Stabby",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(270,90,0), Vector(0,-1,-2), 1.5, "anim_attachment_RH") 
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_033_stand.ogg")
            end)
            timer.Simple(1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(270,90,0), Vector(0,-1,-2), 1.5, "anim_attachment_RH") 
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_033_laststand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["40"] = {
        name = "Rapid Incision",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(270,90,0), Vector(0,-1,-2), 1.5, "anim_attachment_RH") 
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_040_stand.ogg")
            end)
            timer.Simple(2.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Upperarm", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,-1,3), 1.5, "anim_attachment_RH")
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_040_laststand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["41"] = {
        name = "Killer Kodachis",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(-10,0,0), Vector(0,-1,-4), 1.3, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, new_katana_model, Angle(10,0,0), Vector(1,0,-4), 1.3, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_041_stand.ogg")
            end)
            timer.Simple(0.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(0.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end) 
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(-10,0,0), Vector(0,-1,-4), 1.3, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, new_katana_model, Angle(10,0,0), Vector(1,0,-4), 1.3, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_041_laststand.ogg")
            end)
            timer.Simple(1.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end) 
        end,
    },
    ["42"] = {
        name = "Sadukar Wrath",
        deathtime = 2.8,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(-10,0,0), Vector(0,-1,-4), 1.3, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, new_katana_model, Angle(10,0,0), Vector(1,0,-4), 1.3, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_042_stand.ogg")
            end)
            timer.Simple(0.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.9, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(-10,0,180), Vector(0,-1,4), 1.3, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, new_katana_model, Angle(10,0,180), Vector(1,0,4), 1.3, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_042_laststand.ogg")
            end)
            timer.Simple(1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["43"] = {
        name = "Smack Attack",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_043_stand.ogg")
            end)
            timer.Simple(0.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_043_laststand.ogg")
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["44"] = {
        name = "Foul Fate",
        deathtime = 3,
        deathtime_laststand = 2.6,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_044_stand.ogg")
            end)
            timer.Simple(0.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Pelvis", tar:GetBloodColor())
            end)
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.35, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Pelvis", tar:GetBloodColor())
            end)
            timer.Simple(0.35, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Pelvis", tar:GetBloodColor())
            end)
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_044_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["45"] = {
        name = "Sticky Situation",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_stick_model, Angle(-10,0,0), Vector(1.5,0,-4), 1.2, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, new_stick_model, Angle(10,0,0), Vector(0,0,-4), 1.2, "anim_attachment_LH")
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_045_stand.ogg")
            end)
            timer.Simple(0.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_stick_model, Angle(-10,0,0), Vector(1.5,0,-4), 1.2, "anim_attachment_RH")
            local wep2 = COD:ConnectWeapon(att, new_stick_model, Angle(10,0,0), Vector(0,0,-4), 1.2, "anim_attachment_LH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_045_laststand.ogg")
            end)
            timer.Simple(2.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["47"] = {
        name = "Timber",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, new_pickaxe_model, Angle(10,0,0), Vector(0,0,-3), 1.2, "anim_attachment_RH")
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_047_stand.ogg")
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Thigh", tar:GetBloodColor())
            end)
            timer.Simple(1.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Upperarm", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Upperarm", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, new_pickaxe_model, Angle(10,0,0), Vector(0,0,-3), 1.2, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_047_laststand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Upperarm", tar:GetBloodColor())
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Upperarm", tar:GetBloodColor())
            end)
        end,
    },
    ["49"] = {
        name = "Hammer It Out",
        deathtime = 2.7,
        deathtime_laststand = 2.2,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, sledgehammer_model, Angle(0,90,30), Vector(2,0,4), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_049_stand.ogg")
                if true then
                    tar:SetNWBool('HeadBlowMWII', true)
                end
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Neck1", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, sledgehammer_model, Angle(0,90,30), Vector(2,0,4), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_049_laststand.ogg")
                if true then
                    tar:SetNWBool('HeadBlowMWII', true)
                end
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
            end)
        end,
    },
    ["51"] = {
        name = "Blackcell SOP",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH") 
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_051_stand.ogg")
            end)
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH") 
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_051_laststand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["52"] = {
        name = "Blackcell Moves",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH")  
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_052_stand.ogg")
            end)
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Calf", tar:GetBloodColor())
            end)
            timer.Simple(2.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH")  
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_052_laststand.ogg")
            end)
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(1.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["53"] = {
        name = "Bootlicker",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_053_stand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_053_laststand.ogg")
            end)
            timer.Simple(2.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["55"] = {
        name = "Hip Hop Hurt",
        deathtime = 2.4,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep2 = COD:ConnectWeapon(bm, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_055_stand.ogg")
            end)
            timer.Simple(1.5, function()
                if !IsValid(wep2) then return end
                local wep3, wep3_p = COD:TakeThisIntoPhys(wep2, 10)
                wep3_p:SetVelocityInstantaneous(att:GetForward()*128)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_055_laststand.ogg")
            end)
        end,
    },
    ["56"] = {
        name = "Spinal Adjustment",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_056_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_056_laststand.ogg")
            end)
        end,
    },
    ["57"] = {
        name = "Shred Em Up",
        deathtime = 2.2,
        deathtime_laststand = 2.5,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(-10,0,0), Vector(0,-1,-4), 1.3, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_057_stand.ogg")
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Calf", tar:GetBloodColor())
            end)
            timer.Simple(1.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Neck1", tar:GetBloodColor())
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(0,0,180), Vector(0,-1,4), 1.3, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_057_laststand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
            end)
        end,
    },
    ["58"] = {
        name = "Shhh",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, new_katana_model, Angle(0,0,180), Vector(0,-1,4), 1.3, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_058_stand.ogg")
            end)
            timer.Simple(1.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, katana_model, Angle(-10,0,0), Vector(0,-1,4), 0.7, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_058_laststand.ogg")
            end)
            timer.Simple(0.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
            end)
        end,
    },
    ["60"] = {
        name = "Boomstick Boogie",
        deathtime = 2.75,
        deathtime_laststand = 2.75,
        effect = function(att, tar, bm)
            tar:SetNWBool('HeadBlowMWII', true)
            local wep = COD:ConnectWeapon(att, "models/tdmg/wep/new/doomshotgun.mdl", Angle(-25,0,0), Vector(10,0,2), 1.1, "anim_attachment_RH")
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_060_stand.ogg")
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
            end)
            timer.Simple(2.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetOrigin(wep:GetPos()+wep:GetForward()*32)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            tar:SetNWBool('HeadBlowMWII', true)
            local wep = COD:ConnectWeapon(att, "models/tdmg/wep/new/doomshotgun.mdl", Angle(-25,0,0), Vector(10,0,2), 1.1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_060_laststand.ogg")
            end)
            timer.Simple(2.7, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
            end)
            timer.Simple(2.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetOrigin(wep:GetPos()+wep:GetForward()*32)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["61"] = {
        name = "Daughter Of Hatred",
        deathtime = 3.8,
        deathtime_laststand = 3.8,
        effect = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_061_stand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, true, true, true)
            end)
            for i=1,10 do
                timer.Simple(1+(i/10), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                end)
            end
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, false)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_061_laststand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, true, false, true)
            end)
            for i=1,10 do
                timer.Simple(1+(i/10), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                end)
            end
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, false)
            end)
        end,
    },
    ["62"] = {
        name = "Inarius Impaling",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/props_junk/harpoon002a.mdl", Angle(90,0,0), Vector(0,0,3), 0.8, "anim_attachment_RH")
            local wep3, wep3_p
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_062_stand.ogg")
            end)
            timer.Simple(1.25, function()
                if !IsValid(tar) or !tar.Takedowning or !IsValid(wep) then return end
                wep:Remove()
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
                wep = COD:ConnectWeapon(bm, "models/props_junk/harpoon002a.mdl", Angle(0,0,0), Vector(0,0,3), 0.8, "chest")
            end)
            
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/props_junk/harpoon002a.mdl", Angle(270,0,0), Vector(0,0,3), 0.8, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_062_laststand.ogg")
            end)
            timer.Simple(1.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
        end,
    },
    ["63"] = {
        name = "Stabbed A Lot",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,0,3), 1.6, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_063_stand.ogg")
            end)
            timer.Simple(1.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,0,3), 1.6, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_063_laststand.ogg")
            end)
            timer.Simple(0.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["64"] = {
        name = "Lets Go Clubbing",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/w_baton.mdl", Angle(0,90,0), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_064_stand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/w_baton.mdl", Angle(0,270,0), Vector(0,0,0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_064_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["65"] = {
        name = "Bruised and Battered",
        deathtime = 3.2,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/w_batteringram.mdl", Angle(0,140,0), Vector(7,10,-3), 1, "anim_attachment_RH")
            local wep3, wep3_p
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_065_stand.ogg")
            end)
            timer.Simple(2.9, function()
                if !IsValid(wep1) then return end
                wep3, wep3_p = COD:TakeThisIntoPhys(wep1, 10)
                wep3_p:SetVelocity(att:GetForward()*128+att:GetRight()*48-Vector(0,0,128))
            end)
            timer.Simple(3.15, function()
                if !IsValid(wep3_p) then return end
                wep3_p:SetVelocity(att:GetForward()*72+Vector(0,0,200))
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/w_batteringram.mdl", Angle(0,90,0), Vector(7,4,-3), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_065_laststand.ogg")
            end)
            timer.Simple(2.6, function()
                if !IsValid(wep1) then return end
                wep3, wep3_p = COD:TakeThisIntoPhys(wep1, 10)
                wep3_p:SetVelocity(Vector(0,0,-64))
            end)
            timer.Simple(2.8, function()
                if !IsValid(wep3_p) then return end
                wep3_p:SetVelocity(att:GetForward()*72+Vector(0,0,200))
            end)
        end,
    },
    ["66"] = {
        name = "Electrifying",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/w_shocker.mdl", Angle(0,90,0), Vector(0,0,3), 1, "anim_attachment_RH")
            for i=1,20 do
                timer.Simple(0.5+(i*0.05), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                    local ef = EffectData()
                    ef:SetEntity(bm)
                    ef:SetMagnitude(1)
                    util.Effect("TeslaHitboxes", ef)
                end)
            end
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_066_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, "models/tdmg/wep/w_shocker.mdl", Angle(0,90,0), Vector(0,0,3), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_066_laststand.ogg")
            end)
            for i=1,20 do
                timer.Simple(1+(i*0.05), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                    local ef = EffectData()
                    ef:SetEntity(bm)
                    ef:SetMagnitude(1)
                    util.Effect("TeslaHitboxes", ef)
                end)
            end
        end,
    },
    ["67"] = {
        name = "Shell Of A Day",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(20,190,0), Vector(12,1,3), 1, "anim_attachment_RH")
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
                att:EmitSound(")tdmg/takedown/execution_067_stand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(20,190,0), Vector(12,1,3), 1, "anim_attachment_RH")
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_067_laststand.ogg")
            end)
            timer.Simple(1.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["68"] = {
        name = "Shotgun Slayed",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(20,190,0), Vector(12,1,3), 1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_068_stand.ogg")
            end)
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
            timer.Simple(2.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, shotgun_model, Angle(20,190,0), Vector(12,1,3), 1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_068_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine", tar:GetBloodColor())
            end)
        end,
    },
    ["69"] = {
        name = "No Escape",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-0,90,180), Vector(10,-2,-2), 1.1, "anim_attachment_RH")
            timer.Simple(0.6, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_069_stand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-0,90,180), Vector(10,-2,-2), 1.1, "anim_attachment_RH")
            timer.Simple(0.7, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_069_laststand.ogg")
            end)
            timer.Simple(2.2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["70"] = {
        name = "OMG LMG",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-0,100,180), Vector(10,0,-3), 1.1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_070_stand.ogg")
            end)
            timer.Simple(1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, pkm_model, Angle(-0,100,180), Vector(10,0,-3), 1.1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_070_laststand.ogg")
            end)
            for i=1,4 do
                timer.Simple(2.1+(i*0.1), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
                end)
                timer.Simple(2.1+(i*0.1), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                    local ef = EffectData()
                    ef:SetEntity(wep)
                    ef:SetAttachment(1)
                    ef:SetFlags(1)
                    util.Effect("MuzzleFlash", ef)
                end)
            end
        end,
    },
    ["71"] = {
        name = "Close Encounter",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(0,270,4), Vector(12,0,6), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_071_stand.ogg")
            end)
            timer.Simple(0.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Calf", tar:GetBloodColor())
            end)
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(0,270,4), Vector(12,0,6), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_071_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["72"] = {
        name = "No Scope Needed",
        deathtime = 2.1,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            tar:SetNWBool('HeadBlowMWII', true)
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(0,270,4), Vector(12,0,6), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            local wep2 = COD:ConnectWeapon(bm, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_072_stand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
            end)
            timer.Simple(2, function()
                if !IsValid(wep2) then return end
                COD:TakeThisIntoPhys(wep2, 10)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, sniper_model, Angle(0,270,4), Vector(12,0,6), 1, "anim_attachment_RH", false, "ValveBiped.Bip01_R_Hand")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_072_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep) then return end
                local ef = EffectData()
                ef:SetEntity(wep)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["73"] = {
        name = "Heavy Handed",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_073_stand.ogg")
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_073_laststand.ogg")
            end)
        end,
    },
    ["74"] = {
        name = "Get Bodied",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_074_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_074_laststand.ogg")
            end)
        end,
    },
    ["75"] = {
        name = "Beat Drop",
        deathtime = 3,
        deathtime_laststand = 2.8,
        effect = function(att, tar, bm)
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_075_stand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_075_laststand.ogg")
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["77"] = {
        name = "Snoop Hustle",
        deathtime = 2.8,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(270,90,0), Vector(0,-1,-2), 1.5, "anim_attachment_RH") 
            local wep = COD:ConnectWeapon(bm, ar_model, Angle(0,0,20), Vector(-2,-1,-0), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_077_stand.ogg")
            end)
            timer.Simple(2.1, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(wep) then return end
                COD:TakeThisIntoPhys(wep, 10)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            COD:ConnectWeapon(att, knife_model, Angle(90,90,0), Vector(0,-1,3), 1.5, "anim_attachment_RH") 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_077_laststand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["79"] = {
        name = "Bong RIP",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/props_junk/GlassBottle01a.mdl", Angle(0,0,0), Vector(0,0.5,4), 1, "anim_attachment_RH") 
            local wep3, wep3_p
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_079_stand.ogg")
            end)
            timer.Simple(0.5, function()
                if !IsValid(wep) then return end
                wep3, wep3_p = COD:TakeThisIntoPhys(wep, 10)
                wep3_p:SetVelocity(att:GetForward()*64-Vector(0,0,256))
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/props_junk/GlassBottle01a.mdl", Angle(0,0,0), Vector(0,0.5,4), 1, "anim_attachment_RH") 
            local wep3, wep3_p
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_079_laststand.ogg")
            end)
            timer.Simple(0.5, function()
                if !IsValid(wep) then return end
                wep3, wep3_p = COD:TakeThisIntoPhys(wep, 10)
                wep3_p:SetVelocity(att:GetForward()*100)
            end)
            timer.Simple(2.4, function()
                if !IsValid(wep3) then return end
                wep3:Fire("Break")
            end)
        end,
    },
    ["81"] = {
        name = "Deadly From Downtown",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/weapons/w_eq_fraggrenade_thrown.mdl", Angle(0,0,0), Vector(0,0,0), 1, "anim_attachment_RH")
            local wep3, wep3_p
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_081_stand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                wep3, wep3_p = COD:TakeThisIntoPhys(wep, 10)
                wep3_p:SetVelocity(att:GetForward()*150+Vector(0,0,100))
            end)
            timer.Simple(2.6, function()
                if !IsValid(wep3) then return end
                local ef = EffectData()
                ef:SetOrigin(wep3:GetPos())
                ef:SetFlags(1)
                util.Effect("Explosion", ef)
                wep3:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/weapons/w_eq_fraggrenade_thrown.mdl", Angle(0,0,0), Vector(0,0,0), 1, "anim_attachment_RH")
            local wep3, wep3_p
            timer.Simple(0.2, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_081_laststand.ogg")
            end)
            timer.Simple(1.7, function()
                if !IsValid(att) or !att.Takedowning then return end
                wep3, wep3_p = COD:TakeThisIntoPhys(wep, 10)
                wep3_p:SetVelocity(att:GetForward()*24)
            end)
            timer.Simple(2.6, function()
                if !IsValid(wep3) then return end
                local ef = EffectData()
                ef:SetOrigin(wep3:GetPos())
                ef:SetFlags(1)
                util.Effect("Explosion", ef)
                wep3:Remove()
            end)
        end,
    },
    ["83"] = {
        name = "Tatman Tactics",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_083_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_083_laststand.ogg")
            end)
        end,
    },
    ["85"] = {
        name = "Kickin It",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0.5, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_085_stand.ogg")
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_085_laststand.ogg")
            end)
            timer.Simple(2.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
    },
    ["86"] = {
        name = "Cranial Crack",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_086_stand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_086_laststand.ogg")
            end)
        end,
    },
    ["87"] = {
        name = "Laser Everyone",
        deathtime = 2.5,
        deathtime_laststand = 2.5,
        effect = function(att, tar, bm)
            tar:SetNWBool('HeadBlowMWII', true)
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_087_stand.ogg")
                lasers(att, true)
            end)
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning then return end
                lasers(att, true)
            end)
            timer.Simple(0.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_L_Calf", tar:GetBloodColor())
            end)
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                lasers(att, false)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
                lasers(att, true)
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning then return end
                lasers(att, false)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            tar:SetNWBool('HeadBlowMWII', true)
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_087_laststand.ogg")
            end)
            timer.Simple(1, function()
                if !IsValid(att) or !att.Takedowning then return end
                lasers(att, true)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
                if true then
                    tar:HeadBlow()
                end
                lasers(att, true)
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                lasers(att, false)
            end)
        end,
    },
    ["88"] = {
        name = "Crowbar 101",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/tdmg/wep/w_crowbar.mdl", Angle(0,90,0), Vector(0,0,3), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_088_stand.ogg")
            end)
            timer.Simple(0.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep = COD:ConnectWeapon(att, "models/tdmg/wep/w_crowbar.mdl", Angle(0,90,0), Vector(0,0,3), 1, "anim_attachment_RH")
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_088_laststand.ogg")
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
        end,
    },
    ["89"] = {
        name = "Necessary Evil",
        deathtime = 2.8,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_089_stand.ogg")
            end)
            timer.Simple(1.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, true)
            end)
            timer.Simple(1.7, function()
                if !IsValid(bm) or !bm.Takedowning then return end
                local ef = EffectData()
                local pos = bm:GetPos()
                if bm:LookupBone("ValveBiped.Bip01_Pelvis") then
                    pos = bm:GetBonePosition(bm:LookupBone("ValveBiped.Bip01_Pelvis"))
                end
                ef:SetOrigin(pos)
                util.Effect("HelicopterMegaBomb", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, false)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_089_laststand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, true, true)
            end)
            timer.Simple(2.8, function()
                if !IsValid(bm) or !bm.Takedowning then return end
                local ef = EffectData()
                local pos = bm:GetPos()
                if bm:LookupBone("ValveBiped.Bip01_Pelvis") then
                    pos = bm:GetBonePosition(bm:LookupBone("ValveBiped.Bip01_Pelvis"))
                end
                ef:SetOrigin(pos)
                util.Effect("HelicopterMegaBomb", ef)
            end)
            timer.Simple(3, function()
                if !IsValid(att) or !att.Takedowning then return end
                lights(att, false)
            end)
        end,
    },
    ["90"] = {
        name = "Sidepiece Deceased",
        deathtime = 3,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_090_stand.ogg")
            end)
            timer.Simple(0.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_R_Calf", tar:GetBloodColor())
            end)
            timer.Simple(0.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
            end)
            timer.Simple(2.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_090_laststand.ogg")
            end)
            timer.Simple(2.3, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.3, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
        end,
    },
    ["93"] = {
        name = "Play For Sport",
        deathtime = 2.8,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH") 
            timer.Simple(0, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_093_stand.ogg")
            end)
            for i=1,3 do
                timer.Simple(0.8+(i/5), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                    local ef = EffectData()
                    ef:SetEntity(wep1)
                    ef:SetAttachment(1)
                    ef:SetFlags(1)
                    util.Effect("MuzzleFlash", ef)
                end)
                timer.Simple(0.8+(i/5), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
                end)
                timer.Simple(0.95+(i/5), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                    local ef = EffectData()
                    ef:SetEntity(wep2)
                    ef:SetAttachment(1)
                    ef:SetFlags(1)
                    util.Effect("MuzzleFlash", ef)
                end)
                timer.Simple(0.95+(i/5), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
                end)
            end
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH") 
            timer.Simple(0.1, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_093_laststand.ogg")
            end)
            timer.Simple(1.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(1.9, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.9, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
    ["94"] = {
        name = "Fate And Consequence",
        deathtime = 2.8,
        deathtime_laststand = 3,
        effect = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH") 
            timer.Simple(0.6, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_094_stand.ogg")
            end)
            timer.Simple(0.8, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(0.8, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(1.6, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(1.6, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Spine2", tar:GetBloodColor())
            end)
            timer.Simple(2.4, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                local ef = EffectData()
                ef:SetEntity(wep2)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.4, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(2.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                local ef = EffectData()
                ef:SetEntity(wep1)
                ef:SetAttachment(1)
                ef:SetFlags(1)
                util.Effect("MuzzleFlash", ef)
            end)
            timer.Simple(2.5, function()
                if !IsValid(tar) or !tar.Takedowning then return end
                bm:MWII_BE("ValveBiped.Bip01_Head1", tar:GetBloodColor())
            end)
            timer.Simple(3.7, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
        effect_laststand = function(att, tar, bm)
            local wep1 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_RH")  
            local wep2 = COD:ConnectWeapon(att, pistol_model, Angle(0,0,0), Vector(-4,-0.2,-1), 1.1, "anim_attachment_LH") 
            timer.Simple(0.4, function()
                if !IsValid(att) or !att.Takedowning then return end
                att:EmitSound(")tdmg/takedown/execution_094_laststand.ogg")
            end)
            for i=1,4 do
                timer.Simple(1.1+(i/5), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                    local ef = EffectData()
                    ef:SetEntity(wep1)
                    ef:SetAttachment(1)
                    ef:SetFlags(1)
                    util.Effect("MuzzleFlash", ef)
                end)
                timer.Simple(1.1+(i/5), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
                end)
                timer.Simple(1.2+(i/5), function()
                    if !IsValid(att) or !att.Takedowning or !IsValid(wep2) then return end
                    local ef = EffectData()
                    ef:SetEntity(wep2)
                    ef:SetAttachment(1)
                    ef:SetFlags(1)
                    util.Effect("MuzzleFlash", ef)
                end)
                timer.Simple(1.2+(i/5), function()
                    if !IsValid(tar) or !tar.Takedowning then return end
                    bm:MWII_BE("ValveBiped.Bip01_Spine4", tar:GetBloodColor())
                end)
            end
            timer.Simple(3.5, function()
                if !IsValid(att) or !att.Takedowning or !IsValid(wep1) then return end
                wep1:Remove()
                wep2:Remove()
            end)
        end,
    },
}