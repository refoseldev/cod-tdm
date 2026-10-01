ATTACHMENT.Base = "att_arm"
ATTACHMENT.Name = "XRK Quill 100 Lb"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_arms_light.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_arms_light.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Projectile.Speed = weapon.Projectile.Speed * 0.8
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.07
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.07
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.05
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.05
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 1.1
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 1.1
end