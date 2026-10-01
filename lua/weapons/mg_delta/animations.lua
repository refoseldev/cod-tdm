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
        Length = 0.7,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_raise_01")) end},
        }
    },

    ["Holster"] = {
        Sequences = {"holster"},
        Length = 0.8,
        Fps = 30,
        Events = {
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_drop_01")) end},
        }
    },

    ["Equip"] = {
        Sequences = {"draw_First"},
        Length = 1.25,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.467, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_raise_first_02")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_raise_first_01")) end},
            {Time = 0.9, Callback = function(self) self:EnableGrip() end},
            {Time = 1.033, Callback = function(self) self:EnableGrip() end},
            {Time = 0.9, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_raise_first_03")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
        }
    },

    ["Reload_Xmag"] = {
        Sequences = {"reload_xmag"},
        Length = 3.25,
        MagLength = 2.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.6, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_02")) end},
            {Time = 0.867, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_03")) end},
            {Time = 0.233, Callback = function(self) self:DisableGrip() end},
            {Time = 0.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_01")) end},
            {Time = 2.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_06")) end},
            {Time = 1.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_04")) end},
            {Time = 1.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_05")) end},
            {Time = 2.367, Callback = function(self) self:EnableGrip() end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 2.633, Callback = function(self) self:EnableGrip() end},
            {Time = 2.3, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_xmag_055")) end},
        
        }
    },

    ["Reload_Xmag_Fast"] = {
        Sequences = {"reload_xmag_fast"},
        Length = 2.1,
        MagLength = 1.56,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.133, Callback = function(self) self:DisableGrip() end},
            {Time = 1.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_fast_xmag_045")) end},
            {Time = 1.767, Callback = function(self) self:EnableGrip() end},
            {Time = 1.7, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_fast_xmag_05")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 1.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_04")) end},
            {Time = 0.233, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_01")) end},
            {Time = 0.633, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_02")) end},
            {Time = 0.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_03")) end},
            {Time = 1.733, Callback = function(self) self:EnableGrip() end},
        
        }
    },

    ["Reload"] = {
        Sequences = {"reload"},
        Length = 3.25,
        MagLength = 2.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.233, Callback = function(self) self:DisableGrip() end},
            {Time = 2.367, Callback = function(self) self:EnableGrip() end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 1.867, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_05")) end},
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_04")) end},
            {Time = 2.6, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_06")) end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_01")) end},
            {Time = 0.9, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_03")) end},
            {Time = 0.5, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_02")) end},
            {Time = 2.3, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_055")) end},
            {Time = 2.633, Callback = function(self) self:EnableGrip() end},
        
        }
    },

    ["Reload_Fast"] = {
        Sequences = {"reload_fast"},
        Length = 2.1,
        MagLength = 1.56,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.133, Callback = function(self) self:DisableGrip() end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 1.7, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_fast_05")) end},
            {Time = 1.733, Callback = function(self) self:EnableGrip() end},
            {Time = 1.767, Callback = function(self) self:EnableGrip() end},
            {Time = 1.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_04")) end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_03")) end},
            {Time = 0.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_02")) end},
            {Time = 0.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_01")) end},
            {Time = 1.5, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_fast_045")) end},
        
        }
    },

    ["Reload_Empty_Xmag"] = {
        Sequences = {"reload_empty_xmag"},
        Length = 4.3,
        MagLength = 2.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.333, Callback = function(self) self:DisableGrip() end},
            {Time = 2.267, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_045")) end},
            {Time = 2.833, Callback = function(self) self:DisableGrip() end},
            {Time = 3.467, Callback = function(self) self:EnableGrip() end},
            {Time = 3.5, Callback = function(self) self:EnableGrip() end},
            {Time = 3.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_06")) end},
            {Time = 3.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_07")) end},
            {Time = 1.4, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_04")) end},
            {Time = 2.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_05")) end},
            {Time = 0.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_02")) end},
            {Time = 0.967, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_03")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_xmag_01")) end},
        }
    },

    ["Reload_Empty_Xmag_Fast"] = {
        Sequences = {"reload_empty_xmag_fast"},
        Length = 2.7,
        MagLength = 1.6,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_04")) end},
            {Time = 2.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_06")) end},
            {Time = 0.633, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_02")) end},
            {Time = 0.233, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_01")) end},
            {Time = 1.533, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_045")) end},
            {Time = 2.367, Callback = function(self) self:EnableGrip() end},
            {Time = 2.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_05")) end},
            {Time = 0.167, Callback = function(self) self:DisableGrip() end},
            {Time = 0.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_xmag_03")) end},
        }
    },

    ["Reload_Empty"] = {
        Sequences = {"reload_empty"},
        Length = 4.3,
        MagLength = 2.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 2.267, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_045")) end},
            {Time = 0.333, Callback = function(self) self:DisableGrip() end},
            {Time = 0.3, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_01")) end},
            {Time = 0.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_03")) end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_02")) end},
            {Time = 2.733, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_05")) end},
            {Time = 3.5, Callback = function(self) self:EnableGrip() end},
            {Time = 3.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_06")) end},
            {Time = 2.833, Callback = function(self) self:DisableGrip() end},
            {Time = 3.467, Callback = function(self) self:EnableGrip() end},
            {Time = 1.533, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_04")) end},
        }
    },

    ["Reload_Empty_Fast"] = {
        Sequences = {"reload_empty_fast"},
        Length = 2.7,
        MagLength = 1.6,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.167, Callback = function(self) end},
            {Time = 0.167, Callback = function(self) end},
            {Time = 0.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_01")) end},
            {Time = 0.167, Callback = function(self) self:DisableGrip() end},
            {Time = 2.367, Callback = function(self) self:EnableGrip() end},
            {Time = 2.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_06")) end},
            {Time = 2.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_05")) end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_03")) end},
            {Time = 0.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_02")) end},
            {Time = 1.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_04")) end},
            {Time = 1.533, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_reload_empty_fast_045")) end},
        }
    },

    ["Fire"] = {
        Sequences = {"fire"},
        Fps = 60,
        NextSequence = "Idle",
        Events = {
            {
                Time = 0, 
                Callback = function(self) 
                    self:DoParticle("MuzzleFlash", "muzzle")
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Fire_Last"] = {
        Sequences = {"fire_last"},
        Fps = 60,
        NextSequence = "Idle",
        Events = {
            {
                Time = 0, 
                Callback = function(self) 
                    self:DoParticle("MuzzleFlash", "muzzle")
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Ads_In"] = {
        Sequences = {"ads_in"},
        Length = 0.25,
        Fps = 25,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}, 
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("weap_sn_delta_ads_up")) end},
        }
    },

    ["Ads_Out"] = {
        Sequences = {"ads_out"},
        Length = 0.25,
        Fps = 25,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}, 
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("weap_sn_delta_ads_down")) end},
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
            {Time = 3.8, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_inspect_03")) end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_inspect_01")) end},
            {Time = 1.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_delta_inspect_02")) end},
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
        Sequences = {"melee_miss_01", "melee_miss_02", "melee_miss_03"},
        Length = 0.6, --if melee misses

        Size = 15,
        Range = 40,

        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DisableGrip() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("MW_Melee.Miss_Medium")) end},
            {Time = 0.8, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Melee_Hit"] = {
        Sequences = {"melee_hit_01", "melee_hit_02", "melee_hit_03"},
        Length = 0.3, --if melee hits

        Damage = 45,

        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DisableGrip() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("MW_Melee.Flesh_Medium")) end},
            {Time = 0.8, Callback = function(self) self:EnableGrip() end},
        }
    },
}