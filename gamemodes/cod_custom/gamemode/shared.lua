GM.Author = 'HarionPlayZ'
GM.Name = "Call Of Duty TDM"

--[[
    Say thanks to this guys:
        HarionPlayZ - Main Developer, ported CoD Animations to GMod.
        TameCoot - Retargeted CoD Season 1 Animations
        Kirloper - Gave MWII Animations
        Shark_Vil - SLib Library
        RefoselDev - Gave Hosting for server and many more
        HPZ Development Team - Viewmodels, animations, languages and more.

        ----------------------------------------------------------------
        help with Languages:

        
]]--

COD = COD or {}

AddCSLuaFile('languages.lua')
include('languages.lua')
AddCSLuaFile('takedowns.lua')
include('takedowns.lua')

COD.ApplyCommands = {
    ["Server"] = {
        ["sv_crazyphysics_warning"] = 0,
    },
    ["Client"] = {},
}

COD.DataTable = {
    ["MaxKills"] = 75,
    ["MaxTime"] = 600,
}

local str = file.Read("cod_tdm/"..game.GetMap()..".lua", "LUA")
if str then
    RunString(str)
end

COD.DataTable["Delay_Before_Start"] = 18
COD.DataTable["Enable_KillCam"] = true
COD.DataTable["Enable_KillCam_WithBots"] = true

COD.DataTable["Enable_RandomGamemode"] = true

COD.DataTable["Team1_Kills"] = 0
COD.DataTable["Team2_Kills"] = 0

COD.DataTable["MaxKills"] = 100
COD.DataTable["MaxTime"] = 600
COD.DataTable["MaxAIInTeam"] = 10

if not COD.DataTable["Gamemode"] then
    COD.DataTable["Gamemode"] = 1
end

COD.GamemodeSettings = {
    [1] = {
        ["MaxKills"] = 100,
        ["MaxTime"] = 600,
    },
    [2] = {
        ["MaxKills"] = 500,
        ["MaxTime"] = 900,
        ["Time_Before_HeavyUnits"] = 300,
        ["Time_Before_SupportPackages"] = 480,
    },
    [3] = {
        ["MaxKills"] = 100,
        ["MaxTime"] = 120,
    },
    [4] = {
        ["MaxKills"] = 100,
        ["MaxTime"] = 120,
    },
    [5] = {
        ["MaxKills"] = 200,
        ["MaxTime"] = 600,
    },
}

team.SetUp(1, "SpecGru", Color(85,165,95))
team.SetUp(2, "KorTac", Color(195,165,85))

