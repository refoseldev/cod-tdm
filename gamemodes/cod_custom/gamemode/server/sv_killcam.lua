util.AddNetworkString("COD.KillcamSend")

COD.LastKillData = {
    length = 0,
    data = ""
}

function COD:ShowLastKillCam(delay)
    if not COD.DataTable["Enable_KillCam"] then return end
    local len = COD.LastKillData.length
    local tab = COD.LastKillData.data
    timer.Simple(delay, function()
        net.Start("COD.KillcamSend")
        net.WriteUInt(len, 32)
        net.WriteData(tab, len)
        net.WriteBool(true)
        net.Broadcast()
    end)
end

function COD:ShowKillCam(ply, att, delay)
    if not COD.DataTable["Enable_KillCam"] then return end

    if !istable(ply) then
        ply = {ply}
    end
    if not delay then
        delay = 0
    end

    if att.KillCamTable then
        local tab = att.KillCamTable
        local num2 = #att.KillCamTable-300

        for i=1,num2 do
            table.remove(tab, 1)
        end

        local tab3 = util.TableToJSON(tab)
        tab3 = util.Compress(tab3)
        local flt = #tab3

        if flt < 4294967295 then
            for _, en in pairs(ply) do
                if IsValid(en) then
                    net.Start("COD.KillcamSend")
                    net.WriteUInt(flt, 32)
                    net.WriteData(tab3, flt)
                    net.WriteBool(false)
                    net.Send(en)
                end
            end

            COD.LastKillData = {
                length = flt,
                data = tab3
            }
        end
    end
end

hook.Add("Tick", "RecordCamBot", function()
	if COD.DataTable["Enable_KillCam"] then
        local plyall = player.GetAll()
        for k=1,#plyall do
            local ply = plyall[k]

            if !COD.DataTable["Enable_KillCam_WithBots"] and !ply:IsPlayer() then continue end

			if not ply.KillCamTable then
				ply.KillCamTable = {}
            end

            if #ply.KillCamTable > 500 then
                table.remove(ply.KillCamTable, 1)
            end
	
			local plytab = {
				model = ply:GetModel(),
                ang = (ply:GetAimVector()):GetNormalized():Angle(),
				pos = ply:EyePos()-ply:GetAimVector()*32+ply:GetUp()*16,
				snd = "",
				blt = {},
                hit = 0
			}
	
			if ply:GetNWString('SVAnim') != "" then
                plytab.ang = (ply:GetForward()*1-ply:GetRight()*2):GetNormalized():Angle()
				plytab.pos = ply:GetAttachment(ply:LookupAttachment('eyes')).Pos+ply:GetRight()*64-ply:GetForward()*16
			end

			if ply.VMSND and istable(ply.VMSND) then
				plytab.snd = ply.VMSND
				ply.VMSND = nil
			end

			if ply.VMBLT then
				plytab.blt = ply.VMBLT
				ply.VMBLT = nil
			end

            if ply.VMHIT then
                plytab.hit = ply.VMHIT
				ply.VMHIT = nil
            end
	
			local otab = {
				ent = {},
				model = {},
				pos = {},
				ang = {},
				cycle = {},
				seq = {},
				alive = {}
            }

			for i=1,#plyall do
                local pl = plyall[i]
				if pl:IsLineOfSightClear(ply) then
					table.insert(otab.ent, pl:EntIndex())
					table.insert(otab.model, pl:GetModel())
					table.insert(otab.pos, pl:GetPos())
					table.insert(otab.ang, Angle(0,math.Round(pl:EyeAngles().y),0))
					table.insert(otab.cycle, pl:GetCycle())
					table.insert(otab.seq, pl:GetSequenceName(pl:GetSequence()))
					table.insert(otab.alive, pl:Alive())
				end
			end
	
			table.insert(ply.KillCamTable, {
				ply = plytab,
				other = otab,
			})
		end
	end
end)

hook.Add("EntityEmitSound", "RecordCamBot", function(data)
	local ent = data.Entity

    if ent:IsPlayer() or ent.IsBot and ent:IsBot() then
        if not istable(ent.VMSND) then
            ent.VMSND = {}
        end

        table.insert(ent.VMSND, data.SoundName)
    end
end)

hook.Add("EntityTakeDamage", "RecordCamBot", function(ent, data)
    local att = data:GetAttacker()
    if (att:IsPlayer() or att.IsBot and att:IsBot()) and (ent:IsPlayer() or ent.IsBot and ent:IsBot()) then
        att.VMHIT = 1
        if data:GetDamage() >= ent:Health()+ent:Armor() then
            att.VMHIT = 2
        end
    end
end)
		
hook.Add("EntityFireBullets", "RecordCamBot", function(ent, data)
    if ent:IsPlayer() or ent.IsBot and ent:IsBot() then
        if not istable(ent.VMSND) then
            ent.VMSND = {}
        end

        ent.VMBLT = data
    end
end)