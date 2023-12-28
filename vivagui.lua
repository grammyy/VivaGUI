--@author Elias
--@includedir VivaGUI/resources
--@includedir VivaGUI/widgets
--@includedir VivaGUI/addons
--@include VivaGUI/constructor.lua
--@client

--Version: 2.7 in-dev

--todo next:
    --hook up more internal vars to main
    --scrollbar
    --fix slider pointer math
    --slider2 ^ needs to be done right after this

require("VivaGUI/constructor.lua")
requiredir("VivaGUI/resources")
requiredir("VivaGUI/widgets")
requiredir("VivaGUI/addons")

viva.flags=viva.init()
style=viva.flags.style
colors=style.colors

function viva:initialize(name,data,flags,drawData)
    self.x=data.x or 40
    self.y=data.y or 40
    self.width=data.width or 100
    self.height=data.height or 200
    self.active=data.active==nil and true or data.active
    self.flags=viva.constructor(flags or {})
    self.name=name
    
    self.scroll=0
    self.length=0
    self.headers={}
    self.menuItems={}
    self.drawStack={}

    drawData(self)

    viva.windows[#viva.windows+1]=self
end

function viva:dragEvent(func,name)
    func()
    
    hook.add("mousemoved",name or "dragging",function()
        self.event=name or "dragging"

        func()
    end)

    hook.add("inputReleased",name or "dragging",function(key)
        if hitboxes.filter(key) then
            hook.remove("mousemoved",name or "dragging")
            hook.remove("inputReleased",name or "dragging")

            self.event=nil
        end
    end)
end

function viva:renderStack(stack,drawStack) --some serious variable compression work needed
    --temp notes, going to be pushed to wiki soon

    --cache stores things like x to return to for treenode overflow events
    --widget stores all argumentive or modifiable instance variables such as 'hidden'
    --draw refers to the post draw of the widgets arguments type, it returns the modified stack 
        --stack instanced modifiers can be pushed by draw ^
    --stack refers to the draw order and settings matrix, such as pushing styles and then popping them later

    local cache={}

    for i,widget in pairs(drawStack) do
        local modifier=drawStack[i+1]

        if stack.y<(self.height/0.7)-18 and viva.widgets[widget.type] then
            if (stack.y<0 or stack.x>(self.width/0.7)-18) and stack.x!=10000 then
                cache.x=stack.x --^ temp solution for hidding overflow above/right
                stack.x=10000
            end

            if widget.rule=="rule" then
                local rule=viva.widgets[widget.type](self,widget,stack,i,cache)
                
                if rule then
                    for key,data in pairs(rule) do
                        stack[key]=data
                    end
                end
            elseif (!stack.header or table.hasValue(self.headers,stack.header[#stack.header])) and !widget.hidden then
                local draw=viva.widgets[widget.type](self,widget,stack,i,cache) --cache passed to argument to fix overflow bug
                
                if modifier and modifier.type!="sameLine" then --try converting to pure addon later
                    stack.y=draw.y
                    stack.x=stack.modify.x or style.windowPadding[1]
                else
                    stack.x=draw.x
                end
            end
        end

        if i==#drawStack then
            self.length=stack.y-self.scroll
        end
    end
end

function viva.render()
    render.setFilterMin(1)
    render.setFilterMag(1)
    
    for id,window in pairs(viva.windows) do
        local context=Matrix(nil,Vector(window.x,window.y))

        if window.active then
            render.setColor(colors.windowBg)
            render.drawRoundedBox(style.windowRounding/2,window.x,window.y,window.width,window.height)
            
            context:setScale(Vector(0.7))
            render.pushMatrix(context)

            local stack={
                x=style.windowPadding[1],
                y=window.scroll+(!window.flags.noTitlebar and ((!window.flags.noMenu and table.count(window.menuItems)!=0) and 38+(style.windowPadding[2]-6) or 20+(style.windowPadding[2]-6)) or style.windowPadding[2]-6),
                modify={}
            }

            window:renderStack(stack,window.drawStack)

            if !window.flags.noMenu then --convert into addon soon, and fix word length issue
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
                            window.menuItem=window.menuItem==item and nil or item
                            print(Color(255,204,229),window.menuItem.." <-- "..item)
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
                window.x=math.max(cursor.x+offset.x,0)
                window.y=math.max(cursor.y+offset.y,0)
            end)
        end,nil,function()
            if !window.flags.noTitlebar then
                render.setColor(window.active and ((window.active and viva.windows[#viva.windows]==window) and colors.titleBgActive or colors.titleBg) or colors.titleBigCollapsed)
                render.drawRoundedBoxEx(window.x,window.y,window.width,12,style.windowRounding/2,5)
            end
        end)

        if !window.flags.noTitlebar then
            hitboxes.create(window,2,table.address(window).."toggle",window.x+2.5,window.y+2.5,6.5,6.5,function()
                window.active=not window.active
            end,nil,function()
                render.setColor(colors.text)
                render.drawTriangle(window.x+3,window.y+3,6,6,window.active and 0 or -90)
            end)

            hitboxes.create(window,2,table.address(window).."close",window.x+window.width-10,window.y+2.5,6.5,6.5,function()
                table.removeByValue(viva.windows,window)

                hitboxes.purge()
            end,nil,function()
                render.drawExMark(window.x+window.width-10,window.y+2.5,5.5,5.5)
            end)

            if window.active then
                render.setColor(colors.resizeGrip)

                hitboxes.create(window,1,table.address(window).."resize",window.x+window.width-6,window.y+window.height-6,6,6,function()
                    local offset=Vector(window.width,window.height)-cursor
            
                    window:dragEvent(function()
                        window.width=math.max(cursor.x+offset.x,8.4)
                        window.height=math.max(cursor.y+offset.y,8.4)

                        hitboxes.purge()
                    end,"resizing")
                end,function()
                    if !window.event then
                        render.setColor(colors.resizeGripHovered)
                    end
                end,function()
                    if window.event=="resizing" then
                        render.setColor(colors.resizeGripActive)
                    end
                    
                    render.drawPoly({
                        Vector(window.x+window.width,window.y+window.height),
                        Vector(window.x+window.width-6,window.y+window.height),
                        Vector(window.x+window.width,window.y+window.height-6)
                    })
                    --visual bug: doesnt account for curved styles ^
                end)
            end

            if window.name then
                context:setScale(Vector(0.75,0.7,0.7))
                render.pushMatrix(context)
    
                render.setColor(colors.text)
                render.setFont(style.fonts[1])
                render.drawText(18,2,window.name)
    
                render.popMatrix()
            end
        end

        if style.windowBorder then
            render.setColor(colors.border)
            render.drawOutlineRounded(window.x-0.5,window.y-0.5,window.width,(window.active and window.height or 12),window.flags.popup and style.popupRounding/2 or style.windowRounding/2,5)
        end
    end
end