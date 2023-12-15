viva.registerWidgets({
    {
        "textColored",
        {
            "text",
            "color"
        },
        function(window,self,stack)
            render.setColor(self.color)
            render.drawText(3.5,stack.y+1,self.text)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})