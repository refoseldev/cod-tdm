AddCSLuaFile()

SWEP.Animations = {
    ["Idle"] = {--idle is a special animation index, movement animations are played when this is on
        Sequences = {"idle"},
        Fps = 30,
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
        --does not need NextSequence to loop, it's an exception to the rule
    },

    ["Draw"] = {
        Sequences = {"draw"},
        Length = 0.75,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("wfoly_plr_ar_scharlie_raise")) end},
            {Time = 0.25, Callback = function(self) self:EnableGrip() end}
        }
    },

    ["Holster"] = {
        Sequences = {"holster"},
        Length = 0.75,
        Fps = 30,
        Events = {
            {Time = 0.5, Callback = function(self) self:DisableGrip() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("wfoly_plr_ar_scharlie_down")) end}
        }
    },

    ["Equip"] = {
        Sequences = {"draw_First"},
        Length = 2.5,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DisableGrip() end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.start")) end},
            {Time = 0.46, Callback = function(self) self:DoSound(Sound("mw19.g3a3.bolt.charge")) end},
            {Time = 1.15, Callback = function(self) self:DoSound(Sound("mw19.g3a3.bolt.back")) end},
            {Time = 1.65, Callback = function(self) self:DoSound(Sound("mw19.g3a3.bolt.forward")) end},
            {Time = 1.9, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.end")) end},
            {Time = 1.9, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload"] = {
        Sequences = {"reload"},
        Length = 2.3,
        Fps = 30,
        MagLength = 1.5,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.start")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.5, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magout")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1")) end},
            {Time = 1.4, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2")) end},
            {Time = 1.93, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.end")) end},
            {Time = 2.12, Callback = function(self) self:EnableGrip() end},
            {Time = 1.95, Callback = function(self) end},
        }
    },

   ["Reload_Fast"] = {
        Sequences = {"reload_fast"},
        Length = 1.7,
        Fps = 30,
        MagLength = 1.2,
        NextSequence = "Idle",
        Events = {
            {Time = 0.066, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.startF")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magoutF")) end},
            {Time = 0.75, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(0, 0, 40)) end},
            {Time = 0.9, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1F")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2F")) end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.endF")) end},
            {Time = 1.33, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload_Xmag"] = {
        Sequences = {"reload_xmag"},
        Length = 2.3,
        Fps = 30,
        MagLength = 1.5,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.start")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.5, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magout")) end},
            {Time = 1.2, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1")) end},
            {Time = 1.56, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2")) end},
            {Time = 1.93, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.end")) end},
            {Time = 1.95, Callback = function(self) self:EnableGrip() end},
            {Time = 1.95, Callback = function(self) end},
        }
    },


   ["Reload_Xmag_Fast"] = {
        Sequences = {"reload_xmag_fast"},
        Length = 1.8,
        Fps = 30,
        MagLength = 1.2,
        NextSequence = "Idle",
        Events = {
            {Time = 0.066, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.startF")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magoutF")) end},
            {Time = 0.75, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(0, 0, 40)) end},
            {Time = 0.9, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1F")) end},
            {Time = 1.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2F")) end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.endF")) end},
            {Time = 1.33, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload_Empty"] = {
        Sequences = {"reload_empty"},
        Length = 3.3,
        Fps = 30,
        MagLength = 2.1,
        NextSequence = "Idle",
        Events = {
            {Time = 0.066, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.start.empty")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.bolt.charge")) end},
            {Time = 0.66, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magout.empty")) end},
            {Time = 1.34, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-40, 0, 40)) end},
            {Time = 0.066, Callback = function(self) self:DisableGrip() end}, 
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1.empty")) end},
            {Time = 2.0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2.empty")) end},
            {Time = 2.5, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.bolt.slap")) end},
            {Time = 2.95, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.end.empty")) end},
            {Time = 3, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload_Empty_Carbine"] = {
        Sequences = {"reload_empty_carbine"},
        Length = 3.3,
        Fps = 30,
        MagLength = 2.1,
        NextSequence = "Idle",
        Events = {
            {Time = 0.066, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.start.empty")) end},
            {Time = 0.2, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.bolt.charge")) end},
            {Time = 0.66, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magout.empty")) end},
            {Time = 1.34, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-40, 0, 40)) end},
            {Time = 0.066, Callback = function(self) self:DisableGrip() end}, 
            {Time = 1.6, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1.empty")) end},
            {Time = 2.0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2.empty")) end},
            {Time = 2.5, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.bolt.slap")) end},
            {Time = 2.95, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.end.empty")) end},
            {Time = 2.9, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Reload_Empty_Fast"] = {
        Sequences = {"reload_empty_fast"},
        Length = 2.5,
        Fps = 30,
        MagLength = 1.55,
        NextSequence = "Idle",
        Events = {
            {Time = 0.066, Callback = function(self) self:DisableGrip() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.start.emptyF")) end},
            {Time = 0.16, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.bolt.charge")) end},
            {Time = 0.5, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magout.emptyF")) end},
            {Time = 0.9, Callback = function(self) self:DoSpatialSound(Sound("MW_MagazineDrop.AR.Metal"), Vector(-10, 0, 40)) end},
            {Time = 1.3, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.1.emptyF")) end},
            {Time = 1.45, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.magin.2.emptyF")) end},
            {Time = 2.0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.bolt.slapF")) end},
            {Time = 2.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.reload.end.emptyF")) end},
            {Time = 2.33, Callback = function(self) self:EnableGrip() end},
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
                    self:DoParticle("Ejection", "shell_eject")
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 0, Callback = function(self) self:EnableGrip() end},
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
                    self:DoParticle("Ejection", "shell_eject")
                    self:DoEjection("shell_eject")
                end
            },
            {Time = 0, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Ads_In"] = {
        Sequences = {"ads_in"},
        Length = 0.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.ads.up")) end},
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
    },

    ["Ads_Out"] = {
        Sequences = {"ads_out"},
        Length = 0.3,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.ads.down")) end},
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
    },

    ["Sprint_In"] = {
        Sequences = {"sprint_in"},
        Fps = 24,
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
        --NextSequence = "Sprint_Loop",
    },

    ["Sprint_Loop"] = {
        Sequences = {"sprint_loop"},
        Fps = 30,
        NextSequence = "Sprint_Loop" --make our state loop
        --while sprinting, the playback rate of the viewmodel is scaled with velocity (cod-like behaviour)
    },

    ["Sprint_Out"] = {
        Sequences = {"sprint_out"},
        Length = 0.3,
        Fps = 24,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
    },

    ["Firemode_Auto"] = {
        Sequences = {"semi_off"},
        Length = 0.75,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.semi.off")) end},
         }
    },
    
    ["Firemode_Semi"] = {
        Sequences = {"semi_on"},
        Length = 0.75,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end},
            {Time = 0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.semi.on")) end},
        }
    },

    ["Inspect"] = {
        Sequences = {"inspect"},
        Length = 5,
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0.0, Callback = function(self) self:DoSound(Sound("mw19.g3a3.inspect.1")) end},
            {Time = 0.1, Callback = function(self) self:DisableGrip() end},
            {Time = 1.36, Callback = function(self) self:DoSound(Sound("mw19.g3a3.inspect.2")) end},
            {Time = 2.25, Callback = function(self) self:DoSound(Sound("mw19.g3a3.inspect.3")) end},
            {Time = 4.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.inspect.4")) end},
            {Time = 4.1, Callback = function(self) self:DoSound(Sound("mw19.g3a3.inspect.5")) end},
            {Time = 4.3, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Jog_Out"] = {
        Sequences = {"jog_out"},
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
    },

    ["Jump"] = {
        Sequences = {"jump"},
        Fps = 15,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}
        }
    },

    ["Land"] = {
        Sequences = {"jump_land"},
        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:EnableGrip() end}
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
            {Time = 0, Callback = function(self) self:DoSound(Sound("MW_Melee.Miss_Medium")) end},
            {Time = 0.066, Callback = function(self) self:DisableGrip() end},
            {Time = 0.75, Callback = function(self) self:EnableGrip() end},
        }
    },

    ["Melee_Hit"] = {
        Sequences = {"melee_hit_01", "melee_hit_02", "melee_hit_03"},
        Length = 0.3, --if melee hits

        Damage = 45,

        Fps = 30,
        NextSequence = "Idle",
        Events = {
            {Time = 0, Callback = function(self) self:DoSound(Sound("MW_Melee.Flesh_Medium")) end},
            {Time = 0.066, Callback = function(self) self:DisableGrip() end},
            {Time = 0.75, Callback = function(self) self:EnableGrip() end},
        }
    },
}