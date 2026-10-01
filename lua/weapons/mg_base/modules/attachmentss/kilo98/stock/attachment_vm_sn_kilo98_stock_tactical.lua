ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "STVOL Precision Comb"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_stock_tactical.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_stock_tactical.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Recoil.AdsMultiplier = 0
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.9
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.9
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.88
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.88
end