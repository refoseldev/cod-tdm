ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "M91 Heavy"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo121/attachment_vm_lm_kilo121_barrel_long.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo121/icon_attachment_lm_kilo121_barrel_long.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.15
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.15
    weapon.Cone.Hip = weapon.Cone.Hip * 0.75
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.86
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.86
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.8
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.8
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
end 