COD.Killstreaks = {
    [1] = {
        name = COD.Language["killstreak_1"],
        desc = COD.Language["killstreak_desc_1"],
        icon = Material('tdmg/hud/killstreaks/puav.png'),
        kills = 4,
        sound = "tdmg/killstreaks/uav_ready.wav",
        func = function(ply)
            COD:UAVCall(ply:Team(), false)
            COD:GiveKSAnn(1, ply)
        end,
    },
    [2] = {
        name = COD.Language["killstreak_2"],
        desc = COD.Language["killstreak_desc_2"],
        icon = Material('tdmg/hud/killstreaks/drone.png'),
        kills = 4,
        sound = "tdmg/killstreaks/care_ready.wav",
        func = function(ply)
            COD:DroneSpawn(ply)
        end,
    },
    [3] = {
        name = COD.Language["killstreak_3"],
        desc = COD.Language["killstreak_desc_3"],
        icon = Material('tdmg/hud/killstreaks/armor.png'),
        kills = 4,
        sound = "tdmg/killstreaks/care_ready.wav",
        func = function(ply)
            ply:SetMaxArmor(250)
            ply:SetArmor(250)
            COD:GiveKSAnn(3, ply)
        end,
    },
    [4] = {
        name = COD.Language["killstreak_4"],
        desc = COD.Language["killstreak_desc_4"],
        icon = Material('tdmg/hud/killstreaks/carepackage.png'),
        kills = 5,
        sound = "tdmg/killstreaks/care_ready.wav",
        func = function(ply)
            ply:GiveRadioWep("package")
        end,
    },
    [5] = {
        name = COD.Language["killstreak_5"],
        desc = COD.Language["killstreak_desc_5"],
        icon = Material('tdmg/hud/killstreaks/counteruav.png'),
        kills = 5,
        sound = "tdmg/killstreaks/counter_uav_ready.wav",
        func = function(ply)
            COD:CounterUAVCall(ply)
        end,
    },
    [6] = {
        name = COD.Language["killstreak_6"],
        desc = COD.Language["killstreak_desc_6"],
        icon = Material('tdmg/hud/killstreaks/mine.png'),
        kills = 5,
        sound = "tdmg/killstreaks/care_ready.wav",
        func = function(ply)
            COD:SpawnCMine(ply)
        end,
    },
    [7] = {
        name = COD.Language["killstreak_7"],
        desc = COD.Language["killstreak_desc_7"],
        icon = Material('tdmg/hud/killstreaks/airstrike.png'),
        kills = 6,
        sound = "tdmg/killstreaks/airstrike_ready.wav",
        func = function(ply)
            ply:GiveRadioWep("airstrike")
        end,
    },
    [8] = {
        name = COD.Language["killstreak_8"],
        desc = COD.Language["killstreak_desc_8"],
        icon = Material('tdmg/hud/killstreaks/k9.png'),
        kills = 6,
        sound = "tdmg/dog/bark (7).wav",
        func = function(ply)
            COD:CallK9(ply)
            COD:GiveKSAnn(8, ply)
        end,
    },
    [9] = {
        name = COD.Language["killstreak_9"],
        desc = COD.Language["killstreak_desc_9"],
        icon = Material('tdmg/hud/killstreaks/sentry.png'),
        kills = 7,
        sound = "tdmg/killstreaks/turret_ready.wav",
        func = function(ply)
            COD:SpawnSentry(ply)
        end,
    },
    [10] = {
        name = COD.Language["killstreak_10"],
        desc = COD.Language["killstreak_desc_10"],
        icon = Material('tdmg/hud/killstreaks/patrol.png'),
        kills = 7,
        sound = "tdmg/killstreaks/airstrike_ready.wav",
        func = function(ply)
            COD:AirPatrol(ply)
            COD:GiveKSAnn(10, ply)
        end,
    },
    [11] = {
        name = COD.Language["killstreak_11"],
        desc = COD.Language["killstreak_desc_11"],
        icon = Material('tdmg/hud/killstreaks/mortar.png'),
        kills = 7,
        sound = "tdmg/killstreaks/airstrike_ready2.wav",
        func = function(ply)
            ply:GiveRadioWep("mortar")
        end,
    },
    [12] = {
        name = COD.Language["killstreak_12"],
        desc = COD.Language["killstreak_desc_12"],
        icon = Material('tdmg/hud/killstreaks/strat.png'),
        kills = 8,
        sound = "tdmg/killstreaks/airstrike_ready.wav",
        func = function(ply)
            ply:GiveRadioWep("strating_run")
        end,
    },
    [13] = {
        name = COD.Language["killstreak_13"],
        desc = COD.Language["killstreak_desc_13"],
        icon = Material('tdmg/hud/killstreaks/helicopter.png'),
        kills = 9,
        sound = "tdmg/killstreaks/heli_ready.wav",
        func = function(ply)
            ply:GiveRadioWep("helicopter")
        end,
    },
    [14] = {
        name = COD.Language["killstreak_14"],
        desc = COD.Language["killstreak_desc_14"],
        icon = Material('tdmg/hud/killstreaks/harrier.png'),
        kills = 9,
        sound = "tdmg/killstreaks/harrier_ready.wav",
        func = function(ply)
            ply:GiveRadioWep("harrier")
        end,
    },
    [15] = {
        name = COD.Language["killstreak_15"],
        desc = COD.Language["killstreak_desc_15"],
        icon = Material('tdmg/hud/killstreaks/backup.png'),
        kills = 9,
        sound = "tdmg/killstreaks/cover_ready.wav",
        func = function(ply)
            COD:CallReinforcment(ply)
            COD:GiveKSAnn(15, ply)
        end,
    },
    [16] = {
        name = COD.Language["killstreak_16"],
        desc = COD.Language["killstreak_desc_16"],
        icon = Material('tdmg/hud/killstreaks/stealth.png'),
        kills = 10,
        sound = "tdmg/killstreaks/airstrike_ready2.wav",
        func = function(ply)
            ply:GiveRadioWep("airstrike_line")
        end,
    },
    [17] = {
        name = COD.Language["killstreak_17"],
        desc = COD.Language["killstreak_desc_17"],
        icon = Material('tdmg/hud/killstreaks/heli.png'),
        kills = 10,
        sound = "tdmg/killstreaks/heli_ready.wav",
        func = function(ply)
            if not COD.DataTable["Enable_ManualControl_ChopperGunner"] then
                ply:GiveRadioWep("helicopterrun")
            else
                COD:HelicopterRun(ply, Vector())
            end
        end,
    },
    [18] = {
        name = COD.Language["killstreak_18"],
        desc = COD.Language["killstreak_desc_18"],
        icon = Material('tdmg/hud/killstreaks/muav.png'),
        kills = 12,
        sound = "tdmg/killstreaks/uav_ready.wav",
        func = function(ply)
            COD:UAVCall(ply:Team(), true)
            COD:GiveKSAnn(18, ply)
        end,
    },
    [19] = {
        name = COD.Language["killstreak_19"],
        desc = COD.Language["killstreak_desc_19"],
        icon = Material('tdmg/hud/killstreaks/airdrop.png'),
        kills = 12,
        sound = "tdmg/killstreaks/care_ready.wav",
        func = function(ply)
            ply:GiveRadioWep("emergencypackage")
        end,
    },
    [20] = {
        name = COD.Language["killstreak_20"],
        desc = COD.Language["killstreak_desc_20"],
        icon = Material('tdmg/hud/killstreaks/ac130.png'),
        kills = 15,
        sound = "tdmg/killstreaks/ac130_ready.wav",
        func = function(ply)
            COD:CallAC130(ply)
            COD:GiveKSAnn(20, ply)
        end,
    },
    [21] = {
        name = COD.Language["killstreak_21"],
        desc = COD.Language["killstreak_desc_21"],
        icon = Material('tdmg/hud/killstreaks/jugger.png'),
        kills = 15,
        sound = "tdmg/killstreaks/care_ready.wav",
        func = function(ply)
            COD:GiveJuggernaut(ply)
            COD:GiveKSAnn(21, ply)
        end,
    },
    [22] = {
        name = COD.Language["killstreak_22"],
        desc = COD.Language["killstreak_desc_22"],
        icon = Material('tdmg/hud/killstreaks/nuke.png'),
        kills = 25,
        sound = "tdmg/killstreaks/nuke_ready.wav",
        func = function(ply)
            COD:Nuke(ply:Team())
            COD:GiveKSAnn(22, ply)
        end,
    },
}

