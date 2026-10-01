AddCSLuaFile()

PrecacheParticleSystem("AC_muzzle_rifle")
PrecacheParticleSystem("AC_muzzle_pistol_suppressed")
PrecacheParticleSystem("AC_muzzle_pistol_ejection")
PrecacheParticleSystem("AC_muzzle_pistol_smoke_barrel")
include("animations.lua")
include("customization.lua")

if CLIENT then
    killicon.Add( "mg_g3a3", "VGUI/entities/mg_g3a3", Color(255, 0, 0, 255))
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/spawnicons/icon_cac_weapon_ar_g3a3")
end

SWEP.Base = "mg_base"
SWEP.GripPoseParameters = {"grip_vert_offset", "grip_vert_pro_offset", "grip_cqc", "grip_sniper"}
SWEP.PrintName = "G3A3"
SWEP.Category = "Modern Warfare"
SWEP.SubCategory = "Assault Rifles"
SWEP.Spawnable = true
SWEP.VModel = Model("models/viper/mw/weapons/v_gamma3.mdl")
SWEP.WorldModel = Model("models/viper/mw/weapons/w_gamma3.mdl")

SWEP.Slot = 2
SWEP.HoldType = "Rifle"

SWEP.Primary.Sound = Sound("mw19.g3a3.fire")
-- SWEP.Trigger = {
--     PressedSound = Sound("mw19.scharlie.fire.first"),
--     ReleasedSound = Sound("mw19.scharlie.disconnector"),
--     Time = 0.1
-- }
SWEP.Primary.Ammo = "Ar2"
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.BurstRounds = 1
SWEP.Primary.BurstDelay = 0
SWEP.Primary.RPM = 600  
SWEP.CanChamberRound = true  
  
SWEP.ParticleEffects = {
    ["MuzzleFlash"] = "AC_muzzle_rifle",
    ["MuzzleFlash_Suppressed"] = "AC_muzzle_pistol_suppressed",
    ["Ejection"] = "AC_muzzle_pistol_ejection", 
}

SWEP.Reverb = { 
    RoomScale = 50000, --(cubic hu)
    --how big should an area be before it is categorized as 'outside'?

    Sounds = {
        Outside = {
            Layer = Sound("Atmo_LMG.Outside"),
            Reflection = Sound("Reflection_AR.Outside")
        },

        Inside = { 
            Layer = Sound("Atmo_LMG.Inside"),
            Reflection = Sound("Reflection_AR.Inside")
        }
    }
}

SWEP.Firemodes = {
    [1] = {
        Name = "Full Auto",
        OnSet = function()
            return "Firemode_Auto"
        end
    },

    [2] = {
        Name = "Semi Auto",
        OnSet = function(self)
            self.Primary.Automatic = false
            self.Primary.RPM = 450

            return "Firemode_Semi"
        end
    },

}

SWEP.BarrelSmoke = {
    Particle = "AC_muzzle_pistol_smoke_barrel",
    Attachment = "muzzle",
    ShotTemperatureIncrease = 35,
    TemperatureThreshold = 100, --temperature that triggers smoke
    TemperatureCooldown = 100 --degrees per second
}

SWEP.Cone = {
    Hip = 0.46, --accuracy while hip
    Ads = 0.06, --accuracy while aiming
    Increase = 0.13, --increase cone size by this amount every time we shoot
    AdsMultiplier = 0.15, --multiply the increase value by this amount while aiming
    Max = 1.64, --the cone size will not go beyond this size
    Decrease = 0.8, -- amount (in seconds) for the cone to completely reset (from max)
    Seed = 6215654 --just give this a random number
}

SWEP.Recoil = {
    Vertical = {1.25, 2.7}, --random value between the 2
    Horizontal = {0.57, 1.36}, --random value between the 2
    Shake = 1.3, --camera shake
    AdsMultiplier = 0.3, --multiply the values by this amount while aiming
    Seed = 213654 --give this a random number until you like the current recoil pattern
}

SWEP.Bullet = {
    Damage = {47, 33}, --first value is damage at 0 meters from impact, second value is damage at furthest point in effective range
    EffectiveRange = 650, --in meters, damage scales within this distance
    DropOffStartRange = 20,
    Range = 1500, --in meters, after this distance the bullet stops existing
    Tracer = false, --show tracer
    NumBullets = 1, --the amount of bullets to fire
    PhysicsMultiplier = 1, --damage is multiplied by this amount when pushing objects
    Penetration = {
        DamageMultiplier = 0.8, --how much damaged is multipled by when leaving a surface.
        MaxCount = 3, --how many times the bullet can penetrate.
        Thickness = 17, --in hu, how thick an obstacle has to be to stop the bullet.
    }
}

SWEP.Zoom = {
    FovMultiplier = 0.95,
    ViewModelFovMultiplier = 1,
    Blur = {
        EyeFocusDistance = 7
    }
}

SWEP.WorldModelOffsets = {
    Bone = "tag_sling",
    Angles = Angle(180,180,0),
    Pos = Vector(7,-2,-1.6)
}

SWEP.ViewModelOffsets = {
    Aim = {
        Angles = Angle(0, 0, 0),
        Pos = Vector(0, 0, 0)
    },
    Idle = {
        Angles = Angle(0, 0, 0),
        Pos = Vector(0, 0, 0)
    },
    Inspection = {
        Bone = "tag_sling",
        X = {
            [0] = {Pos = Vector(0, -3, -3), Angles = Angle(40, 0, -30)},
            [1] = {Pos = Vector(0, 0, 0), Angles = Angle(-10, 0, 0)}
        },
        Y = {
            [0] = {Pos = Vector(0, 0, 0), Angles = Angle(-10, 20, 0)},
            [1] = {Pos = Vector(0, 0, 0), Angles = Angle(10, -20, 0)}
        }
    },

    RecoilMultiplier = 2,
    KickMultiplier = 0.5,
    AimKickMultiplier = 0.3
}

SWEP.Shell = "mwb_shelleject_7625x"

