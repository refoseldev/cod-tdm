ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "Hollow Stock Mod"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_stockl.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_stockl.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_stock"] = 1
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.15
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.03
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.03
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.1
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.1
end