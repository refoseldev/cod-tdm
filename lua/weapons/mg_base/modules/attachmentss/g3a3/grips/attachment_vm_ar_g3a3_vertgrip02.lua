ATTACHMENT.Base = "att_vm_vertgrip02"
ATTACHMENT.BonemergeToCategory = {"Barrels"}
ATTACHMENT.Bodygroups = {
    ["foregrip_rail"] = 1
}
ATTACHMENT.AttachmentBodygroups = {
    ["bipod"] = 1,
    ["tag_grip_rail"] = 1,
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_vert_offset")
end 