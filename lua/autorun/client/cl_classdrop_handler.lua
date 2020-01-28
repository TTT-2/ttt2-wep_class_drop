net.Receive("TTTCSetClassCooldownTS", function()
	local client = LocalPlayer()

	client:SetClassCooldownTS(net.ReadFloat())
	client:SetClassCooldown(net.ReadFloat())
end)
