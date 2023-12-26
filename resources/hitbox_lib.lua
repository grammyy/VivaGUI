--@name hitbox lib
--@author Elias
--@client

hitboxes=class("hitboxes")
_hitboxes={}

cursorFunc=function()
    x,y=render.cursorPos()
    
    return Vector(x,y) or Vector()
end

function hitboxes.create(window,layer,id,x,y,w,h,callback,hover,renderFunc)
    if !_hitboxes[layer] then
        _hitboxes[layer]={}
    end

    if !_hitboxes[layer][id] then
        _hitboxes[layer][id]={
            x=x,
            y=y,
            w=w,
            h=h,
            callback=callback,
            hover=false,
            window=window
        }
    else
        if hover and _hitboxes[layer][id].hover then
            hover()
        end

        _hitboxes[layer][id].x=x
        _hitboxes[layer][id].y=y
        _hitboxes[layer][id].w=w
        _hitboxes[layer][id].h=h
    end 

    if renderFunc then
        renderFunc(x,y,w,h)
    end
end

function hitboxes.each(_hitboxes,func)
    for i,layer in pairs(_hitboxes) do
        for id,hitbox in pairs(layer) do
            func(i,id,hitbox)
        end
    end
end

function hitboxes.edit(layer,id,x,y,w,h,callback)
    local hitbox=_hitboxes[layer][id]
    
    _hitboxes[layer][id]={
        x=x or hitbox.x,
        y=y or hitbox.y,
        w=w or hitbox.w,
        h=h or hitbox.h,
        callback=callback or hitbox.callback,
        hover=false
    }
end

function hitboxes.remove(layer,id)
    if !_hitboxes[layer] then
        return
    end

    _hitboxes[layer][id]=nil
end

function hitboxes.clear(layer)
    if !_hitboxes[layer] then
        return
    end

    _hitboxes[layer]=nil
end

function hitboxes.purge()
    for layer,_ in pairs(_hitboxes) do
        hitboxes.clear(layer)
    end
end

function hitboxes.renderDebug()
    hitboxes.each(_hitboxes,function(i,id,hitbox)
        render.setColor(Color((i/4)*((!isstring(id) and id*20 or 0)+timer.realtime()*20),1,1):hsvToRGB())
        
        render.drawRectOutline(hitbox.x,hitbox.y,hitbox.w,hitbox.h)
    end)
end

hook.add("render","cl_hitboxes",function()
    cursor=cursorFunc()
    
    if hitboxes.debug then
        hitboxes.renderDebug()
    end
end)

hook.add("think","cl_hitboxes",function()
    local curLayer=nil
    
    hitboxes.each(_hitboxes,function(i,id,hitbox)
        if curLayer and curLayer!=i then
            hitboxes.each(_hitboxes,function(i,id,hitbox)
                if curLayer<i then
                    hitbox.hover=false
                end
            end)
            
            return
        end

        if cursor:withinAABox(Vector(hitbox.x,hitbox.y),Vector(hitbox.x+hitbox.w,hitbox.y+hitbox.h)) then
            local frontWindow=viva.windows[#viva.windows]

            if i!=0 then
                curLayer=i
            end

            if hitbox.window==frontWindow then
                hitbox.hover=true
            else
                if !cursor:withinAABox(Vector(frontWindow.x,frontWindow.y),Vector(frontWindow.x+frontWindow.width,frontWindow.y+frontWindow.height)) then
                    hitbox.hover=true
                else
                    hitbox.hover=false
                end
            end
        else
            hitbox.hover=false
        end
    end)
end)

hook.add("inputPressed","_vivahitboxes",function(key)
    hitboxes.each(_hitboxes,function(i,id,hitbox)
        if hitbox.hover and hitbox.callback then
            if hitboxes.filter and !hitboxes.filter(key,hitbox,i,id) then
                return
            end

            hitbox.callback(key,cursor)
        end
    end)
end)