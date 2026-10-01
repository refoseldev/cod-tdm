ATTACHMENT.Base = "att_optic_20x"
ATTACHMENT.Name = "HDR Scope"

ATTACHMENT.Model = Model("models/viper/mw/attachments/hdromeo/attachment_vm_sn_hdromeo_snprscope.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/hdromeo/icon_attachment_sn_hdromeo_snprscope.vmt")
ATTACHMENT.AttachmentBodygroups = {
    ["sight"] = 2
}

ATTACHMENT.Optic = {
    HideModel = Model("models/viper/mw/attachments/hdromeo/attachment_vm_sn_hdromeo_snprscope_hide.mdl"),
    LensHideMaterial = Material("viper/MW/weapons/hdromeo/weapon_vm_sn_hdromeo_scope_lens.vmt"),
    LensBodygroup = "lens",
    FOV = 7, 
    ParallaxSize = 700, --a value of zero means 1:1 size with the end of the optic
    Thermal = false
}

ATTACHMENT.Reticle = {
    Material = Material("viper/mw/reticles/reticle_sniper_new.vmt"),
    Size = 2000,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle"
}
