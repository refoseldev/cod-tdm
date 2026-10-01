ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "M91 Special Forces"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo121/attachment_vm_lm_kilo121_barrel_mid.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo121/icon_attachment_lm_kilo121_barrel_mid.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_barrel_hide"] = 1
}
local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Recoil.DecreaseEveryShot = weapon.Recoil.DecreaseEveryShot * 1.15
    weapon.Cone.DecreaseEveryShot = weapon.Cone.DecreaseEveryShot * 1.15
    weapon.Cone.Hip = weapon.Cone.Hip * 0.95
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.9
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.9
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.88
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.88
end