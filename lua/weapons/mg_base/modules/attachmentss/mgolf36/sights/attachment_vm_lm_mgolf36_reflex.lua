ATTACHMENT.Base = "att_optic_2x"
ATTACHMENT.Name = "FSS Integral Reflex"

ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_reflex.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_reflex.vmt")
ATTACHMENT.Bodygroups = {
    ["sight"] = 2
}

ATTACHMENT.Optic = {
    HideModel = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_reflex_hide.mdl"),
    LensHideMaterial = Material("viper/MW/weapons/mgolf36/weapon_vm_lm_mgolf36_reflex_lens.vmt"),
    LensBodygroup = "lens",
    FOV = 7, 
    ParallaxSize = 700, --a value of zero means 1:1 size with the end of the optic
    Thermal = false
}

ATTACHMENT.Reticle = {
    Material = Material("viper/mw/reticles/reticle_reflex_default2.vmt"),
    Size = 600,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle"
}