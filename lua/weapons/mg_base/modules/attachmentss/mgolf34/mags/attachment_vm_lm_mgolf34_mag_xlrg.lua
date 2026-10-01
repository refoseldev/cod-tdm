ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "100 Round Belt"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf34/attachment_vm_lm_mgolf34_mag_xlrg.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf34/icon_attachment_lm_mgolf34_mag.vmt")

--Current mag
ATTACHMENT.BulletList = {
    [0] = {"j_bullet_01"},
    [1] = {"j_bullet_02"},
    [2] = {"j_bullet_03"},
    [3] = {"j_bullet_04"},
    [4] = {"j_bullet_05"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 100
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.85
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.85
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.8
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.8
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 0.9
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.9
end