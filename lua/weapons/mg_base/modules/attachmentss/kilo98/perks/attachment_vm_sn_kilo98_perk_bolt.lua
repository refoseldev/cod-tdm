ATTACHMENT.Base = "att_perk_bolt"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.rechamber_scope.Fps = weapon.Animations.rechamber_scope.Fps * 1.5
    --weapon.Animations.reload_start_scope.Fps = weapon.Animations.reload_start_scope.Fps * 1.5
    weapon.Animations.reload_end_scope.Fps = weapon.Animations.reload_end_scope.Fps * 1.5
    --weapon.Animations.reload_start_fast_scope.Fps = weapon.Animations.reload_start_fast_scope.Fps * 1.5
    weapon.Animations.reload_end_fast_scope.Fps = weapon.Animations.reload_end_fast_scope.Fps * 1.5
end 