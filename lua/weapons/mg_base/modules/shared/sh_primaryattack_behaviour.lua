AddCSLuaFile()

function SWEP:CanAttack()
    if (self:Clip1() <= 0) then
        return false
    end
    
    if (self:GetAnimation("Rechamber") != nil && self:GetAnimation("Reload_Loop") != nil && self:HasFlag("Reloading") && !self:HasFlag("Customizing")) then
        return true
    end

    if (self:GetAnimation("Rechamber") != nil && !self:HasFlag("Rechambered")) then
        return false
    end

    if (self:HasFlag("Customizing")) then
        return false
    end

    if (CurTime() < self:GetNextPrimaryFire()) then
        return false
    end

    if (CurTime() < self:GetNextFiremodeTime()) then
        return false
    end

    --[[if (self:GetOwner():KeyDown(IN_USE)) then
        return false
    end]]

    if ((self:HasFlag("Reloading") && !self:CanAttackInterruptReload()) || self:HasFlag("Holstering") || self:HasFlag("Drawing") || self:HasFlag("Sprinting")) then
        return false
    end

    if (CurTime() < self:GetNextMeleeTime()) then
        return false
    end

    if (CurTime() < self:GetNextSprintTime()) then
        return false
    end

    if (self.Primary.BurstRounds > 1 && self:GetBurstRounds() >= self.Primary.BurstRounds) then
        return false
    end

    --[[if (CurTime() < self:GetNextReloadTime() && self:HasFlag("MagInserted")) then --avoid people from shooting after they canceled their reloads
        return false
    end]]
    --yeah reward it

    return !self.Trigger || self:GetTriggerDelta() >= 1
end

function SWEP:GetRecoilDecreaseEveryShotMultiplier()
    local globalMul = 1

    if (self.Recoil.DecreaseEveryShot != nil) then
        globalMul = 1 - (self:GetSprayRounds() * self.Recoil.DecreaseEveryShot)
        globalMul = math.max(globalMul, self.Recoil.MinDecreaseEveryShot || 0)
    end

    return globalMul
end

function SWEP:GetRecoilMultiplier()
    if (self:HasFlag("BipodDeployed")) then
        return 0.1
    end

    return 1
end

function SWEP:CalculateRecoil()
    math.randomseed(self.Recoil.Seed + self:GetSprayRounds())

    local verticalRecoil = math.min(self:GetSprayRounds(), math.min(self:GetMaxClip1() * 0.33, 20)) * 0.1 + math.Rand(self.Recoil.Vertical[1], self.Recoil.Vertical[2]) * GetConVar("mgbase_sv_recoil"):GetFloat()
    local horizontalRecoil = math.Rand(self.Recoil.Horizontal[1], self.Recoil.Horizontal[2]) * GetConVar("mgbase_sv_recoil"):GetFloat()
    local angles = Angle(-verticalRecoil, horizontalRecoil, horizontalRecoil * -0.3)

    return angles * Lerp(self:GetAimDelta(), 1, self.Recoil.AdsMultiplier) * self:GetRecoilDecreaseEveryShotMultiplier() * self:GetRecoilMultiplier()
end

function SWEP:MetersToHU(meters)
    return (meters * 100) / 2.54
end

SWEP.FireSurfaces = {
    MAT_ANTLION, MAT_BLOODYFLESH, MAT_EGGSHELL, MAT_FLESH, MAT_ALIENFLESH, MAT_PLASTIC, MAT_FOLIAGE, MAT_SLOSH, MAT_GRASS, MAT_WOOD, MAT_DIRT
}

