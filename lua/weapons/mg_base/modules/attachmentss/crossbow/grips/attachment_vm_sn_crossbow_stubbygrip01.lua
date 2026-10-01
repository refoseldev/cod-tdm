ATTACHMENT.Base = "att_vm_stubbygrip01"
ATTACHMENT.Name = "XRK Talon"
ATTACHMENT.Bodygroups = {
    ["tag_grip_hide"] = 1
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    weapon.Animations.Sprint_Out.Fps = weapon.Animations.Sprint_Out.Fps * 1.13
    weapon.Cone.Hip = weapon.Cone.Hip * 1.06
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_vert_offset")
end 