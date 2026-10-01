ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "Singuard Custom 21.2\""
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo98/attachment_vm_sn_kilo98_barshort.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_barshort.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.92
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.92
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.05
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.05
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.1
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.1
end