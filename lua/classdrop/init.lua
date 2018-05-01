-- server
include("classdrop/server/functions.lua")

util.AddNetworkString("TTT2_SendCustomClass")

DROPCLASSENTS = {}
    
hook.Add("TTTCDropClass", "TTTCClassDropAddon", function(ply)
    DropCustomClass(ply)
end)

-- todo blocks slot?
hook.Add("TTT2_PreReceiveCustomClass", "TTTCClassDropAddonPost", function(ply)
    if not ply:HasWeapon("weapon_ttt_classdrop") then
        ply:Give("weapon_ttt_classdrop")
    end
end)

hook.Add("TTT2_PostReceiveCustomClass", "TTTCClassDropAddonPost", function(ply)
    if not ply:HasWeapon("weapon_ttt_classdrop") then
        ply:Give("weapon_ttt_classdrop")
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

--[[
hook.Add("PlayerDeath", "TTTCDropClassDeath", function(victim, inflictor, attacker)
    if victim:HasWeapon("weapon_ttt_classdrop") then
        DropCustomClass(victim)
    end
end)
]]--
