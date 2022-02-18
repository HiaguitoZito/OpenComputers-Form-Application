local gpu = require("component").gpu
local event = require("event")

Form = {}
Form.Components = {}
subform = {Components = {}}

Button = {Position = {x = 0, y = 0}, text = "", onCLick = function() end}
Label = {Position = {x = 0, y = 0}, text = "", color = 0x000000, onClick = function() end}

function subform:update()
    
    gpu.setBackground(self.color)
    gpu.fill(self.x, self.y, self.width, self.height, " ")
    gpu.setBackground(0x9F9F9F)
    gpu.setForeground(0xFF0000)
    gpu.fill(self.x + self.width - 1, self.y, 1, 1, "X")
    gpu.setBackground(self.color)
    gpu.setForeground(0x000000)
    local isClosed = false
    while isClosed == false do
        -- For each component in Form do
        local _, _, x, y = event.pull(0.1, "touch")
        for i, c in pairs(self.Components)do
            -- Draw component and read it in the Form
            c:update()
            if y ~= nil then
                c:event(x, y)
            end
        end
        if y ~= nil then
            if self.y == y and self.x + self.width - 1 == x then 
                isClosed = true
            end
        end
    end
end

function subform:Add(component)
    table.insert(self.Components, #self.Components+1, component)
end
function Label:event(x, y)
    local text = self.text
    local xPos = self.Position.x
    local yPos = self.Position.y

    -- Checks if the user clicked on the button.
    if x >= xPos and x <= #text + xPos and y == yPos then
        self.onClick()
    end
end
-- Updates the Form
function Label:update()
    gpu.setForeground(self.color)
    local function DrawText(text, xT, yT)
        local tempColor = gpu.getBackground()
        for i = 1, #text do
            local _, _, back = gpu.get(xT,yT)
            gpu.setBackground(back)
            gpu.fill(xT+(i-1),yT,1,1,text:sub(i,i))
        end
        gpu.setBackground(tempColor)
    end
    DrawText(self.text, self.Position.x, self.Position.y)
end

function Button:event(x, y)
    local text = self.text
    local xPos = self.Position.x
    local yPos = self.Position.y

    -- Checks if the user clicked on the button.
    if x >= xPos and x <= #text + xPos and y == yPos then
        self.onClick()
    end
end
function Button:update()
    gpu.setForeground(0x000000)
    local function DrawText(text, xT, yT, color)
        local tempColor = gpu.getBackground()
        gpu.setBackground(color)
        for i = 1, #text do
            gpu.fill(xT+(i-1),yT,1,1,text:sub(i,i))
        end
        gpu.setBackground(tempColor)
    end
    DrawText(self.text, self.Position.x, self.Position.y, 0xAFAFAF)
end

-- Adds a component to the Form
function Form:Add(component)
    table.insert(self.Components, #self.Components+1, component)
end
function Form:update()
    Rx, Ry = gpu.getResolution()
    gpu.setBackground(0xFFFFFF)
    gpu.fill(1,1,Rx,Ry," ")
    while true do
        -- For each component in Form do
        local _, _, x, y = event.pull(0.1, "touch")
        if self.Components ~= nil then
            for i, c in pairs(self.Components)do
                -- Draw component and read it in the Form
                c:update()
                if y ~= nil then
                    c:event(x, y)
                    gpu.setBackground(0xFFFFFF)
                    gpu.fill(1,1,Rx,Ry," ")
                end
            end
        end
    end
end
function Label:new(x, y, text, color)
    local t = {Position = {x = x, y = y}, text = text, color = color} or {Position = {x = 1, y = 1}, text = "label", color = 0x000000}
    setmetatable(t, self)
    self.__index = self
    return t
end
function Button:new(x, y, text)
    local t = {Position = {x = x, y = y}, text = text} or {x = 1, y = 1, text = "Button"}
    setmetatable(t, self)
    self.__index = self
    return t
end

function subform:new(x, y, width, height, color)
    local t = {x = x, y = y, width = width, height = height, color = color} or {x = 6, y = 3, width = 30, height = 10, color = 0xBFBFBF}
    setmetatable(t, self)
    self.__index = self
    return t
end

-- Instantiate a new Form
function Form:new(width, height)
    local t = {width = width, height = height} or {width = 30, height = 10}
    setmetatable(t, self)
    self.__index = self
    return t
end

return Form