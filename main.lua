local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- CONFIGURAÇÃO DO REMOTO
local ClaimReward = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
	:WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")
	:WaitForChild("Services"):WaitForChild("ChallengeService"):WaitForChild("RF")
	:WaitForChild("ClaimReward")

local rodando = false
local speedAtivo = false
local flyAtivo = false
local invisivelAtivo = false
local NOME_ARQUIVO = "infinity_premium_v13.json"

-- 1. SISTEMA DE KEYS (LISTA COMPLETA ATUALIZADA)
local KeysDuploUso = {
    -- Originais
    "INFINITY98B7", "INFINITY22X1", "INFINITY44A3", "INFINITY09Z2", "INFINITY11L9", "INFINITY66K8", "INFINITY33M1", "INFINITY77P0", "INFINITY55R4", "INFINITY88Q5", "INFINITY12A1", "INFINITY13B2", "INFINITY14C3", "INFINITY15D4", "INFINITY16E5", "INFINITY17F6", "INFINITY18G7", "INFINITY19H8", "INFINITY20I9", "INFINITY21J0", "INFINITY22K1", "INFINITY23L2", "INFINITY24M3", "INFINITY25N4", "INFINITY26O5", "INFINITY27P6", "INFINITY28Q7", "INFINITY29R8", "INFINITY30S9", "INFINITY31T0",
    -- Novas 20 Keys
    "INFINITY44K2", "INFINITY55L3", "INFINITY66M4", "INFINITY77N5", "INFINITY88O6", "INFINITY99P7", "INFINITY00Q8", "INFINITY11R9", "INFINITY22S1", "INFINITY33T2", "INFINITY44U3", "INFINITY55V4", "INFINITY66W5", "INFINITY77X6", "INFINITY88Y7", "INFINITY99Z8", "INFINITY10A2", "INFINITY20B3", "INFINITY30C4", "INFINITY40D5"
}

local KeysLifetime = {
    -- Originais
    "ALINE_ADMIN", "INFINITY_DEV", "VIP_ACCESS", "MASTER_KEY", "GOD_MODE", "LIFETIME_1", "LIFETIME_2", "LIFETIME_3", "LIFETIME_4", "LIFETIME_5", "LIFETIME_6", "LIFETIME_7", "LIFETIME_8", "LIFETIME_9", "LIFETIME_10", "GOLD_PASS", "PLATINUM_KEY", "ALINE_VIP", "DEV_PASS", "OWNER_ONLY",
    -- Novas 20 Keys
    "INFINITY_QUEEN", "ALINE_POWER", "SUPREME_USER", "ULTIMATE_KEY", "ADMIN_ACCESS", "INFINITY_BOSS", "LEGENDARY_PASS", "INFINITY_KING", "GOD_VERSION", "VIP_EXCLUSIVE", "OWNER_PASS", "ALINE_INFINITY", "MASTER_INFINITY", "PREMIUM_GUEST", "DEVTALENT_KEY", "INFINITY_2026", "GLOBAL_ACCESS", "INFINITY_ELITE", "BEYOND_LIMITS", "ALINE_PRIVATE"
}

local function listaParaTabela(lista)
	local t = {}
	for _, v in pairs(lista) do t[v] = true end
	return t
end
local ChavesUsoTab, ChavesLifeTab = listaParaTabela(KeysDuploUso), listaParaTabela(KeysLifetime)

-- 2. BANCO DE DADOS (HWID LOCK)
local function carregarDados()
	local sucesso, conteudo = pcall(function() return readfile(NOME_ARQUIVO) end)
	if sucesso then return HttpService:JSONDecode(conteudo) end
	return {usos = {}, vinculos = {}}
end

local function registrarUsoEVinculo(key)
	local dados = carregarDados()
	if not dados.vinculos[key] then dados.vinculos[key] = Player.UserId end
	dados.usos[key] = (dados.usos[key] or 0) + 1
	pcall(function() writefile(NOME_ARQUIVO, HttpService:JSONEncode(dados)) end)
end

-- 3. INTERFACE (TABLET WIDESCREEN)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityV13_KeysUpdate"
ScreenGui.ResetOnSpawn = false; ScreenGui.Parent = PlayerGui

local function makeDraggable(gui)
	local dragging, dragStart, startPos
	gui.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = gui.Position end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
	gui.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 360); MainFrame.Position = UDim2.new(0.5, -300, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1); MainFrame.BorderSizePixel = 0; MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
makeDraggable(MainFrame)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
UIGradient.Rotation = 90; UIGradient.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = "INFINITY STORE - LOGIN"; Title.Font = Enum.Font.GothamBold
Title.TextSize = 24; Title.BackgroundTransparency = 1; Title.Parent = MainFrame

-- LOGIN UI
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 450, 0, 50); KeyBox.Position = UDim2.new(0.5, -225, 0, 100)
KeyBox.PlaceholderText = "COLE SUA KEY..."; KeyBox.TextSize = 18; KeyBox.BackgroundColor3 = Color3.new(1,1,1); KeyBox.Parent = MainFrame
Instance.new("UICorner", KeyBox)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0, 450, 0, 60); VerifyBtn.Position = UDim2.new(0.5, -225, 0, 170)
VerifyBtn.Text = "VERIFICAR KEY"; VerifyBtn.Font = Enum.Font.GothamBold; VerifyBtn.TextSize = 20
VerifyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); VerifyBtn.TextColor3 = Color3.new(1, 1, 1); VerifyBtn.Parent = MainFrame
Instance.new("UICorner", VerifyBtn)

