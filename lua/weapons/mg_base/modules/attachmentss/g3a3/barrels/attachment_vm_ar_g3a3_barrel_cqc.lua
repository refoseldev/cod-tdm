ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Model = Model("models/viper/mw/attachments/gamma3/barrel_cqc.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/gamma3/cqc_barrel.vmt")
ATTACHMENT.Name = "CQC Barrel"
ATTACHMENT.ExcludedCategories = {"Grips", "Lasers"}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_Empty_Carbine
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter("grip_cqc")
end