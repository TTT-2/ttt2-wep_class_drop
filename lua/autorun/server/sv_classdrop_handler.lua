util.AddNetworkString("TTTCSetClassCooldownTS")

function DropCustomClass(ply)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	if not IsValid(ply) or not ply:IsPlayer() or not ply:HasCustomClass() then return end

	--return if class is dropped on death (0 hp) and keeping class on respawn is enabled
	if ply:Health() <= 0 and GetGlobalBool("ttt_classes_keep_on_respawn") or ply:GetClassData().activeDuringDeath then return end

	if ply:HasWeapon("weapon_ttt_classdrop") then
		ply:GetWeapon("weapon_ttt_classdrop").OldOwner = nil

		ply:StripWeapon("weapon_ttt_classdrop")
	end

	local drop = ents.Create("tttc_classdrop")

	if not IsValid(drop) then return end

	drop:SetNWInt("customClass", ply:GetCustomClass())
	drop:SavePlayerClassInfo(ply)

	ply:UpdateClass(nil)

	hook.Run("TTTCCustomClassDrop", ply, drop)

	local vsrc = ply:GetShootPos()
	local vang = ply:GetAimVector()
	local vvel = ply:GetVelocity()

	local vthrow = vvel + vang * 100

	drop:SetPos(vsrc + vang * 10)
	drop:Spawn()
	drop:Activate()

	table.insert(DROPCLASSENTS, drop)

	drop:PhysWake()

	local phys = drop:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetVelocity(vthrow)
	end

	ply:SetAnimation(PLAYER_ATTACK1)
end
