ATTACHMENT.Base = "att_arrow"
ATTACHMENT.Name = "Freeman"
ATTACHMENT.Model = Model("models/crossbow_bolt.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_mag_firebolt.vmt")
ATTACHMENT.UIColor = CUSTOMIZATION_COLOR_LEGENDARY
ATTACHMENT.VElement = {
    Bone = "j_mag1",
    Position = Vector(0, -10, 0),
    Angles = Angle(),
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Projectile.Class = "crossbow_bolt"
    weapon.Projectile.Velocity = 3000
    weapon.Primary.TrailingSound = "Weapon_Crossbow.BoltFly"
end