COD.Perks = {
    ["Type1"] = {
        [1] = {
            name = COD.Language["perk_1_1"],
            desc = COD.Language["perk_1_1_desc"],
            icon = Material("tdmg/hud/perks/explodedef.png"),
        },
        [2] = {
            name = COD.Language["perk_1_2"],
            desc = COD.Language["perk_1_2_desc"],
            icon = Material("tdmg/hud/perks/spectator.png"),
        },
        [3] = {
            name = COD.Language["perk_1_3"],
            desc = COD.Language["perk_1_3_desc"],
            icon = Material("tdmg/hud/perks/star.png"),
        },
        [4] = {
            name = COD.Language["perk_1_4"],
            desc = COD.Language["perk_1_4_desc"],
            icon = Material("tdmg/hud/perks/fastequip.png"),
        },
    },
    ["Type2"] = {
        [1] = {
            name = COD.Language["perk_2_1"],
            desc = COD.Language["perk_2_1_desc"],
            icon = Material("tdmg/hud/perks/fasthealth.png"),
        },
        [2] = {
            name = COD.Language["perk_2_2"],
            desc = COD.Language["perk_2_2_desc"],
            icon = Material("tdmg/hud/perks/survival.png"),
        },
        [3] = {
            name = COD.Language["perk_2_3"],
            desc = COD.Language["perk_2_3_desc"],
            icon = Material("tdmg/hud/perks/ghost.png"),
        },
        [4] = {
            name = COD.Language["perk_2_4"],
            desc = COD.Language["perk_2_4_desc"],
            icon = Material("tdmg/hud/perks/invisiblity.png"),
        },
    },
}

