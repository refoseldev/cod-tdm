ATTACHMENT.Base = "att_stock"
ATTACHMENT.Name = "XRK SP-LITE 208 Blitz"
ATTACHMENT.Model = Model("models/viper/mw/attachments/romeo700/attachment_vm_sn_romeo700_stockskel.mdl")
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/romeo700/icon_attachment_sn_romeo700_stockskel.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Animations.Ads_In.Fps = weapon.Animations.Ads_In.Fps * 1.09
    weapon.Animations.Ads_Out.Fps = weapon.Animations.Ads_Out.Fps * 1.09
    weapon.Animations.Draw.Fps = weapon.Animations.Draw.Fps * 1.16
    weapon.Animations.Holster.Fps = weapon.Animations.Holster.Fps * 1.16
    weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 1.12
    weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 1.12
    weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 1.12
    weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 1.12
    weapon.Animations.Rechamber.Fps = weapon.Animations.Rechamber.Fps * 0.9
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon:SetGripPoseParameter2("grip_pistolgrip_offset")
    weapon:SetGripPoseParameter("grip_stockskel_offset")
end 