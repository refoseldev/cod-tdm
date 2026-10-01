ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "25.0\" RAAL Tri-fold Lite"
ATTACHMENT.Model = Model("models/viper/mw/attachments/slima/attachment_vm_lm_slima_barlight.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/slima/icon_attachment_lm_slima_barlight.vmt")


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.06
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.06
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.08
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.08
    weapon.Cone.Hip = weapon.Cone.Hip * 1.1
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.96
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.96
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
end 