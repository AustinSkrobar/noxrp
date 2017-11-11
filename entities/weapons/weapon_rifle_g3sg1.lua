SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'G3SG1' Rifle"
	SWEP.PrintName2 = "Semi-Auto Rifle"

	SWEP.CSMuzzleFlashes = true

	SWEP.Font = "csKillIcons"
	SWEP.Icon = "i"

	SWEP.PosX = 0
	SWEP.PosY = 20

	SWEP.HUDPosX = 0
	SWEP.HUDPosY = 15

	SWEP.BoneDeltaAngles = {Up = 0, Right = 180, Forward = 180, MU = -12, MR = 3, MF = -8, Scale = 1}

	SWEP.SprintAngles = Angle(-10, 0, 40)
	SWEP.SprintVector = Vector(5, 0, 0)

	--SWEP.HolsterAngle = Angle(-15, 0, 40)
	--SWEP.HolsterVector = Vector(10, 0, 1)

	SWEP.Ammo3DBone = "v_weapon.g3sg1_Parent"
	--SWEP.Ammo3DPos = Vector(-0.72, -5.8, -10)
	SWEP.Ammo3DPos = Vector(-0.7, -5.8, 0)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.015
end

SWEP.m_WeaponDeploySpeed = 0.3

SWEP.Item = "rifle_g3sg1"
SWEP.AmmoItem = "ammobox_smg"

SWEP.Slot = 6
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.ShootSound = Sound("Weapon_G3SG1.Single")
SWEP.ReloadSound = Sound("Weapon_G3SG1.Reload")

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 1

SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 1

SWEP.HoldType = "ar2"
SWEP.HolsterTime = 1

SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Skill = SKILL_RIFLES

SWEP.NextZoom = 0

function SWEP:SetZoomed(level)
	self:SetDTInt(2, level)
end

function SWEP:GetZoomLevel()
	return self:GetDTInt(2)
end

function SWEP:GetZoomed()
	return self:GetDTInt(2) > 0
end

function SWEP:SecondaryAttack()
	if self:GetHolstered() then return end
	self.NextZoom = self.NextZoom or CurTime()
	if CurTime() < self.NextZoom then return end
	self.NextZoom = CurTime() + 0.5

	local zoomed = self:GetZoomLevel()
	if zoomed == 0 then
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.2, 0.4)
		end
		self:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)

		self:SetZoomed(1)
	else
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.3)
		end
		self:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)

		self:SetZoomed(0)
	end
end

function SWEP:Holster()
	if CLIENT then
		if self.Owner.LoadoutEffect then
			self.Owner.LoadoutEffect:WeaponHolster(self)
		end
		if self:GetZoomed() then
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		end
	else
		if self:GetZoomed() then
			self:SetZoomed(0)
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.4)
		end
	end
	return true
end

function SWEP:OnReload()
	if self.Owner:IsKnockedDown() then return end
	if self:GetZoomed() then
		self:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)

		if SERVER then
			self:SetZoomed(0)
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.3)
		end
	end

	return false
end


if CLIENT then
	function SWEP:DrawHUD()
		local zoomed = self:GetZoomed()
		if zoomed then
			self:DrawZoomCursor()
		else
			self:DrawCursor()
		end
	end

	function SWEP:PreDrawViewModel(vm)
		if self.ShowViewModel == false or self:GetZoomed() then
			render.SetBlend(0)
		end
	end

	function SWEP:PostDrawViewModel(vm)
		if self.ShowViewModel == false or self:GetZoomed() then
			render.SetBlend(1)
		end


		local pos, ang = self:GetAmmo3DPos(vm)

		if pos then
			self:Draw3DAmmo(vm, pos, ang)
		end
	end

	local texScope = surface.GetTextureID("gui/gradient", "smooth")
	function SWEP:DrawZoomCursor()
		local scrw, scrh = ScrW(), ScrH()

		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(0, scrh * 0.5 - 5, scrw * 0.35, 10)
		surface.DrawRect(ScrW() * 0.65, scrh * 0.5 - 5, scrw * 0.35, 10)
		surface.DrawRect(ScrW() * 0.35, scrh * 0.5 - 2, scrw * 0.3, 4)

		surface.DrawRect(scrw * 0.5 - 5, 0, 10, scrh * 0.35)
		surface.DrawRect(scrw * 0.5 - 5, scrh * 0.65, 10, scrh * 0.35)
		surface.DrawRect(scrw * 0.5 - 2, scrh * 0.35, 4, scrh * 0.3)

		surface.SetTexture(texScope)
		surface.SetDrawColor(10, 10, 10, 255)
		surface.DrawTexturedRect(0, 0, ScrW() * 0.5, ScrH())
		surface.DrawTexturedRectRotated(ScrW() * 0.5, ScrH() * 0.75, ScrH() * 0.5, ScrW(), 90)
		surface.DrawTexturedRectRotated(ScrW() * 0.5, ScrH() * 0.25, ScrH() * 0.5, ScrW(), -90)
		surface.DrawTexturedRectRotated(ScrW() * 0.75 + 2, ScrH() * 0.5, ScrW() * 0.5, ScrH(), 180)

		local tr = LocalPlayer():GetEyeTrace()

		local dist = tr.HitPos:Distance(LocalPlayer():GetShootPos())

		if dist >= 4000 then
			dist = "---"
		else
			dist = tostring(math.Round(dist))
		end

	--	draw.SimpleText("Distance: "..dist, "hidden18", ScrW() - 10, ScrH() * 0.5, Color(200, 255, 200, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	function SWEP:PostDrawViewModel(vm)
		if self.ShowViewModel == false then
			render.SetBlend(1)
		end

		if self:GetZoomed() then return end
		local pos, ang = self:GetAmmo3DPos(vm)

		if self.Modifications then
			for _, mod in pairs(self.Modifications) do
				local gitem = ITEMS[mod.Name]
				if gitem.DrawViewModelEffects then
					gitem:DrawViewModelEffects(self, vm)
				end
			end
		end

		if pos then
			self:Draw3DAmmo(vm, pos, ang)
		end
	end

	function SWEP:DrawWorldModel()
		--[[if not self:GetHolstered() then
			self:DrawModel()
			self:Cons_DrawWorldModel()
		end]]

		self:Cons_DrawWorldModel()

		--[[if self:GetZoomed() then
			local pos2 = self.Owner:GetShootPos()
			local ang2 = self.Owner:GetAimVector()

			local trace = {}
			trace.start = pos2
			trace.endpos = pos2 + (ang2 * 9999)
			trace.filter = self.Owner
			trace.mask = MASK_SOLID_BRUSHONLY
			local tr = util.TraceLine(trace)
		end]]
	end
end