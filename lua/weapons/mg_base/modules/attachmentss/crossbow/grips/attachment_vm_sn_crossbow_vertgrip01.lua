ATTACHMENT.Base = "att_vm_vertgrip01"
ATTACHMENT.Name = "XRK Precision Grip"
ATTACHMENT.Bodygroups = {
    ["tag_grip_hide"] = 1
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.98
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.98
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.95
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.95
    weapon.Cone.Hip = weapon.Cone.Hip * 0.93
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_vert_offset")
end 