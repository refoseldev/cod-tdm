require("mw_math")
require("mw_utils")

ENT.m_AimDelta = 0
ENT.m_AimModeDelta = 0
ENT.m_CameraAttachment = nil
function ENT:CalcView(origin, angles)
    if (self:GetRenderOrigin() == nil) then
        return
    end

    --local camera = self:GetAttachment(mw_utils.LookupAttachmentCached(self, "camera"))

    if (self.m_CameraAttachment == nil) then
        return
    end

    local camera = self.m_CameraAttachment
    local cameraPos, cameraAng = camera:GetTranslation(), camera:GetAngles()
    
    angles:RotateAroundAxis(angles:Forward(), cameraAng.r)
    angles:RotateAroundAxis(angles:Up(), -cameraAng.y)
    angles:RotateAroundAxis(angles:Right(), cameraAng.p)

    mw_math.VectorAddAndMul(origin, angles:Forward(), -cameraPos.x)
    mw_math.VectorAddAndMul(origin, angles:Up(), -cameraPos.z)
    mw_math.VectorAddAndMul(origin, angles:Right(), cameraPos.y)
end

ENT.m_Movement = {
    p = mw_math.CreateSpring(150, 0.75),
    x = mw_math.CreateSpring(80, 1),
    y = mw_math.CreateSpring(100, 1)
}

ENT.m_LastZVel = 0
ENT.m_LandTarget = 0

local function movementInertia(vm, pos, ang)
    local w = vm:GetWeaponOwner()
    local p = vm:GetPlayerOwner()

    if (!IsValid(vm:GetPlayerOwner())) then
        return
    end

    local vel = p:GetVelocity()

    --vertical
    if (!p:IsOnGround()) then
        vm.m_LastZVel = vel.z
        vm.m_LandTarget = 0
    else
        if (vm.m_LastZVel != 0) then
            vm.m_LandTarget = -math.Clamp(vm.m_LastZVel, -1000, 1000) * 0.02
            vm.m_LastZVel = 0
        end

        vm.m_LandTarget = mw_math.SafeLerp(5 * FrameTime(), vm.m_LandTarget, 0)
    end

    vm.m_Movement.p:SetTarget(math.Clamp(math.Clamp(vel.z, -200, 200) * 0.025, -10, 10) + vm.m_LandTarget)
    vm.m_Movement.p:Decay()

    local pi = vm.m_Movement.p:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, 0.1) 

    ang:SetUnpacked(ang.p - pi, ang.y, ang.r)

    --horizontal
    vel:Div(p:GetWalkSpeed())

    local dotY = 0
    local dotX = 0

    if (!w:HasFlag("Sprinting")) then
        local movementAngles = Angle(0, p:EyeAngles().y, 0)
        dotY = movementAngles:Forward():Dot(vel)
        dotY = dotY * -1
        dotY = math.Clamp(dotY, -2, 2)

        dotX = movementAngles:Right():Dot(vel)
        dotX = dotX * -1
        dotX = math.Clamp(dotX, -1.25, 1.25)
    end

    vm.m_Movement.y:SetTarget(dotY)
    vm.m_Movement.y:Decay()

    vm.m_Movement.x:SetTarget(dotX)
    vm.m_Movement.x:Decay()

    local y = vm.m_Movement.y:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, 0.3)
    local x = vm.m_Movement.x:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, 0.075)

    pos:SetUnpacked(pos.x + x, pos.y + y, pos.z)
end

ENT.m_SwayAngle = nil
ENT.m_Sway = {
    p = mw_math.CreateSpring(150, 0.75),
    ya = mw_math.CreateSpring(120, 1),
    r = mw_math.CreateSpring(60, 0.85),
    x = mw_math.CreateSpring(145, 1),
    y = mw_math.CreateSpring(100, 1),
    z = mw_math.CreateSpring(150, 0.75)
}

