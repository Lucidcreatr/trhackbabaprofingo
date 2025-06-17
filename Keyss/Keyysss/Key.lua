-- ⚙️ Hizmetler
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔐 Sabit Key
local doğruKey = "LUCID123"

-- 🌐 Webhook URL'ni buraya yaz
local webhookURL = "https://discord.com/api/webhooks/1384625088644776077/5cmgcEis2RcIr3W5bD9U0712tkCwjRECM6uAM2uOPK8tl4a_HlLTC1-Tr6E90WZVR2YI"

-- 📤 Webhook gönderme fonksiyonu
local function sendWebhook(title, desc, color)
	local data = {
		content = "**Lucid Key Sistemi**",
		embeds = {{
			title = title,
			description = desc,
			color = color
		}}
	}

	local success, response = pcall(function()
		HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn("Webhook başarısız:", response)
	end
end

-- 🖥️ GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔑 Lucid Key Doğrulama"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.new(1, 1, 1)

local textbox = Instance.new("TextBox", frame)
textbox.Size = UDim2.new(0.9, 0, 0, 30)
textbox.Position = UDim2.new(0.05, 0, 0.4, 0)
textbox.PlaceholderText = "Key giriniz..."
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 30)
button.Position = UDim2.new(0.05, 0, 0.7, 0)
button.Text = "Doğrula"
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.TextColor3 = Color3.new(1, 1, 1)

-- 🧠 Key kontrol
button.MouseButton1Click:Connect(function()
	if textbox.Text == doğruKey then
		button.Text = "✅ Key Doğru"
		sendWebhook("✅ Doğrulama Başarılı", "Kullanıcı: **" .. player.Name .. "**\nKey: `" .. textbox.Text .. "`", 65280)
		wait(1)
		gui:Destroy()
		-- Hileyi buraya ekle
		print("Hile aktif")
	else
		button.Text = "❌ Hatalı Key"
		sendWebhook("❌ Hatalı Key", "Kullanıcı: **" .. player.Name .. "**\nGirdiği Key: `" .. textbox.Text .. "`", 16711680)
	end
end)

button.Parent = frame
textbox.Parent = frame
