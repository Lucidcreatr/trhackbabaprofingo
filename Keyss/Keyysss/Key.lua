local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ⏳ Süre tanımı
local KEY_LIFETIME = 24 * 60 * 60 -- 1 gün (saniye cinsinden)

-- Key üretici
local charset = {} 
for i = 48, 57 do table.insert(charset, string.char(i)) end -- 0-9
for i = 65, 90 do table.insert(charset, string.char(i)) end -- A-Z

local function generateKey(length)
	local key = ""
	for i = 1, length do
		key = key .. charset[math.random(1, #charset)]
	end
	return key
end

-- 🔐 Key oluştur ve zamanla eşle
local generatedKey = generateKey(12)
local keyCreatedTime = os.time() -- Unix zaman damgası

-- Webhook
local webhookURL = "https://discord.com/api/webhooks/1384601700131672225/IYzkevmhlUMzCFk6WmuP6Zprv_P-hd8VEtWttv7DPowWiJ9gHtZGPFRLMBzc3JeW4thO"

local function sendWebhook(title, desc, color)
	local data = {
		content = "**Key Sistemi Bildirimi**",
		embeds = {{
			title = title,
			description = desc,
			color = color
		}}
	}
	HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data))
end

sendWebhook("🔑 Yeni Key Oluşturuldu", "Kullanıcı: **" .. player.Name .. "**\nKey: `" .. generatedKey .. "`\nGeçerlilik: 24 saat", 3447003)

-- GUI sistemi
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeySystem"
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local textbox = Instance.new("TextBox", frame)
textbox.Position = UDim2.new(0, 10, 0, 10)
textbox.Size = UDim2.new(1, -20, 0, 30)
textbox.PlaceholderText = "Key Gir..."
textbox.TextColor3 = Color3.new(1,1,1)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local button = Instance.new("TextButton", frame)
button.Position = UDim2.new(0, 10, 0, 50)
button.Size = UDim2.new(1, -20, 0, 30)
button.Text = "Doğrula"
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.TextColor3 = Color3.new(1, 1, 1)

button.MouseButton1Click:Connect(function()
	if textbox.Text == generatedKey then
		local now = os.time()
		if now - keyCreatedTime <= KEY_LIFETIME then
			button.Text = "✅ Key Doğru"
			gui:Destroy()

			sendWebhook("✅ Key Doğrulandı", "Kullanıcı: **" .. player.Name .. "**\nKey: `" .. textbox.Text .. "`", 3066993)

			-- 📥 Hile kodunu dışardan çekip çalıştır
			local success, result = pcall(function()
				return loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucidcreatr/fpsdefusa/refs/heads/main/Scripts/merhaba2.lua"))()
			end)

			if not success then
				warn("Hile scripti yüklenemedi: " .. tostring(result))
			end
		else
			button.Text = "⏰ Key Süresi Doldu"
			sendWebhook("❌ Key Süresi Doldu", "Kullanıcı: **" .. player.Name .. "**\nKey: `" .. textbox.Text .. "`\nDURUM: Süresi dolmuş", 15158332)
		end
	else
		button.Text = "❌ Hatalı Key"
	end
end)
