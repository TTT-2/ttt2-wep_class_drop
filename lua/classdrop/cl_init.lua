-- client
net.Receive("TTTCSetClassCooldownTS", function()
        local oldCooldownTS = net.ReadFloat()
        local oldCooldown = net.ReadFloat()

        LocalPlayer():SetClassCooldownTS(oldCooldownTS)
        LocalPlayer():SetClassCooldown(oldCooldown)
end)