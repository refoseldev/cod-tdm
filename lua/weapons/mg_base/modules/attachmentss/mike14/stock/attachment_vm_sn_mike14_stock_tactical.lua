ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "FTAC Precision Comb"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_stock_tactical.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stock_tactical.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.95
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.95
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 0.9
end