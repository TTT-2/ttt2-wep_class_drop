if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("classdrop/cl_init.lua")

    -- include main file
	include("classdrop/init.lua")
else
    -- include main file
	include("classdrop/cl_init.lua")
end
