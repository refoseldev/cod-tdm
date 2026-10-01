ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "FORGE TAC Dart CB"
ATTACHMENT.Model = Model("models/viper/mw/attachments/crossbow/attachment_vm_sn_crossbow_stock_light.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/crossbow/icon_attachment_sn_crossbow_stock_light.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.05
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.05
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.1
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.1
    weapon.Cone.Hip = weapon.Cone.Hip * 1.3
end