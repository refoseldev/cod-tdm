ATTACHMENT.Base = "att_vm_stock_heavy01"
ATTACHMENT.Name = "MK2 Ultralight Hollow"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_stock_v2.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_stock"] = 2
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter2("grip_pistolgrip_offset")
end 