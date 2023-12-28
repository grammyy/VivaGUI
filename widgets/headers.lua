viva.registerWidgets({
    {
        "collapsingHeader",
        {
            "name",
            "closeButton"
        },
        function(window,self,stack,id,cache)
            render.setColor(stack.style and stack.style.header or colors.header)

            hitboxes.create(window,3,table.address(window)..id,window.x+stack.x*0.7,window.y+stack.y*0.7,window.width-style.windowPadding[1]-4,11.2,function()
                window.headers[self.name]=not window.headers[self.name]

                hitboxes.purge()
            end,function()
                render.setColor(stack.style and stack.style.headerHovered or colors.headerHovered)
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x,stack.y,(window.width-style.windowPadding[1]-4)/0.7,16)
            end)

            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(stack.x+20,stack.y+1,self.name,nil,window.width-7)
            render.drawTriangle(stack.x+4,stack.y+4,9,9,window.headers[self.name] and 0 or -90)
            
            if !window.headers[self.name] then
                stack.header=self.name
                cache.header=self.name
            end

            if self.closeButton then
                hitboxes.create(window,2,table.address(window)..id.."close",window.x+window.width-style.windowPadding[1]-8.5,window.y+(stack.y+4)*0.7,6.5,6.5,function()
                    self.hidden=true

                    hitboxes.purge()
                end,function()

                end,function()
                    render.drawExMark(((window.width-style.windowPadding[1]-4)/0.7)-6,stack.y+4.5,7,7)
                end)
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
        function(window,_,stack,_,cache)
            stack.header=nil
            cache.header=nil
        end,
        "rule"
    }
})