ATTACHMENT.Base = "att_ammo_he"
ATTACHMENT.Name = "Explosive Rounds"
ATTACHMENT.Particle = "smoke_explosion_he"
ATTACHMENT.Radius = 128
ATTACHMENT.Model = Model("models/viper/mw/attachments/xmike109/attachment_vm_sn_xmike109_calcust1.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/xmike109/icon_attachment_sn_xmike109_calcust1.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 0.75
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 0.75
end