local function sway(vm, pos, ang, originalAng)
    if (vm.m_SwayAngle == nil) then
        vm.m_SwayAngle = Angle(originalAng)
    end

    local diffY = math.AngleDifference(vm.m_SwayAngle.y, originalAng.y)
    diffY = diffY / RealFrameTime()
    diffY = diffY * 0.015

    local diffP = math.AngleDifference(vm.m_SwayAngle.p, originalAng.p)
    diffP = diffP / RealFrameTime()
    diffP = diffP * 0.01

    vm.m_Sway.p:SetTarget(diffP + diffY * mw_math.SafeLerp(vm.m_AimDelta, 0.1, 0))
    vm.m_Sway.ya:SetTarget(diffY)
    vm.m_Sway.r:SetTarget(diffY * 0.75)
    
    vm.m_Sway.z:SetTarget(diffP * 0.125 + diffY * mw_math.SafeLerp(vm.m_AimDelta, 0.01, 0))
    vm.m_Sway.x:SetTarget(diffY * 0.15)
    vm.m_Sway.y:SetTarget(diffY * 0.1)

    vm.m_Sway.p:Decay()
    vm.m_Sway.ya:Decay()
    vm.m_Sway.r:Decay()
    vm.m_Sway.x:Decay()
    vm.m_Sway.y:Decay()
    vm.m_Sway.z:Decay()

    vm.m_SwayAngle:Set(originalAng)

    --

    local p = vm.m_Sway.p:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, -0.1)
    local y = vm.m_Sway.ya:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, -0.1)
    local r = vm.m_Sway.r:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, -0.1)

    ang:SetUnpacked(ang.p - p, ang.y + y, ang.r - r)

    local x = vm.m_Sway.x:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, -0.1)
    x = x - mw_math.SafeLerp(vm.m_AimDelta, r * 0.05, 0)

    local y = vm.m_Sway.y:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, -0.1)
    local z = vm.m_Sway.z:GetValue() * mw_math.SafeLerp(vm.m_AimDelta, 1, -0.1) 
    z = z - mw_math.SafeLerp(vm.m_AimDelta, r * 0.035, 0)

    pos:SetUnpacked(pos.x + x, pos.y + y, pos.z + z)
end

local defaultSprintAngle = Angle(0, 0, 25)
local defaultSprintPos = Vector(1, 0, -1)
local defaultVManipAngle = Angle(0, 2, -10)
local defaultVManipPos = Vector(1.5, 3, -1.5)
local defaultCrouchAngle = Angle(0, 0, -5)
local defaultCrouchPos = Vector(-1, -0.5, -1)
local defaultBipodAngle = Angle()
local defaultBipodPos = Vector(-1.5, 0, -1.5)

ENT.m_OffsetAng = {
    p = mw_math.CreateSpring(150, 0.75),
    ya = mw_math.CreateSpring(120, 1),
    r = mw_math.CreateSpring(100, 1.5)
}

ENT.m_OffsetPos = mw_math.CreateVectorSpring(150, 1.5)

local offsetsPos = Vector()
local offsetsAng = Angle()
local sprintAng = Angle()
local sprintPos = Vector()
local alternateAimPos = Vector()
local alternateAimAng = Angle()
local aimPos = Vector()
local aimAng = Angle()
local vManipAng = Angle()
local vManipPos = Vector()
local bipodAng = Angle()
local bipodPos = Vector()
local crouchAng = Angle()
local crouchPos = Vector()

