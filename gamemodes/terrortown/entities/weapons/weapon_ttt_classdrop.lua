-- class drop
AddCSLuaFile()

SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.AdminSpawnable = true

SWEP.HoldType = "normal"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

if CLIENT then
   SWEP.PrintName = "ClassDropper"	
   SWEP.Author = "Alf21"
   
   SWEP.Slot = 6
   
   SWEP.ViewModelFOV = 10
   
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Throw your class away."
   }
   
   SWEP.Icon = "vgui/ttt/icon_xmas_present"
end

SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.NoSights = true

-- some other stuff
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.Kind = WEAPON_EQUIP
SWEP.WeaponID = AMMO_DROPCLASS

-- view / world
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_office/microwave.mdl"

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    
    self:ClassDrop()
end

-- mostly replicating HL2DM slam throw here
function SWEP:ClassDrop()
    if SERVER then
        local ply = self.Owner

        if not IsValid(ply) then return end

        local drop = ents.Create("tttc_classdrop")
        
        if not IsValid(drop) then return end

        drop:SetNWInt("customClass", ply:GetCustomClass())
        drop.classWeapons = table.Copy(ply.classWeapons or {})
        drop.classEquipment = table.Copy(ply.classEquipment or {})
        
        ply:ResetCustomClass()
        
        local vsrc = ply:GetShootPos()
        local vang = ply:GetAimVector()
        local vvel = ply:GetVelocity()

        local vthrow = vvel + vang * 100
        
        drop:SetPos(vsrc + vang * 10)
        drop:Spawn()
        
        table.insert(DROPCLASSENTS, drop)

        drop:PhysWake()

        local phys = drop:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetVelocity(vthrow)
        end

        ply:SetAnimation(PLAYER_ATTACK1)
    end

    self:Remove()
end

function SWEP:Reload()
   return false
end

function SWEP:ShouldDropOnDie()
    return false
end

function SWEP:DrawWorldModel()
    return false
end
