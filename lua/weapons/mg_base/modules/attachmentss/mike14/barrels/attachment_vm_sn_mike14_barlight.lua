ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "FORGE TAC Elite"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_barlight.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_barlight.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    --weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.97
    --weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.97
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.15
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.05
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.05
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.05
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.05
end
