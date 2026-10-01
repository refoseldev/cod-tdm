ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = ".338 Lapua Mag 5-R Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_magcalcust2.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_magcalcust2.vmt")

ATTACHMENT.BulletList = {
    [1] = {"j_bullet01"},
    [2] = {"j_bullet02"},
    [3] = {"j_bullet03"},
}


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Projectile.Gravity = weapon.Projectile.Gravity * 1.2
    weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 1.1
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.1
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.2
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.2
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.5
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.9
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.93
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.93
end