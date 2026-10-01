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
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_raise")) end},
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Holster"] = {
        Sequences = {"holster"},
        Length = 0.8,
        Fps = 30,
        Events = {
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_drop")) end},
        }
    },

    ["Equip"] = {
        Sequences = {"draw_First"},
        Length = 1.25,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0.933, Callback = function(self) self:EnableGrip2() end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_raise_first_01")) end},
            {Time = 0.467, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_raise_first_02")) end},
            {Time = 0.633, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_raise_first_03")) end},
        }
    },

    ["Reload_Xmag"] = {
        Sequences = {"reload"},
        Length = 2,
        MagLength = 1.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_045")) end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_03")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_02")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_01")) end},
            {Time = 1.267, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_05")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_04")) end},
        
        }
    },

    ["Reload_Xmag_Fast"] = {
        Sequences = {"reload_fast"},
        Length = 1.36,
        MagLength = 0.83,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_01")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_02")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_04")) end},
            {Time = 1.067, Callback = function(self) self:EnableGrip() end},
            {Time = 0.667, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_03")) end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_035")) end},
        
        }
    },

    ["Reload"] = {
        Sequences = {"Reload_Xmag"},
        Length = 2,
        MagLength = 1.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_01")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_02")) end},
            {Time = 0.7, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_03")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_04")) end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_05")) end},
            {Time = 1.633, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_06")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmag_045")) end},
        
        }
    },

    ["Reload_Fast"] = {
        Sequences = {"Reload_Xmag_Fast"},
        Length = 1.36,
        MagLength = 0.83,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmag_05")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmag_045")) end},
            {Time = 1.067, Callback = function(self) self:EnableGrip() end},
            {Time = 0.7, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmag_04")) end},
            {Time = 0.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmag_02")) end},
            {Time = 0.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmag_03")) end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmag_01")) end},
        
        }
    },

    ["Reload_Xmag2"] = {
        Sequences = {"Reload_Xmag2"},
        Length = 2,
        MagLength = 1.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_02")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_01")) end},
            {Time = 1.667, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_06")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_04")) end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_05")) end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_045")) end},
            {Time = 0.767, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_xmaglrg_03")) end},
        
        }
    },

    ["Reload_Xmag2_Fast"] = {
        Sequences = {"Reload_Xmag2_Fast"},
        Length = 1.36,
        MagLength = 0.83,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.067, Callback = function(self) self:EnableGrip() end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmaglrg_01")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmaglrg_05")) end},
            {Time = 0.7, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmaglrg_04")) end},
            {Time = 0.833, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmaglrg_045")) end},
            {Time = 0.3, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmaglrg_02")) end},
            {Time = 0.3, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_fast_xmaglrg_03")) end},
        
        }
    },

    ["Reload_Empty_Xmag"] = {
        Sequences = {"Reload_Empty"},
        Length = 2.6,
        MagLength = 1.36,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 1.367, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_045")) end},
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_05")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.76, Callback = function(self) self:DisableGrip2() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 2.23, Callback = function(self) self:EnableGrip2() end},
            {Time = 1.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_03")) end},
            {Time = 0.4, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_02")) end},
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_01")) end},
            {Time = 2.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_07")) end},
            {Time = 2.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_06")) end},
            {Time = 1.167, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_04")) end},
            {Time = 2.267, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload_Empty_Xmag_Fast"] = {
        Sequences = {"Reload_Empty_Fast"},
        Length = 1.8,
        MagLength = 0.86,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 1.567, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_05")) end},
            {Time = 1.133, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_04")) end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_01")) end},
            {Time = 0.8, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_03")) end},
            {Time = 0.4, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_02")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 0.867, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_035")) end},
        }
    },

    ["Reload_Empty"] = {
        Sequences = {"Reload_Empty_Xmag"},
        Length = 2.6,
        MagLength = 1.36,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.76, Callback = function(self) self:DisableGrip2() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 2.23, Callback = function(self) self:EnableGrip2() end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmag_035")) end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmag_01")) end},
            {Time = 0.5, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmag_02")) end},
            {Time = 1.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmag_03")) end},
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmag_04")) end},
            {Time = 2.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmag_05")) end},
        }
    },

    ["Reload_Empty_Fast"] = {
        Sequences = {"Reload_Empty_Xmag_Fast"},
        Length = 1.8,
        MagLength = 0.86,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_02")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 0.033, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_01")) end},
            {Time = 1.5, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_06")) end},
            {Time = 1.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_04")) end},
            {Time = 0.867, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_035")) end},
            {Time = 0.7, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_03")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmag_05")) end},
        }
    },

    ["Reload_Empty_Xmag2"] = {
        Sequences = {"Reload_Empty_Xmag2"},
        Length = 2.6,
        MagLength = 1.36,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 1.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmaglrg_035")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.76, Callback = function(self) self:DisableGrip2() end},
            {Time = 1.633, Callback = function(self) self:EnableGrip() end},
            {Time = 2.23, Callback = function(self) self:EnableGrip2() end},
            {Time = 0.5, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmaglrg_02")) end},
            {Time = 1.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmaglrg_03")) end},
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmaglrg_01")) end},
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmaglrg_04")) end},
            {Time = 1.967, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_xmaglrg_05")) end},
        }
    },

    ["Reload_Empty_Xmag2_Fast"] = {
        Sequences = {"Reload_Empty_Xmag2_Fast"},
        Length = 1.8,
        MagLength = 0.86,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 1, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0, Callback = function(self) end},
            {Time = 0.067, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_01")) end},
            {Time = 0.367, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_02")) end},
            {Time = 0.7, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_03")) end},
            {Time = 1.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_04")) end},
            {Time = 1.167, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_05")) end},
            {Time = 1.5, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_06")) end},
            {Time = 0.0, Callback = function(self) self:DisableGrip() end},
            {Time = 1.533, Callback = function(self) self:EnableGrip() end},
            {Time = 0.867, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_reload_empty_fast_xmaglrg_035")) end},
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
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.mike14.fire.last")) end},
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
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.mike14.ads.up")) end},
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
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.mike14.ads.down")) end},
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
            {Time = 0, Callback = function(self) self:EnableGrip2() end},
            {Time = 0.133, Callback = function(self) self:DisableGrip() end},
            {Time = 4.3, Callback = function(self) self:EnableGrip() end},
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_inspect_01")) end},
            {Time = 2.333, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_inspect_03")) end},
            {Time = 1.367, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_inspect_02")) end},
            {Time = 4.2, Callback = function(self) self:DoSound(Sound("ps_wfoly_plr_sn_mike14_inspect_04")) end},
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

    ["HybridOn"] = {
        Sequences = {"hybrid_toggle_off"},
        Fps = 30,
        Length = 0.9,
        NextSequence = "Idle",
        Events = {
            {Time = 0.15, Callback = function(self) self:DoSound(Sound("Flipsight.Up")) end},	
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:DisableGrip2() end},
            {Time = 0.833, Callback = function(self) self:EnableGrip2() end},
        }
    },

    ["HybridOff"] = {
        Sequences = {"hybrid_toggle_on"},
        Fps = 30,
        Length = 0.9,
        NextSequence = "Idle",
        Events = {
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("Flipsight.Down")) end},
            {Time = 0, Callback = function(self) self:DisableGrip() end},
            {Time = 0.767, Callback = function(self) self:EnableGrip() end},
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