local HttpService = game:GetService("HttpService")
local webhookURL = "https://discord.com/api/webhooks/1384601700131672225/IYzkevmhlUMzCFk6WmuP6Zprv_P-hd8VEtWttv7DPowWiJ9gHtZGPFRLMBzc3JeW4thO"

local player = game:GetService("Players").LocalPlayer

local data = {
	content = "Yeni key alımı",
	embeds = {{
		title = "🔑 Key Denemesi",
		description = "Kullanıcı: **" .. player.Name .. "**\nKey: `TEST123ABC456`",
		color = 65280
	}}
}

local success, err = pcall(function()
	HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data))
end)

if not success then
	warn("Webhook gönderilemedi:", err)
else
	print("Webhook gönderildi")
end