function SWEP:MakeLight(pos, color, brightness, dieTime)
    if (SERVER && game.SinglePlayer()) then
        local args = "Vector("..pos.x..", "..pos.y..", "..pos.z.."), Color("..color.r..", "..color.g..", "..color.b.."), "..brightness..", "..dieTime
        self:GetOwner():SendLua("local e = Entity("..self:EntIndex()..") if (IsValid(e)) then e:MakeLight("..args..") end")
    end

    if (CLIENT) then
        local dlight = DynamicLight(-1)
        if (dlight) then
            dlight.pos = pos
            dlight.r = color.r
            dlight.g = color.g
            dlight.b = color.b
            dlight.brightness = brightness
            dlight.Decay = 1000
            dlight.Size = 256
            dlight.DieTime = dieTime
        end
    end
end

local function drawHitDebug(self, tr, damage, dist, effectiveRange, dropoffStart)
    RunConsoleCommand("clear_debug_overlays")

    timer.Simple(0, function()
        local original = weapons.Get(self:GetClass())
        local ang = tr.HitNormal:Angle()
        debugoverlay.EntityTextAtPosition(tr.HitPos, 0, "°", 5, Color(0, 255, 0, 255))

        --check if we have any atts that change range
        if (self.Bullet.EffectiveRange != original.Bullet.EffectiveRange
            || self.Bullet.DropOffStartRange != original.Bullet.DropOffStartRange
            || self.Bullet.Damage[1] != original.Bullet.Damage[1]
            || self.Bullet.Damage[2] != original.Bullet.Damage[2]) then
            debugoverlay.ScreenText(0.55, 0.51, "You have attachments that modify range values!", 5, Color(255, 100, 50, 255))
        end

        debugoverlay.ScreenText(0.55, 0.52, math.Round(dist - dropoffStart).." / "..math.Round(effectiveRange).." units ("..self.Bullet.EffectiveRange.."m)", 5, Color(0, 200, 50, 255))
        debugoverlay.ScreenText(0.55, 0.53, math.floor(damage).." damage (raw)", 5, Color(255, 200, 0, 255))
    end)
end

