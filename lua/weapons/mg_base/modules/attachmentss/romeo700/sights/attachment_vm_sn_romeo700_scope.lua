ATTACHMENT.Base = "att_optic_10x"
ATTACHMENT.Name = "Solozero SP-R 28mm"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_scope.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_scope.vmt")
ATTACHMENT.Bodygroups = {
        ["tag_sight"] = 1,
        ["sight"] = 1
}
ATTACHMENT.Optic = {
        LensHideMaterial = Material("viper/mw/weapons/romeo700/weapon_vm_sn_romeo700_scopelens.vmt"),
        HideModel = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_scope_hide.mdl"),
        LensBodygroup = "lens",
        FOV = 7, 
        ParallaxSize = 750, --a value of zero means 1:1 size with the end of the optic
        Thermal = false
}
ATTACHMENT.Reticle = {
        Material = Material("viper/mw/reticles/reticle_16.vmt"),
        Size = 1250,
        Color = Color(255, 255, 255, 255),
        Attachment = "reticle"
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Zoom.ViewModelFovMultiplier = weapon.Zoom.ViewModelFovMultiplier * 0.9
end