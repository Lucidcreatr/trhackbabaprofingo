-- ⚙️ HİZMETLER
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- 📅 KEY SÜRESİ (1 GÜN)
local KEY_LIFETIME = 24 * 60 * 60
local keyCreatedTime = os.time()

-- 🔐 KEY ÜRETİCİ
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

local generatedKey = generateKey(12)

-- 🧪 TEST EKRANINA YAZ
print("KEY:", generatedKey)

-- 🌐 WEBHOOK
local webhookURL = "https://discord.com/api/webhooks/1384625088644776077/5cmgcEis2RcIr3W5bD9U0712tkCwjRECM6uAM2uOPK8tl4a_HlLTC1-Tr6E90WZVR2YI"

local function sendWebhook(title, desc, color)
	local success, err = pcall(function()
		HttpService:PostAsync(
			webhookURL,
			HttpService:JSONEncode({
				content = "**Key Sistemi Bildirimi**",
				embeds = {{
					title = title,
					description = desc,
					color = color
				}}
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)
	if not success then warn("Webhook hatası:", err) end
end

sendWebhook("🔑 Yeni Key Oluşturuldu", "Kullanıcı: **" .. player.Name .. "**\nKey: `" .. generatedKey .. "`\nGeçerlilik: 24 saat", 3447003)

-- 📺 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KeySystem"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Parent = gui

local textbox = Instance.new("TextBox")
textbox.PlaceholderText = "Key Giriniz..."
textbox.Size = UDim2.new(1, -20, 0, 40)
textbox.Position = UDim2.new(0, 10, 0, 20)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textbox.Parent = frame

local button = Instance.new("TextButton")
button.Text = "Doğrula"
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 0, 70)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = frame

-- ✅ BUTON FONKSİYONU
button.MouseButton1Click:Connect(function()
	local key = textbox.Text
	if key == generatedKey then
		if os.time() - keyCreatedTime <= KEY_LIFETIME then
			button.Text = "✅ Doğru"
			gui:Destroy()
			sendWebhook("✅ Key Doğrulandı", "Kullanıcı: **" .. player.Name .. "**\nKey: `" .. key .. "`", 3066993)

			-- 📥 Hileyi çek ve çalıştır
			local success, result = pcall(function()
				return loadstring(game:HttpGet("https://github.com/Lucidcreatr/fpsdefusa/blob/main/Scripts/merhaba2.lua"))()
			end)
			if not success then warn("Hile yüklenemedi:", result) end
		else
			button.Text = "⏰ Süre Doldu"
			sendWebhook("❌ Key Süresi Doldu", "Kullanıcı: **" .. player.Name .. "**", 15158332)
		end
	else
		button.Text = "❌ Hatalı Key"
	end
end)
