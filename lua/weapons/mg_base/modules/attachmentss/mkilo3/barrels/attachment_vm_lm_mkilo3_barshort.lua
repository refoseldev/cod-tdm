ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Bruen 18.0\" Para"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mkilo3/attachment_vm_lm_mkilo3_barshort.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mkilo3/icon_attachment_lm_mkilo3_barshort.vmt")


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.95
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.95
    weapon.Cone.Hip = weapon.Cone.Hip * 1.2
    weapon.Cone.MinDecreaseEveryShot = weapon.Cone.MinDecreaseEveryShot * 1.1
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.08
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.08
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.11
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.11
end