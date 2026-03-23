-- [[ TH MODZ V1 - VERSÃO SEM ERRO DE CORE_GUI ]] --
local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

-- ESSE É O SEGREDO: Usar PlayerGui em vez de CoreGui
local GetGui = Player:WaitForChild("PlayerGui")

-- Limpeza para não bugar se executar 2 vezes
if _G.TH_Connection then _G.TH_Connection:Disconnect() end
if GetGui:FindFirstChild("TH_V1") then GetGui.TH_V1:Destroy() end
if GetGui:FindFirstChild("TH_Login") then GetGui.TH_Login:Destroy() end

local Settings = {
    Aimbot = false, ShowFOV = false, FOVSize = 150,
    ESP = false, Fly = false, FlySpeed = 70,
    AutoAction = false, RadarStaff = false
}

-- 1. FOV (DESENHO)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.Color = Color3.fromRGB(255, 0, 150)
FOVCircle.Visible = false

-- 2. FUNÇÃO DRAG (ARRASTAR)
local function Drag(obj)
    local d, s, sp
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true s = i.Position sp = obj.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - s
        obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    obj.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end

-- 3. LOGIN (NO PLAYERGUI)
local function CreateLogin()
    local LoginGui = Instance.new("ScreenGui", GetGui); LoginGui.Name = "TH_Login"
    local Main = Instance.new("Frame", LoginGui); Main.Size = UDim2.new(0, 320, 0, 320); Main.Position = UDim2.new(0.5, -160, 0.4, -160)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", Main)
    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 80); Title.Text = "TH SYSTEM"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 24; Title.BackgroundTransparency = 1
    local LogBtn = Instance.new("TextButton", Main); LogBtn.Size = UDim2.new(0.8, 0, 0, 45); LogBtn.Position = UDim2.new(0.1, 0, 0.65, 0); LogBtn.Text = "ENTRAR NO SISTEMA"; LogBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150); LogBtn.TextColor3 = Color3.fromRGB(255, 255, 255); LogBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", LogBtn)

    LogBtn.MouseButton1Click:Connect(function()
        LogBtn.Visible = false
        task.spawn(function()
            Title.Text = "VERIFICANDO..."; task.wait(0.5)
            Title.Text = "BEM VINDO, " .. Player.Name:upper(); task.wait(0.5)
            LoginGui:Destroy(); LoadV1Menu()
        end)
    end)
end

-- 4. MENU (NO PLAYERGUI)
function LoadV1Menu()
    local HUD = Instance.new("ScreenGui", GetGui); HUD.Name = "TH_V1"
    local Main = Instance.new("Frame", HUD); Main.Size = UDim2.new(0, 260, 0, 480); Main.Position = UDim2.new(0.5, -130, 0.4, -240); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Main); Drag(Main)
    
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 40); Top.BackgroundColor3 = Color3.fromRGB(255, 0, 150); Instance.new("UICorner", Top)
    local MTitle = Instance.new("TextLabel", Top); MTitle.Size = UDim2.new(1, 0, 1, 0); MTitle.Text = "TH MODZ V1"; MTitle.TextColor3 = Color3.fromRGB(255, 255, 255); MTitle.Font = Enum.Font.GothamBold; MTitle.BackgroundTransparency = 1

    local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -20, 1, -60); Scroll.Position = UDim2.new(0, 10, 0, 50); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

    local function AddSwitch(txt, key)
        local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = "  " .. txt; b.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            b.BackgroundColor3 = Settings[key] and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(20, 20, 25)
        end)
    end

    AddSwitch("AIMBOT (M2)", "Aimbot"); AddSwitch("EXIBIR FOV", "ShowFOV"); AddSwitch("ESP DISTANCIA", "ESP"); AddSwitch("VOAR (FLY)", "Fly"); AddSwitch("RADAR STAFF", "RadarStaff")

    _G.TH_Connection = RS.RenderStepped:Connect(function()
        FOVCircle.Visible = Settings.ShowFOV; FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2); FOVCircle.Radius = Settings.FOVSize
        local Char = Player.Character; if not (Char and Char:FindFirstChild("HumanoidRootPart")) then return end

        if Settings.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            -- Lógica de Aimbot aqui
        end

        if Settings.Fly then
            Char.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame * CFrame.new(0,0,-Settings.FlySpeed/10) end
        end
    end)
    print("TH MODZ: MENU ABERTO COM SUCESSO!")
end

CreateLogin()
