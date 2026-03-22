
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- CONFIGURAÇÃO DO REMOTO
local ClaimReward = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
	:WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")
	:WaitForChild("Services"):WaitForChild("ChallengeService"):WaitForChild("RF")
	:WaitForChild("ClaimReward")

local rodando = false
_G.StopInfinity = false -- Trava de segurança global
local NOME_ARQUIVO = "infinity_vfinal_fix.json"

-- 1. KEYS (30 COM 2 USOS + 20 LIFETIME)
local KeysDuploUso = {
	"INFINITY98B7", "INFINITY22X1", "INFINITY44A3", "INFINITY09Z2", "INFINITY11L9",
	"INFINITY66K8", "INFINITY33M1", "INFINITY77P0", "INFINITY55R4", "INFINITY88Q5",
	"INFINITY12A1", "INFINITY13B2", "INFINITY14C3", "INFINITY15D4", "INFINITY16E5",
	"INFINITY17F6", "INFINITY18G7", "INFINITY19H8", "INFINITY20I9", "INFINITY21J0",
	"INFINITY22K1", "INFINITY23L2", "INFINITY24M3", "INFINITY25N4", "INFINITY26O5",
	"INFINITY27P6", "INFINITY28Q7", "INFINITY29R8", "INFINITY30S9", "INFINITY31T0"
}
local KeysLifetime = {
	"ALINE_ADMIN", "INFINITY_DEV", "VIP_ACCESS", "MASTER_KEY", "GOD_MODE",
	"LIFETIME_1", "LIFETIME_2", "LIFETIME_3", "LIFETIME_4", "LIFETIME_5",
	"LIFETIME_6", "LIFETIME_7", "LIFETIME_8", "LIFETIME_9", "LIFETIME_10",
	"GOLD_PASS", "PLATINUM_KEY", "ALINE_VIP", "DEV_PASS", "OWNER_ONLY"
}

local function listaParaTabela(lista)
	local t = {}
	for _, v in pairs(lista) do t[v] = true end
	return t
end
local ChavesUsoTab, ChavesLifeTab = listaParaTabela(KeysDuploUso), listaParaTabela(KeysLifetime)

-- 2. SAVE LOCAL
local function carregarDados()
	local sucesso, conteudo = pcall(function() return readfile(NOME_ARQUIVO) end)
	if sucesso then return HttpService:JSONDecode(conteudo) end
	return {usos = {}}
end
local function registrarUso(key)
	local dados = carregarDados()
	dados.usos[key] = (dados.usos[key] or 0) + 1
	pcall(function() writefile(NOME_ARQUIVO, HttpService:JSONEncode(dados)) end)
end

-- 3. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityMenuAline_Fix"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local function makeDraggable(gui)
	local dragging, dragStart, startPos
	gui.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = gui.Position end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
	gui.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 240); MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.new(1,1,1); MainFrame.BorderSizePixel = 0; MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
makeDraggable(MainFrame)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(230,230,230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))})
UIGradient.Rotation = 90; UIGradient.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45); Title.Text = "INFINITY MENU"; Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.BackgroundTransparency = 1; Title.Parent = MainFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 260, 0, 40); KeyBox.Position = UDim2.new(0, 20, 0, 55); KeyBox.PlaceholderText = "INSIRA SUA KEY..."
KeyBox.BackgroundColor3 = Color3.new(1,1,1); KeyBox.Font = Enum.Font.Gotham; KeyBox.Parent = MainFrame
Instance.new("UICorner", KeyBox)
local KeyStroke = Instance.new("UIStroke")
KeyStroke.Thickness = 2; KeyStroke.Color = Color3.fromRGB(200,200,200); KeyStroke.Parent = KeyBox

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 260, 0, 55); ToggleBtn.Position = UDim2.new(0, 20, 0, 115)
ToggleBtn.Text = "ATIVAR LUCKY"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100); ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.Visible = false; ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn)

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 40); Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.Text = "BY INFINITY"; Footer.TextColor3 = Color3.fromRGB(130,130,130); Footer.Font = Enum.Font.GothamBold; Footer.TextSize = 18; Footer.BackgroundTransparency = 1; Footer.Parent = MainFrame

-- 4. VALIDAÇÃO (APENAS MOSTRA O BOTÃO, NÃO ATIVA)
KeyBox:GetPropertyChangedSignal("Text"):Connect(function()
	local key = KeyBox.Text
	local dados = carregarDados()
	local usos = dados.usos[key] or 0
	
	if ChavesLifeTab[key] then
		KeyStroke.Color = Color3.fromRGB(0, 150, 255); ToggleBtn.Visible = true; Title.Text = "LIFETIME KEY"
	elseif ChavesUsoTab[key] and usos < 2 then
		KeyStroke.Color = Color3.fromRGB(0, 255, 100); ToggleBtn.Visible = true; Title.Text = "USOS: "..(2-usos)
	else
		KeyStroke.Color = Color3.fromRGB(255, 50, 50); ToggleBtn.Visible = false; Title.Text = "INFINITY MENU"
	end
end)

-- 5. LÓGICA DE ATIVAÇÃO / DESATIVAÇÃO REAL
ToggleBtn.MouseButton1Click:Connect(function()
	local keyAtual = KeyBox.Text
	
	if not rodando then
		rodando = true
		_G.StopInfinity = false
		ToggleBtn.Text = "DESATIVAR"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		
		if ChavesUsoTab[keyAtual] then registrarUso(keyAtual) end
		
		task.spawn(function()
			local i = 1
			while rodando and not _G.StopInfinity do
				for count = 1, 10 do -- Lotes menores para parar mais rápido
					if not rodando or _G.StopInfinity then break end
					task.spawn(function() pcall(function() ClaimReward:InvokeServer(i) end) end)
					i = i + 1
				end
				task.wait(0.02)
			end
		end)
	else
		rodando = false
		_G.StopInfinity = true
		ToggleBtn.Text = "ATIVAR LUCKY"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
	end
end)

-- 6. LOGO E FECHAR
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn)

local MiniIcon = Instance.new("ImageButton")
MiniIcon.Size = UDim2.new(0, 70, 0, 70); MiniIcon.Visible = false; MiniIcon.BackgroundColor3 = Color3.new(1,1,1)
MiniIcon.Image = "rbxassetid://101393892487031"; MiniIcon.ScaleType = Enum.ScaleType.Stretch; MiniIcon.Parent = ScreenGui
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(0, 15); makeDraggable(MiniIcon)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniIcon.Visible = true end)
MiniIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniIcon.Visible = false end)
