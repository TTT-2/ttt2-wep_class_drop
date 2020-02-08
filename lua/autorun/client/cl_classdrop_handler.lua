-- target ID
hook.Add("TTTRenderEntityInfo", "ttt2_class_drop_render_entity_info", function(data, params)
	local client = LocalPlayer()

	if data.distance > 100 or data.ent:GetClass() ~= "tttc_classdrop" then return end
	if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end

	local hd = CLASS.GetClassDataByIndex(data.ent:GetNWInt("customClass"))
	local pName = hd and CLASS.GetClassTranslation(hd) or ""

	params.drawInfo = true
	params.displayInfo.key = input.GetKeyCode(input.LookupBinding("+use"))
	params.displayInfo.title.text = LANG.GetParamTranslation("ttt_class_title", {class = pName})
	params.displayInfo.subtitle.text = LANG.GetParamTranslation("ttt_pickup_class", {usekey = Key("+use", "USE")})

	-- add class description to targetID if provided
	if hd and hd.lang and hd.lang.desc then
		desc_wrapped = draw.GetWrappedText(LANG.TryTranslation("tttc_class_" .. hd.name .. "_desc"), 400, "TargetID_Description")

		for i = 1, #desc_wrapped do
			params.displayInfo.desc[#params.displayInfo.desc + 1] = {
				text = tostring(desc_wrapped[i]), color = COLOR_WHITE
			}
		end
	end

	params.drawOutline = true
	params.outlineColor = client:GetRoleColor()
end)

hook.Add("Initialize", "ttt2_classdrop_init_lang", function()
	LANG.AddToLanguage("English", "ttt_class_title", "Class: {class}")
	LANG.AddToLanguage("Deutsch", "ttt_class_title", "Klasse: {class}")

	LANG.AddToLanguage("English", "ttt_pickup_class", "Press [{usekey}] to pickup class")
	LANG.AddToLanguage("Deutsch", "ttt_pickup_class", "Drücke [{usekey}] um Klasse aufzuheben")

	LANG.AddToLanguage("English", "ttt_drop_class_help", "{primaryfire} drops the class")
	LANG.AddToLanguage("Deutsch", "ttt_drop_class_help", "{primaryfire} um die Klasse wegzuwerfen")
end)
