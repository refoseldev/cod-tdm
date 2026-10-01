ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "XRK Ultralight"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_barrel_short.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_barrel_short.vmt")


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.9
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.9
    weapon.Cone.Hip = weapon.Cone.Hip * 1.15
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.08
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.08
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.11
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.11
end