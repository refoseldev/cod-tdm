AddCSLuaFile()

PrecacheParticleSystem("AC_muzzle_shotgun")
PrecacheParticleSystem("AC_muzzle_shotgun_db")
PrecacheParticleSystem("AC_muzzle_pistol_suppressed")
PrecacheParticleSystem("AC_muzzle_pistol_ejection")
PrecacheParticleSystem("AC_muzzle_pistol_smoke_barrel")
PrecacheParticleSystem("AC_muzzle_minigun_smoke_barrel")
include("animations.lua")
include("customization.lua")

if CLIENT then
    killicon.Add( "mg_crossbow", "VGUI/entities/mg_crossbow", Color(255, 0, 0, 255))
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/spawnicons/icon_cac_weapon_sn_crossbow")
end

SWEP.GripPoseParameters = {"grip_ang_offset", "grip_vert_offset", "grip_vertpro_offset"}
-- SWEP.GripPoseParameters2 = {"grip_pistolgrip_offset"}

SWEP.Base = "mg_base" 

SWEP.PrintName = "Crossbow"
SWEP.Category = "Modern Warfare"
SWEP.SubCategory = "Marksman Rifles"
SWEP.Spawnable = true
SWEP.VModel = Model("models/viper/mw/weapons/v_crossbow.mdl") 
SWEP.WorldModel = Model("models/viper/mw/weapons/w_crossbow.mdl") 
SWEP.Trigger = {
    PressedSound = Sound("mw19.sksierra.fire.first"),
    ReleasedSound = Sound("mw19.sksierra.disconnector"),
    Time = 0.03
}

SWEP.Slot = 3 
SWEP.HoldType = "Rifle"

SWEP.Primary.Sound = Sound("weap_crossbow_fire_plr")
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.BurstRounds = 1
SWEP.Primary.BurstDelay = 0
SWEP.Primary.RPM = 328  
SWEP.CanChamberRound = false
SWEP.CanDisableAimReload = false
SWEP.ReloadRechambers = true
SWEP.Projectile = {
    Class = "mg_arrow", --bullet entity class
    Speed = 8500, 
    Gravity = 1
}
SWEP.ParticleEffects = {
    ["MuzzleFlash"] = "mw_fas2_muzzleflash_dmr",
    ["MuzzleFlash_Suppressed"] = "mw_fas2_muzzleflash_suppressed",
    ["Ejection"] = "mw_ins2_shell_eject", 
}


SWEP.Reverb = { 
    RoomScale = 50000, --(cubic hu)
    --how big should an area be before it is categorized as 'outside'?

    Sounds = {
        Outside = {
            Layer = Sound(""),
            Reflection = Sound("")
        },

        Inside = { 
            Layer = Sound(""),
            Reflection = Sound("")
        }
    }
}

SWEP.Firemodes = {

    [1] = {
        Name = "Semi-Automatic",
        OnSet = function(self)
            self.Primary.Automatic = false
            return "Firemode_Semi"
        end
    },

}

SWEP.BarrelSmoke = {
    Particle = "AC_muzzle_minigun_smoke_barrel",
    Attachment = "muzzle",
    ShotTemperatureIncrease = 75,
    TemperatureThreshold = 100, --temperature that triggers smoke
    TemperatureCooldown = 65 --degrees per second
}

SWEP.Cone = {
    Hip = 0.35, --accuracy while hip
    Ads = 0.033, --accuracy while aiming
    Increase = 0.086, --increase cone size by this amount every time we shoot
    AdsMultiplier = 0.025, --multiply the increase value by this amount while aiming
    Max = 2.5, --the cone size will not go beyond this size
    Decrease = 1, -- amount (in seconds) for the cone to completely reset (from max)
    Seed = 6985 --just give this a random number
}

SWEP.Recoil = {
    Vertical = {0, 0}, --random value between the 2
    Horizontal = {0, 0}, --random value between the 2
    Shake = 3, --camera shake
    AdsMultiplier = 0.05, --multiply the values by this amount while aiming
    Seed = 3584, --give this a random number until you like the current recoil pattern
}

SWEP.Bullet = {
    Damage = {150, 90}, --first value is damage at 0 meters from impact, second value is damage at furthest point in effective range
    EffectiveRange = 100, --in meters, damage scales within this distance
    DropOffStartRange = 10,
    Range = 100, --in meters, after this distance the bullet stops existing
    Tracer = false, --show tracer
    NumBullets = 1, --the amount of bullets to fire
    PhysicsMultiplier = 1.25, --damage is multiplied by this amount when pushing objects
    Penetration = {
        DamageMultiplier = 0.85, --how much damaged is multipled by when leaving a surface.
        MaxCount = 12, --how many times the bullet can penetrate.
        Thickness = 25, --in hu, how thick an obstacle has to be to stop the bullet.
    }
}

SWEP.Zoom = {
    FovMultiplier = 0.95,
    ViewModelFovMultiplier = 1,
    Blur = {
        EyeFocusDistance = 10
    }
}

SWEP.WorldModelOffsets = {
    Bone = "tag_sling",
    Angles = Angle(15,0,-180),
    Pos = Vector(9,-1,-3.5)
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
            [0] = {Pos = Vector(0, 3, 3), Angles = Angle(40, 0, -30)},
            [1] = {Pos = Vector(0, 0, 0), Angles = Angle(-10, 0, 0)}
        },
        Y = {
            [0] = {Pos = Vector(0, 0, 0), Angles = Angle(-10, 20, 0)},
            [1] = {Pos = Vector(4, 0, 1.5), Angles = Angle(10, -20, 0)}
        }
    },
    
    RecoilMultiplier = 1,
    KickMultiplier = 1,
    AimKickMultiplier = 1
}

local BaseClass = baseclass.Get(SWEP.Base)

function SWEP:PostAttachment(attachment)
    BaseClass.PostAttachment(self, attachment)

    if (!self:HasAttachment("attachment_vm_sn_crossbow_mag_gordonbolt")) then
        self.Projectile.Velocity = nil
        self.Primary.TrailingSound = nil
    end
end
