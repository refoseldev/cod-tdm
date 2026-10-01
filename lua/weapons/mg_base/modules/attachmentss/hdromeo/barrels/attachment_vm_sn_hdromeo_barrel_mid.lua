ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "26.0\" Bull Barrel"
ATTACHMENT.Model = Model("models/viper/mw/attachments/hdromeo/attachment_vm_sn_hdromeo_barrel_mid.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/hdromeo/icon_attachment_sn_hdromeo_barrel_mid.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.91
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.91
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.92
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.92
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 0.9
    weapon.Projectile.Gravity = weapon.Projectile.Gravity * 0.65
end
