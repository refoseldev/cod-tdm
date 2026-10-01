ATTACHMENT.Base = "att_vm_stock_light01"
ATTACHMENT.Bodygroups = {
    ["tag_stock"] = 2
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter2("grip_pistolgrip_offset")
end 