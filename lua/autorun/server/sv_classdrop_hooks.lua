DROPCLASSENTS = {}

hook.Add("TTTCDropClass", "TTTCClassDropAddon", function(ply)
	DropCustomClass(ply)
end)

hook.Add("TTTCUpdateClass", "TTTCClassDropAddonPost", function(ply, old, new)
	if ply:HasWeapon("weapon_ttt_classdrop") or not new then return end

	ply:Give("weapon_ttt_classdrop")
end)

hook.Add("TTTCPlayerRespawnedWithClass", "TTTCGiveClassDropperOnSpawn", function(ply)
	if ply:HasWeapon("weapon_ttt_classdrop") then return end

	ply:Give("weapon_ttt_classdrop")
end)

hook.Add("TTTPrepareRound", "TTTCDropClassPrepare", function()
	for _, e in ipairs(DROPCLASSENTS) do
		SafeRemoveEntity(e)
	end

	DROPCLASSENTS = {}
end)

hook.Add("TTTEndRound", "TTTCDropClassPrepare", function()
	for _, v in pairs(player.GetAll()) do
		if not v:HasWeapon("weapon_ttt_classdrop") then continue end

		v:StripWeapon("weapon_ttt_classdrop")
	end

	for _, e in ipairs(DROPCLASSENTS) do
		SafeRemoveEntity(e)
	end

	DROPCLASSENTS = {}
end)

hook.Add("PlayerCanPickupWeapon", "TTTCPickupClassDropper", function(ply, wep)
	if not ply:HasCustomClass() then return end

	local wepClass = wep:GetClass()

	if wepClass ~= "weapon_ttt_classdrop" or ply:HasWeapon(wepClass) then return end

	return true
end)
