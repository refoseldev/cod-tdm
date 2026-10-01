ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Rifled Barrel"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_recon.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    if (weapon.Projectile != nil) then
        weapon.Projectile.Gravity = 0
    end
end