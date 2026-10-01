ATTACHMENT.Base = "att_optic_10x"
ATTACHMENT.Name = "Scope"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo98/weapon_vm_scope_kilo98.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo98/icon_attachment_scope_kilo98.vmt")
ATTACHMENT.Optic = {
        HideModel = Model("models/viper/mw/attachments/kilo98/weapon_vm_scope_kilo98_lens_hide.mdl"),
        LensHideMaterial = Material("viper/mw/weapons/kilo98/weapon_vm_sn_kilo98_scopeglass.vmt"),
        LensBodygroup = "lens",
        FOV = 7, 
        ParallaxSize = 750, --a value of zero means 1:1 size with the end of the optic
        Thermal = false
}

ATTACHMENT.Bodygroups ={
    ["tag_sight"] = 2,
    ["tag_rail"] = 0,
}

ATTACHMENT.Reticle = {
    Material = Material("viper/mw/reticles/reticle_sniper_new.vmt"),
    Size = 5000,
    Color = Color(255, 255, 255, 255),
    Attachment = "reticle",
    Offset = Vector(-0.09, 0.01, 0)
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload_Start = weapon.Animations.reload_start_scope
    weapon.Animations.Reload_Loop = weapon.Animations.reload_loop_scope
    weapon.Animations.Reload_End = weapon.Animations.reload_end_scope
    weapon.Animations.Rechamber = weapon.Animations.rechamber_scope
end