ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "SA87 18.2\" Factory"
ATTACHMENT.Model = Model("models/viper/mw/attachments/lima86/attachment_vm_lm_lima86_barrel_mid.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/lima86/icon_attachment_lm_lima86_barrel_mid.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_barrel_hide"] = 1
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Cone.Hip = weapon.Cone.Hip * 1.06
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.96
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.96
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.05
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.05
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.07
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.07
end