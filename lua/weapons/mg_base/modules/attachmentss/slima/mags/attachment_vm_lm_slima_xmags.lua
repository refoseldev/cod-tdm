ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "150 Round Belt"
ATTACHMENT.Model = Model("models/viper/mw/attachments/slima/attachment_vm_lm_slima_xmags.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/slima/icon_attachment_lm_slima_xmags.vmt")

--Current mag
ATTACHMENT.BulletList = {
    [12] = {"j_bullet13"},
    [11] = {"j_bullet12"},
    [10] = {"j_bullet11"},
    [9] = {"j_bullet10"},
    [8] = {"j_bullet9"},
    [7] = {"j_bullet8"},
    [6] = {"j_bullet7"},
    [5] = {"j_bullet6"},
    [4] = {"j_bullet5"},
    [3] = {"j_bullet4"},
    [2] = {"j_bullet3"},
    [1] = {"j_bullet2"},
    [0] = {"j_bullet1"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    weapon.Primary.ClipSize = 150
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.85
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.85
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.81
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.81
    weapon.Animations.Reload = weapon.Animations.Reload_xmag
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_Empty_xmag
    weapon.Animations.Inspect = weapon.Animations.Inspect_xmag
end