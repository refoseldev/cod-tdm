ATTACHMENT.Base = "att_perk_soh"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload = weapon.Animations.reload_fast
    weapon.Animations.Reload_Empty = weapon.Animations.reload_empty_fast
    weapon.Animations.reload_start_scope = weapon.Animations.reload_start_fast_scope
    weapon.Animations.reload_loop_scope = weapon.Animations.reload_loop_fast_scope
    weapon.Animations.reload_end_scope = weapon.Animations.reload_end_fast_scope
end