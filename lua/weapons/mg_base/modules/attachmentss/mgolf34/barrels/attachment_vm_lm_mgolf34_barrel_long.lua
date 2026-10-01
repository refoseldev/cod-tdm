ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "FSS Brute"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf34/attachment_vm_lm_mgolf34_barlong.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf34/icon_attachment_lm_mgolf34_barlong.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 0.85
    weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 0.85
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.92
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.92
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.86
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.86
end