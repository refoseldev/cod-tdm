ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Model = Model("models/viper/mw/attachments/gamma3/barrel_carbine.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/gamma3/carbine_barrel.vmt")
ATTACHMENT.Name = "Carbine Barrel"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_Empty_Carbine
end