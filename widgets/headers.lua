viva.registerWidgets({
    {
        "collapsingHeader",
        {
            "name",
            "flags"
        },
        function(window,self,stack,id)
            hitboxes.create(window,3,table.address(window)..id,window.x+stack.x*0.7,window.y+stack.y*0.7,window.width-style.windowPadding[1]-4,11.2,function()
                window.headers[self.name]=not window.headers[self.name]

                hitboxes.purge()
            end,function()
                render.setColor(stack.style and stack.style.headerHovered or colors.headerHovered)
            end,function()
                render.setColor(stack.style and stack.style.header or colors.header)
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x,stack.y,(window.width-style.windowPadding[1]-4)/0.7,16)
            end)

            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(stack.x+20,stack.y+1,self.name)
            render.drawTriangle(stack.x+4,stack.y+4,9,9,window.headers[self.name] and -90 or 0)
            
            if window.headers[self.name] then
                stack.header=self.name
            end

            return {
                x=stack.x,
                y=stack.y+19,
            }
        end
    },
    {
        "endHeader",
        {},
        function(window,_,stack)
            stack.header=nil
        end,
        true
    }
})