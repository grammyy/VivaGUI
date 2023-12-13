viva.registerWidgets({
    {
        "plotLines",
        {
            "name",
            "table"
        },
        function(window,stack,stackHeight)
            local data=window.data

            render.setColor(colors.frameBg)
            render.drawRect(3.5,stackHeight,169.5,15.5)

            for i,value in pairs(stack.table) do
                local hovering=cursor:withinAABox(Vector(data.x,data.y)+Vector(3.5+(118.65*((i-1)/(#stack.table-1))),stackHeight*0.7),Vector(data.x,data.y)+Vector(3.5+(118.65*((i)/(#stack.table-1))),(stackHeight+15.5)*0.7))

                if i==#stack.table then
                    break
                end

                render.setColor(hovering and colors.plotLinesHovered or colors.plotLines)

                render.drawLine(3.5+(169.5*((i-1)/(#stack.table-1))),stackHeight+7.75-value,3.5+(169.5*((i)/(#stack.table-1))),stackHeight+7.75-stack.table[i+1])
            end

            render.setColor(colors.text)
            render.drawText(177,stackHeight+1,stack.name)

            return stackHeight+18.5
        end
    }
})