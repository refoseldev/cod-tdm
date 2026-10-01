ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Singuard Custom 27.6\""
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_barlong.vmt")
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.11
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.11
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.92
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.92
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.84
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.84
end