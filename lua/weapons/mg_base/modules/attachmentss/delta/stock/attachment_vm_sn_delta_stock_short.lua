ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "VLK Lightweight Stock"
ATTACHMENT.Model = Model("models/viper/mw/attachments/delta/attachment_vm_sn_delta_stock_short.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/delta/icon_attachment_sn_delta_stock_short.vmt")
ATTACHMENT.BonemergeToCategory = {"Receivers"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.07
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.07
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.03
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.03
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 0.95
    weapon.Zoom.MovementMultiplier = weapon.Zoom.MovementMultiplier * 1.25
end