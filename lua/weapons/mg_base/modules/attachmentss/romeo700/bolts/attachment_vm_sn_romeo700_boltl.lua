ATTACHMENT.Base = "att_bolt"
ATTACHMENT.Name = "Sloan KR-600 Feather"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_boltl.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_boltl.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Rechamber = weapon.Animations.rechamber_boltl
end