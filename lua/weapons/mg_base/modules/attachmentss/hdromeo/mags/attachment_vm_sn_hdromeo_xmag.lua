ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "7 Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/hdromeo/attachment_vm_sn_hdromeo_xmag.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/hdromeo/icon_attachment_sn_hdromeo_xmag.vmt")

--Current mag
ATTACHMENT.BulletList = {
    [1] = {"j_bullet1"},
    [2] = {"j_bullet2"},
}


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload = weapon.Animations.reload_xmag
    weapon.Animations.Reload_Fast = weapon.Animations.reload_xmag_fast
    weapon.Animations.Reload_Empty = weapon.Animations.reload_empty_xmag
    weapon.Animations.Reload_Empty_Fast = weapon.Animations.reload_empty_xmag_fast
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.93
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.93
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 0.95
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.95
    weapon.Primary.ClipSize = 7
end