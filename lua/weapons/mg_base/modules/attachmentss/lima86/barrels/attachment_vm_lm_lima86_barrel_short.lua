ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "SA87 12.4\" Factory"
ATTACHMENT.Model = Model("models/viper/mw/attachments/lima86/attachment_vm_lm_lima86_barrel_short.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/lima86/icon_attachment_lm_lima86_barrel_short.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Cone.Hip = weapon.Cone.Hip * 1.15
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.9
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.9
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.1
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.1
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.15
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.15
end