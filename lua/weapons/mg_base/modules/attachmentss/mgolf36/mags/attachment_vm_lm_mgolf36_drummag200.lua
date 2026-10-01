ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "200 Round Drums"
ATTACHMENT.Model = Model("models/viper/mw/attachments/attachment_vm_ar_kilo433_drum_mag.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_mag.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 200
end