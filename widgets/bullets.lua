viva.registerWidgets({
    {
        "bulletText",
        {
            "text"
        },
        function(window,self,stack)
            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawRoundedBox(100,stack.x+20,stack.y+4.5,4,4)
            render.drawText(stack.x+33,stack.y,self.text,nil,window.width-7)

            return {
                x=stack.x,
                y=stack.y+17.5
            }
        end
    }
})