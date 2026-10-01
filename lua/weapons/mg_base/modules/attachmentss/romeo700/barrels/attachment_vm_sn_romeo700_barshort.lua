ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "ZLR Asp"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_barshort.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_barshort.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.5
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.35
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.15
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.15
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.17
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.17
    weapon.Projectile.Gravity = weapon.Projectile.Gravity * 1.2
    weapon.Projectile.Speed = weapon.Projectile.Speed * 0.55
end