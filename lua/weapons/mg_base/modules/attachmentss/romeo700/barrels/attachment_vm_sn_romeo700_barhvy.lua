ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "ZLR VeraTwist 9.6"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_barhvy.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_dyn_attachment_sn_romeo700_barhvy.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.94
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.94
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.9
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.9
    weapon.Projectile.Gravity = weapon.Projectile.Gravity * 0.73
    weapon.Projectile.Speed = weapon.Projectile.Speed * 1.2
end