local function offsets(vm, pos, ang)
    local w = vm:GetOwner()
    local p = w:GetOwner()

    offsetsPos:SetUnpacked(0, 0, 0)
    offsetsAng:SetUnpacked(0, 0, 0)

    --aim offsets
    aimPos:Set(w.ViewModelOffsets.Aim.Pos)
    aimAng:Set(w.ViewModelOffsets.Aim.Angles)

    if (w:GetSight() != nil) then
        aimPos:Add(w:GetSight().AimPos || mw_math.ZeroVector)
        aimAng:Add(w:GetSight().AimAng || mw_math.ZeroAngle)
    end

    aimPos:Mul(mw_math.btn(w:HasFlag("Aiming") && w:GetAimMode() == 0))
    aimAng:Mul(mw_math.btn(w:HasFlag("Aiming") && w:GetAimMode() == 0))
    
    offsetsPos:Add(aimPos)
    offsetsAng:Add(aimAng)

    --canted aim offsets
    alternateAimPos:Set(w.ViewModelOffsets.Aim.Pos)
    alternateAimAng:Set(w.ViewModelOffsets.Aim.Angles)

    if (w:GetSight() != nil && w:GetSight().ReticleHybrid != nil) then
        alternateAimPos:Add(w:GetSight().HybridAimPos || w.HybridAimPos || mw_math.ZeroVector)
        alternateAimAng:Add(w:GetSight().HybridAimAng || w.HybridAimAngles || mw_math.ZeroAngle)
    else
        if (w.LaserAimPos != nil && w.LaserAimAngles != nil && w:GetLaser() != nil) then
            alternateAimPos:Set(w.LaserAimPos)
            alternateAimAng:Set(w.LaserAimAngles)

            local reloadDelta = Lerp(mw_math.btn(CurTime() >= Lerp(0.5, w:GetNextMagTime(), w:GetNextReloadTime())), 0.5, 1)
            alternateAimAng:Mul(reloadDelta)
            alternateAimPos:Mul(reloadDelta)
        end
    end

    --alternateAimPos:Mul(vm.m_AimModeDelta)
    alternateAimPos:Mul(mw_math.btn(!(w.DisableCantedReload && w:HasFlag("Reloading")) && w:HasFlag("Aiming") && w:GetAimMode() > 0))
    
    --alternateAimAng:Mul(vm.m_AimModeDelta)
    alternateAimAng:Mul(mw_math.btn(!(w.DisableCantedReload && w:HasFlag("Reloading")) && w:HasFlag("Aiming") && w:GetAimMode() > 0))

    offsetsPos:Add(alternateAimPos)
    offsetsAng:Add(alternateAimAng)

    --sprinting
    sprintAng:Set(defaultSprintAngle)
    sprintPos:Set(defaultSprintPos)

    if (w.ViewModelOffsets.Sprint != nil) then
        sprintAng:Set(w.ViewModelOffsets.Sprint.Angles || sprintAng) 
        sprintPos:Set(w.ViewModelOffsets.Sprint.Pos || sprintPos) 
    end

    sprintPos:Mul(mw_math.btn(w:HasFlag("Sprinting")))
    sprintAng:Mul(mw_math.btn(w:HasFlag("Sprinting")))

    offsetsAng:Add(sprintAng)
    offsetsPos:Add(sprintPos)

    --idle
    local eyePitch = Lerp(mw_math.btn(w:HasFlag("Aiming")), p:EyeAngles().p / 90, 0)
    offsetsAng:Add(w.ViewModelOffsets.Idle.Angles * mw_math.btn(!w:HasFlag("Aiming")))
    offsetsAng.r = offsetsAng.r + (eyePitch * 5)

    offsetsPos:Add(w.ViewModelOffsets.Idle.Pos * mw_math.btn(!w:HasFlag("Aiming")))
    offsetsPos.y = offsetsPos.y + eyePitch
    offsetsPos.z = offsetsPos.z + (math.min(eyePitch, 0.5) * 5 * mw_math.btn(w:HasFlag("BipodDeployed")))

    --vmanip
    vManipAng:Set(defaultVManipAngle)
    vManipPos:Set(defaultVManipPos)

    if (w.ViewModelOffsets.VManip != nil) then
        vManipAng:Set(w.ViewModelOffsets.VManip.Angles || vManipAng)
        vManipPos:Set(w.ViewModelOffsets.VManip.Pos || vManipPos)
    end

    vManipPos:Mul(mw_math.btn(VManip != nil && !w:HasFlag("Aiming") && VManip:IsActive()))
    vManipAng:Mul(mw_math.btn(VManip != nil && !w:HasFlag("Aiming") && VManip:IsActive()))

    offsetsAng:Add(vManipAng)
    offsetsPos:Add(vManipPos)

    --bipod
    bipodAng:Set(defaultBipodAngle)
    bipodPos:Set(defaultBipodPos)

    if (w.ViewModelOffsets.Bipod != nil) then
        bipodAng:Set(w.ViewModelOffsets.Bipod.Angles || bipodAng)
        bipodPos:Set(w.ViewModelOffsets.Bipod.Pos || bipodPos)
    end

    bipodPos:Mul(mw_math.btn(w:HasFlag("BipodDeployed") && !w:HasFlag("Aiming")))
    bipodAng:Mul(mw_math.btn(w:HasFlag("BipodDeployed") && !w:HasFlag("Aiming")))

    offsetsAng:Add(bipodAng)
    offsetsPos:Add(bipodPos)

    --crouching
    crouchAng:Set(defaultCrouchAngle)
    crouchPos:Set(defaultCrouchPos)

    if (w.ViewModelOffsets.Crouch != nil) then
        crouchAng:Set(w.ViewModelOffsets.Crouch.Angles || crouchAng)
        crouchPos:Set(w.ViewModelOffsets.Crouch.Pos || crouchPos)
    end

    local crouchDelta = mw_math.btn(p:IsFlagSet(4) && !w:HasFlag("BipodDeployed") && !w:HasFlag("Aiming"))
    crouchPos:Mul(crouchDelta)
    crouchAng.p = crouchAng.p * crouchDelta
    crouchAng.y = crouchAng.y * crouchDelta
    crouchAng.r = Lerp(mw_math.btn(p:IsFlagSet(4) && !w:HasFlag("BipodDeployed")), 0, Lerp(mw_math.btn(w:HasFlag("Aiming")), crouchAng.r, crouchAng.r * 0.5))
        
    offsetsAng:Add(crouchAng)
    offsetsPos:Add(crouchPos)

    --final result
    vm.m_OffsetAng.p:SetTarget(offsetsAng.p)
    vm.m_OffsetAng.ya:SetTarget(offsetsAng.y)
    vm.m_OffsetAng.r:SetTarget(offsetsAng.r)
    
    vm.m_OffsetPos:SetTarget(offsetsPos)
    mw_math.DecaySprings(vm.m_OffsetAng.p, vm.m_OffsetAng.ya, vm.m_OffsetAng.r, vm.m_OffsetPos)

    local x, y, z = vm.m_OffsetPos:GetValue().x, vm.m_OffsetPos:GetValue().y, vm.m_OffsetPos:GetValue().z
    pos:SetUnpacked(pos.x + x, pos.y + y, pos.z + z)

    local pi, ya, r = vm.m_OffsetAng.p:GetValue(), vm.m_OffsetAng.ya:GetValue(), vm.m_OffsetAng.r:GetValue()
    ang:SetUnpacked(ang.p - pi, ang.y + ya, ang.r + r)
