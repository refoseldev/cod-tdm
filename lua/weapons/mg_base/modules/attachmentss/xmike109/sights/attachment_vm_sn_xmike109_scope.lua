ATTACHMENT.Base = "att_optic_20x"
ATTACHMENT.Name = "Rytec AMR Scope"
ATTACHMENT.Model = Model("models/viper/mw/attachments/xmike109/attachment_vm_sn_xmike109_scope.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/xmike109/icon_attachment_sn_xmike109_scope.vmt")
ATTACHMENT.Bodygroups = {
    ["sight"] = 2
}
ATTACHMENT.Optic = {
    HideModel = Model("models/viper/mw/attachments/xmike109/attachment_vm_sn_xmike109_scope_hide.mdl"),
    LensHideMaterial = Material("viper/MW/weapons/xmike109/weapon_vm_sn_xmike109_scopelens.vmt"),
    LensBodygroup = "lens",
    FOV = 7, 
    ParallaxSize = 700, --a value of zero means 1:1 size with the end of the optic
    Thermal = false
}

ATTACHMENT.Reticle = {
    Material = Material("viper/mw/reticles/reticle_int_default"),
    Size = 1200,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle"
}