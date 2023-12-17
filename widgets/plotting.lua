viva.registerWidgets({
    {
        "plotLines",
        {
            "name",
            "table"
        },
        function(window,self,stack)
            local data=window.data
            local width=95*(data.width/100)+8

            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)
            render.drawRect(3.5,stack.y,width,15.5)

            for i,value in pairs(self.table) do
                local hovering=cursor:withinAABox(Vector(data.x,data.y)+Vector(3.5+(118.65*((i-1)/(#self.table-1))),stack.y*0.7),Vector(data.x,data.y)+Vector(3.5+(118.65*((i)/(#self.table-1))),(stack.y+15.5)*0.7))

                if i==#self.table then
                    break
                end

                render.setColor(hovering and colors.plotLinesHovered or (stack.style and stack.style.plotLines or colors.plotLines))

                render.drawLine(3.5+(width*((i-1)/(#self.table-1))),stack.y+7.75-value,3.5+(width*((i)/(#self.table-1))),stack.y+7.75-self.table[i+1])
            end

            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(width+7.5,stack.y+1,self.name)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})