ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "SP-R 26\""
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_barlong.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.93
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.93
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.88
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.88
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.1
end