end

ENT.m_RecoilResetSpeed = 100
ENT.m_RecoilAngleTarget = Angle()
ENT.m_RecoilPosTarget = Vector()
ENT.m_RecoilShakeLerp = 0
ENT.m_RecoilRollLerp = 0
ENT.m_RecoilRoll = 0

local recoilFuncs = {
    [true] = function(w, name) return w.Recoil.ViewModel[name] || 1 end,
    [false] = function() return 1 end
}

local function getRecoilValue(w, name)
    return recoilFuncs[w.Recoil.ViewModel != nil](w, name)
end

ENT.m_RecoilAng = mw_math.CreateAngleSpring(80, 1)
ENT.m_RecoilPos = mw_math.CreateVectorSpring(40, 1)

function ENT:SetRecoilTargets(pos, ang)
    self.m_RecoilAngleTarget:Set(ang)
    self.m_RecoilPosTarget:Set(pos)
    self.m_RecoilResetSpeed = -1
end

local lerp = Lerp
local clamp = math.Clamp
local safeLerp = mw_math.SafeLerp
local realFrameTime = RealFrameTime
local approach = mw_math.Approach
local approachAngle = mw_math.ApproachAngle
local function recoil(vm, pos, ang)
    local w = vm:GetOwner()
    
    vm.m_RecoilShakeLerp = safeLerp(10 * realFrameTime(), vm.m_RecoilShakeLerp, w.Camera.Shake)
    vm.m_RecoilRoll = safeLerp(10 * realFrameTime(), vm.m_RecoilRoll, 0)
    vm.m_RecoilRollLerp = safeLerp(10 * realFrameTime(), vm.m_RecoilRollLerp, vm.m_RecoilRoll)

    vm.m_RecoilAng.sc = lerp(vm.m_AimDelta, 80, 240) * getRecoilValue(w, "SnapMultiplier") 
    vm.m_RecoilAng.wc = lerp(vm.m_AimDelta, 1.25, 0.85) / getRecoilValue(w, "LoosenessMultiplier") 
    vm.m_RecoilPos.sc = lerp(vm.m_AimDelta, 80, 120) * getRecoilValue(w, "SnapMultiplier") 
    vm.m_RecoilPos.wc = lerp(vm.m_AimDelta, 1, 1.2) / getRecoilValue(w, "LoosenessMultiplier") 

    vm.m_RecoilResetSpeed = safeLerp(10 * realFrameTime(), vm.m_RecoilResetSpeed, 1)
    local resetSpeed = clamp(vm.m_RecoilResetSpeed, 0, 1) * 100
    
    vm.m_RecoilAngleTarget.pitch = approachAngle(vm.m_RecoilAngleTarget.pitch, 0, resetSpeed * realFrameTime())
    vm.m_RecoilAngleTarget.yaw = approachAngle(vm.m_RecoilAngleTarget.yaw, 0, resetSpeed * realFrameTime())
    vm.m_RecoilAngleTarget.roll = approachAngle(vm.m_RecoilAngleTarget.roll, 0, resetSpeed * realFrameTime())

    vm.m_RecoilAng:SetTarget(vm.m_RecoilAngleTarget * 10)
    vm.m_RecoilAng:Decay()

    vm.m_RecoilPosTarget.x = approach(vm.m_RecoilPosTarget.x, 0, resetSpeed * realFrameTime())
    vm.m_RecoilPosTarget.y = approach(vm.m_RecoilPosTarget.y, 0, resetSpeed * realFrameTime())
    vm.m_RecoilPosTarget.z = approach(vm.m_RecoilPosTarget.z, 0, resetSpeed * realFrameTime())

    vm.m_RecoilPos:SetTarget(vm.m_RecoilPosTarget)
    vm.m_RecoilPos:Decay()
    
    local p = vm.m_RecoilAng:GetValue().p * lerp(vm.m_AimDelta, 1, 0.065)
    local ya = vm.m_RecoilAng:GetValue().y * lerp(vm.m_AimDelta, 1, 0.08)
    local r = vm.m_RecoilAng:GetValue().r * lerp(vm.m_AimDelta, 1, 0.1)

    ang.p = ang.p - p
    ang.y = ang.y - ya
    ang.r = ang.r + r + lerp(vm.m_AimDelta, 0, vm.m_RecoilRollLerp)

    local x = vm.m_RecoilPos:GetValue().x * lerp(vm.m_AimDelta, 1, 0.35)
    local y = vm.m_RecoilPos:GetValue().y * lerp(vm.m_AimDelta, 1, 0.35)
    local z = vm.m_RecoilPos:GetValue().z * lerp(vm.m_AimDelta, 1, 0.35) 

    pos.x = pos.x - x
    pos.y = pos.y - y - lerp(vm.m_AimDelta, 0, vm.m_RecoilShakeLerp * 1.5)
    pos.z = pos.z + z
