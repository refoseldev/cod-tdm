ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "XRK Horizon 23.0\""
ATTACHMENT.Model = Model("models/viper/mw/attachments/mkilo3/attachment_vm_lm_mkilo3_barhvy.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mkilo3/icon_attachment_lm_mkilo3_barhvy.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_barrel_hide"] = 1
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Recoil.DecreaseEveryShot = weapon.Recoil.DecreaseEveryShot * 1.22
    weapon.Cone.DecreaseEveryShot = weapon.Cone.DecreaseEveryShot * 0.95
    weapon.Cone.Hip = weapon.Cone.Hip * 0.95
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.93
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.93
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.9
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.9
end