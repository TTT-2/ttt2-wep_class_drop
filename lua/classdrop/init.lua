-- server
include("classdrop/server/functions.lua")

DROPCLASSENTS = {}
    
hook.Add("TTTCDropClass", "TTTCClassDropAddon", function(ply)
    DropCustomClass(ply)
end)

-- todo blocks slot?
hook.Add("TTTCPreReceiveCustomClasses", "TTTCClassDropAddonPost", function()
    for _, ply in pairs(player.GetAll()) do
        if not ply:HasWeapon("weapon_ttt_classdrop") then
            ply:Give("weapon_ttt_classdrop")
        end
    end
end)

hook.Add("TTTCPostReceiveCustomClasses", "TTTCClassDropAddonPost", function()
    for _, ply in pairs(player.GetAll()) do
        if not ply:HasWeapon("weapon_ttt_classdrop") then
            ply:Give("weapon_ttt_classdrop")
        end
    end
end)

hook.Add("TTTPrepareRound", "TTTCDropClassPrepare", function()
    for _, e in pairs(DROPCLASSENTS) do
        SafeRemoveEntity(e)
    end
    
    DROPCLASSENTS = {}
end)

hook.Add("TTTEndRound", "TTTCDropClassPrepare", function()
    for _, v in pairs(player.GetAll()) do
        if v:HasWeapon("weapon_ttt_classdrop") then 
            v:StripWeapon("weapon_ttt_classdrop")
        end
    end

    for _, e in pairs(DROPCLASSENTS) do
        SafeRemoveEntity(e)
    end
    
    DROPCLASSENTS = {}
end)

hook.Add("PlayerCanPickupWeapon", "TTTCPickupClassDropper", function(ply, wep)
    if ply:HasCustomClass() then
        local wepClass = wep:GetClass()
    
        if wepClass == "weapon_ttt_classdrop" and not ply:HasWeapon("weapon_ttt_classdrop") then
            return true
        end
    end
end)

--[[
hook.Add("PlayerDeath", "TTTCDropClassDeath", function(victim, inflictor, attacker)
    if victim:HasWeapon("weapon_ttt_classdrop") then
        DropCustomClass(victim)
    end
end)
]]--
