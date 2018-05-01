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
   
   SWEP.Slot = 12
   
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
    
    self.OldOwner = self.Weapon:GetOwner()
    
    if SERVER then
        self.OldOwner:DropWeapon(self)
    end
end

function SWEP:Equip(NewOwner)
    self.OldOwner = NewOwner
end

function SWEP:OnDrop()
    if SERVER and GetRoundState() == ROUND_ACTIVE then
        DropCustomClass(self.OldOwner)
    end

    SafeRemoveEntity(self)
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
