ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "Skeleton Stock"
ATTACHMENT.Model = Model("models/viper/mw/attachments/delta/attachment_vm_sn_delta_stock_light.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/delta/icon_attachment_sn_delta_stock_light.vmt")
ATTACHMENT.BonemergeToCategory = {"Receivers"}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.2
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.2
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.1
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.1
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.2
    weapon.Zoom.BreathingMultiplier = weapon.Zoom.BreathingMultiplier * 1.3
end