ATTACHMENT.Base = "att_optic_4x"
ATTACHMENT.Name = "XRK MidTrak 4.0x Scope"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_scope.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_scope.vmt")
ATTACHMENT.Bodygroups ={
        ["tag_sight"] = 1
}
ATTACHMENT.Optic = {
        HideModel = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_scope_hide.mdl"),
        LensHideMaterial = Material("viper/mw/weapons/crossbow/weapon_vm_sn_crossbow_lens.vmt"),
        LensBodygroup = "lens",
        FOV = 7, 
        ParallaxSize = 500, --a value of zero means 1:1 size with the end of the optic
        Thermal = false
}
ATTACHMENT.Reticle = {
        Material = Material("viper/mw/reticles/reticle_16.vmt"),
        Size = 1000,
        Color = Color(255, 255, 255, 255),
        Attachment = "reticle"
}