function SWEP:BulletCallbackInternal(attacker, tr, dmgInfo)
    local dist = tr.HitPos:Distance(self:GetOwner():GetShootPos())
    local effectiveRange = self:MetersToHU(self.Bullet.EffectiveRange)
    local dropoffStart = self.Bullet.DropOffStartRange && self:MetersToHU(self.Bullet.DropOffStartRange) || 0

    local damage
    if !self.Explosive then --regular hitscan damage
        damage = Lerp(math.Clamp((dist - dropoffStart) / effectiveRange, 0, 1), self.Bullet.Damage[1], self.Bullet.Damage[2])
        damage = math.max(damage / self.Bullet.NumBullets, 1) 
    else --launcher damage
        damage = self.Bullet.Damage[1] / self.Explosive.ImpactBlastRatio
    end

    local pen = self.Bullet.Penetration

    if (SERVER && GetConVar("mgbase_debug_range"):GetInt() > 0) then
        drawHitDebug(self, tr, damage, dist, effectiveRange, dropoffStart)
    end

    local bCanPenetrate = (GetConVar("mgbase_sv_full_penetration"):GetBool() || (self:GetMaxClip1() <= 10 || self:Clip1() % 2 == 0))
        && self.Bullet.NumBullets <= 1 
        && (self.Projectile == nil || self.Projectile.Penetrate) 

    if (bCanPenetrate) then
        if (self:GetPenetrationCount() < pen.MaxCount) then
            local mul = pen.DamageMultiplier
            local c = pen.MaxCount - self:GetPenetrationCount()

            while (c > 0) do
                mul = mul * pen.DamageMultiplier
                c = c - 1
            end

            damage = damage * mul
        end
    end

    if (tr.Entity:IsPlayer()) then
        damage = damage * GetConVar("mgbase_sv_pvpdamage"):GetFloat()
    elseif (tr.Entity:IsNPC() || tr.Entity:IsNextBot()) then
        damage = damage * GetConVar("mgbase_sv_pvedamage"):GetFloat()
    end

    local bGenericButHead = tr.Entity:EyePos() != tr.Entity:GetPos() && tr.HitGroup == HITGROUP_GENERIC && tr.HitPos.z > tr.Entity:EyePos().z
    local bHeadshot = tr.HitGroup == HITGROUP_HEAD || bGenericButHead
    
    if (bGenericButHead) then
        tr.HitGroup = HITGROUP_HEAD
        damage = damage * 2
    end

    if (bHeadshot) then
        dmgInfo:SetDamageCustom(1)
        damage = damage * (self.Bullet.HeadshotMultiplier || 1)
    elseif (tr.HitGroup == HITGROUP_LEFTARM || tr.HitGroup == HITGROUP_RIGHTARM) then
        damage = damage * 4
    elseif (tr.HitGroup == HITGROUP_LEFTLEG || tr.HitGroup == HITGROUP_RIGHTLEG) then
        damage = damage * 2
    end

    dmgInfo:SetDamage(damage + 1)
    
    if (tr.Entity == self.lastHitEntity && (tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.Entity:IsNextBot())) then --if we are penetrating something again (bad coz we apply double damage this way)
        dmgInfo:SetDamage(0)
    end

    if (bCanPenetrate) then
        self.lastHitEntity = tr.Entity
    end

    if (self.Projectile == nil) then
        dmgInfo:SetDamageType(DMG_BULLET)
    end

    dmgInfo:SetDamageForce(tr.Normal * (self.Bullet.Damage[2] * self.Bullet.PhysicsMultiplier * 200) / self.Bullet.NumBullets)

    local bInWater = bit.band(util.PointContents(tr.HitPos), CONTENTS_WATER) == CONTENTS_WATER

    if (!bInWater) then
        for _, att in pairs(self:GetAllAttachmentsInUse()) do
            if (att.OnImpact != nil) then
                att:OnImpact(self, dmgInfo, tr)
            end
        end
    end

    local bCanRicochet = !tr.bFromRicochet && !bWater && (tr.Entity:IsWorld() || tr.Entity:Health() <= 0) && !tr.Entity:IsNPC() && !tr.Entity:IsPlayer() && !tr.Entity:IsNextBot()
    math.randomseed(self:Clip1() + self:Ammo1())

    if (self.Bullet.Ricochet && bCanRicochet && math.random(1, math.Clamp(self:GetMaxClip1() / 10, 2, 4)) == 1) then
        local finalDir = tr.HitNormal + VectorRand()

        if (IsFirstTimePredicted()) then
            for _, e in pairs(ents.FindInSphere(tr.HitPos, 1024)) do
                if (e == self:GetOwner()) then
                    continue
                end
                
                if (!e:IsNPC() && !e:IsPlayer() && !e:IsNextBot()) then
                    continue
                end

                if (e:Health() <= 0) then
                    continue
                end

                local dir = (e:WorldSpaceCenter() - tr.HitPos):GetNormalized()
                local dot = tr.HitNormal:Dot(dir)

                if (dot < 0.5) then
                    continue
                end

                if (!e:IsLineOfSightClear(tr.HitPos)) then
                    continue
                end

                local bCanTarget = (e:IsNPC() || e:IsNextBot()) 
                    || (e:IsPlayer() && (GetConVar("sbox_playershurtplayers"):GetInt() > 0  || e:Team() != self:GetOwner():Team()))

                if (bCanTarget) then
                    finalDir = dir + (VectorRand() * 0.01)
                    break
                end
            end
        end

        if (SERVER) then
            sound.Play("^viper/shared/blt_ricco_0"..math.random(1, 6)..".wav", tr.HitPos, 85, math.random(95, 105), 1)
        end --i was forced, suppresshostevents does nothing like always

        --fire forward
        self:GetOwner():FireBullets({
            Attacker = self:GetOwner(),
            Src = tr.HitPos,
            Dir = finalDir,
            Num = 1,
            Tracer = 0,
            Callback = function(attacker, tr, dmgInfo)
                tr.bFromRicochet = true
                
                if (IsFirstTimePredicted()) then
                    local ed = EffectData()
                    ed:SetScale(5000) --speed
                    ed:SetStart(tr.StartPos)
                    ed:SetOrigin(tr.HitPos)
                    ed:SetNormal(finalDir)
                    ed:SetEntity(self)
                    util.Effect("Tracer", ed)

                    ed = EffectData()
                    ed:SetOrigin(tr.StartPos)
                    ed:SetMagnitude(1)
                    ed:SetScale(1)
                    ed:SetNormal(tr.HitNormal)
                    ed:SetRadius(2)
                    util.Effect("Sparks", ed)

                    --[[if (CLIENT) then
                        local dlight = DynamicLight(self:EntIndex())
                        if (dlight) then
                            dlight.pos = tr.StartPos
                            dlight.r = 255
                            dlight.g = 75
                            dlight.b = 0
                            dlight.brightness = 5
                            dlight.Decay = 500
                            dlight.Size = 8
                            dlight.DieTime = CurTime()
                        end
                    end]]
                end
                
                self:BulletCallback(attacker, tr, dmgInfo)
            end
        })

        return --stop penetration
    end

    if (damage <= 1.9 || tr.HitTexture == "**displacement**" || bInWater || tr.bFromRicochet) then
        return
    end
    
    if (bCanPenetrate && self:GetPenetrationCount() > 0) then
        if (tr.HitNoDraw || tr.HitSky) then
            return
        end

        local output = {}
        local dir = tr.Normal
        local start = tr.HitPos

        if (IsFirstTimePredicted()) then
            --debugoverlay.Axis(tr.HitPos, tr.HitNormal:Angle(), 5, 5, true)
            
            util.TraceLine({
                start = tr.HitPos + tr.Normal,
                endpos = tr.HitPos + tr.Normal * pen.Thickness,
                mask = MASK_SHOT,
                filter = {tr.Entity},
                ignoreworld = !IsValid(tr.Entity),
                output = output
            })

            util.TraceLine({
                start = output.HitPos,
                endpos = tr.HitPos,
                mask = MASK_SHOT,
                output = output
            })

            --debugoverlay.Line(tr.HitPos, output.HitPos, 5, Color(255, 0, 0, 255), true)
        end
        
        if (output != nil && !output.StartSolid && !output.HitNoDraw && !output.HitSky) then
            self:SetPenetrationCount(self:GetPenetrationCount() - 1)

            --fire back to the wall to make hole
            self:GetOwner():FireBullets({
                Attacker = self:GetOwner(),
                Src = output.StartPos,
                Dir = -tr.Normal,
                Num = 1,
                Tracer = 0,
                Damage = 0
            })

            --fire forward
            self:GetOwner():FireBullets({
                Attacker = self:GetOwner(),
                Src = output.HitPos,
                Dir = tr.Normal,
                Num = 1,
                Tracer = 0,
                Callback = function(attacker, tr, dmgInfo)
                    self:BulletCallback(attacker, tr, dmgInfo)
                end
            })
        end
    end
