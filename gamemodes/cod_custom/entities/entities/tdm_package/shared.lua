AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Care Package"

if SERVER then
    local function get_random_key(tbl)
        local total = 0
        for k,v in pairs(tbl) do
            total = total + v
        end
    
        local rand = math.random(0, total)
        local count = 0
    
        for k,v in pairs(tbl) do
            count = count + v
            if rand <= count then
                return k
            end
        end
    end
    
    local Items = {
        [1] = 50,
        [2] = 50,
        [3] = 50,
        [5] = 50,
        [6] = 50,
        [7] = 50,
        [8] = 50,
        [9] = 40,
        [10] = 35,
        [11] = 30,
        [12] = 30,
        [13] = 20,
        [14] = 20,
        [15] = 20,
        [16] = 15,
        [17] = 15,
        [18] = 10,
        [20] = 5,
        [21] = 5,
    }

    function ENT:Initialize()
        self:SetModel("models/cod/score_carepackage.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        self.Item = get_random_key(Items)
        self:GetPhysicsObject():SetVelocity(Vector(0,0,-256))
        self:SetNWFloat('Item', self.Item)
    end

    function ENT:Open(ply)
        if self.Item == 0 then
            local wep = ply:GetActiveWeapon()
            ply:GiveAmmo(wep:GetMaxClip1()*10, wep:GetPrimaryAmmoType(), false)
        else
            COD:KillstreakAddOther(ply, false, self.Item)
            net.Start("COD.KillstreaksHUD")
            net.WriteFloat(self.Item)
            net.Send(ply)
        end
        self:EmitSound("items/ammocrate_open.wav")
        self:Remove()
    end

    net.Receive("COD.PickupCarePackage", function(len, ply)
        local ent = net.ReadEntity()
        if IsValid(ent) then
            ent:Open(ply)
        end
    end)
end
