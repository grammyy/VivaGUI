viva.registerWidgets({
    {
        "textColored",
        {
            "text",
            "color"
        },
        function(window,self,stack)
            render.setColor(self.color)
            render.drawText(stack.x,stack.y+1,self.text)

            return {
                x=stack.x,
                y=stack.y+18.5
            }
        end
    }
})