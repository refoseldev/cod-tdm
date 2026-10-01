AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



--[[---------------------------------------------------------
	Name: KeyValue
	Desc: Called when a keyvalue is added to us
-----------------------------------------------------------]]
function ENT:KeyValue( key, value )
end

--[[---------------------------------------------------------
	Name: OnRestore
	Desc: The game has just been reloaded. This is usually the right place
		to call the GetNW* functions to restore the script's values.
-----------------------------------------------------------]]
function ENT:OnRestore()
end

--[[---------------------------------------------------------
	Name: AcceptInput
	Desc: Accepts input, return true to override/accept input
-----------------------------------------------------------]]
function ENT:AcceptInput( name, activator, caller, data )
	return false
end

--[[---------------------------------------------------------
	Name: UpdateTransmitState
	Desc: Set the transmit state
-----------------------------------------------------------]]
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

--[[---------------------------------------------------------
	Name: Think
	Desc: Entity's think function.
-----------------------------------------------------------]]
function ENT:Think()
end

function ENT:PhysicsCollide(colData, collider)
	if (self.m_Water && self:GetVelocity():Length() < 250) then
		timer.Simple(0, function()
			self:Remove()
		end)

		return
	end

	local bHasExploded = false

	for i, e in pairs(ents.FindInSphere(self:GetPos(), 16)) do
		if (e:IsNPC()) then
			self:Explode({
				HitEntity = e, 
				HitNormal = (e:NearestPoint(self:GetPos()) - self:GetPos()):GetNormalized(), 
				HitPos = e:NearestPoint(self:GetPos())
			})

			if (e:GetClass() == "npc_strider") then
				e:Fire("Explode")
			end

			bHasExploded = true
		end
	end

	if (!bHasExploded) then
		self:Explode(colData)
	end
end

-- function ENT:PhysicsUpdate(phys)
-- 	if (self:WaterLevel() > 0) then
-- 		self.m_Water = true
-- 	end

-- 	if (self.m_Water) then
-- 		phys:EnableDrag(true)
-- 		phys:EnableGravity(true)
-- 		return
-- 	end

-- 	self.m_Fuel = self.m_Fuel - 100 * FrameTime()
-- 	self.m_Stability = self.m_Stability + 700 * FrameTime()
	
-- 	if (self.m_Propel && self.m_Fuel <= 0) then
-- 		self.m_Propel = false
-- 		phys:EnableDrag(true)
-- 		phys:EnableGravity(true)
-- 	end
	
-- 	if (self.m_Propel) then
-- 		phys:AddVelocity(phys:GetAngles():Forward() * self.Projectile.Speed)
-- 		self.m_gravity = self.m_gravity + (self.Projectile.Gravity)

-- 		phys:SetPos(self.LastPos + phys:GetAngles():Forward() * (self.Projectile.Speed * FrameTime()) - (Vector(0, 0, self.m_gravity) * FrameTime()))
-- 	end

-- 	local vel = phys:GetVelocity()
-- 	phys:SetAngles(vel:Angle() + Angle(self.Projectile.Gravity,math.Rand(self.m_Stability / -self.Projectile.Stability, self.m_Stability / self.Projectile.Stability),self.m_gravity))
-- 	phys:SetVelocity(vel)




-- 	if (self:WaterLevel() > 0) then
-- 		self.m_Propel = false
-- 	end

-- 	for i, e in pairs(ents.FindInSphere(phys:GetPos(), 16)) do
-- 		if (e:IsNPC()) then
-- 			self:Explode({
-- 				HitEntity = e, 
-- 				HitNormal = (e:NearestPoint(phys:GetPos()) - phys:GetPos()):GetNormalized(), 
-- 				HitPos = e:NearestPoint(phys:GetPos())
-- 			})

-- 			if (e:GetClass() == "npc_strider") then
-- 				e:Fire("Explode")
-- 			end
-- 		end
-- 	end
-- end

