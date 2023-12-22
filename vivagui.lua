--@author Elias
--@includedir VivaGUI/resources
--@includedir VivaGUI/widgets
--@includedir VivaGUI/addons
--@include VivaGUI/constructor.lua
--@client

local mat=material.create("UnlitGeneric") --drawpoly fix

require("VivaGUI/constructor.lua")
requiredir("VivaGUI/resources")
requiredir("VivaGUI/widgets")
requiredir("VivaGUI/addons")

viva.flags=viva.init()
style=viva.flags.style
colors=style.colors

function viva:initialize(name,data,flags,drawData)
    self.self=self
    self.name=name
    self.x=data.x or 40
    self.y=data.y or 40
    self.width=data.width or 100
    self.height=data.height or 200
    self.active=data.active==nil and true or data.active
    self.menuItems={}
    self.flags=viva.constructor(flags or {})
    self.drawStack={}

    if drawData then
        drawData(self)
    end

    viva.windows[#viva.windows+1]=self

    return self
end

function viva:newMenu(name,options)
    self.menuItems[name]=options
end

function viva:sameLine()
    self.drawStack[#self.drawStack+1]={
        type="sameLine"
    }
end

function viva:pushStyle(style)
    self.drawStack[#self.drawStack+1]={
        type="pushStyle",
        style=style
    }
end

function viva:popStyle()
    self.drawStack[#self.drawStack+1]={
        type="popStyle"
    }
end

function viva:dragEvent(func,cleanup,name)
    hook.add("mousemoved",table.address(func),function()
        self.event=name or "dragging"

        func()
    end)

    hook.add("inputReleased",table.address(func),function(key)
        if hitboxes.filter(key) then
            hook.remove("mousemoved",table.address(func))
            hook.remove("inputReleased",table.address(func))

            self.event=nil

            if cleanup then
                cleanup()
            end
        end
    end)
end

function viva:render()
    render.setFilterMin(1)
    render.setFilterMag(1)
    
    --viva.tooltip(cursor.x+10,cursor.y,30,10)

    for id,window in pairs(viva.windows) do
        local context=Matrix(nil,Vector(window.x,window.y))

        if window.active then
            render.setColor(colors.windowBg)
            render.drawRoundedBox(style.windowRounding/2,window.x,window.y,window.width,window.height)
            
            context:setScale(Vector(0.7))
            render.pushMatrix(context)

            local stack={
                x=style.windowPadding[1],
                y=!window.flags.noTitlebar and ((!window.flags.noMenu and table.count(window.menuItems)!=0) and 38+(style.windowPadding[2]-6) or 20+(style.windowPadding[2]-6)) or style.windowPadding[2]-6
            }

            for i,self in pairs(window.drawStack) do
                --stack.x hiding needs to be completed asap
                
                local modifier=window.drawStack[i+1]

                if stack.y<(window.height/0.7)-18 then
                    if self.type=="pushStyle" then
                        stack.style=self.style
                    end

                    if self.type=="popStyle" then
                        stack.style=nil
                    end

                    if viva.widgets[self.type] then
                        local draw=viva.widgets[self.type](window,self,stack,i) 
                        
                        if modifier and modifier.type!="sameLine" then
                            stack.y=draw.y
                            stack.x=style.windowPadding[1]
                        else
                            stack.x=draw.x
                        end
                    end
                end
            end

            if !window.flags.noMenu then
                if table.count(window.menuItems)!=0 then
                    local i=-1

                    render.setColor(colors.menuBarBg)
                    render.drawRect(0,17.14,window.width/0.7,17.14)

                    for item,buttons in pairs(window.menuItems) do
                        local w,_=render.getTextSize(item)
                        i=i+1

                        if window.menuItem==item or !window.event and (_hitboxes[2] and _hitboxes[2][item] and _hitboxes[2][item].hover)then
                            render.setColor(colors.frameBg)
                            render.drawRect(2+(25*i)+2*i,18,25,15.5)
                        end

                        hitboxes.create(window,3,item..table.address(self),window.x+1.4+(17.5*i)+1.4*i,window.y+12.6,17.5,10.85,function()
                            if window.menuItem==item then
                                window.menuItem=nil
                            else
                                window.menuItem=item
                            end

                            hitboxes.purge()
                        end,function()
                            if !window.event then
                                if window.menuItem!=item and window.menuItem then
                                    window.menuItem=item
                                end

                                render.setColor(colors.headerHovered)
                                render.drawRect(2+(25*i)+2*i,18,25,15.5)
                            end
                        end,function()
                            render.setColor(colors.text)
                            render.drawText(7+(25*i)+2*i,19,item)
                        end)

                        if window.menuItem==item then
                            render.setColor(colors.popupBg)
                            render.drawRect(2+(25*i),34,110,7+15.5*table.count(buttons))

                            if style.popupBorder then
                                render.setColor(colors.border)
                                render.drawRectOutline(2+(25*i),34,110,7+15.5*table.count(buttons))
                            end
                            
                            render.setColor(colors.text)

                            for ii=1,#buttons do
                                hitboxes.create(window,3,table.address(window).."button"..ii,window.x+3.5+(17.5*i),window.y+15.4+(10.85*ii),72.8,10.85,function()
                                    if buttons[ii][2] then
                                        buttons[ii][2](window)
                                    end
                                end,function()
                                    if !window.event then
                                        render.setColor(colors.headerHovered)
                                        render.drawRect(5+(25*i),22+(15.5*ii),104,15.5)
                                    end
                                end,function()
                                    render.setColor(colors.text)
                                    render.drawText(7+(25*i),24+(15*ii),buttons[ii][1])

                                    render.setColor(colors.textDisabled)
                                    render.drawText(48+(25*i),24+(15*ii),buttons[ii][3])
                                end)
                            end
                        end
                    end
                end
            end

            render.popMatrix()
        end

        hitboxes.create(window,2,table.address(window).."titlebar",window.x,window.y,window.width,12,function()
            local offset=Vector(window.x,window.y)-cursor
            
            window:dragEvent(function()
                window.x=cursor.x+offset.x
                window.y=cursor.y+offset.y
            end,hitboxes.purge)
        end,nil,function()
            if window.flags.noTitlebar then
                return
            end

            render.setMaterial(mat)
            render.setColor(window.active and ((window.active and viva.windows[#viva.windows]==window) and colors.titleBgActive or colors.titleBg) or colors.titleBigCollapsed)
            render.drawRoundedBoxEx(window.x,window.y,window.width,12,style.windowRounding/2,5)
            --visual bug: create function parented from drawRoundedBox to Ex fill instead ^
        end)

        if !window.flags.noTitlebar then
            hitboxes.create(window,2,table.address(window).."toggle",window.x+2.5,window.y+2.5,6.5,6.5,function()
                window.active=not window.active

                hitboxes.purge()
            end,nil,function()
                render.setColor(colors.text)
                render.drawTriangle(window.x+3,window.y+3,6,6,window.active and 0 or -90)
            end)

            hitboxes.create(window,2,table.address(window).."close",window.x+window.width-10,window.y+2.5,6.5,6.5,function()
                table.removeByValue(viva.windows,window)
                self=nil

                hitboxes.purge()
            end,nil,function()
                render.setMaterial(mat)
                render.setColor(colors.text)
                render.drawLine(window.x+window.width-11,window.y+2.5,window.x+window.width-5,window.y+8)
                render.drawLine(window.x+window.width-11,window.y+8,window.x+window.width-5,window.y+2.5)
            end)

            if window.active then
                render.setColor(colors.resizeGrip)

                hitboxes.create(window,1,table.address(window).."resize",window.x+window.width-6,window.y+window.height-6,6,6,function()
                    local offset=Vector(window.width,window.height)-cursor
            
                    window:dragEvent(function()
                        window.width=math.max(cursor.x+offset.x,8.4)
                        
                        if window.active then
                            window.height=math.max(cursor.y+offset.y,8.4)
                        end
                    end,hitboxes.purge,"resizing")
                end,function()
                    if !window.event then
                        render.setColor(colors.resizeGripHovered)
                    end
                end,function()
                    if window.event=="resizing" then
                        render.setColor(colors.resizeGripActive)
                    end
                    
                    if window.active then
                        render.setMaterial(mat)
                        render.drawPoly({
                            Vector(window.x+window.width,window.y+window.height),
                            Vector(window.x+window.width-6,window.y+window.height),
                            Vector(window.x+window.width,window.y+window.height-6)
                        })
                        --visual bug: create function to draw curve ^
                    end
                end)
            end
        end

        if style.windowBorderSize>0 then
            render.setColor(colors.border)
            render.drawOutlineRounded(window.x,window.y,window.width,(window.active and window.height or 12),window.flags.popup and style.popupRounding/2 or style.windowRounding/2,5)
        end

        if window.name and !window.flags.noTitlebar then
            context:setScale(Vector(0.75,0.7,0.7))
            render.pushMatrix(context)

            render.setColor(colors.text)
            render.setFont(style.fonts[1])
            render.drawText(18,2,window.name)

            render.popMatrix()
        end
    end
end

hook.add("inputPressed","_viva",function(key)
    if !hitboxes.filter(key) then
        return
    end

    for i=1,#viva.windows do
        local window=viva.windows[#viva.windows-(i-1)]
        
        if cursor and cursor:withinAABox(Vector(window.x,window.y),Vector(window.x+window.width,window.y+window.height)) then
            if viva.windows[#viva.windows]!=window then
                table.remove(viva.windows,#viva.windows-(i-1))

                viva.windows[#viva.windows+1]=window
                
                hook.add("inputReleased","_viva",function(key)
                    if !hitboxes.filter(key) then
                        return
                    end

                    hitboxes.purge()

                    hook.remove("inputReleased","_viva")
                end)
            end
            
            return
        end
    end
end)