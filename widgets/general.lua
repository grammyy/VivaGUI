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

            hitboxes.create(window,3,window.name..self.type..id,data.x+(stack.x*0.7)+7,data.y+(stack.y*0.7),(w+6)*0.7,10.85,function()
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

            hitboxes.create(window,3,window.name..self.type..id,data.x+7,data.y+(stack.y*0.7),10.85,10.85,function()
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
            local w,_=render.getTextSize(self.name)
            local data=window.data
            
            local width=95*(data.width/100)
            local ratio=self.data.max-self.data.min
            local margin=width/ratio

            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)

            hitboxes.create(window,3,window.name..self.type..id,data.x+(stack.x*0.7)+7,data.y+(stack.y*0.7),width*0.7,10.85,function()
                window:dragEvent(function()
                    _G[self.var]=math.clamp((ratio*(cursor.x-data.x-7)/(width)/0.7)+self.data.min,self.data.min,self.data.max)

                    --math.clamp((ratio*(cursor.x-data.x-3.5-margin/2)/(width-margin)/0.7)+self.data.min,self.data.min,self.data.max)
                end)
            end,function()
                if !data.event then
                    render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                end
            end,function()
                render.drawRoundedBox(stack.style and stack.style.frameRounding or style.frameRounding,stack.x+10,stack.y,width,15.5)

                render.setColor(stack.style and stack.style.text or colors.text)
                render.drawText(stack.x+width+27,stack.y,self.name,1)

                render.setColor(stack.style and stack.style.sliderGrab or colors.sliderGrab)
                render.drawRoundedBox(stack.style and stack.style.grabRounding or style.grabRounding,stack.x+10+(width*(math.clamp(_G[self.var],self.data.min+0.4,self.data.max-0.5)-self.data.min)/ratio)-margin/2,stack.y,margin,15.5)
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
            local width=24*(data.width/100)

            render.setColor(stack.style and stack.style.frameBg or colors.frameBg)

            for ii=1,4 do
                hitboxes.create(window,3,window.name..self.type..id..ii,data.x+2.45*ii+((width*0.7)*(ii-1)),data.y+(stack.y*0.7),width*0.7,10.85,function()
                    local offset={cursor.x,_G[self.var][ii]}

                    window:dragEvent(function()
                        _G[self.var][ii]=math.clamp(math.round((offset[2] or 255)+(cursor.x-offset[1])*3,1),0,255)
                    end)
                end,function()
                    if !data.event then
                        render.setColor(stack.style and stack.style.frameBgHovered or colors.frameBgHovered)
                    end
                end,function()
                    render.drawRect(3.5*ii+(width*(ii-1)),stack.y,width,15.5)

                    render.setColor(stack.style and stack.style.text or colors.text)
                    render.drawText(3.5*ii+(width*(ii-1))+width/2,stack.y+1,(width>33 and rgba[ii] or "")..(_G[self.var] or {0,0,0,0})[ii] or 255,1)

                    render.setColor(stack.style and stack.style.frameBg or colors.frameBg)
                end)
            end

            hitboxes.create(window,3,window.name..self.type..id,data.x+12.25+(width*4)*0.7,data.y+(stack.y*0.7),10.85,10.85,function()
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
                render.drawRect(width*4+17.5,stack.y,15.5,15.5)
            end)
            
            render.setColor(stack.style and stack.style.text or colors.text)
            render.drawText(width*4+37,stack.y+1,self.name)

            return {
                x=0,
                y=stack.y+18.5
            }
        end
    }
})