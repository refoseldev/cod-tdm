ATTACHMENT.Base = "att_barrel"
ATTACHMENT.Name = "FSS Elite"
ATTACHMENT.Model = Model("models/viper/mw/attachments/mgolf34/attachment_vm_lm_mgolf34_barmid.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/mgolf34/icon_attachment_lm_mgolf34_barmid.vmt")
ATTACHMENT.Bodygroups = {
    ["tag_barrel_hide"] = 1
}

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Cone.Hip = weapon.Cone.Hip * 0.75
    weapon.Cone.MinDecreaseEveryShot = weapon.Cone.MinDecreaseEveryShot * 0.75
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 0.92
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 0.92
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 0.86
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 0.86
end