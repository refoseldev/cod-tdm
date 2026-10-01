AddCSLuaFile()

function SWEP:CanChangeFiremode()
    return !self:HasFlag("Reloading")
        && !self:HasFlag("Drawing")
        && !self:HasFlag("Holstering")
        && (!self:HasFlag("Sprinting") || self:HasFlag("Lowered"))
        && CurTime() > self:GetNextSprintTime()
        && CurTime() > self:GetNextPrimaryFire()
        && CurTime() > self:GetNextMeleeTime()
        && CurTime() > self:GetNextFiremodeTime()
        && !self:HasFlag("Customizing")
end

function SWEP:ChangeFiremode()
    if (CLIENT && game.SinglePlayer()) then
        return
    end

    if (!self:CanChangeFiremode()) then
        return
    end

    local index = self:GetFiremode()

    if (self.Firemodes[index + 1]) then
        index = index + 1
    else
        index = 1
    end

    if (self:GetFiremode() != index) then
        local seqIndex = self:ApplyFiremode(index)
        self:PlayViewModelAnimation(seqIndex)
        
        local length = self:GetAnimation(seqIndex).Length || 0.5
        self:SetNextFiremodeTime(CurTime() + length)
        self:SetBurstRounds(0)
    end
end

function SWEP:ApplyFiremodeStats()
    return self.Firemodes[self:GetFiremode()].OnSet(self)
end

function SWEP:ApplyFiremode(index)
    local seqIndex = "Idle"

    if (type(index) == "string") then
        index = tonumber(index)
    end

    self:SetFiremode(index)

    if (game.SinglePlayer() || IsFirstTimePredicted()) then
        self:BuildCustomizedGun() --to reset to defaults
    end

    if (game.SinglePlayer() && SERVER) then
        self:CallOnClient("ApplyFiremode", index)
    end

    return self:ApplyFiremodeStats()
end