-- ÁREA DE FUNÇÕES
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(0, 520, 0, 250); ActionFrame.Position = UDim2.new(0.5, -260, 0, 75)
ActionFrame.BackgroundTransparency = 1; ActionFrame.Visible = false; ActionFrame.Parent = MainFrame
Instance.new("UIListLayout", ActionFrame).Padding = UDim.new(0, 8)

local function criarOpcao(texto, ordem)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundTransparency = 1; Frame.LayoutOrder = ordem; Frame.Parent = ActionFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.75, 0, 1, 0); Label.Text = texto .. " [ OFF ]"; Label.Font = Enum.Font.GothamBold
    Label.TextSize = 19; Label.TextColor3 = Color3.fromRGB(50, 50, 50); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.BackgroundTransparency = 1; Label.Parent = Frame
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 65, 0, 32); Btn.Position = UDim2.new(0.85, 0, 0.15, 0)
    Btn.Text = ""; Btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180); Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 50)
    return Label, Btn
end

local SpinLabel, SpinBtn = criarOpcao("LUCKY SPINS (NO DELAY)", 1)
local FlyLabel, FlyBtn = criarOpcao("FLY HACK (80 SPD)", 2)
local SpeedLabel, SpeedBtn = criarOpcao("SPEED HACK (3X)", 3)
local InvisLabel, InvisBtn = criarOpcao("MODO INVISÍVEL", 4)

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 40); Footer.Position = UDim2.new(0, 0, 1, -45)
Footer.Text = "BY INFINITY"; Footer.Font = Enum.Font.GothamBold; Footer.TextSize = 20
Footer.TextColor3 = Color3.fromRGB(120, 120, 120); Footer.BackgroundTransparency = 1; Footer.Parent = MainFrame

-- LÓGICA VERIFICAÇÃO
VerifyBtn.MouseButton1Click:Connect(function()
	local key = KeyBox.Text
	local dados = carregarDados()
	local validada = false
	
	if ChavesLifeTab[key] then
		validada = true
	elseif ChavesUsoTab[key] then
		local usos = dados.usos[key] or 0
		local dono = dados.vinculos[key]
		if (not dono or dono == Player.UserId) and usos < 2 then
			validada = true
		end
	end
	
	if validada then
		KeyBox.Visible = false; VerifyBtn.Visible = false; ActionFrame.Visible = true; Title.Text = "INFINITY STORE"
	else
		Title.Text = "KEY INVÁLIDA OU ESGOTADA!"
	end
end)

-- FUNÇÃO LUCKY SPINS
SpinBtn.MouseButton1Click:Connect(function()
	if not rodando then
		rodando = true; SpinBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80); SpinLabel.Text = "LUCKY SPINS [ ON ]"
		if ChavesUsoTab[KeyBox.Text] then registrarUsoEVinculo(KeyBox.Text) end
		task.spawn(function()
			local i = 1
			while rodando do
				for _ = 1, 20 do
					if not rodando then break end
					task.spawn(function() pcall(function() ClaimReward:InvokeServer(i) end) end)
					i = i + 1
				end
				RunService.RenderStepped:Wait() 
			end
			SpinBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 180); SpinLabel.Text = "LUCKY SPINS [ OFF ]"
		end)
	else rodando = false end
end)

-- FUNÇÃO SPEED
SpeedBtn.MouseButton1Click:Connect(function()
    speedAtivo = not speedAtivo
    SpeedBtn.BackgroundColor3 = speedAtivo and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(180, 180, 180)
    SpeedLabel.Text = speedAtivo and "SPEED HACK [ ON ]" or "SPEED HACK [ OFF ]"
    task.spawn(function()
        while speedAtivo do
            local hum = (Player.Character or Player.CharacterAdded:Wait()):FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 48 end; RunService.RenderStepped:Wait()
        end
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = 16 end
    end)
end)

-- FUNÇÃO FLY
FlyBtn.MouseButton1Click:Connect(function()
    flyAtivo = not flyAtivo
    FlyBtn.BackgroundColor3 = flyAtivo and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(180, 180, 180)
    FlyLabel.Text = flyAtivo and "FLY HACK [ ON ]" or "FLY HACK [ OFF ]"
    if flyAtivo then
        local char = Player.Character or Player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local bV = Instance.new("BodyVelocity", root)
        bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bV.Velocity = Vector3.new(0,0,0); bV.Name = "InfinityFly"
        task.spawn(function()
            while flyAtivo do
                local camera = workspace.CurrentCamera
                local direction = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0,1,0) end
                bV.Velocity = direction * 80; RunService.RenderStepped:Wait()
            end
            bV:Destroy()
        end)
    end
end)

-- FUNÇÃO INVISÍVEL
InvisBtn.MouseButton1Click:Connect(function()
    invisivelAtivo = not invisivelAtivo
    InvisBtn.BackgroundColor3 = invisivelAtivo and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(180, 180, 180)
    InvisLabel.Text = invisivelAtivo and "MODO INVISÍVEL [ ON ]" or "MODO INVISÍVEL [ OFF ]"
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = invisivelAtivo and 1 or (part.Name == "HumanoidRootPart" and 1 or 0)
            end
        end
    end
end)

-- LOGO E FECHAR
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32); CloseBtn.Position = UDim2.new(1, -42, 0, 10); CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn)

local MiniIcon = Instance.new("ImageButton")
MiniIcon.Size = UDim2.new(0, 75, 0, 75); MiniIcon.Visible = false; MiniIcon.Image = "rbxassetid://101393892487031"; MiniIcon.Parent = ScreenGui
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(0, 18); makeDraggable(MiniIcon)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniIcon.Visible = true end)
MiniIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniIcon.Visible = false end)