end

function SWEP:BulletCallback(attacker, tr, dmgInfo)
    self:BulletCallbackInternal(attacker, tr, dmgInfo)
end

function SWEP:Bullets(hitpos)
    self.lastHitEntity = NULL
    self:SetPenetrationCount(self.Bullet.Penetration != nil && self.Bullet.Penetration.MaxCount || 0)


    local spread = Vector(self:GetCone(), self:GetCone()) * 0.1

    if (self.Bullet.NumBullets == 1) then
        spread = LerpVector(self:GetAimDelta(), spread, Vector(0, 0))
    end

    local dir = (self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles() + self:GetBreathingSwayAngle()):Forward()

    if (hitpos != nil && isvector(hitpos)) then
        dir = (hitpos - self:GetOwner():EyePos()):GetNormalized()
        spread = Vector()
    end
    
    local bCanAssist = self:GetAimDelta() > 0.5 && self:GetOwner():GetInfoNum("mgbase_aimassist", 1) > 0 && GetConVar("mgbase_sv_aimassist"):GetInt() > 0
    bCanAssist = self.Bullet.NumBullets > 1 || bCanAssist
    
    self:GetOwner():FireBullets({
        Attacker = self:GetOwner(),
        Src = self:GetOwner():EyePos(),
        Dir = dir,
        Spread = spread,
        Num = self.Bullet.NumBullets,
        Damage = self.Bullet.Damage[1], --for some fucking bullet mod or something idk
        HullSize = bCanAssist && 1 || 0,
        --Force = (self.Bullet.Damage[1] * self.Bullet.PhysicsMultiplier) * 0.01,
        Distance = self:MetersToHU(self.Bullet.Range) * GetConVar("mgbase_sv_range"):GetFloat(),
        Tracer = self.Bullet.Tracer && 1 || 0,
        Callback = function(attacker, tr, dmgInfo)
            self:BulletCallback(attacker, tr, dmgInfo, bFromServer)

            if (IsFirstTimePredicted() || game.SinglePlayer()) then
                self:FireTracer(tr.HitPos)
            end
        end
    })
