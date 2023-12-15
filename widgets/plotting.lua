viva.registerWidgets({
    {
        "plotLines",
        {
            "name",
            "table"
        },
        function(window,self,stack)
            local data=window.data

            render.setColor(colors.frameBg)
            render.drawRect(3.5,stack.y,169.5,15.5)

            for i,value in pairs(self.table) do
                local hovering=cursor:withinAABox(Vector(data.x,data.y)+Vector(3.5+(118.65*((i-1)/(#self.table-1))),stack.y*0.7),Vector(data.x,data.y)+Vector(3.5+(118.65*((i)/(#self.table-1))),(stack.y+15.5)*0.7))

                if i==#self.table then
                    break
                end

                render.setColor(hovering and colors.plotLinesHovered or colors.plotLines)

                render.drawLine(3.5+(169.5*((i-1)/(#self.table-1))),stack.y+7.75-value,3.5+(169.5*((i)/(#self.table-1))),stack.y+7.75-self.table[i+1])
            end

            render.setColor(colors.text)
            render.drawText(177,stack.y+1,self.name)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})