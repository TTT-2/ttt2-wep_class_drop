-- tttc_classdrop
AddCSLuaFile()

local ENT = {}
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "tttc_classdrop"
ENT.Instructions = "Drops a custom class!"
ENT.Spawnable = true
ENT.Author = "Alf21"
ENT.Purpose = "For TTTC"

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box003b_gib01.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    if SERVER then 
        self:PhysicsInit(SOLID_VPHYSICS) 
    end

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
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
            for _, v in pairs(self.classWeapons) do
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
        
        for k, v in pairs(DROPCLASSENTS) do
            if v == self then
                table.remove(DROPCLASSENTS, k)
                
                SafeRemoveEntity(self)
            end
        end
    end

    function ENT:Use(activator)
        if IsValid(activator) and activator:IsPlayer() and activator:IsActive() then
            self:TakeClass(activator)
        end
    end
end
    
if CLIENT then
    local GetLang

    function ENT:Draw()
        if IsValid(self) then
            GetLang = GetLang or LANG.GetUnsafeLanguageTable
            
            local L = GetLang()
        
            self:DrawModel()
            
            local pos = self:GetPos() + Vector(0, 0, 20)
            local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
            
            surface.SetFont("Default")
            
            local txt = L[GetClassByIndex(self:GetNWInt("customClass")).name]
            local width = surface.GetTextSize(txt) + 55

            cam.Start3D2D(pos, ang, 0.3)

            draw.RoundedBox(5, -width / 2 , -30, width, 15, Color(10, 90, 140, 100))
            draw.SimpleText(txt, "ChatFont", 0, -30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            
            cam.End3D2D()
        end
    end
end
scripted_ents.Register(ENT, "tttc_classdrop", true)
