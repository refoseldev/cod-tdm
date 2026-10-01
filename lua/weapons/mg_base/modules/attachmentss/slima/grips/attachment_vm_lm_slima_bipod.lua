ATTACHMENT.Base = "att_grip"
ATTACHMENT.Name = "Bipod"
ATTACHMENT.Model = Model("models/viper/mw/attachments/slima/attachment_vm_lm_slima_bipod.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/slima/icon_attachment_lm_slima_bipod.vmt")
ATTACHMENT.Bipod = true

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
end 