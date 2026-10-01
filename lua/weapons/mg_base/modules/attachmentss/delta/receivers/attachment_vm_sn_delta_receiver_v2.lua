ATTACHMENT.Base = "att_receiver"
ATTACHMENT.Name = "Plague Sore"
ATTACHMENT.Model = Model("models/viper/mw/attachments/delta/attachment_vm_sn_delta_receiver_v2.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/delta/icon_attachment_sn_delta_receiver_v2.vmt")
ATTACHMENT.CosmeticChange = true
ATTACHMENT.UIColor = CUSTOMIZATION_COLOR_LEGENDARY

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Customization[7][2] = "attachment_vm_sn_delta_scope_v2"
end