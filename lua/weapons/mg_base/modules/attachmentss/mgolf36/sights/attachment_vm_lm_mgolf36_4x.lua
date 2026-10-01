ATTACHMENT.Base = "att_optic_4x"
ATTACHMENT.Name = "Solozero K498 4.0x Integral"

ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_4x.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_4x.vmt")
ATTACHMENT.Bodygroups = {
    ["sight"] = 2
}
ATTACHMENT.Optic = {
    HideModel = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_4x_hide.mdl"),
    LensHideMaterial = Material("viper/MW/weapons/mgolf36/weapon_vm_lm_mgolf36_4x_lens.vmt"),
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