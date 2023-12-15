local rgba={"R: ","G: ","B: ","A: "}

viva.registerWidgets({
    {
        "separatorText",
        {
            "text"
        },
        function(window,self,stack)
            local data=window.data
            local w,_=render.getTextSize(self.text)

            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(16,stack.y+1,self.text)

            render.setColor(stack.style and stack.style.separator or colors.separator)
            render.drawRect(3.5,stack.y+9.25-(style.separatorTextBorderSize/2),10,style.separatorTextBorderSize)
            render.drawRect(18+w,stack.y+9.25-(style.separatorTextBorderSize/2),(data.width-31)/0.7,style.separatorTextBorderSize)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    },
    {
        "button",
        {
            "text",
            "func"
        },
        function(window,self,stack,id)
            local data=window.data
            local w,_=render.getTextSize(self.text)

            render.setColor(stack.style and stack.style.button or colors.button)

            hitboxes.create(3,window.name..self.type..id,data.x+(stack.x*0.7)+7,data.y+(stack.y*0.7),(w+6)*0.7,10.85,function()
                if self.func then
                    self.func()
                end
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.buttonHovered or colors.buttonHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x+10,stack.y,w+6,15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+(10+w/2)+3,stack.y+2,self.text,1)
            end)

            return {
                x=stack.x+32,
                y=stack.y+19
            }
        end
    },
    {
        "checkbox",
        {
            "var",
            "name"
        },
        function(window,self,stack,id)
            local data=window.data

            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)

            hitboxes.create(3,window.name..self.type..id,data.x+7,data.y+(stack.y*0.7),10.85,10.85,function()
                _G[self.var]=not _G[self.var]
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,10,stack.y,15.5,15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(29,stack.y+1,self.name)
            end)

            return {
                x=0,
                y=stack.y+19
            }
        end
    },
    {
        "slider",
        {
            "name",
            "var",
            "data"
        },
        function(window,self,stack,id)
            local data=window.data
            local w,_=render.getTextSize(self.name)

            render.setColor(stack.style and stack.style.button or colors.button)

            hitboxes.create(3,window.name..self.type..id,data.x+(stack.x*0.7)+7,data.y+(stack.y*0.7),(data.width-(data.width*0.1))*0.7,10.85,function()
                
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.buttonHovered or colors.buttonHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x+10,stack.y,data.width-(data.width*0.1),15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+data.width-(data.width*0.1)+27,stack.y,self.name,1)
            end)

            return {
                x=0,
                y=stack.y+19
            }
        end
    },
    {
        "colorEdit4",
        {
            "name",
            "var"
        },
        function(window,self,stack,id)
            local data=window.data
            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)

            for ii=1,4 do
                hitboxes.create(3,window.name..self.type..id..ii,data.x+2.45*ii+(24.5*(ii-1)),data.y+(stack.y*0.7),24.5,10.85,function()
                    local offset={cursor.x,_G[self.var][ii]}

                    hook.add("mousemoved","cl_drag",function()
                        _G[self.var][ii]=math.clamp(math.round((offset[2] or 255)+(cursor.x-offset[1])*3,1),0,255)
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
                        render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                    end
                end,function()
                    render.drawRect(3.5*ii+(35*(ii-1)),stack.y,35,15.5)

                    render.setColor(stack.style and stack.style.text or colors.text)
                    render.drawText(3.5*ii+(35*(ii-1))+17.5,stack.y+1,rgba[ii]..(_G[self.var] or {0,0,0,0})[ii] or 255,1)

                    render.setColor(stack.style and stack.style.frameBg or colors.frameBg)
                end)
            end

            hitboxes.create(3,window.name..self.type..id,data.x+12.25+(24.5*4),data.y+(stack.y*0.7),10.85,10.85,function()
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
                render.setColor(_G[self.var] or (stack.style and stack.style.textDisabled or colors.textDisabled))
                render.drawRect(157.5,stack.y,15.5,15.5)
            end)
            
            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(177,stack.y+1,self.name)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})