ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "FTAC Lightweight Stock"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stock_v2.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_stock"] = 1
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.1
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.1
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.2
    weapon.Animations.Sprint_In.Fps = weapon.Animations.Sprint_In.Fps * 1.12
    weapon.Animations.Sprint_Out.Fps = weapon.Animations.Sprint_Out.Fps * 1.12
end