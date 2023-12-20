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
            render.drawText(stack.x+12.5,stack.y+1,self.text)

            render.setColor(stack.style and stack.style.separator or colors.separator)
            render.drawRect(stack.x,stack.y+9.25-(style.separatorTextBorderSize/2),10,style.separatorTextBorderSize)
            render.drawRect(stack.x+14.5+w,stack.y+9.25-(style.separatorTextBorderSize/2),(data.width-13.5)/0.7-stack.x-w,style.separatorTextBorderSize)

            return {
                x=stack.x,
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

            hitboxes.create(window,3,window.name..self.type..id,data.x+stack.x*0.7,data.y+(stack.y*0.7),(w+6)*0.7,10.85,function()
                if self.func then
                    self.func()
                end
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.buttonHovered or colors.buttonHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x,stack.y,w+6,15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+(w/2)+3,stack.y+2,self.text,1)
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

            hitboxes.create(window,3,window.name..self.type..id,data.x+stack.x*0.7,data.y+stack.y*0.7,10.85,10.85,function()
                _G[self.var]=not _G[self.var]
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x,stack.y,15.5,15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+20,stack.y+1,self.name)
            end)

            return {
                x=stack.x,
                y=stack.y+19
            }
        end
    },
    {
        "sliderFloat",
        {
            "name",
            "var",
            "data",
            "func"
        },
        function(window,self,stack,id)
            local w,_=render.getTextSize(self.name)
            local data=window.data
            local float=self.func and self.func(_G[self.var]) or nil

            local width=95*(data.width/100)
            local ratio=self.data.max-self.data.min+1
            local margin=width/ratio
            
            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)

            hitboxes.create(window,3,window.name..self.type..id,data.x+(stack.x*0.7),data.y+(stack.y*0.7),width*0.7,10.85,function()
                window:dragEvent(function()
                    _G[self.var]=math.clamp((ratio*(cursor.x-data.x-stack.x*0.7-(margin/2)*0.7)/(width)/0.7)+self.data.min,self.data.min,self.data.max)
                end,hitboxes.purge)
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x,stack.y,width,15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+width+3,stack.y,self.name,nil,window)

                render.setColor(stack.style and stack.style.sliderGrab or colors.sliderGrab)
                render.drawRoundedBox(stack.style and stack.style.grabRounding or style.grabRounding,stack.x+(width*(math.clamp(float or _G[self.var],self.data.min,self.data.max)-self.data.min)/ratio),stack.y,math.max(margin,1),16)
            
                if self.func and float then
                    render.setColor(stack.style and stack.style.text or colors.text)
                    render.drawText(stack.x+width/2,stack.y,self.func(_G[self.var]),1)
                end
            end)

            return {
                x=stack.x,
                y=stack.y+19
            }
        end
    },
    {
        "sliderFloat2",
        {
            "name",
            "var",
            "data",
            "func"
        },
        function(window,self,stack,id)
            
        end
    },
    {
        "SliderAngle",
        {
            "name",
            "var",
            "data",
            "func"
        },
        function(window,self,stack,id)
            
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
            local width=24*(data.width/100)

            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)

            for ii=0,3 do
                hitboxes.create(window,3,window.name..self.type..id..ii,stack.x*0.7+data.x+2.45*(ii)+((width*0.7)*ii),data.y+(stack.y*0.7),width*0.7,10.85,function()
                    local offset={cursor.x,_G[self.var][ii+1]}

                    window:dragEvent(function()
                        _G[self.var][ii+1]=math.clamp(math.round((offset[2] or 255)+(cursor.x-offset[1])*3,1),0,255)
                    end)
                end,function()
                    if !data.event then
                        render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                    end
                end,function()
                    render.drawRect(stack.x+3.5*ii+(width*ii),stack.y,width,15.5)

                    render.setColor(stack.style and stack.style.text or colors.text)
                    render.drawText(stack.x+3.5*ii+(width*ii)+width/2,stack.y+1,(width>33 and rgba[ii+1] or "")..(_G[self.var] or {0,0,0,0})[ii+1] or 255,1)

                    render.setColor(stack.style and stack.style.frameBg or colors.frameBg)
                end)
            end

            hitboxes.create(window,3,window.name..self.type..id,stack.x*0.7+data.x+9.8+(width*4)*0.7,data.y+(stack.y*0.7),10.85,10.85,function()
                viva:new(nil,{
                    width=150,
                    height=160,
                    x=cursor.x,
                    y=cursor.y,
                },{
                    noTitlebar=true,
                    popup=true
                },function(self)
                    self:textColored("color2",Color(timer.realtime()*10,1,1):hsvToRGB())
                end)
            end,nil,function()
                render.setColor(_G[self.var] or (stack.style and stack.style.textDisabled or colors.textDisabled))
                render.drawRect(stack.x+width*4+14,stack.y,15.5,15.5)
            end)
            
            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(stack.x+width*4+33,stack.y+1,self.name,nil,window)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})