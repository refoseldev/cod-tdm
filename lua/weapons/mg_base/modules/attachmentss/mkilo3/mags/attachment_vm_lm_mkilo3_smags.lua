ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "60 Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mkilo3/attachment_vm_lm_mkilo3_smags.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mkilo3/icon_attachment_lm_mkilo3_smags.vmt")

--Current mag
-- ATTACHMENT.BulletList = {
--     [1] = {"j_b_08"},
--     [2] = {"j_b_07"},
--     [3] = {"j_b_06"},
--     [4] = {"j_b_05"},
--     [5] = {"j_b_04"},
--     [6] = {"j_b_03"},
--     [7] = {"j_b_02"},
--     [8] = {"j_b_01"},
-- }

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 60
    weapon.Animations.Fire = weapon.Animations.Fire_smag
    weapon.Animations.Melee = weapon.Animations.Melee_smag
    weapon.Animations.Melee_Hit = weapon.Animations.Melee_Hit_smag
    weapon.Animations.Idle = weapon.Animations.Idle_smag
    weapon.Animations.Jump = weapon.Animations.Jump_smag
    weapon.Animations.Land = weapon.Animations.Land_smag
    weapon.Animations.Jog_Out = weapon.Animations.Jog_Out_smag
    weapon.Animations.Sprint_In = weapon.Animations.Sprint_In_smag
    weapon.Animations.Sprint_Out = weapon.Animations.Sprint_Out_smag
    weapon.Animations.Ads_In = weapon.Animations.Ads_In_smag
    weapon.Animations.Ads_Out = weapon.Animations.Ads_Out_smag
    weapon.Animations.Reload = weapon.Animations.Reload_smag
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_empty_smag
    weapon.Animations.Inspect = weapon.Animations.Inspect_smag
    weapon.CanDisableAimReload = false
end