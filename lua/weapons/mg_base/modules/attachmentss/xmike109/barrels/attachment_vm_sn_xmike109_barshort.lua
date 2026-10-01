ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "FORGE TAC Elite"
ATTACHMENT.Model = Model("models/viper/mw/attachments/xmike109/attachment_vm_sn_xmike109_barshort.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/xmike109/icon_attachment_sn_xmike109_barshort.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.15
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.15
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.2
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.2
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 0.78
    weapon.Cone.Hip = weapon.Cone.Hip * 1.15
end
