ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "FTAC Sport Comb"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_stocks.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_stocks.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.2
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.08
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.08
end