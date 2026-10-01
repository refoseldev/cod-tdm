ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "30 Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf36/attachment_vm_lm_mgolf36_mag.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf36/icon_attachment_lm_mgolf36_mag.vmt")

--round, bone name
--im aware its the other way around but the reloads switch mags


--Current mag
ATTACHMENT.BulletList = {
    [1] = {"j_bullet1"},
    [2] = {"j_bullet2"},
    [3] = {"j_bullet3"},
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 30
    weapon.Animations.Reload = weapon.Animations.Reload_armag
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_empty_armag
    weapon.Animations.Inspect = weapon.Animations.Inspect_armag
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.25
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.25
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.25
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.25
end