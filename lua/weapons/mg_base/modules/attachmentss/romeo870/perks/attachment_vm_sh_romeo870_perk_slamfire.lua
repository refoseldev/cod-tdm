ATTACHMENT.Base = "att_perk"
ATTACHMENT.Name = "Slamfire"
ATTACHMENT.Icon = Material("viper/mw/attachments/icons/perks/perk_icon_slamfire.vmt")

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)
    -- weapon.Animations.Rechamber = weapon.Animations.rechamber_slam
    -- weapon.Animations.Fire = weapon.Animations.fire_slam
    -- weapon.Animations.Fire_Last = weapon.Animations.fire_last_slam
    weapon.Primary.RPM = 450
    weapon.Animations.Rechamber.Length = 0.3
    weapon.Cone.Hip = 1.3 
    weapon.Cone.Max = 7.5 
    --weapon.Primary.Automatic = true 

    local oldOnSet = weapon.Firemodes[1].OnSet
    weapon.Firemodes[1].OnSet = function(wpn) 
        oldOnSet(wpn)
        wpn.Primary.Automatic = true
    end
end