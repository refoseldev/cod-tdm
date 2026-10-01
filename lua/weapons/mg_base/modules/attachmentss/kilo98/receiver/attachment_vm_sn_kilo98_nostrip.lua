ATTACHMENT.Base = "att_miscellaneous"
ATTACHMENT.Name = "No Stripper Clips"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_sling.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload_Start = weapon.Animations.reload_start_scope
    weapon.Animations.Reload_Loop = weapon.Animations.reload_loop_scope
    weapon.Animations.Reload_End = weapon.Animations.reload_end_scope
end