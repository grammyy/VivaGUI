local rgba={"R: ","G: ","B: ","A: "}

viva.registerWidgets({
    {
        "separatorText",
        {
            "text"
        },
        function(window,stack,stackHeight)
            local data=window.data
            local w,_=render.getTextSize(stack.text)

            render.setColor(colors.text)
            render.drawText(16,stackHeight+1,stack.text)

            render.setColor(colors.separator)
            render.drawRect(3.5,stackHeight+9.25-(style.separatorTextBorderSize/2),10,style.separatorTextBorderSize)
            render.drawRect(18+w,stackHeight+9.25-(style.separatorTextBorderSize/2),(data.width-31)/0.7,style.separatorTextBorderSize)

            return stackHeight+18.5
        end
    },
    {
        "button",
        {
            "text",
            "func"
        },
        function(window,stack,stackHeight)
            local data=window.data
            local w,_=render.getTextSize(stack.text)

            render.setColor(colors.button)

            hitboxes.create(3,window.name..stack.type..stack.text,data.x+7,data.y+(stackHeight*0.7),(w+6)*0.7,10.85,function()
                if stack.func then
                    stack.func()
                end
            end,function()
                if !window.event then
                    render.setColor(colors.buttonHovered)
                end
            end,function()
                render.drawRoundedBox(style.frameRounding,10,stackHeight,w+6,15.5)

                render.setColor(colors.text)
                render.drawText((10+w/2)+3,stackHeight+2,stack.text,1)
            end)

            return stackHeight+19
        end
    },
    {
        "checkbox",
        {
            "var",
            "name"
        },
        function(window,stack,stackHeight)
            local data=window.data

            render.setColor(colors.frameBg)

            hitboxes.create(3,window.name..stack.type..stack.name,data.x+7,data.y+(stackHeight*0.7),10.85,10.85,function()
                _G[stack.var]=not _G[stack.var]
            end,function()
                if !window.event then
                    render.setColor(colors.frameBgHovered)
                end
            end,function()
                render.drawRoundedBox(style.frameRounding,10,stackHeight,15.5,15.5)

                render.setColor(colors.text)
                render.drawText(29,stackHeight+2,stack.name)
            end)

            return stackHeight+19
        end
    },
    {
        "colorEdit4",
        {
            "name",
            "var"
        },
        function(window,stack,stackHeight)
            local data=window.data
            render.setColor(colors.frameBg)

            for ii=1,4 do
                hitboxes.create(3,window.name..stack.type..stack.var..ii,data.x+2.45*ii+(24.5*(ii-1)),data.y+(stackHeight*0.7),24.5,10.85,function()
                    local offset={cursor.x,_G[stack.var][ii]}

                    hook.add("mousemoved","cl_drag",function()
                        _G[stack.var][ii]=math.clamp(math.round((offset[2] or 255)+(cursor.x-offset[1])*3,1),0,255)
                    end)

                    hook.add("inputReleased","hitId",function(key)
                        if hitboxes.filter(key) then
                            hook.remove("mousemoved","cl_drag")
                            hook.remove("inputReleased","hitId")

                            data.dragging=false
                        end
                    end)
                end,function()
                    if !data.event then
                        render.setColor(colors.frameBgHovered)
                    end
                end,function()
                    render.drawRect(3.5*ii+(35*(ii-1)),stackHeight,35,15.5)

                    render.setColor(colors.text)
                    render.drawText(3.5*ii+(35*(ii-1))+17.5,stackHeight+1,rgba[ii]..(_G[stack.var] or {0,0,0,0})[ii] or 255,1)

                    render.setColor(colors.frameBg)
                end)
            end

            hitboxes.create(3,window.name..stack.type..stack.var,data.x+12.25+(24.5*4),data.y+(stackHeight*0.7),10.85,10.85,function()
                viva:new(nil,{
                    width=100,
                    height=100,
                    x=cursor.x,
                    y=cursor.y,
                },{
                    noTitlebar=true
                },function(self)
                    self:textColored("Important stuff!",Color(timer.realtime()*10,1,1):hsvToRGB())
                end)
            end,nil,function()
                render.setColor(_G[stack.var] or colors.textDisabled)
                render.drawRect(157.5,stackHeight,15.5,15.5)
            end)
            
            render.setColor(colors.text)
            render.drawText(177,stackHeight+1,stack.name)

            return stackHeight+18.5
        end
    }
})