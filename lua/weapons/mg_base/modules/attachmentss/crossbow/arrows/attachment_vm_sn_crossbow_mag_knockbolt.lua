ATTACHMENT.Base = "att_arrow"
ATTACHMENT.Name = "Knockback Arrow"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_mag_firebolt.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_mag_firebolt.vmt")
ATTACHMENT.ExcludedAttachments = {"attachment_vm_sn_crossbow_perk_ammo"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.Damage[1] = 0
    weapon.Bullet.Damage[2] = 0
    weapon.Projectile.Class = "mg_arrow_knockback"
end