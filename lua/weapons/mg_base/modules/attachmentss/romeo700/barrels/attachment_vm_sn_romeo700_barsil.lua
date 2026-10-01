ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "XRK 208 Dragoon"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_barsil.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_barsil.vmt")
ATTACHMENT.ExcludedCategories = {"Muzzle Devices"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.97
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.97
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.93
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.93
    weapon.Projectile.Speed = weapon.Projectile.Speed * 1.2

    weapon:doSuppressorStats()
end