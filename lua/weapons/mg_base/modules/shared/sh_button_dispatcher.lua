AddCSLuaFile()

local buttonFunctions = {
    ["mgbase_binds_melee"] = function(weapon) weapon:Melee() end,
    ["mgbase_binds_firemode"] = function(weapon) weapon:ChangeFiremode() end,
    ["mgbase_binds_safety"] = function(weapon) weapon:ChangeSafety() end,
    ["mgbase_binds_inspect"] = function(weapon) weapon:Inspect() end,
    ["mgbase_binds_customize"] = function(weapon) weapon:Customize(!weapon:HasFlag("Customizing")) end,
    ["mgbase_binds_switchsights"] = function(weapon) weapon:ChangeAimMode() end,
    ["mgbase_binds_holster"] = function(weapon) if (weapon:HasFlag("Holstering") && weapon:GetNextWeapon() != weapon:GetOwner()) then weapon:Deploy() else weapon:Holster() end end
}

function SWEP:HandleButton(btn)
    if (btn == 0) then
        return
    end

    for convar, func in pairs(buttonFunctions) do
        if (self:GetOwner():GetInfoNum(convar, -1) == btn) then
            func(self)
        end
    end
end