ATTACHMENT.Base = "att_arrow"
ATTACHMENT.Name = "Thermite Arrow"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_mag_firebolt.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_mag_firebolt.vmt")
ATTACHMENT.ExcludedAttachments = {"attachment_vm_sn_crossbow_perk_ammo"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.Damage[1] = 50
    weapon.Bullet.Damage[2] = 25
    weapon.Projectile.Class = "mg_arrow_thermite"
    weapon.Projectile.Speed = 6000
end