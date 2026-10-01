ATTACHMENT.Base = "att_sight"
ATTACHMENT.Name = "Default Ironsights"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.ViewModelOffsets.Aim.Angles = Angle(0, 0, 0)
    weapon.ViewModelOffsets.Aim.Pos = Vector(0, 0, 0.5)
end