function ENT:PhysicsUpdate(phys)

		self.Target:SetPos(phys:GetPos())

		self.m_Fuel = self.m_Fuel - 100 * FrameTime()
		self.m_Stability = self.m_Stability + 700 * FrameTime()
		
		if (self.m_Propel && self.m_Fuel <= 0) then
			self.m_Propel = false
			phys:EnableDrag(true)
			phys:EnableGravity(true)
			phys:AddVelocity(phys:GetAngles():Forward() * self.Projectile.Speed)
		end
		
		if (self.m_Propel) then

			phys:SetPos(self.LastPos + phys:GetAngles():Forward() * (self.Projectile.Speed * FrameTime()) - (Vector(0, 0, self.m_gravity) * FrameTime()))

			if (self.m_Tracking && self.TrackedEntity:IsValid()) then
				local dir = self.TrackedEntity:WorldSpaceCenter() - phys:GetPos()
				phys:SetAngles(LerpAngle(self.Projectile.TrackingFraction, phys:GetAngles(), dir:Angle()))
			elseif self.Projectile.Stability != 0 then
				phys:SetAngles(phys:GetAngles() + Angle(0,math.Rand(self.m_Stability / -self.Projectile.Stability, self.m_Stability / self.Projectile.Stability),0))
			end

		else 
			local vel = phys:GetVelocity()
			phys:SetAngles(vel:Angle() + Angle(self.Projectile.Gravity,math.Rand(self.m_Stability / -self.Projectile.Stability, self.m_Stability / self.Projectile.Stability),self.m_gravity))
			phys:SetVelocity(vel)
		end

	if (!self.bCollided) then
		--Aim assist
		if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
			debugoverlay.Box(phys:GetPos(), -self.Maxs, self.Maxs, 0, Color(0, 200, 50, 10))
		end

		local trData = {
			start = self.LastPos,
			endpos = phys:GetPos(),
			filter = {self:GetOwner(), self},
			mask = MASK_SHOT_PORTAL,
			collisiongroup = COLLISION_GROUP_NONE,
			mins = -self:OBBMaxs(),
			maxs = self:OBBMins()
		}

		local tr = util.TraceHull(trData)

		if (tr.Hit && (tr.Entity:IsPlayer() || tr.Entity:IsNPC())) then
			self:SetPos(tr.HitPos)
			self:Impact(tr,phys,true)
			self:ImpactDamage(tr.Entity)
			self:Explode(tr)
			return
		end

		--Normal hitscan
		if (GetConVar("mgbase_debug_projectiles"):GetInt() > 0) then
			debugoverlay.Line(self.LastPos, phys:GetPos(), 1, Color(255, 0, 0, 1))
		end
		
		tr = util.TraceLine(trData)

		if (tr.Hit) then
			if tr.Entity:GetClass() == "func_breakable_surf" then 
				--shatter glass windows and other weak surfaces
				util.BlastDamage(self, self, tr.HitPos, 1, 1)
			else
				self:SetPos(tr.HitPos)
				self:Impact(tr,phys,false)
				self:ImpactDamage(tr.Entity)
				self:Explode(tr) 
				return
			end
		end
	end

	self.LastPos = phys:GetPos()
end

function ENT:Explode(trData)

	local phys = self:GetPhysicsObject()
	if (self:WaterLevel() <= 0) then
		if self.WeaponData.Explosive.BlastRadius >= 200 then
			ParticleEffect("Generic_explo_vhigh", phys:GetPos() + trData.HitNormal,Angle(0,0,0)) 
		else
			ParticleEffect("Generic_explo_high", phys:GetPos() + trData.HitNormal,Angle(0,0,0)) 
		end
	else
		local effectdata = EffectData()
		effectdata:SetOrigin(phys:GetPos())
		util.Effect("WaterSurfaceExplosion", effectdata)
	end

	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(self.WeaponData.Bullet.Damage[1])
	dmgInfo:SetAttacker(IsValid(self:GetOwner()) && self:GetOwner() || self)
	dmgInfo:SetInflictor(self)
	dmgInfo:SetDamageType(self:GetDamageType())
	util.BlastDamageInfo(dmgInfo, phys:GetPos(), self.WeaponData.Explosive.BlastRadius)

	util.ScreenShake(phys:GetPos(), 3500, 1111, 1, self.WeaponData.Explosive.BlastRadius * 4)

	util.Decal("Scorch", trData.HitPos - trData.HitNormal, trData.HitPos + trData.HitNormal, self)

	for i, e in pairs(ents.FindInSphere(self:GetPos(), 32)) do
		if (e:GetClass() == "npc_strider") then
			e:Fire("Explode")
		end 
	end

	self:Remove()
end

function ENT:ImpactDamage(ent) 
	-- local dmgInfo = DamageInfo()
	-- dmgInfo:SetDamage(self.WeaponData.Bullet.Damage[1] / self.WeaponData.Explosive.ImpactBlastRatio)
	-- dmgInfo:SetAttacker(IsValid(self:GetOwner()) && self:GetOwner() || self)
	-- dmgInfo:SetInflictor(self)
	-- dmgInfo:SetDamageType(self:GetDamageType())
	-- dmgInfo:SetDamagePosition(self:GetPos())
	-- ent:TakeDamageInfo(dmgInfo)
end

function ENT:GetDamageType() 
	return DMG_BLAST + DMG_AIRBOAT
end

function ENT:Impact(tr, phys, bHull) 
	if (IsValid(self.Weapon)) then
		self:FireBullets({
			Attacker = self:GetOwner(),
			Num = 1,
			Tracer = 0,
			Src = self.LastPos,
			Dir = (phys:GetPos() - self.LastPos):GetNormalized(),
			HullSize = bHull && 2 || 1,
			IgnoreEntity = self,
			Callback = function(attacker, tr, dmgInfo)
				dmgInfo:SetInflictor(self.Weapon)
				dmgInfo:SetDamageType(DMG_DIRECT + self:GetDamageType())
				self.Weapon:BulletCallback(attacker, tr, dmgInfo)
			end
		})
	end
end