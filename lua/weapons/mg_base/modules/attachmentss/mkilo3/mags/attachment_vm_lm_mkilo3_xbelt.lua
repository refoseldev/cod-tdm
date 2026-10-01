ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "200 Round Belt"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mkilo3/attachment_vm_lm_mkilo3_xbelt.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mkilo3/icon_attachment_lm_mkilo3_xbelt.vmt")

--Current mag
ATTACHMENT.BulletList = {
    [15] = {"j_bullet016"},
    [14] = {"j_bullet015"},
    [13] = {"j_bullet014"},
    [12] = {"j_bullet013"},
    [11] = {"j_bullet012"},
    [10] = {"j_bullet011"},
    [9] = {"j_bullet10"},
    [8] = {"j_bullet09"},
    [7] = {"j_bullet08"},
    [6] = {"j_bullet07"},
    [5] = {"j_bullet06"},
    [4] = {"j_bullet05"},
    [3] = {"j_bullet04"},
    [2] = {"j_bullet03"},
    [1] = {"j_bullet02"},
    [0] = {"j_bullet01"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 200
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.8
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.8
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.75
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.75
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 0.85
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.85
end