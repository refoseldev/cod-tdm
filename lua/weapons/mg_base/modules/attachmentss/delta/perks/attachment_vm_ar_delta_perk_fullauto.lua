ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Full Auto"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_hipaim.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)

function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    weapon.Firemodes[1].Name = "Automatic"
    weapon.Firemodes[1].OnSet = function(weapon)
        weapon.Primary.Automatic = true
        weapon.Primary.RPM = 700
    end
    weapon.Primary.Automatic = true
    weapon.Primary.RPM = 700
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.Recoil.AdsMultiplier = 0.8 --deliberate, hidden stat
    
    weapon.Recoil.Vertical[1] = weapon.Recoil.Vertical[1] * 0.15
    weapon.Recoil.Vertical[2] = weapon.Recoil.Vertical[2] * 0.15

    weapon.Recoil.Horizontal[1] = weapon.Recoil.Horizontal[1] * 2
    weapon.Recoil.Horizontal[2] = weapon.Recoil.Horizontal[2] * 2
end