end

function SWEP:GetTracerOrigin() 
    --[[local vm = self:GetViewModel()
    local att = vm:GetAttachment(vm:LookupAttachment("muzzle"))
    
    if (att == nil) then
        return self:GetPos()
    end
    
    return att.Pos - Vector(0, 0, 10)]]

    if (CLIENT && self:IsCarriedByLocalPlayer()) then
       local attEnt, attId = self:GetViewModel():FindAttachment("muzzle")

       return attEnt:GetAttachment(attId).Pos
    end

    return self:GetPos()
end

function SWEP:PrimaryAttack()
    if (!self:CanAttack()) then
        return
    end

    self:RemoveFlag("Lowered")
    self:SetNextInspectTime(0)

    if (self:HasFlag("Reloading")) then
        self:EndReload()

        if (self:GetAnimation("Rechamber") != nil && self:GetAnimation("Reload_Loop") != nil) then
            return
        end
    end

    if (self.Animations.Rechamber || self:Clip1() <= 1) then
        self:RemoveFlag("Rechambered")

        if (self:Clip1() <= 1 && self.ReloadRechambers) then
            self:AddFlag("Rechambered")
        end
    end

    self:SetClip1(self:Clip1() - 1)
    self:SetSprayRounds(self:GetSprayRounds() + 1)

    --self:GetOwner():DoCustomAnimEvent(PLAYERANIMEVENT_ATTACK_PRIMARY, 0)
    self:PlayerGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self.HoldTypes[self:GetCurrentHoldType()].Attack)

    local seqIndex = "Fire"

    if (self:Clip1() <= 0 && self:GetAnimation("Fire_Last") != nil) then
        seqIndex = "Fire_Last"
    end
    
    self:PlayViewModelAnimation(seqIndex)

    self:SetNextPrimaryFire(CurTime() + (60 / self.Primary.RPM))
    self:SetBurstRounds(self:GetBurstRounds() + 1)

    if (self:GetBurstRounds() >= self.Primary.BurstRounds && self.Primary.BurstRounds > 1) then
        self:SetNextPrimaryFire(CurTime() + self.Primary.BurstDelay)

        if (self.Trigger == nil) then
            self:SetBurstRounds(0)
        end
    end

    local punch = self:CalculateRecoil()
    self:GetOwner():ViewPunch(punch)

    self:HandleReverb()

    if (!game.SinglePlayer()) then
        self:EmitSound(self.Primary.Sound)
    else
        self:GetOwner():SendLua("LocalPlayer():EmitSound('"..self.Primary.Sound.."')")
    end
    
    if (self.Primary.TrailingSound != nil) then
        if (!game.SinglePlayer()) then
            self:EmitSound(self.Primary.TrailingSound)
        else
            self:GetOwner():SendLua("LocalPlayer():EmitSound('"..self.Primary.TrailingSound.."')")
        end
    end
    
    --bullets
    self.lastHitEntity = NULL
    if (!self.Projectile) then
        self:Bullets()
    else
        self:Projectiles()
    end

    --setting the eye angles after we shoot, feels like shit otherwise
    if (self.Recoil.Punch != nil) then
        if (IsFirstTimePredicted() || game.SinglePlayer()) then
            punch:Mul(self.Recoil.Punch)
            local ang = self:GetOwner():EyeAngles() + punch
            ang.r = 0

            self:GetOwner():SetEyeAngles(ang)
        end
    end

    self:SetLastShootTime(CurTime())

    --cone
    self:SetCone(math.min(self:GetCone() + self.Cone.Increase * Lerp(self:GetAimDelta(), 10, 10 * self.Cone.AdsMultiplier), self:GetConeMax()))

    if (CLIENT && IsFirstTimePredicted()) then
        self:ShakeCamera()
        self:ShakeViewModel()
    end
    
    if (SERVER && game.SinglePlayer()) then 
        self:CallOnClient("ShakeCamera") 
        self:CallOnClient("ShakeViewModel")
    end
