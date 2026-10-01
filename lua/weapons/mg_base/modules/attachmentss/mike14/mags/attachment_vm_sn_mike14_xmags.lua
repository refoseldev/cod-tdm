ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "10 Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mike14/attachment_vm_sn_mike14_mag.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mike14/icon_attachment_sn_mike14_xmags.vmt")

ATTACHMENT.BulletList = {
    [1] = {"j_ammo01_mrkt"},
    [2] = {"j_ammo02_mrkt"},
    [3] = {"j_ammo03_mrkt"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload = weapon.Animations.Reload_Xmag
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_Empty_Xmag
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.04
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.04
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.1
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.1
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 1.1
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 1.1
    weapon.Primary.ClipSize = 10
end