if SERVER then
    function DropCustomClass(ply)
        if GetRoundState() ~= ROUND_ACTIVE then return end

        if not IsValid(ply) then return end

        if ply:HasWeapon("weapon_ttt_classdrop") then
            ply:GetWeapon("weapon_ttt_classdrop").OldOwner = nil
        
            ply:StripWeapon("weapon_ttt_classdrop")
        end
        
        local drop = ents.Create("tttc_classdrop")
            
        if not IsValid(drop) then return end
        
        drop:SetModel("models/props_junk/cardboard_box003b_gib01.mdl")

        drop:SetNWInt("customClass", ply:GetCustomClass())
        
        local tbl = {}
        
        if ply.classWeapons then
            for _, wep in pairs(ply.classWeapons) do
                local v = ply:GetWeapon(wep)
                
                if v and IsValid(v) then
                    table.insert(tbl, {
                        class = v:GetClass(),
                        clip1 = v:Clip1(),
                        clip2 = v:Clip2()
                    })
                end
            end
            
            drop.classWeapons = tbl
        end
        
        --drop.classItems = table.Copy(ply.classItems)
        --drop.classItems.__index = drop.classItems
        
        ply.oldClass = ply:GetCustomClass()
        
        ply:ResetCustomClass()
        
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
end
