ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "SA87 25.4\" Factory"
ATTACHMENT.Model = Model("models/viper/mw/attachments/lima86/attachment_vm_lm_lima86_barrel_long.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/lima86/icon_attachment_lm_lima86_barrel_long.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.03
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.03
    weapon.Recoil.DecreaseEveryShot = weapon.Recoil.DecreaseEveryShot * 1.1
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.98
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.98
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.96
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.96
end