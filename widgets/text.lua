viva.registerWidgets({
    {
        "textColored",
        {
            "text",
            "color"
        },
        function(window,stack,stackHeight)
            render.setColor(stack.color)
            render.drawText(3.5,stackHeight+1,stack.text)

            return stackHeight+18.5
        end
    }
})