ATTACHMENT.Base = "att_vm_thermal_west01"

ATTACHMENT.Model = Model("models/viper/mw/attachments/delta/attachment_vm_thermalsnpr_west01_delta_v3_lod0.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/delta/icon_attachment_thermalsnpr_west01_delta_v3.vmt")

ATTACHMENT.Optic = {
    HideModel = Model("models/viper/mw/attachments/delta/thermalsnpr_west01_delta_v3_hide.mdl"),
    LensHideMaterial = Material("viper/MW/weapons/delta/attachment_vm_thermalsnpr_west01_lens.vmt"),
    LensBodygroup = "lens",
    FOV = 7, 
    ParallaxSize = 700, --a value of zero means 1:1 size with the end of the optic
    Thermal = true,
    ThermalBackgroundColor = Color(50, 100, 75, 223),
    ThermalBodiesColor = Color(250, 250, 0, 150)
}