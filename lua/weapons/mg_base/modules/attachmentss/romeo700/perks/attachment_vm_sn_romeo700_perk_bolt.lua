ATTACHMENT.Base = "att_perk_bolt"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.rechamber_bolthvy.Fps = weapon.Animations.rechamber_bolthvy.Fps * 1.5
    weapon.Animations.rechamber_boltl.Fps = weapon.Animations.rechamber_boltl.Fps * 1.5
end