end

function ENT:CalcViewModelView(pos, ang)
    if (game.SinglePlayer() && gui.IsGameUIVisible()) then
        return
    end
    
    local w = self:GetOwner()
    local lpos, lang = hook.Run("CalcViewModelView", w, self, pos, ang, Vector(pos), Angle(ang))
    
    pos:Set(lpos)
    ang:Set(lang) 

    local cPos, cAng = Vector(), Angle()

    self.m_AimDelta = mw_math.SafeLerp(18 * RealFrameTime(), self.m_AimDelta, w:GetAimDelta())
    self.m_AimModeDelta = mw_math.SafeLerp(18 * RealFrameTime(), self.m_AimModeDelta, w:GetAimModeDelta())
    
    movementInertia(self, cPos, cAng)
    sway(self, cPos, cAng, ang)
    recoil(self, cPos, cAng)

    cPos:Mul(mw_math.btn(1 / RealFrameTime() >= 14))
    cAng:Mul(mw_math.btn(1 / RealFrameTime() >= 14))

    ang:RotateAroundAxis(ang:Forward(), cAng.r)
    ang:RotateAroundAxis(ang:Right(), cAng.p)
    ang:RotateAroundAxis(ang:Up(), cAng.y)

    pos:Add(ang:Forward() * cPos.y)
    pos:Add(ang:Right() * cPos.x)
    pos:Add(ang:Up() * cPos.z)

    --we calculate offsets at the end so movements are aligned to original axis
    --regardless of offset
    cPos:SetUnpacked(0, 0, 0)
    cAng:SetUnpacked(0, 0, 0)
    offsets(self, cPos, cAng)

    ang:RotateAroundAxis(ang:Forward(), cAng.r)
    ang:RotateAroundAxis(ang:Right(), cAng.p)
    ang:RotateAroundAxis(ang:Up(), cAng.y)

    pos:Add(ang:Forward() * cPos.y)
    pos:Add(ang:Right() * cPos.x)
    pos:Add(ang:Up() * cPos.z)

    local originalFov = weapons.GetStored("mg_base").ViewModelFOV
    local hipFovMul = GetConVar("mgbase_fx_vmfov"):GetFloat()
    local adsFovMul = GetConVar("mgbase_fx_vmfov_ads"):GetFloat()

    if (w:GetSight() != nil && w:GetSight().Optic != nil) then
        adsFovMul = math.max(adsFovMul, Lerp(self.m_AimModeDelta, 1, adsFovMul))
    end

    w.ViewModelFOV = mw_math.SafeLerp(self.m_AimDelta, originalFov, originalFov * Lerp(self.m_AimModeDelta, w.Zoom.ViewModelFovMultiplier, 0.9))
    w.ViewModelFOV = w.ViewModelFOV * Lerp(self.m_AimDelta, hipFovMul, adsFovMul)

    if (GetViewEntity():IsPlayer()) then
        local curFov = GetViewEntity():GetFOV()
        w.ViewModelFOV = w.ViewModelFOV / Lerp(self.m_AimDelta, 1, (90 / curFov))
    end
end