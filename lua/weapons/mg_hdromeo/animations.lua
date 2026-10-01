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
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_raise_01")) end},
        }
    },

    ["Holster"] = {
        Sequences = {"holster"},
        Length = 1,
        Fps = 30,
        Events = {
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_drop_01")) end},
        }
    },

    ["Equip"] = {
        Sequences = {"draw_First"},
        Length = 1.25,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_raise_first_01")) end},
            {Time = 0.3, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_raise_first_02")) end},
            {Time = 1.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_raise_first_03")) end},
            {Time = 1.4, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_raise_first_04")) end},
        }
    },

    ["reload_xmag"] = {
        Sequences = {"reload_xmag"},
        Length = 3.33,
        MagLength = 2.75,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_06")) end},
            {Time = 2.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_05")) end},
            {Time = 2.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_04")) end},
            {Time = 2.7, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_055")) end},
            {Time = 0.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_03")) end},
            {Time = 0.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_02")) end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_01")) end},        
        }
    },

    ["reload_xmag_fast"] = {
        Sequences = {"reload_xmag_fast"},
        Length = 2.56,
        MagLength = 1.9,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_055")) end},
            {Time = 1.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_05")) end},
            {Time = 1.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_04")) end},
            {Time = 2.233, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_07")) end},
            {Time = 1.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_06")) end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_01")) end},
            {Time = 0.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_03")) end},
            {Time = 0.533, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_02")) end},        
        }
    },

    ["Reload"] = {
        Sequences = {"reload"},
        Length = 3.33,
        MagLength = 2.75,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_06")) end},
            {Time = 2.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_05")) end},
            {Time = 2.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_04")) end},
            {Time = 2.7, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_055")) end},
            {Time = 0.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_03")) end},
            {Time = 0.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_02")) end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_01")) end},        
        }
    },

    ["Reload_Fast"] = {
        Sequences = {"reload_fast"},
        Length = 2.56,
        MagLength = 1.9,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_055")) end},
            {Time = 1.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_05")) end},
            {Time = 1.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_04")) end},
            {Time = 2.233, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_07")) end},
            {Time = 1.933, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_06")) end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_01")) end},
            {Time = 0.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_03")) end},
            {Time = 0.533, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_fast_02")) end},
        
        }
    },

    ["reload_empty_xmag"] = {
        Sequences = {"reload_empty_xmag"},
        Length = 4.5,
        MagLength = 3.2,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) end},
            {
                Time = 0.5, 
                Callback = function(self) 
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 3.267, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_075")) end},
            {Time = 2.4, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_06")) end},
            {Time = 3.9, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_09")) end},
            {Time = 3.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_08")) end},
            {Time = 0.867, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_03")) end},
            {Time = 0.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_02")) end},
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_rechamber_01")) end},
            {Time = 2.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_07")) end},
            {Time = 1.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_05")) end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_04")) end},
        }
    },

    ["reload_empty_xmag_fast"] = {
        Sequences = {"reload_empty_xmag_fast"},
        Length = 3.5,
        MagLength = 2.5,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) end},
            {
                Time = 0.25, 
                Callback = function(self) 
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 2.3, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_06")) end},
            {Time = 2.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_07")) end},
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_05")) end},
            {Time = 0.233, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_02")) end},
            {Time = 1.867, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_055")) end},
            {Time = 0.167, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_rechamber_01")) end},
            {Time = 0.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_03")) end},
            {Time = 1.0, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_04")) end},
        }
    },

    ["Reload_Empty"] = {
        Sequences = {"reload_empty"},
        Length = 4.5,
        MagLength = 3.2,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 3.033, Callback = function(self) end},
            {Time = 3.033, Callback = function(self) end},
            {
                Time = 0.5, 
                Callback = function(self) 
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 3.267, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_075")) end},
            {Time = 2.4, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_06")) end},
            {Time = 3.9, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_09")) end},
            {Time = 3.567, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_08")) end},
            {Time = 0.867, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_03")) end},
            {Time = 0.433, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_02")) end},
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_rechamber_01")) end},
            {Time = 2.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_07")) end},
            {Time = 1.667, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_05")) end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_04")) end},
        }
    },

    ["Reload_Empty_Fast"] = {
        Sequences = {"reload_empty_fast"},
        Length = 3.5,
        MagLength = 2.5,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {
                Time = 0.25, 
                Callback = function(self) 
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 3.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_09")) end},
            {Time = 2.5, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_08")) end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_rechamber_01")) end},
            {Time = 0.767, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_03")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_02")) end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_05")) end},
            {Time = 1.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_04")) end},
            {Time = 2.133, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_07")) end},
            {Time = 2.133, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_06")) end},
            {Time = 3.067, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_10")) end},
            {Time = 3.333, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_11")) end},
            {Time = 2.5, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_reload_empty_fast_075")) end},
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
                end
            },
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["Rechamber"] = {
        Sequences = {"rechamber"},
        Fps = 30,
        Length = 1.3,
        NextSequence = "Idle",
        Events = {
            {
                Time = 0.5, 
                Callback = function(self) 
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_rechamber_01")) end},
            {Time = 0.6, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_rechamber_02")) end},
        }
    },

    ["Fire_Last"] = {
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

    ["Ads_In"] = {
        Sequences = {"ads_in"},
        Length = 0.25,
        Fps = 20,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}, 
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("weap_sn_hdromeo_ads_up")) end},
        }
    },

    ["Ads_Out"] = {
        Sequences = {"ads_out"},
        Length = 0.25,
        Fps = 20,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}, 
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("weap_sn_hdromeo_ads_down")) end},
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
            {Time = 1.7, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_inspect_02")) end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_inspect_01")) end},
            {Time = 3.867, Callback = function(self) self:DoSound(Sound("wfoly_plr_sn_hdromeo_inspect_03")) end},
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