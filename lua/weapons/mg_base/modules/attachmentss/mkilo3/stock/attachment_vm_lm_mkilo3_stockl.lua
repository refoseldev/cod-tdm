ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "Skeleton Stock"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mkilo3/attachment_vm_lm_mkilo3_stockl.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mkilo3/icon_attachment_lm_mkilo3_stockl.mdl")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.03
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.03
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.1
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.1
    weapon.Animations.Sprint_Out.Fps = weapon.Animations.Sprint_Out.Fps * 1.12
    weapon.Recoil.DecreaseEveryShot = weapon.Recoil.DecreaseEveryShot * 0.85
end