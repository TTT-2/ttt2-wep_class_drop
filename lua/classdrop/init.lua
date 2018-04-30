-- server
DROPCLASSENTS = {}
    
hook.Add("TTTCDropClass", "TTTCClassDropAddon", function(ply)
    if ply:HasWeapon("weapon_ttt_classdrop") then 
        ply:StripWeapon("weapon_ttt_classdrop")
    end

    if not IsValid(ply) then return end
    
    local drop = ents.Create("tttc_classdrop")
        
    if not IsValid(drop) then return end

    drop:SetNWInt("customClass", ply:GetCustomClass())
    drop.classWeapons = table.Copy(ply.classWeapons or {})
    drop.classEquipment = table.Copy(ply.classEquipment or {})
    
    local vsrc = ply:GetShootPos()
    local vang = ply:GetAimVector()
    local vvel = ply:GetVelocity()

    local vthrow = vvel + vang * 100
    
    drop:SetPos(vsrc + vang * 10)
    drop:Spawn()

    drop:PhysWake()

    table.insert(DROPCLASSENTS, drop)

    local phys = drop:GetPhysicsObject()

    if IsValid(phys) then
        phys:SetVelocity(vthrow)
    end

    ply:SetAnimation(PLAYER_ATTACK1)
end)

hook.Add("TTT2_PostReceiveCustomClass", "TTTCClassDropAddon", function(ply)
    ply:Give("weapon_ttt_classdrop")
end)

hook.Add("TTTPrepareRound", "TTTCDropClassPrepare", function()
    for _, v in pairs(player.GetAll()) do
        v.classWeapons = {}
        v.classEquipment = {}
    end

    for _, e in pairs(DROPCLASSENTS) do
        e:Remove()
    end
    
    DROPCLASSENTS = {}
end)
