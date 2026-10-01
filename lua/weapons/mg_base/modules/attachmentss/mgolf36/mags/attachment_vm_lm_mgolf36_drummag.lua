ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "100 Round Drums"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_drummag.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_mag.vmt")

--Current mag
ATTACHMENT.BulletList = {
    [1] = {"j_bullet1"},
    [2] = {"j_bullet2"},
    [3] = {"j_bullet3"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 100 --so when putting other mags in they dont show up as negative
end