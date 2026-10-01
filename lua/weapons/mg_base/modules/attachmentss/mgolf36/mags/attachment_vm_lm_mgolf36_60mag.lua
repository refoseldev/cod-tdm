ATTACHMENT.Base = "att_vm_60rnd_mag"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    weapon.Animations.Reload = weapon.Animations.Reload_armag
    weapon.Animations.Reload_Empty = weapon.Animations.Reload_empty_armag
    weapon.Animations.Inspect = weapon.Animations.Inspect_armag
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.25
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.25
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.25
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.25
    BaseClass.Stats(self, weapon)
end