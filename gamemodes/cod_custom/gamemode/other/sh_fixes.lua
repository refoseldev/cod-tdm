if game.SinglePlayer() then return end

-----------------------------------------------------------------------=#
if SERVER then

    util.AddNetworkString("MultiplayerSoundFix_PlaySound")
    
    local ENT = FindMetaTable("Entity")

    if !MPSNDFIX_SOUND_PLAY then MPSNDFIX_SOUND_PLAY = sound.Play end
    if !MPSNDFIX_EMITSOUND then MPSNDFIX_EMITSOUND = ENT.EmitSound end

    -----------------------------------------------------------------------=#
    timer.Create("MPSOUNDFIX_RESET_PLY_NET_MSG_COUNT", 1, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            ply.MPSNDFIX_NETMSGS = 0
        end
    end)
    -----------------------------------------------------------------------=#

    -----------------------------------------------------------------------=#
    local function posObscured( pos1, pos2 )
        return util.TraceLine({
            start = pos1,
            endpos = pos2,
            mask = MASK_NPCWORLDSTATIC,
        }).Hit
    end
    -----------------------------------------------------------------------=#

    -----------------------------------------------------------------------=#
    local function sound_Net( name, pos, lvl, pitch, vol )
        if lvl < 100 then return end

        for _, ply in ipairs(player.GetAll()) do

            if ply.MPSNDFIX_NETMSGS and ply.MPSNDFIX_NETMSGS >= 10 then continue end

            local dist = ply:GetPos():DistToSqr(pos)

            if dist < 1970^2 then continue end
            if dist > 8000^2 && posObscured( ply:WorldSpaceCenter(), pos ) then continue end

            net.Start("MultiplayerSoundFix_PlaySound")
            net.WriteString(name)
            net.WriteVector(pos)
            net.WriteUInt(lvl, 10)
            net.WriteUInt(pitch, 9)
            net.WriteFloat(vol)
            net.Send(ply)
            ply.MPSNDFIX_NETMSGS = ply.MPSNDFIX_NETMSGS + 1

        end
    end
    -----------------------------------------------------------------------=#

    -----------------------------------------------------------------------=#
    function sound:Play( pos, lvl, pitch, vol )
        sound_Net( self, pos or Vector(), lvl or 100, pitch or 100, vol or 1 )
        MPSNDFIX_SOUND_PLAY( self, pos, lvl, pitch, vol )
    end
    -----------------------------------------------------------------------=#

    -----------------------------------------------------------------------=#
    function ENT:EmitSound( name, lvl, pitch, vol, ... )

        if !self.GetClass or self:GetClass() == "gmod_tool" then return end -- Weird entities that we just skip

        sound_Net( name, self:WorldSpaceCenter(), lvl or 100, pitch or 100, vol or 1 )
        MPSNDFIX_EMITSOUND( self, name, lvl, pitch, vol, ... )

    end
    -----------------------------------------------------------------------=#

end
-----------------------------------------------------------------------=#
if CLIENT then

    net.Receive("MultiplayerSoundFix_PlaySound", function()

        local name = net.ReadString()
        local pos = net.ReadVector()
        local lvl = net.ReadUInt(10)
        local pitch = net.ReadUInt(9)
        local vol = net.ReadFloat()

        sound.Play(name, pos, lvl, pitch, vol)
        
    end)

end
--PENETRATION-----------------------------------------------------------=#
local matEasyPen = {
    [MAT_GLASS] = 0, 
    [MAT_WOOD] = 1,
    [MAT_PLASTIC] = 1, 
}

local function Penetration(ent, data)
    if IsValid(ent) then
        if ent.CurrentPenetrationPower >= 0 then
            data.Damage = data.Damage/1.5
            data.Callback = function(ent, tr, dmg)
                data.Src = tr.HitPos+data.Dir*4
                if matEasyPen[tr.MatType] then
                    ent.CurrentPenetrationPower = ent.CurrentPenetrationPower - matEasyPen[tr.MatType]
                else
                    ent.CurrentPenetrationPower = ent.CurrentPenetrationPower - 2
                end
                if tr.Entity and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
                    ent.CurrentPenetrationPower = ent.CurrentPenetrationPower - 1
                    data.IgnoreEntity = tr.Entity
                end
                if ent.CurrentPenetrationPower >= 0 and not tr.HitSky then
                    Penetration(ent, data)
                end
            end
            ent:FireBullets(data)
        end
    end
end

hook.Add("EntityFireBullets", "TDM_Penetration", function(ent, data)
    if ent.PenetrationPower and ent.PenetrationPower > 0 then
        if ent.CurrentPenetrationPower == ent.PenetrationPower then
            data.Callback = function(ent, tr, dmg)
                if tr.Entity and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
                    ent.CurrentPenetrationPower = ent.CurrentPenetrationPower - 1
                    data.IgnoreEntity = tr.Entity
                end
                if matEasyPen[tr.MatType] then
                    ent.CurrentPenetrationPower = ent.CurrentPenetrationPower - matEasyPen[tr.MatType]
                else
                    ent.CurrentPenetrationPower = ent.CurrentPenetrationPower - 2
                end
                if ent.CurrentPenetrationPower >= 0 and not tr.HitSky then
                    data.Src = tr.HitPos+data.Dir*4
                    Penetration(ent, data)
                end
            end
            return true
        end
    end
end)