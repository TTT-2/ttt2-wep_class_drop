-- tttc_classdrop
if SERVER then
    AddCSLuaFile()
end

local ENT = {}
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "tttc_classdrop"
ENT.Instructions = "Drops a custom class!"
ENT.Spawnable = true
ENT.Author = "Alf21"
ENT.Purpose = "For TTTC"

function ENT:Initialize()
	self:SetHealth(50)
    
	self.canexplode = false
    
    self:SetModel("models/items/boxmrounds.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetMass(50)
	end
end

if SERVER then
    function ENT:TakeClass(ply)
        if GetRoundState() ~= ROUND_ACTIVE then return end
        
        if not ply or not IsValid(ply) or not ply:IsPlayer() or not ply:IsActive() or ply:HasWeapon("weapon_ttt_classdrop") then return end

        if hook.Run("TTTCClassDropNotPickupable", ply) then return end
        
        -- should never happen
        if ply:HasCustomClass() then
            ply:ResetCustomClass()
        end

        ply:UpdateCustomClass(self:GetNWInt("customClass"))
        
        if self.classWeapons then
            for _, v in ipairs(self.classWeapons) do
                if v then
                    ply:GiveServerClassWeapon(v.class, v.clip1, v.clip2)
                end
            end
        end
        
        ply:Give("weapon_ttt_classdrop")
        
        --[[
        if self.classItems then
            for _, id in pairs(self.classItems) do
                if id then
                    ply:GiveServerClassItem(id)
                end
            end
        end
        ]]--
        
        for k, v in ipairs(DROPCLASSENTS) do
            if v == self then
                SafeRemoveEntity(self)
				
                table.remove(DROPCLASSENTS, k)
				
				break
            end
        end
    end

    function ENT:Use(activator)
        if IsValid(activator) and activator:IsPlayer() and activator:IsActive() then
            self:TakeClass(activator)
        end
    end
    
    function ENT:OnTakeDamage(damage)
        dmg = self:Health() - damage:GetDamage()

        self:SetHealth(dmg)

        if self:Health() <= 0 then
            --[[
            local pos = self:GetPos()
            local effect = EffectData()

            effect:SetStart(pos)
            effect:SetOrigin(pos)
            
            util.Effect("cball_explode", effect, true, true)
            ]]--
               
            self:Remove()
        end
    end
else
    function ENT:Draw()
        if IsValid(self) then
            if not hook.Run("TTTCClassDropDraw", self) then
                local cd = GetClassByIndex(self:GetNWInt("customClass"))
                local pName = GetClassTranslation(cd)
            
                self:DrawModel()
                
                local pos = self:GetPos() + Vector(0, 0, 20)
                local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
                
                surface.SetFont("Default")
                
                local width = surface.GetTextSize(pName) + 55

                cam.Start3D2D(pos, ang, 0.3)

                draw.RoundedBox(5, -width / 2 , -30, width, 15, Color(10, 90, 140, 100))
                draw.SimpleText(pName, "ChatFont", 0, -30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                
                cam.End3D2D()
            end
        end
    end
end
scripted_ents.Register(ENT, "tttc_classdrop", true)
