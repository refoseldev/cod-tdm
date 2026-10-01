ATTACHMENT.Base = "att_optic_10x"
ATTACHMENT.Name = "Sniper Scope"
ATTACHMENT.Model = Model("models/viper/mw/attachments/charlie725/attachment_vm_sh_charlie725_scope.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/charlie725/icon_attachment_sh_charlie725_scope.vmt")
ATTACHMENT.Bodygroups = {
        ["tag_rail"] = 1,
}
ATTACHMENT.Optic = {
        LensHideMaterial = Material("viper/mw/weapons/charlie725/weapon_vm_sh_charlie725_huntingscope_lens.vmt"),
        HideModel = Model("models/viper/mw/attachments/charlie725/attachment_vm_sh_charlie725_scope_hide.mdl"),
        LensBodygroup = "lens",
        FOV = 7, 
        ParallaxSize = 750, --a value of zero means 1:1 size with the end of the optic
        Thermal = false
}
ATTACHMENT.Reticle = {
        Material = Material("viper/mw/reticles/reticle_sniper_new.vmt"),
        Size = 2000,
        Color = Color(255, 255, 255, 255),
        Attachment = "reticle"
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Zoom.ViewModelFovMultiplier = weapon.Zoom.ViewModelFovMultiplier * 0.9
    weapon.Animations.Reload = weapon.Animations.reload_scope
    weapon.Animations.Reload_Empty = weapon.Animations.reload_empty_scope
end