ATTACHMENT.Base = "att_optic_4x"
ATTACHMENT.Name = "SUSAT"
ATTACHMENT.Model = Model("models/viper/mw/attachments/lima86/attachment_vm_lm_lima86_4x_west.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/lima86/icon_attachment_sn_lima86_scope.vmt")
ATTACHMENT.Bodygroups = {
        ["sight"] = 1,
        ["tag_sight"] = 1
}
ATTACHMENT.Optic = {
        HideModel = Model("models/viper/mw/attachments/lima86/attachment_vm_lm_lima86_4x_west_hide.mdl"),
        LensHideMaterial = Material("viper/mw/weapons/lima86/weapon_vm_sn_lima86_scopelens.vmt"),
        LensBodygroup = "lens",
        FOV = 7, 
        ParallaxSize = 750, --a value of zero means 1:1 size with the end of the optic
        Thermal = false
}
ATTACHMENT.Reticle = {
        Material = Material("viper/mw/reticles/reticle_16.vmt"),
        Size = 600,
        Color = Color(255, 255, 255, 255),
        Attachment = "reticle"
}