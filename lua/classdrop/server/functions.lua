if SERVER then
    function DropCustomClass(ply)
        if GetRoundState() ~= ROUND_ACTIVE then return end

        if not IsValid(ply) or not ply:IsPlayer() or not ply:HasCustomClass() then return end

        if ply:HasWeapon("weapon_ttt_classdrop") then
            ply:GetWeapon("weapon_ttt_classdrop").OldOwner = nil
        
            ply:StripWeapon("weapon_ttt_classdrop")
        end
        
        local drop = ents.Create("tttc_classdrop")
            
        if not IsValid(drop) then return end

        drop:SetNWInt("customClass", ply:GetCustomClass())
        
        local oldClassCooldownTS = ply:GetClassCooldownTS()
        local oldClassCooldown = ply:GetClassCooldown()
        ply:UpdateClass(nil)
        
        ply:SetClassCooldownTS(oldClassCooldownTS)
        ply:SetClassCooldown(oldClassCooldown)

        if(oldClassCooldown and oldClassCooldownTS) then
            net.Start("TTTCSetClassCooldownTS")
            net.WriteFloat(oldClassCooldownTS)
            net.WriteFloat(oldClassCooldown)
            net.Send(ply)
        end
        
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
end
