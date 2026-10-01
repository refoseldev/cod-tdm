ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "32.0\" RAAL Line Breaker"
ATTACHMENT.Model = Model("models/viper/mw/attachments/slima/attachment_vm_lm_slima_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/slima/icon_attachment_lm_slima_barlong.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.13
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.13
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.85
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.85
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.8
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.8
    weapon.Cone.Hip = weapon.Cone.Hip * 0.75
    weapon.Recoil.DecreaseEveryShot = weapon.Recoil.DecreaseEveryShot * 1.2
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
end 