--@author Elias
--@includedir VivaGUI/resources
--@includedir VivaGUI/widgets
--@includedir VivaGUI/addons
--@include VivaGUI/constructor.lua
--@client

viva=class("vivagui")

require("VivaGUI/constructor.lua")

viva.flags=viva.init()
viva.windows={}
viva.widgets={}
style=viva.flags.style
colors=style.colors

local mat=material.create("UnlitGeneric")

function viva.registerWidget(name,stack,func)
    viva[name]=function(self,...)
        local arguments={
            type=name
        }

        for i,v in ipairs({...}) do
            arguments[stack[i]]=v
        end

        self.drawStack[#self.drawStack+1]=arguments
    end

    viva.widgets[name]=func
end

function viva.registerWidgets(widgets)
    for i,widget in pairs(widgets) do
        viva.registerWidget(widget[1],widget[2],widget[3])
    end
end

requiredir("VivaGUI/resources")
requiredir("VivaGUI/widgets")
requiredir("VivaGUI/addons")

hitboxes.filter=function(key)
    if key==107 then
        return true
    end
end

function viva:initialize(name,data,flags,drawData)
    self.name=name
    self.data={
        x=data.x or 40,
        y=data.y or 40,
        width=data.width or 100,
        height=data.height or 200,
        active=data.active or true,
        menuItems={},
    }
    self.flags=viva.constructor(flags or {})
    self.drawStack={}

    if self.data.active and drawData then
        drawData(self)
    end

    viva.windows[#viva.windows+1]=self

    return self
end

function render.drawOutlineRounded(x, y, w, h, r, f)
    local coords={}
    local f2=f*2
 
    for i=f*0, f*1 do 
        local rad=i/f2*math.pi; 

        coords[#coords+1]=Vector(x+r-math.cos(rad)*r,y+r-math.sin(rad)*r)
    end

    for i=f*1, f*2 do 
        local rad=i/f2*math.pi; 

        coords[#coords+1]=Vector(x+w-r-math.cos(rad)*r, y+r-math.sin(rad)*r)
    end

    for i=f*2, f*3 do 
        local rad=i/f2*math.pi; 

        coords[#coords+1]=Vector(x+w-r-math.cos(rad)*r, y+h-r-math.sin(rad)*r)
    end

    for i=f*3, f*4 do 
        local rad=i/f2*math.pi

        coords[#coords+1]=Vector(x+r-math.cos(rad)*r, y+h-r-math.sin(rad)*r)
    end
 
    for i=1,#coords do
        render.drawLine(coords[i][1],coords[i][2],(coords[i+1] or coords[1])[1],(coords[i+1] or coords[1])[2])
    end
end

function render.drawTriangle(x,y,width,height,degrees)
    render.pushMatrix(Matrix(Angle(0,degrees or 0,0),Vector(x+(width/2),y+(height/2))))

    render.drawPoly({
        Vector(-width/2,-height/2),
        Vector(width/2,-height/2),
        Vector(0,height/2)
    })

    render.popMatrix()
end

function viva:newMenu(name,options)
    self.data.menuItems[name]=options
end

function viva:render()
    render.setFilterMin(1)
    render.setFilterMag(1)

    --viva.tooltip(cursor.x+10,cursor.y,30,10)

    for id,window in pairs(viva.windows) do
        local data=window.data
        local context=Matrix(nil,Vector(data.x,data.y))

        if style.windowBorderSize then
            render.setColor(colors.border)
            render.drawOutlineRounded(data.x-1,data.y-1,data.width+1,(data.active and data.height or 12+1)+1,style.windowRounding,5)
        end

        if data.active then
            render.setColor(colors.windowBg)
            render.drawRoundedBox(style.windowRounding,data.x,data.y,data.width,data.height)
            
            context:setScale(Vector(0.7))
            render.pushMatrix(context)

            local stackHeight=table.count(data.menuItems)!=0 and 38 or 21

            for i,stack in pairs(window.drawStack) do
                if viva.widgets[stack.type] then
                    stackHeight=viva.widgets[stack.type](window,stack,stackHeight)
                end
            end

            if !window.flags.noTitlebar then
                if table.count(data.menuItems)!=0 then
                    local i=-1

                    render.setColor(colors.menuBarBg)
                    render.drawRect(0,17.14,data.width/0.7,17.14)

                    for item,buttons in pairs(data.menuItems) do
                        local w,_=render.getTextSize(item)
                        i=i+1

                        if data.menuItem==item or !data.event and (_hitboxes[2] and _hitboxes[2][item] and _hitboxes[2][item].hover)then
                            render.setColor(colors.frameBg)
                            render.drawRect(2+(25*i)+2*i,18,25,15.5)
                        end

                        hitboxes.create(3,item..table.address(self),data.x+1.4+(17.5*i)+1.4*i,data.y+12.6,17.5,10.85,function()
                            if data.menuItem==item then
                                data.menuItem=nil
                            else
                                data.menuItem=item
                            end

                            hitboxes.purge()
                        end,function()
                            if !data.event then
                                if data.menuItem!=item and data.menuItem then
                                    data.menuItem=item
                                end

                                render.setColor(colors.headerHovered)
                                render.drawRect(2+(25*i)+2*i,18,25,15.5)
                            end
                        end,function()
                            render.setColor(colors.text)
                            render.drawText(7+(25*i)+2*i,19,item)
                        end)

                        if data.menuItem==item then
                            render.setColor(colors.popupBg)
                            render.drawRect(2+(25*i),34,110,7+15.5*table.count(buttons))

                            if style.popupBorder then
                                render.setColor(colors.border)
                                render.drawRectOutline(2+(25*i),34,110,7+15.5*table.count(buttons))
                            end
                            
                            render.setColor(colors.text)

                            for ii=1,#buttons do
                                hitboxes.create(3,table.address(window).."button"..ii,data.x+3.5+(17.5*i),data.y+15.4+(10.85*ii),72.8,10.85,function()
                                    if buttons[ii][2] then
                                        buttons[ii][2](window)
                                    end
                                end,function()
                                    if !data.event then
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

        hitboxes.create(2,table.address(window).."titlebar",data.x,data.y,data.width,12,function()
            local offset=Vector(data.x,data.y)-cursor
            data.event="dragging"

            hook.add("mousemoved","cl_drag",function()
                data.x=cursor.x+offset.x
                data.y=cursor.y+offset.y
            end)

            hook.add("inputReleased","hitId",function(key)
                if !hitboxes.filter(key) then
                    return
                end
                
                hook.remove("mousemoved","cl_drag")
                hook.remove("inputReleased","hitId")

                hitboxes.purge()

                data.event=nil
            end)
        end,nil,function()
            render.setColor(data.active and colors.titleBgActive or colors.titleBg)
            render.drawRoundedBoxEx(style.windowRounding,data.x,data.y,data.width,12,true,true,false,false)
        end)

        hitboxes.create(2,table.address(window).."toggle",data.x+2.5,data.y+2.5,6.5,6.5,function()
            data.active=not data.active

            hitboxes.purge()
        end,nil,function()
            render.setMaterial(mat)
            render.setColor(colors.text)
            render.drawTriangle(data.x+3,data.y+3,6,6,data.active and 0 or -90)
        end)

        hitboxes.create(2,table.address(window).."close",data.x+data.width-10,data.y+2.5,6.5,6.5,function()
            viva.windows[table.address(window)]=nil
            self=nil

            hitboxes.purge()
        end,nil,function()
            render.setColor(colors.text)
            render.drawLine(data.x+data.width-11,data.y+2.5,data.x+data.width-5,data.y+8)
            render.drawLine(data.x+data.width-11,data.y+8,data.x+data.width-5,data.y+2.5)
        end)

        render.setColor(colors.resizeGrip)

        hitboxes.create(1,table.address(window).."resize",data.x+data.width-6,data.y+data.height-6,6,6,function()
            local offset=Vector(data.width,data.height)-cursor
            data.event="resizing"
    
            hook.add("mousemoved","cl_drag",function()
                data.width=math.max(cursor.x+offset.x,8.4)
                data.height=math.max(cursor.y+offset.y,8.4)
            end)
    
            hook.add("inputReleased","hitId",function(key)
                if !hitboxes.filter(key) then
                    return
                end

                hook.remove("mousemoved","cl_drag")
                hook.remove("inputReleased","hitId")
    
                hitboxes.purge()
    
                data.event=nil
            end)
        end,function()
            if !data.event then
                render.setColor(colors.resizeGripHovered)
            end
        end,function()
            if data.event=="resizing" then
                render.setColor(colors.resizeGripActive)
            end
            
            if data.active then
                render.setMaterial(mat)
                render.drawPoly({
                    Vector(data.x+data.width,data.y+data.height),
                    Vector(data.x+data.width-6,data.y+data.height),
                    Vector(data.x+data.width,data.y+data.height-6)
                })
            end
        end)

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

hook.add("inputPressed","",function(key)
    if !hitboxes.filter(key) then
        return
    end

    for i=1,#viva.windows do
        local window=viva.windows[#viva.windows-(i-1)]
        local data=window.data

        if cursor and cursor:withinAABox(Vector(data.x,data.y),Vector(data.x+data.width,data.y+data.height)) then
            if viva.windows[#viva.windows]!=window then
                table.remove(viva.windows,#viva.windows-(i-1))

                viva.windows[#viva.windows+1]=window
                
                hook.add("inputReleased","",function(key)
                    if !hitboxes.filter(key) then
                        return
                    end

                    hitboxes.purge()

                    hook.remove("inputReleased","")
                end)
            end
            
            return
        end
    end
end)