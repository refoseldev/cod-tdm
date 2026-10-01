ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "FORGE TAC Precision 20.0\""
ATTACHMENT.Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_barlong.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.04
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.04
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.96
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.96
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.94
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.94
end