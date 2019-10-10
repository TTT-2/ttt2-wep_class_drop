-- server
include("classdrop/server/functions.lua")

DROPCLASSENTS = {}
    
hook.Add("TTTCDropClass", "TTTCClassDropAddon", function(ply)
    DropCustomClass(ply)
end)

hook.Add("TTTCUpdateClass", "TTTCClassDropAddonPost", function(ply, old, new)
    if not ply:HasWeapon("weapon_ttt_classdrop") and not ply.got_classdropper then
        ply:Give("weapon_ttt_classdrop")
        ply.got_classdropper = true
    end
end)

hook.Add("TTTPrepareRound", "TTTCDropClassPrepare", function()
    for _, e in ipairs(DROPCLASSENTS) do
        SafeRemoveEntity(e)
    end
    
    DROPCLASSENTS = {}

    for _, ply in ipairs(player.GetAll()) do
        ply.got_classdropper = false
    end
end)

hook.Add("TTTBeginRound", "TTTCDropClassBegin", function()
    for _, ply in ipairs(player.GetAll()) do
        ply.got_classdropper = false
    end    
end)

hook.Add("TTTEndRound", "TTTCDropClassPrepare", function()
    for _, v in pairs(player.GetAll()) do
        if v:HasWeapon("weapon_ttt_classdrop") then 
            v:StripWeapon("weapon_ttt_classdrop")
        end
    end

    for _, e in ipairs(DROPCLASSENTS) do
        SafeRemoveEntity(e)
    end
    
    DROPCLASSENTS = {}
    
    for _, ply in ipairs(player.GetAll()) do
        ply.got_classdropper = false
    end
end)

hook.Add("PlayerCanPickupWeapon", "TTTCPickupClassDropper", function(ply, wep)
    if ply:HasCustomClass() then
        local wepClass = wep:GetClass()
    
        if wepClass == "weapon_ttt_classdrop" and not ply:HasWeapon(wepClass) then
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
