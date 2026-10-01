ATTACHMENT.Base = "att_arrow"
ATTACHMENT.Name = "Aztec Death Whistle"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_magskull.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_mag_firebolt.vmt")
ATTACHMENT.CosmeticChange = true
ATTACHMENT.UIColor = CUSTOMIZATION_COLOR_LEGENDARY
ATTACHMENT.VElement = {
    Bone = "j_mag1",
    Position = Vector(0, 0, -1.5),
    Angles = Angle(),
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Projectile.Class = "mg_arrow_bone"
end