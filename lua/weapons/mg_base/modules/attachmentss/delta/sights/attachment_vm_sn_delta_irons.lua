ATTACHMENT.Base = "att_sight"
ATTACHMENT.Name = "Ironsights"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.ViewModelOffsets.Aim.Pos:Add(Vector(0, 0, -0.1))
    weapon.ViewModelOffsets.Aim.Angles:Add(Angle(-0.3, 0, 0))
end