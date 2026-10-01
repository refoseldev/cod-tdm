local sdeltaTime = sdeltaTime or 0 
local SysTime = SysTime
local FrameTime = FrameTime
local start_delta_time = 0
local is_second_tick = false

hook.Add('Tick', 'sFixedDeltaTime', function()
    if is_second_tick then
        sdeltaTime = SysTime() - start_delta_time
    else
        start_delta_time = SysTime()
    end
    is_second_tick = not is_second_tick
end)

local function magnitude(vec)
    local magnitude = vec
    magnitude = magnitude.x ^ 2 + magnitude.y ^ 2 + magnitude.z ^ 2
    magnitude = math.sqrt(magnitude)
    return magnitude
end

local function MoveTowardsVector(current_vector, target_vector, delta_time)
    local direction_vector = target_vector - current_vector
    local magnitude = magnitude(direction_vector)
    if magnitude <= delta_time or magnitude == 0 then
        return target_vector
    end
    return current_vector + direction_vector / magnitude * delta_time
end

local rndhooks = {}
net.Receive("COD.TakedownCam", function()
    local cam1 = net.ReadBool()
    local float = net.ReadFloat()
    local toplayer = net.ReadBool()
    local rnd = math.random(1,999999999)
    table.insert(rndhooks, "TakedownCam"..rnd)

    if true then
        local ply = LocalPlayer()

        local delta = sdeltaTime
        local deltanum = 2
        local deltamult = 16

        local ang_fix = ply:GetAngles()
        local forwardplus = ang_fix:Forward()*math.Rand(32,64)
        local rightplus = ang_fix:Right()*math.Rand(32,64)
        local upplus = Vector(0,0,math.Rand(16,32))

        if math.random(1,2) == 2 then
            forwardplus = ply:GetForward()*math.Rand(-64,-32)
        end
        if math.random(1,2) == 2 then
            rightplus = ply:GetRight()*math.Rand(-64,-32)
        end

        local endpos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))+forwardplus+rightplus+upplus
        local curpos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))

        local angle1 = Angle(0,0,0)

        local dist = 0
        local drawv = true
        local tohead = false

        timer.Simple(float/2, function()
            deltamult = 0
        end)
        
        if toplayer then
            timer.Simple(float, function()
                tohead = true
                deltamult = 128
            end)
        end

        if cam1 then
            hook.Add("CalcView", "TakedownCam"..rnd, function( ply, pos, angles, fov )
                curpos = MoveTowardsVector(curpos, endpos, delta*deltanum)
                angle1 = (ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))-curpos):GetNormalized():Angle()
                dist = curpos:Distance(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")))
                if tohead then
                    endpos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
                end
                if deltamult > 0 then
                    deltanum = deltanum+FrameTime()*deltamult
                end
                if dist < 8 and tohead then
                    drawv = false
                    angle1 = ply:EyeAngles()
                else
                    drawv = true
                end
                local view = {
                    angles = angle1,
                    origin = curpos,
                    fov = fov,
                    drawviewer = drawv,
                    nearz = 16,
                }
            
                if ply:Alive() then
                    COD.HideHUD = true
                    return view
                end
            end)
            timer.Simple(float+0.7, function()
                hook.Remove("CalcView", "TakedownCam"..rnd)
                table.RemoveByValue(rndhooks, "TakedownCam"..rnd)
                COD.HideHUD = false
            end)
        else
            for _, v in pairs(rndhooks) do
                hook.Remove("CalcView", v)
                table.RemoveByValue(rndhooks, v)
            end
            COD.HideHUD = false
        end
    end
end)

hook.Add("CalcMainActivity", "!TDMAnims", function(ply, vel)
    local str = ply:GetNWString('SVAnim')
    local num = ply:GetNWFloat('SVAnimDelay')
    local st = ply:GetNWFloat('SVAnimStartTime')
    if str != "" then
        ply:SetCycle((CurTime()-st)/num)
        return -1, ply:LookupSequence(str)
    end
end)