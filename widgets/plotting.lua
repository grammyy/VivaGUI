viva.registerWidgets({
    {
        "plotLines",
        {
            "name",
            "table"
        },
        function(window,self,stack)
            local data=window.data
            local width=97.5*(data.width/100)+8

            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)
            render.drawRect(stack.x,stack.y,width,15.5)

            for i,value in pairs(self.table) do
                local hovering=cursor:withinAABox(Vector(data.x,data.y)+Vector(stack.x*0.7+(118.65*((i-1)/(#self.table-1))),stack.y*0.7),Vector(data.x,data.y)+Vector(stack.x*0.7+(118.65*(i/(#self.table-1))),(stack.y+15.5)*0.7))
                --fix hover math, slightly off ^
                
                if i==#self.table then
                    break
                end

                render.setColor(hovering and colors.plotLinesHovered or (stack.style and stack.style.plotLines or colors.plotLines))

                render.drawLine(stack.x+(width*((i-1)/(#self.table-1))),stack.y+7.75-value,stack.x+(width*((i)/(#self.table-1))),stack.y+7.75-self.table[i+1])
            end

            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(stack.x+width+4,stack.y+1,self.name)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})