end
 
function SWEP:GetConeDecreaseEveryShotMultiplier()
    local recoilGlobalMul = 1

    if (self.Cone.DecreaseEveryShot != nil) then
        recoilGlobalMul = 1 - (self:GetSprayRounds() * self.Cone.DecreaseEveryShot)
        recoilGlobalMul = math.max(recoilGlobalMul, self.Cone.MinDecreaseEveryShot || 0)
    end

    return recoilGlobalMul
end

function SWEP:GetConeMax()
    local cone = (self.Cone.Max * self:GetConeDecreaseEveryShotMultiplier()) / GetConVar("mgbase_sv_accuracy"):GetFloat()

    if (self:HasFlag("BipodDeployed")) then
        cone = cone * 0.25
    end

    return cone
end

function SWEP:GetConeMin()
    local cone = (Lerp(self:GetAimDelta(), self.Cone.Hip, self.Cone.Ads) * self:GetConeDecreaseEveryShotMultiplier()) / GetConVar("mgbase_sv_accuracy"):GetFloat()

    if (self:HasFlag("BipodDeployed")) then
        cone = cone * 0.25
    end
    
    return cone
end

function SWEP:ShakeCamera()
    self.Camera.Shake = self.Recoil.Shake
end

local recoilFuncs = {
    [true] = function(w, name) return w.Recoil.ViewModel[name] || 1 end,
    [false] = function() return 1 end
}

local function getRecoilValue(w, name)
    return recoilFuncs[w.Recoil.ViewModel != nil](w, name)
end

