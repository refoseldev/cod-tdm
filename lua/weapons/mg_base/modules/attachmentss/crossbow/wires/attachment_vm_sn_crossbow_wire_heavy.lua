ATTACHMENT.Base = "att_wire"
ATTACHMENT.Name = "28-Strand Cable"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_wire_heavy.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_wire_heavy.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 0.93
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.93
    weapon.Projectile.Speed = weapon.Projectile.Speed * 1.1
end