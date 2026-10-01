ATTACHMENT.Base = "att_vm_scope_mike14"

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Reload_Start = weapon.Animations.reload_start_scope
    weapon.Animations.Reload_Loop = weapon.Animations.reload_loop_scope
    weapon.Animations.Reload_End = weapon.Animations.reload_end_scope
    weapon.Animations.Rechamber = weapon.Animations.rechamber_scope
end