function SWEP:ShakeViewModel()
    --local seed = math.randomseed(self:GetSprayRounds())
    local vm = self:GetViewModel()

    local recoilPos = Vector(0, 3, -0.5)
    local recoilAng = Angle(0, 0, -2)

    if (self.ViewModelOffsets.Recoil != nil) then
        recoilPos = Vector(self.ViewModelOffsets.Recoil.Pos) || recoilPos
        recoilAng = Angle(self.ViewModelOffsets.Recoil.Angles) || recoilAng
    end

    recoilPos:Mul(1 - self:GetAimDelta())
    recoilAng.p = recoilAng.p * (1 - self:GetAimDelta())
    recoilAng.y = recoilAng.y * (1 - self:GetAimDelta())

    local delta = 1 - self:GetAimDelta()
    local cone = math.Clamp(self:GetCone(), 0.85, 1.2)
    cone = cone * 0.5
    cone = Lerp(delta, 0.5, cone)

    delta = Lerp(delta, 0.3, 1)

    local vpAngles = self:GetOwner():GetViewPunchAngles()
    vpAngles.p = (vpAngles.p * Lerp(self:GetAimDelta(), 0, 0.1)) + math.Rand(-cone, cone)
    vpAngles.y = vpAngles.y * Lerp(self:GetAimDelta(), 0.1, 0.5) + Lerp(self:GetAimDelta(), math.Rand(-cone, cone), 0)

    local ang = Angle()
    ang.pitch = (vpAngles.pitch * getRecoilValue(self, "VerticalMultiplier")) + (recoilAng.pitch * delta)
    ang.yaw = (-vpAngles.yaw * getRecoilValue(self, "HorizontalMultiplier")) + (recoilAng.yaw * delta)
    ang.roll = (math.Rand(-1, 1) * getRecoilValue(self, "HorizontalMultiplier")) + Lerp(delta, recoilAng.roll, recoilAng.roll * 0.5)

    local pos = Vector() 
    pos.y = Lerp(delta, recoilPos.y * 0.5, recoilPos.y) --+ math.sin(math.pi * (math.min(self:GetSprayRounds(), 4) / 4)) * (4 * getRecoilValue(self, "PushBackMultiplier"))
    pos.x = (ang.yaw * 1.5 + (ang.roll * -0.5) + recoilPos.x) * delta
    pos.z = (ang.pitch * 1.5 + (ang.roll * 0.5) + recoilPos.z) * delta

    if (self:HasFlag("BipodDeployed")) then
        pos.x = 0
        pos.z = 0

        ang.pitch = 0
        ang.yaw = 0
        ang.roll = 0
    end

    vm:SetRecoilTargets(pos, ang)
    vm.m_RecoilRoll = math.Clamp(math.Rand(-1, 1) * 100000, -1, 1) * (self.Recoil.Shake * 3)
end

function SWEP:Projectiles()
    if (CLIENT) then
        return
    end

    self:SetPenetrationCount(self.Bullet.Penetration != nil && self.Bullet.Penetration.MaxCount || 0)

    local proj = ents.Create(self.Projectile.Class)

    local angles = self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles()

    local src = LerpVector(self:GetAimDelta(), self:GetOwner():EyePos() + angles:Up() * -3 + angles:Right() * 3, self:GetOwner():EyePos())
    local dir = self:GetOwner():GetEyeTraceNoCursor().HitPos - src 
    
    math.randomseed(self:Clip1() + self:Ammo1() + CurTime() + self.Cone.Seed)
    local spreadRight = math.Rand(-self:GetCone(), self:GetCone()) * 5

    math.randomseed(-self:Clip1() * 0.5 + self:Ammo1() * 2 - CurTime() + self.Cone.Seed)
    local spreadUp = math.Rand(-self:GetCone(), self:GetCone()) * 5

    local spread = LerpVector(self:GetAimDelta(), Vector(spreadRight, spreadUp), Vector(0, 0))
    angles:RotateAroundAxis(angles:Right(), spread.x)
    angles:RotateAroundAxis(angles:Up(), spread.y)

    proj.Weapon = self

    proj:SetPos(src)
    proj:SetAngles(angles)
    proj:SetOwner(self:GetOwner())
    proj:Spawn()
    
    if (self.Projectile.Velocity != nil) then
        proj:SetVelocity(angles:Forward() * self.Projectile.Velocity)
    end
end

local function doTracer(wep, hitpos)
    if (!wep.Bullet) then
        return
    end
    
    local traceEffect = wep.Bullet.TracerName || "mgbase_tracer"
    util.ParticleTracerEx(traceEffect, wep:GetTracerOrigin(), hitpos, false, wep:EntIndex(), -1)
end

function SWEP:FireTracer(pos) 
    if (self.Projectile != nil) then 
        return 
    end

    if (CLIENT) then
        doTracer(self, pos)
    else
        net.Start("mgbase_fire_tracer", false)
            net.WriteEntity(self)
            net.WriteVector(pos)
        if (game.SinglePlayer()) then
            net.Send(self:GetOwner())
        else
            net.SendOmit(self:GetOwner())
        end
    end
end

net.Receive("mgbase_fire_tracer", function() 
    local wep = net.ReadEntity()
    local hitpos = net.ReadVector()
    doTracer(wep, hitpos)
end)