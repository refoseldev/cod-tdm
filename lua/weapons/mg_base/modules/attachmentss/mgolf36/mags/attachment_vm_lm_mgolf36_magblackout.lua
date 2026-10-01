ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = ".300 Blackout 30-Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mcharlie/attachment_vm_ar_mcharlie_magsub.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_mag.vmt")


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 30
    weapon.Animations.Reload = weapon.Animations.Reload_armag
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_empty_armag
    weapon.Animations.Inspect = weapon.Animations.Inspect_armag
end