COD.Loadout = {
    ["Pistols"] = {
        [".357"] = {
            class = "mg_357",
            icon = Material("vgui/entities/mg_357"),
        },
        [".50 GS"] = {
            class = "mg_deagle",
            icon = Material("vgui/entities/mg_deagle"),
        },
        ["M19"] = {
            class = "mg_p320",
            icon = Material("vgui/entities/mg_p320"),
        },
        ["M1911"] = {
            class = "mg_m1911",
            icon = Material("vgui/entities/mg_m1911"),
        },
        ["Renetti"] = {
            class = "mg_m9",
            icon = Material("vgui/entities/mg_m9"),
        },
        ["Sykov"] = {
            class = "mg_makarov",
            icon = Material("vgui/entities/mg_makarov"),
        },
        ["X16"] = {
            class = "mg_glock",
            icon = Material("vgui/entities/mg_glock"),
        },
    },
    ["SMGs"] = {
        ["AUG"] = {
            class = "mg_augolf",
            icon = Material("vgui/entities/mg_augolf"),
        },
        ["CX-9"] = {
            class = "mg_secho",
            icon = Material("vgui/entities/mg_secho"),
        },
        ["Fennec"] = {
            class = "mg_victor",
            icon = Material("vgui/entities/mg_victor"),
        },
        ["ISO"] = {
            class = "mg_charlie9",
            icon = Material("vgui/entities/mg_charlie9"),
        },
        ["MP5"] = {
            class = "mg_mpapa5",
            icon = Material("vgui/entities/mg_mpapa5"),
        },
        ["MP7"] = {
            class = "mg_mpapa7",
            icon = Material("vgui/entities/mg_mpapa7"),
        },
        ["P90"] = {
            class = "mg_papa90",
            icon = Material("vgui/entities/mg_papa90"),
        },
        ["PP19 Bizon"] = {
            class = "mg_beta",
            icon = Material("vgui/entities/mg_beta"),
        },
        ["Striker 45"] = {
            class = "mg_smgolf45",
            icon = Material("vgui/entities/mg_smgolf45"),
        },
        ["UZI"] = {
            class = "mg_uzulu",
            icon = Material("vgui/entities/mg_uzulu"),
        },
    },
    ["Assault Rifles"] = {
        ["AK-47"] = {
            class = "mg_akilo47",
            icon = Material("vgui/entities/mg_akilo47"),
        },
        ["AN-94"] = {
            class = "mg_anovember94",
            icon = Material("vgui/entities/mg_anovember94"),
        },
        ["AS-VAL"] = {
            class = "mg_valpha",
            icon = Material("vgui/entities/mg_valpha"),
        },
        ["CR-56 AMAX"] = {
            class = "mg_galima",
            icon = Material("vgui/entities/mg_galima"),
        },
        ["FAL"] = {
            class = "mg_falima",
            icon = Material("vgui/entities/mg_falima"),
        },
        ["FN SCAR 17"] = {
            class = "mg_scharlie",
            icon = Material("vgui/entities/mg_scharlie"),
        },
        ["FR 5.56"] = {
            class = "mg_falpha",
            icon = Material("vgui/entities/mg_falpha"),
        },
        ["Grau 5.56"] = {
            class = "mg_sierra552",
            icon = Material("vgui/entities/mg_sierra552"),
        },
        ["Kilo 141"] = {
            class = "mg_kilo433",
            icon = Material("vgui/entities/mg_kilo433"),
        },
        ["M13"] = {
            class = "mg_mcharlie",
            icon = Material("vgui/entities/mg_mcharlie"),
        },
        ["M4A1"] = {
            class = "mg_mike4",
            icon = Material("vgui/entities/mg_mike4"),
        },
        ["Oden"] = {
            class = "mg_asierra12",
            icon = Material("vgui/entities/mg_asierra12"),
        },
        ["RAM-7"] = {
            class = "mg_tango21",
            icon = Material("vgui/entities/mg_tango21"),
        },
    },
    ["LMGs"] = {
        ["Bruen MK9"] = {
            class = "mg_mkilo3",
            icon = Material("vgui/entities/mg_mkilo3"),
        },
        ["FiNN LMG"] = {
            class = "mg_sierrax",
            icon = Material("vgui/entities/mg_sierrax"),
        },
        ["Holger-26"] = {
            class = "mg_mgolf36",
            icon = Material("vgui/entities/mg_mgolf36"),
        },
        ["M91"] = {
            class = "mg_kilo121",
            icon = Material("vgui/entities/mg_kilo121"),
        },
        ["MG34"] = {
            class = "mg_mgolf34",
            icon = Material("vgui/entities/mg_mgolf34"),
        },
        ["PKM"] = {
            class = "mg_pkilo",
            icon = Material("vgui/entities/mg_pkilo"),
        },
        ["RAAL MG"] = {
            class = "mg_slima",
            icon = Material("vgui/entities/mg_slima"),
        },
        ["SA87"] = {
            class = "mg_lima86",
            icon = Material("vgui/entities/mg_lima86"),
        },
    },
    ["Sniper Rifles"] = {
        ["AX-50"] = {
            class = "mg_alpha50",
            icon = Material("vgui/entities/mg_alpha50"),
        },
        ["Dragunov"] = {
            class = "mg_delta",
            icon = Material("vgui/entities/mg_delta"),
        },
        ["HDR"] = {
            class = "mg_hdromeo",
            icon = Material("vgui/entities/mg_hdromeo"),
        },
        ["Rytec AMR"] = {
            class = "mg_xmike109",
            icon = Material("vgui/entities/mg_xmike109"),
        },
    },
    ["Marksman Rifles"] = {
        ["Crossbow"] = {
            class = "mg_crossbow",
            icon = Material("vgui/entities/mg_crossbow"),
        },
        ["EBR-14"] = {
            class = "mg_mike14",
            icon = Material("vgui/entities/mg_mike14"),
        },
        ["Kar98k"] = {
            class = "mg_kilo98",
            icon = Material("vgui/entities/mg_kilo98"),
        },
        ["MK2 Carabine"] = {
            class = "mg_sbeta",
            icon = Material("vgui/entities/mg_sbeta"),
        },
        ["SKS"] = {
            class = "mg_sksierra",
            icon = Material("vgui/entities/mg_sksierra"),
        },
        ["SPR"] = {
            class = "mg_romeo700",
            icon = Material("vgui/entities/mg_romeo700"),
        },
    },
    ["Shotguns"] = {
        ["725"] = {
            class = "mg_charlie725",
            icon = Material("vgui/entities/mg_charlie725"),
        },
        ["Jak-12"] = {
            class = "mg_aalpha12",
            icon = Material("vgui/entities/mg_aalpha12"),
        },
        ["Model 680"] = {
            class = "mg_romeo870",
            icon = Material("vgui/entities/mg_romeo870"),
        },
        ["Origin-12"] = {
            class = "mg_oscar12",
            icon = Material("vgui/entities/mg_oscar12"),
        },
        ["R9-0"] = {
            class = "mg_dpapa12",
            icon = Material("vgui/entities/mg_dpapa12"),
        },
        ["VLK Rogue"] = {
            class = "mg_mike26",
            icon = Material("vgui/entities/mg_mike26"),
        },
    },
    ["Others"] = {
        ["Combat Knife"] = {
            class = "tdm_infection_knife",
            icon = Material("vgui/spawnicons/icon_cac_weapon_me_soscar_knife"),
        },
    },
}