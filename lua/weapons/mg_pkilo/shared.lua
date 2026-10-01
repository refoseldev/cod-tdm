AddCSLuaFile()

PrecacheParticleSystem("AC_muzzle_rifle")
PrecacheParticleSystem("AC_muzzle_pistol_suppressed")
PrecacheParticleSystem("AC_muzzle_pistol_ejection")
PrecacheParticleSystem("AC_muzzle_pistol_smoke_barrel")
include("animations.lua")
include("customization.lua")

if CLIENT then
    killicon.Add( "mg_pkilo", "VGUI/entities/mg_pkilo", Color(255, 0, 0, 255))
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/spawnicons/icon_cac_weapon_lm_pkilo")
end

SWEP.Base = "mg_base"
SWEP.GripPoseParameters = {"grip_ang_offset", "grip_vert_offset"}

SWEP.PrintName = "PKM"
SWEP.Category = "Modern Warfare"
SWEP.SubCategory = "Lightmachine Guns"
SWEP.Spawnable = true
SWEP.VModel = Model("models/viper/mw/weapons/v_pkilo.mdl")
SWEP.WorldModel = Model("models/viper/mw/weapons/w_pkilo.mdl")

SWEP.Slot = 2
SWEP.HoldType = "Rifle"
SWEP.Trigger = {
    PressedSound = Sound("weap_pkilo_prefire_plr"),
    ReleasedSound = Sound(""),
    Time = 0.15
}

SWEP.Primary.Sound = Sound("weap_pkilo_fire_plr")
SWEP.Primary.Ammo = "Ar2"
SWEP.Primary.ClipSize = 100
SWEP.Primary.Automatic = true
SWEP.Primary.BurstRounds = 1
SWEP.Primary.BurstDelay = 0
SWEP.Primary.RPM = 750
SWEP.CanChamberRound = false  
SWEP.CanDisableAimReload = true
  
SWEP.ParticleEffects = {
    ["MuzzleFlash"] = "mw_fas2_muzzleflash_lmg",
    ["MuzzleFlash_Suppressed"] = "mw_fas2_muzzleflash_suppressed",
    ["Ejection"] = "mw_ins2_shell_eject", 
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
            Reflection = Sound("Reflection_Shotgun.Inside")
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

}

SWEP.BarrelSmoke = {
    Particle = "AC_muzzle_pistol_smoke_barrel",
    Attachment = "muzzle",
    ShotTemperatureIncrease = 35,
    TemperatureThreshold = 100, --temperature that triggers smoke
    TemperatureCooldown = 100 --degrees per second
}

SWEP.Cone = {
    Hip = 0.8, --accuracy while hip
    Ads = 0.13, --accuracy while aiming
    Increase = 0.093, --increase cone size by this amount every time we shoot
    AdsMultiplier = 0.24, --multiply the increase value by this amount while aiming
    Max = 1.75, --the cone size will not go beyond this size
    Decrease = 0.6, -- amount (in seconds) for the cone to completely reset (from max)
    Seed = 2333, --just give this a random number
    DecreaseEveryShot = 0.1,
    MinDecreaseEveryShot = 0.25
}

SWEP.Recoil = {
    Vertical = {4, 4.5}, --random value between the 2
    Horizontal = {-2.75, 2.75}, --random value between the 2
    Shake = 1.5, --camera shake
    AdsMultiplier = 0.5, --multiply the values by this amount while aiming
    Seed = 675846694, --give this a random number until you like the current recoil pattern
    DecreaseEveryShot = 0.1,
    MinDecreaseEveryShot = 0.25
}

SWEP.Bullet = {
    Damage = {43, 39}, --first value is damage at 0 meters from impact, second value is damage at furthest point in effective range
    DropOffStartRange = 35, --in meters, damage will start dropping off after this range
    EffectiveRange = 65, --in meters, damage scales within this distance
    Range = 180, --in meters, after this distance the bullet stops existing
    Tracer = false, --show tracer
    NumBullets = 1, --the amount of bullets to fire
    PhysicsMultiplier = 1, --damage is multiplied by this amount when pushing objects
    HeadshotMultiplier = 1,
    Penetration = {
        DamageMultiplier = 0.8, --how much damaged is multipled by when leaving a surface.
        MaxCount = 3, --how many times the bullet can penetrate.
        Thickness = 12, --in hu, how thick an obstacle has to be to stop the bullet.
    }
}

SWEP.Zoom = {
    FovMultiplier = 0.95,
    ViewModelFovMultiplier = 1,
    Blur = {
        EyeFocusDistance = 8
    }
}

SWEP.WorldModelOffsets = {
    Bone = "tag_sling",
    Angles = Angle(0, 0, -180),
    Pos = Vector(12,-1,-4)
}

SWEP.ViewModelOffsets = {
    Aim = {
        Angles = Angle(0, 0, 0),
        Pos = Vector(0, 4, 0)
    },
    Idle = {
        Angles = Angle(0, 0, 0),
        Pos = Vector(0, 0, 0)
    },
    Inspection = {
        Bone = "tag_sling",
        X = {
            [0] = {Pos = Vector(0, -4, 3), Angles = Angle(40, 0, -30)},
            [1] = {Pos = Vector(0, 0, 0), Angles = Angle(-10, 0, 0)}
        },
        Y = {
            [0] = {Pos = Vector(3, 0, -2), Angles = Angle(-10, 20, 0)},
            [1] = {Pos = Vector(4, 0, 3), Angles = Angle(10, -20, 0)}
        }
    },

    RecoilMultiplier = 0.45,
    KickMultiplier = 2,
    AimKickMultiplier = 1
}

SWEP.Shell = "mwb_shelleject_762"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:PreAttachments()
    BaseClass.PreAttachments(self)

    if (!self:HasAttachment("att_sight")) then
        self.Animations.Reload.Sequences = {"Reload_scope"}
        self.Animations.Reload_Empty.Sequences = {"Reload_empty_scope"}
        self.Animations.Reload_fast.Sequences = {"Reload_fast_scope"}
        self.Animations.Reload_empty_fast.Sequences = {"Reload_empty_fast_scope"}
    end
end