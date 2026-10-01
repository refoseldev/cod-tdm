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
        return "Firemode_Auto"
    end
end

function ATTACHMENT:PostProcess(weapon)
    BaseClass.PostProcess(self, weapon)
    weapon.Recoil.AdsMultiplier = 0.8 --deliberate, hidden stat
end