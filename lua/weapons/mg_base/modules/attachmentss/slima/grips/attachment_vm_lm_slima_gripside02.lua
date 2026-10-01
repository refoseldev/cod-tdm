ATTACHMENT.Base = "att_vm_stubbygrip01"
ATTACHMENT.Name = "PMC Grip"
ATTACHMENT.Model = Model("models/viper/mw/attachments/slima/attachment_vm_lm_slima_gripside02.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/slima/icon_attachment_lm_slima_gripside02.vmt")


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_sidegrip_offset")

end 