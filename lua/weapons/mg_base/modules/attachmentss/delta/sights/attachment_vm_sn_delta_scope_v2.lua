ATTACHMENT.Base = "attachment_vm_sn_delta_scope"
ATTACHMENT.Name = "Plague Sore"
ATTACHMENT.Model = Model("models/viper/mw/attachments/delta/attachment_vm_sn_delta_scope_v2.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/delta/icon_attachment_sn_delta_scope.vmt")
ATTACHMENT.UIColor = CUSTOMIZATION_COLOR_LEGENDARY

ATTACHMENT.Optic = {
    HideModel = Model("models/viper/mw/attachments/delta/vm_sn_delta_scope_v2_hide.mdl"),
    LensHideMaterial = Material("viper/MW/weapons/delta/weapon_vm_sn_delta_v2_scope_lens.vmt"),
}

ATTACHMENT.Reticle = {
    Material = Material("viper/shared/reticles/po4x_crosshair_new.vmt"),
    Size = 2750,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle"
}
