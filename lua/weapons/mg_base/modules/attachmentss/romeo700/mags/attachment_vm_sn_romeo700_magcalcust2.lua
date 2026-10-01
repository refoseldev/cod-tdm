ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = ".300 Norma Mag 5-R Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_magcalcust1.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_magcalcust1.vmt")

ATTACHMENT.BulletList = {
    [1] = {"j_bullet01"},
    [2] = {"j_bullet02"},
    [3] = {"j_bullet03"},
}


local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    
    weapon.Projectile.Speed = weapon.Projectile.Speed * 1.15
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.12
    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 1.22
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 0.95
end