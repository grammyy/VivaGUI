viva.registerWidgets({
    {
        "treeNode",
        {
            "name"
        },
        function(window,self,stack,id,cache)
            local nodeName="treenode_"..self.name

            hitboxes.create(window,3,table.address(window)..id,window.x+stack.x*0.7,window.y+stack.y*0.7,(window.width-style.windowPadding[1]-13.5)-(stack.x-(stack.style and stack.style.indentSpacing or style.indentSpacing))*0.7,9.8,function()
                window.headers[nodeName]=not window.headers[nodeName]

                hitboxes.purge()
            end,function()
                render.setColor(stack.style and stack.style.headerHovered or colors.headerHovered)
                render.drawRect(stack.x,stack.y,(window.width-style.windowPadding[1]-13.5)/0.7-(stack.x-(stack.style and stack.style.indentSpacing or style.indentSpacing)),14)
            end,function()
                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+17,stack.y,self.name)
                render.drawTriangle(stack.x+5,stack.y+4,6,6,window.headers[nodeName] and 0 or -90)
            end)
            
            if !window.headers[nodeName] then
                stack.header=nodeName
            end

            stack.modify.x=(cache.x or stack.x)+(stack.style and stack.style.indentSpacing/2 or style.indentSpacing/2)

            return {
                x=stack.x+(stack.style and stack.style.indentSpacing or style.indentSpacing),
                y=stack.y+17,
            }
        end
    },
    {
        "endNode",
        {},
        function(window,_,stack,_,cache)
            stack.header=cache.header
            stack.x=style.windowPadding[1]
            stack.modify.x=nil
        end,
        "rule"
    }
})