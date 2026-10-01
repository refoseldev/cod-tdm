ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Resourceful"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_wounding.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Projectile.PickUp = true
end