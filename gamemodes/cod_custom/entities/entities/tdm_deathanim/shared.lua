ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

function ENT:Think()
    self:NextThink(CurTime())
    return true
end

if CLIENT then
    net.Receive("tdm.giveanim", function()
        local ent = net.ReadEntity()
        local str = net.ReadString()
        if IsValid(ent) then
            ent:SetCycle(0)
            ent:ResetSequence(str)
        end
    end)
else
    util.AddNetworkString("tdm.giveanim")
end