ATTACHMENT.Base = "att_accessory"
ATTACHMENT.Name = "Sling"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_sn_kilo98_sling.vmt")
ATTACHMENT.Bodygroups = {
    ["sling"] = 1
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.m_slingTarget = 0
    weapon.m_slingLerp = 0
end