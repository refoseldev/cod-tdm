ATTACHMENT.Base = "att_optic"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.85
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.85
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.9
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.9
    weapon.Zoom.ViewModelFovMultiplier = weapon.Zoom.ViewModelFovMultiplier * 1.55
    weapon.Zoom.FovMultiplier = 0.03
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)

    weapon.Recoil.AdsMultiplier = weapon.Recoil.AdsMultiplier * 0.15

    if (weapon.Recoil.Punch != nil) then
        weapon.Recoil.Punch = weapon.Recoil.Punch * 0.35
    end

    if (weapon.Recoil.AdsShakeMultiplier != nil) then
        weapon.Recoil.AdsShakeMultiplier = weapon.Recoil.AdsShakeMultiplier * 0.25
    end
end 