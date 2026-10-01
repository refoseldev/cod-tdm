ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Model = Model("models/viper/mw/attachments/gamma3/barrel_sniper.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/gamma3/sniper_barrel.vmt")
ATTACHMENT.Name = "Sniper Barrel"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_sniper")
end