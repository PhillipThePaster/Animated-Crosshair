local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local settings = {
    Visible = true;
    size = 10;
    spinSpeed = 2;
    SpinAnimation = true;
    pos = Vector2.new(0, 0);
    Thickness = 1;
}

local lineSets = {
    {count = settings.size, settings.Thickness, direction = 0, visible = settings.Visible},   -- Bottom
    {count = settings.size, settings.Thickness, direction = 90, visible = settings.Visible},  -- Top
    {count = settings.size, settings.Thickness, direction = 180, visible = settings.Visible}, -- Right
    {count = settings.size, settings.Thickness, direction = 270, visible = settings.Visible}  -- Left
}
local drawings = {}

local function toggleSpin()
    settings.SpinAnimation = not settings.SpinAnimation
end

local function updateLines(cursorPosition)
    for setIndex, set in ipairs(lineSets) do
        for i, line in ipairs(drawings[setIndex]) do
            local alpha = 0.1 + (i / set.count) * 0.8 
            local angle = math.rad(set.direction)
            local xOffset = math.cos(angle) * (i * 5)
            local yOffset = math.sin(angle) * (i * 5)    
            local fromX = cursorPosition.X + xOffset + settings.pos.X
            local fromY = cursorPosition.Y + yOffset + settings.pos.Y
            local toX = cursorPosition.X + xOffset * 2 + settings.pos.X
            local toY = cursorPosition.Y + yOffset * 2 + settings.pos.Y
            line.From = Vector2.new(fromX, fromY)
            line.To = Vector2.new(toX, toY)
            line.Color = Color3.new(208/255, 123/255, 255/255) 
            line.Transparency = 1 - alpha
            line.Visible = set.visible
        end
    end
end

for setIndex, set in ipairs(lineSets) do
    drawings[setIndex] = {}
    for i = 1, set.count do
        local line = Drawing.new('Line')
        line.ZIndex = 2
        line.Thickness = set.thickness
        drawings[setIndex][i] = line
    end
end

RunService.RenderStepped:Connect(function()
    if settings.SpinAnimation then 
        for setIndex, set in ipairs(lineSets) do
            set.direction = set.direction + settings.spinSpeed
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local cursorPosition = UserInputService:GetMouseLocation()
    updateLines(cursorPosition)
end)
