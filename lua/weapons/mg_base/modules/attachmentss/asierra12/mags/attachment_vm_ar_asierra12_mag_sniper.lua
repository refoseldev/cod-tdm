ATTACHMENT.Base = "att_magazine"
ATTACHMENT.Name = "10 TP Round Mags"
ATTACHMENT.Model = Model("models/viper/mw/attachments/asierra12/attachment_vm_ar_asierra12_mag_sniper_v3.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/asierra12/icon_attachment_ar_asierra12_mag_sniper.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Primary.ClipSize = 10
    weapon.Primary.Automatic = false

    weapon.Firemodes[1].Name = "Semi Auto"

    weapon.Bullet.Damage[1] = weapon.Bullet.Damage[1] * 1.35
    weapon.Bullet.Damage[2] = weapon.Bullet.Damage[2] * 1.35
    weapon.Bullet.DropOffStartRange = weapon.Bullet.DropOffStartRange * 1.5
    weapon.Bullet.EffectiveRange = weapon.Bullet.EffectiveRange * 1.5
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.03
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.03
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.07
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.07
    weapon.Animations.Reload.Fps = weapon.Animations.Reload.Fps * 1.1
    weapon.Animations.Reload_Empty.Fps = weapon.Animations.Reload_Empty.Fps * 1.1
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.Firemodes[2] = nil
    weapon.Primary.RPM = 380
end