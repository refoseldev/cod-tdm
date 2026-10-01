ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "FSS Stubby"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf34/attachment_vm_lm_mgolf34_barshort.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf34/icon_attachment_lm_mgolf34_barshort.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Cone.Hip = weapon.Cone.Hip * 1.18
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 0.94
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 0.94
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.08
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.08
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.12
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.12
end