AddCSLuaFile()

SWEP.Animations = {
    ["Idle"] = {--idle is a special animation index, movement animations are played when this is on
        Sequences = {"idle"},
        Fps = 30,
        Events = {
        {Time = 0, Callback = function(self) self:EnableGrip() end},
        {Time = 0, Callback = function(self) self:EnableGrip2() end},
    }
        --does not need NextSequence to loop, it's an exception to the rule
    },

    ["Draw"] = {
        Sequences = {"draw"},
        Length = 0.85,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_raise_01")) end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Holster"] = {
        Sequences = {"holster"},
        Length = 0.6,
        Fps = 30,
        Events = {
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_drop_01")) end},
        }
    },

    ["Equip"] = {
        Sequences = {"draw_First"},
        Length = 1.25,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_raise_first_01")) end},
            {Time = 0.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_raise_first_02")) end},
            {Time = 0.7, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload"] = {
        Sequences = {"reload"},
        Length = 3.1,
        MagLength = 2.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 2.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_04")) end},
            {Time = 0.133, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_01")) end},
            {Time = 0.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_02")) end},
            {Time = 1.833, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_03")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 2.767, Callback = function(self) self:EnableGrip() end},
            {Time = 2.367, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_045")) end},
            {Time = 2.633, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_05")) end},
        
        }
    },

    ["Reload_Fast"] = {
        Sequences = {"reload_fast"},
        Length = 2.26,
        MagLength = 1.66,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1.467, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_04")) end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_01")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 2.033, Callback = function(self) self:EnableGrip() end},
            {Time = 1.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_045")) end},
            {Time = 0.467, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_02")) end},
            {Time = 1.133, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_03")) end},
            {Time = 1.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_05")) end},
        
        }
    },

    ["Reload_Empty"] = {
        Sequences = {"reload"},
        Length = 3.1,
        MagLength = 2.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 2.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_04")) end},
            {Time = 0.133, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_01")) end},
            {Time = 0.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_02")) end},
            {Time = 1.833, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_03")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 2.767, Callback = function(self) self:EnableGrip() end},
            {Time = 2.367, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_045")) end},
            {Time = 2.633, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_05")) end},
        }
    },

    ["Reload_Empty_Fast"] = {
        Sequences = {"reload_fast"},
        Length = 2.26,
        MagLength = 1.66,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1.467, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_04")) end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_01")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 2.033, Callback = function(self) self:EnableGrip() end},
            {Time = 1.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_045")) end},
            {Time = 0.467, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_02")) end},
            {Time = 1.133, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_03")) end},
            {Time = 1.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_reload_fast_05")) end},
        }
    },

    ["Fire"] = {
        Sequences = {"fire"},
        Fps = 60,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Fire_Last"] = {
        Sequences = {"fire"},
        Fps = 60,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Ads_In"] = {
        Sequences = {"ads_in"},
        Length = 0.25,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}, 
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.sksierra.ads.up")) end},
        }
    },

    ["Ads_Out"] = {
        Sequences = {"ads_out"},
        Length = 0.25,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}, 
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.sksierra.ads.down")) end},
        }
    },

    ["Sprint_In"] = {
        Sequences = {"sprint_in"},
        Fps = 24,
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
        --NextSequence = "Sprint_Loop",
    },

    ["Sprint_Loop"] = {
        Sequences = {"sprint_loop"},
        Fps = 30,
        NextSequence = "Sprint_Loop", --make our state loop
        --while sprinting, the playback rate of the viewmodel is scaled with velocity (cod-like behaviour)
        Events = {
        {Time = 0, Callback = function(self) self:EnableGrip() end},
        {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Sprint_Out"] = {
        Sequences = {"sprint_out"},
        Length = 0.3,
        Fps = 24,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Inspect"] = {
        Sequences = {"inspect"},
        Length = 5,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.133, Callback = function(self) self:DisableGrip() end},
            {Time = 4.3, Callback = function(self) self:EnableGrip() end},
            {Time = 3.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_inspect_04")) end},
            {Time = 4.233, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_inspect_05")) end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_inspect_01")) end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_inspect_02")) end},
            {Time = 2.367, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_crossbow_inspect_03")) end},
        }
    },

    ["Jog_Out"] = {
        Sequences = {"jog_out"},
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Jump"] = {
        Sequences = {"jump"},
        Fps = 15,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Land"] = {
        Sequences = {"jump_land"},
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Melee"] = {
        Sequences = {"melee_miss_01", "melee_miss_02"},
        Length = 0.6, --if melee misses

        Size = 15,
        Range = 40,

        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("MW_Melee.Miss_Medium")) end},
            {Time = 0, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Melee_Hit"] = {
        Sequences = {"melee_hit_01", "melee_hit_02"},
        Length = 0.3, --if melee hits

        Damage = 45,

        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("MW_Melee.Flesh_Medium")) end},
            {Time = 0, Callback = function(self) self:EnableGrip() end},
        }
    },
}