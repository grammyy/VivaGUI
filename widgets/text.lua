viva.registerWidgets({
    {
        "text",
        {
            "text"
        },
        function(window,self,stack)
            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(stack.x,stack.y,self.text)

            return {
                x=stack.x,
                y=stack.y+17.5
            }
        end
    },
    {
        "textColored",
        {
            "text",
            "color"
        },
        function(window,self,stack)
            render.setColor(self.color)
            render.drawText(stack.x,stack.y,self.text)

            return {
                x=stack.x,
                y=stack.y+17.5
            }
        end
    }
})