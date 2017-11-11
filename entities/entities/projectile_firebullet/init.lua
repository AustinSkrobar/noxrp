AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.BulletBounceTimes = 0
ENT.MaximumBounces = 0
ENT.BulletHitEffect = "hit_bullet_fire"
ENT.BulletHitEffectBlocked = "hit_bullet_blocked"
ENT.BulletDamageType = DMG_BURN

ENT.PiercingPower = 3
ENT.BulletPiercingTimes = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModel(self.BulletModel)
	self:PhysicsInitSphere(1)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetModelScale(1.5, 0)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then 
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0.00001)
		phys:Wake()
	end

	self.Damage = self.Damage or 10
	self.Speed = self.Speed or 3000
	self.BulletDamageType = self.BulletDamageType or DMG_BURN

	self.DeathTime = self.DeathTime or CurTime() + 30

	self.LastPosition = self.LastPosition or self:GetPos()

	-- I cache this because it would be rediculous to do it dynamically.
	local owner = self:GetOwner()
	if owner:IsValid() and owner:IsPlayer() then
		self.BulletFilter = owner:GetAttackFilter()
	end
	
	self:SetColor(Color(255, 200, 0))

	self:NextThink(CurTime())
end

function ENT:Hit(tr, prehit)
	local shouldremove = true

	if tr.HitWorld and self.BulletBounceTimes < self.MaximumBounces and not prehit then
		local Dot = tr.HitNormal:Dot(tr.Normal * -1)
		if Dot <= 0.25 then
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				shouldremove = false
				bounce = (2 * Dot * tr.HitNormal + tr.Normal)
				self.BulletBounceTimes = self.BulletBounceTimes + 1
				sound.Play("weapons/fx/rics/ric"..math.random(1, 5)..".wav", tr.HitPos, 76, math.random(100, 110))
				self.LastPosition = tr.HitPos + tr.HitNormal * 0.5
				phys:SetPos(self.LastPosition)
				phys:SetVelocityInstantaneous(bounce * self.Speed)
			end
		end
	end
	
	if self:OnHit(tr, prehit) then return true end

	local hitent = tr.Entity
	if hitent:IsValid() then
		local ret = hitent.OnHitWithBullet and hitent:OnHitWithBullet(self, tr, prehit)
		if ret == 1 then
			shouldremove = false
		end

		if not ret or ret == 2 then
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
			else
				TEMPBULLET = self
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(self.Damage)
				dmginfo:SetAttacker(self:GetOwner())
				if self.Inflictor and self.Inflictor:IsValid() then
					dmginfo:SetInflictor(self.Inflictor)
				end
				dmginfo:SetDamageType(self.BulletDamageType)
				dmginfo:SetDamageForce(self.Damage * 500 * tr.Normal)
				if hitent:IsPlayer() then
					gamemode.Call("ScalePlayerDamage", hitent, tr.HitGroup, dmginfo, true, true)
					hitent:EmitSound("Flesh.BulletImpact")
				elseif hitent:IsNPC() then
					gamemode.Call("ScaleNPCDamage", hitent, tr.HitGroup, dmginfo)
					hitent:EmitSound("Flesh.BulletImpact")
				end

				if self.AlterDamageInfo then
					self:AlterDamageInfo(dmginfo, tr, prehit)
				end
				
				hitent:TakeDamageInfo(dmginfo)

				for _, ent in pairs(ents.FindInSphere(tr.HitPos, 80)) do
					if ent ~= hitent then
						local scale = ent:GetPos():Distance(tr.HitPos) / 80
						scale = 1 - scale
						dmginfo:SetDamage(self.Damage * scale)	
						
						ent:TakeDamageInfo(dmginfo)
					end
				end
				
				TEMPBULLET = nil

				local phys = hitent:GetPhysicsObject()
				if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					hitent:SetPhysicsAttacker(self:GetOwner())
				end

				if self.PostDoDamage then
					self:PostDoDamage(hitent, dmginfo, tr, prehit, bounce)
				end
			end
		end
	else
		local dmginfo = DamageInfo()
		dmginfo:SetDamagePosition(tr.HitPos)
		dmginfo:SetDamage(self.Damage)
		dmginfo:SetAttacker(self:GetOwner())
		if self.Inflictor and self.Inflictor:IsValid() then
			dmginfo:SetInflictor(self.Inflictor)
		end
		dmginfo:SetDamageType(self.BulletDamageType)
		dmginfo:SetDamageForce(self.Damage * 500 * tr.Normal)

		if self.AlterDamageInfo then
			self:AlterDamageInfo(dmginfo, tr, prehit)
		end
				
		for _, ent in pairs(ents.FindInSphere(tr.HitPos, 40)) do
			local scale = ent:GetPos():Distance(tr.HitPos) / 40
			scale = 1 - scale
			dmginfo:SetDamage(self.Damage * scale)	
						
			ent:TakeDamageInfo(dmginfo)
		end
	end

	if self.BulletHitEffect and not tr.HitSky then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			local owner = self:GetOwner()
			effectdata:SetScale(owner:IsValid() and owner:IsPlayer() and owner:Team() or 0)
			effectdata:SetMagnitude(self.Damage)
		util.Effect(self.BulletHitEffect, effectdata, true, true)
	end

	if shouldremove then
		self.DeathTime = 0
		self.HitTrace = tr
		self:FakeBullet(self.LastPosition, (tr.HitPos - self.LastPosition):GetNormalized())
		self:Remove()
	else
		self:NextThink(CurTime())
	end

	return true
end
