ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "150 Round Belt"
ATTACHMENT.Model = Model("models/viper/mw/attachments/kilo121/attachment_vm_lm_kilo121_mag_ext.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/kilo121/icon_attachment_lm_kilo121_mag_ext.vmt")

--Current mag
ATTACHMENT.BulletList = {
    [0] = {"j_b_17"},
    [1] = {"j_b_16"},
    [2] = {"j_b_15"},
    [3] = {"j_b_14"},
    [4] = {"j_b_13"},
    [5] = {"j_b_12"},
    [6] = {"j_b_11"},
    [7] = {"j_b_10"},
    [8] = {"j_b_09"},
    [9] = {"j_b_08"},
    [10] = {"j_b_07"},
    [11] = {"j_b_06"},
    [12] = {"j_b_05"},
    [13] = {"j_b_04"},
    [14] = {"j_b_03"},
    [15] = {"j_b_02"},
    [16] = {"j_b_01"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 150
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.85
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.85
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.81
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.81
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 0.9
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.9
end