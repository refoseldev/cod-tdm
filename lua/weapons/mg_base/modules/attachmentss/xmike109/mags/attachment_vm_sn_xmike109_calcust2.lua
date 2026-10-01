game.AddParticles("particles/mw19_attachments.pcf")
PrecacheParticleSystem("arrow_thermite")

ATTACHMENT.Base = "att_ammo_db"
ATTACHMENT.Name = "Thermite Rounds"
ATTACHMENT.Model = Model("models/viper/mw/attachments/xmike109/attachment_vm_sn_xmike109_calcust2.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/xmike109/icon_attachment_sn_xmike109_calcust2.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 0.75
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 0.75
end