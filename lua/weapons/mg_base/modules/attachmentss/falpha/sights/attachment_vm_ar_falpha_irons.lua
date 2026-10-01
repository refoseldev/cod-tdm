ATTACHMENT.Base = "att_sight"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    weapon.ViewModelOffsets.Aim.Angles = Angle(0, 0, 0)
    weapon.ViewModelOffsets.Aim.Pos = Vector(0, 1, 1.55)
end