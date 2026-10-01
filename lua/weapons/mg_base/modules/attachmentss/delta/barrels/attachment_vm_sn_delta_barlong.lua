ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "660mm Extended Barrel"
ATTACHMENT.Model = Model("models/viper/mw/attachments/delta/attachment_vm_sn_delta_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/delta/icon_attachment_sn_delta_barlong.vmt")
ATTACHMENT.BonemergeToCategory = {"Receivers"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.1
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.1
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.9
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.9
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.92
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.92
end