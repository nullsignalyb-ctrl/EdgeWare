-- Components.lua
-- This file will be hosted externally

return {
    ["ExampleTab"] = function(Page)
        -- Example Button
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 150, 0, 40)
        Button.Position = UDim2.new(0, 20, 0, 20)
        Button.Text = "Click Me"
        Button.Parent = Page

        Button.MouseButton1Click:Connect(function()
            print("Button clicked!")
        end)
    end,

    ["AnotherTab"] = function(Page)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 200, 0, 40)
        Label.Position = UDim2.new(0, 10, 0, 10)
        Label.Text = "Hello World"
        Label.Parent = Page
    end,
}
