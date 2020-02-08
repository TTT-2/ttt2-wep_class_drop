-- tttc_classdrop
if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "tttc_classdrop"
ENT.Instructions = "Drops a custom class!"
ENT.Spawnable = true
ENT.Author = "Alf21"
ENT.Purpose = "For TTTC"

ENT.CanUseKey = true

function ENT:Initialize()
	self:SetHealth(50)

	self.canexplode = false

	self:SetModel("models/items/boxmrounds.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetMass(50)
	end
end

if SERVER then
	function ENT:SavePlayerClassInfo(ply)
		local cd = CLASS.GetClassDataByIndex(self:GetNWInt("customClass"))
		
		self.amount = ply.classAmount
		self.cooldownTS = ply.classCooldownTS
		self.cooldown = ply.classCooldown

		self.passiveWeapons = {}
		if cd.passiveWeapons then
			for _, cls in ipairs(cd.passiveWeapons) do
				if ply:HasWeapon(cls) then
					local wep = ply:GetWeapon(cls)
					self.passiveWeapons[cls] = {clip1 = wep:Clip1(), clip2 = wep:Clip2()}
				end
			end
		end
	end

	function ENT:ApplySavedClassInfo(ply)
		local cd = CLASS.GetClassDataByIndex(self:GetNWInt("customClass"))
		
		ply.classAmount = self.amount
		ply.classCooldownTS = self.cooldownTS
		ply.classCooldown = self.cooldown

		if cd.passiveWeapons then
			for _, cls in ipairs(cd.passiveWeapons) do
				if ply:HasWeapon(cls) then
					local info = self.passiveWeapons[cls]
					if info then
						local wep = ply:GetWeapon(cls)
						wep:SetClip1(info.clip1 or 0)
						wep:SetClip2(info.clip2 or 0)
					else
						ply:StripWeapon(cls)
					end
				end
			end
		end

		ply:SyncClassState()
	end

	function ENT:TakeClass(ply)
		if GetRoundState() ~= ROUND_ACTIVE then return end

		if not ply or not IsValid(ply) or not ply:IsPlayer() or not ply:IsActive() or ply:HasWeapon("weapon_ttt_classdrop") then return end

		if hook.Run("TTTCClassDropNotPickupable", ply) then return end

		-- should never happen
		if ply:HasClass() then
			ply:UpdateClass(nil)
		end

		ply:UpdateClass(self:GetNWInt("customClass"))	
		self:ApplySavedClassInfo(ply) 

		for k, v in ipairs(DROPCLASSENTS) do
			if v == self then
				SafeRemoveEntity(self)

				table.remove(DROPCLASSENTS, k)

				break
			end
		end
	end

	function ENT:UseOverride(activator)
		if IsValid(activator) and activator:IsPlayer() and activator:IsActive() then
			self:TakeClass(activator)
		end
	end

	function ENT:OnTakeDamage(damage)
		dmg = self:Health() - damage:GetDamage()

		self:SetHealth(dmg)

		if self:Health() <= 0 then
			self:Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		if not IsValid(self) or hook.Run("TTTCClassDropDraw", self) == true then return end

		local cd = CLASS.GetClassDataByIndex(self:GetNWInt("customClass"))
		local pName = cd and CLASS.GetClassTranslation(cd) or ""

		self:DrawModel()

		local pos = self:GetPos() + Vector(0, 0, 20)
		local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)

		surface.SetFont("Default")

		local width = surface.GetTextSize(pName) + 55

		cam.Start3D2D(pos, ang, 0.3)

		draw.RoundedBox(5, -width / 2 , -30, width, 15, Color(10, 90, 140, 100))
		draw.SimpleText(pName, "ChatFont", 0, -30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end
end

scripted_ents.Register(ENT, "tttc_classdrop", true)
