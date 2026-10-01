AddCSLuaFile()
require("mw_utils")

--name, int
SWEP.NetworkedFlags = {}
SWEP.NetworkedFlagIndices = {}

local function getFlagIndex(networkedFlag)
    return math.floor(networkedFlag / 31)
end

local function getFlagValue(networkedFlag)
    return 2 ^ (networkedFlag % 31)
end

--flag networking. using string literals as it's easier to add flags for custom functionality
--and lua takes care of them for us anyways
local function networkFlag(weapon, name)
    local highestFlagValue = table.Count(weapon.NetworkedFlags)
    local currentFlagIndex = getFlagIndex(highestFlagValue)

    --have to do 31 because it's signed int
    if (highestFlagValue % 31 == 0) then
        weapon:CustomNetworkVar("Int", "Flags"..currentFlagIndex)
        weapon.NetworkedFlagIndices[currentFlagIndex] = "Flags"..currentFlagIndex
        mw_utils.DevPrint("networkFlag: Registered new set of flags (Flags"..currentFlagIndex..").")
    end
    
    weapon.NetworkedFlags[name] = highestFlagValue
end

SWEP.VarCount = {}

function SWEP:CustomNetworkVar(typ, name)
    if (typ == "Flag") then
        networkFlag(self, name)
        return
    end

    local count = self.VarCount[typ] || -1
    count = count + 1

    self:NetworkVar(typ, count, name)

    self.VarCount[typ] = count
end

--i've decided to not check if a flag name exists. if you're looking for a flag
--that doesn't exist i'd prefer if you checked your code when it errors
function SWEP:HasFlag(name)
    local networkedFlag = self.NetworkedFlags[name] 
    local flagIndex, flagValue = getFlagIndex(networkedFlag), getFlagValue(networkedFlag)
    return bit.band(self.dt[self.NetworkedFlagIndices[flagIndex]], flagValue) == flagValue
end

function SWEP:AddFlag(name)
    local networkedFlag = self.NetworkedFlags[name]
    local flagIndex, flagValue = getFlagIndex(networkedFlag), getFlagValue(networkedFlag)
    local flagDt = self.NetworkedFlagIndices[flagIndex]
    self.dt[flagDt] = bit.bor(self.dt[flagDt], flagValue)
end

function SWEP:RemoveFlag(name)
    local networkedFlag = self.NetworkedFlags[name]
    local flagIndex, flagValue = getFlagIndex(networkedFlag), getFlagValue(networkedFlag)
    local flagDt = self.NetworkedFlagIndices[flagIndex]
    self.dt[flagDt] = bit.band(self.dt[flagDt], bit.bnot(flagValue))
end

function SWEP:ToggleFlag(name)
    if (self:HasFlag(name)) then
        self:RemoveFlag(name)
    else
        self:AddFlag(name)
    end
end

--TODO: reconsider a lot of these vars, some probably dont need to be
function SWEP:SetupDataTables()
    --idea: most of the gun's actions can be simplified with one timer. this game does not allow for overlayed animations,
    --we can't have more than one action playing on the gun at the same time.
    --get rid of all these "time" dtvars, just use one
    self:CustomNetworkVar("Float", "NextActionTime")
    
    self:CustomNetworkVar("Float", "NextReloadTime")
    self:CustomNetworkVar("Float", "NextMagTime")
    self:CustomNetworkVar("Float", "NextHolsterTime")
    self:CustomNetworkVar("Float", "AimDelta")
    self:CustomNetworkVar("Float", "Cone")
    self:CustomNetworkVar("Float", "NextSprintTime")
    self:CustomNetworkVar("Float", "NextInspectTime")
    self:CustomNetworkVar("Float", "NextFiremodeTime")
    self:CustomNetworkVar("Float", "NextMeleeTime")
    self:CustomNetworkVar("Float", "TriggerDelta")
    self:CustomNetworkVar("Float", "NextAimModeTime")
    self:CustomNetworkVar("Float", "AimModeDelta")
    self:CustomNetworkVar("Float", "BreathingDelta")
    
    self:CustomNetworkVar("Flag", "MagInserted")
    self:CustomNetworkVar("Flag", "PlayFirstDraw")
    self:CustomNetworkVar("Flag", "Reloading")
    self:CustomNetworkVar("Flag", "Drawing")
    self:CustomNetworkVar("Flag", "Holstering")
    self:CustomNetworkVar("Flag", "Aiming")
    self:CustomNetworkVar("Flag", "Sprinting")
    self:CustomNetworkVar("Flag", "Rechambered")
    self:CustomNetworkVar("Flag", "HoldingTrigger")
    self:CustomNetworkVar("Flag", "Customizing")
    self:CustomNetworkVar("Flag", "Lowered")
    self:CustomNetworkVar("Flag", "FlashlightOn")
    self:CustomNetworkVar("Flag", "BipodDeployed")
    self:CustomNetworkVar("Flag", "Inspecting")
    self:CustomNetworkVar("Flag", "StoppedInspectAnimation")

    self:CustomNetworkVar("Bool", "ToggleAim")
    self:CustomNetworkVar("Bool", "HasRunOutOfBreath")

    self:CustomNetworkVar("Entity", "NextWeapon")
    self:CustomNetworkVar("Entity", "ViewModel")

    self:CustomNetworkVar("Int", "SprayRounds")
    self:CustomNetworkVar("Int", "Firemode")
    self:CustomNetworkVar("Int", "BurstRounds")
    self:CustomNetworkVar("Int", "PenetrationCount")
    self:CustomNetworkVar("Int", "AimMode")

    --self:CustomNetworkVar("String", "0", "Camo")

    self:CustomNetworkVar("Angle", "BreathingAngle")
end