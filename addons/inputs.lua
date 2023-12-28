hook.add("inputPressed","_viva",function(key)
    if !hitboxes.filter(key) then
        return
    end

    for i=1,#viva.windows do
        local window=viva.windows[#viva.windows-(i-1)]
        
        if cursor and cursor:withinAABox(Vector(window.x,window.y),Vector(window.x+window.width,window.active and window.y+window.height or window.y+12)) then
            if viva.windows[#viva.windows]!=window then
                table.remove(viva.windows,#viva.windows-(i-1))

                viva.windows[#viva.windows+1]=window
                
                hook.add("inputReleased","_viva",function(key)
                    if !hitboxes.filter(key) then
                        return
                    end

                    hook.remove("inputReleased","_viva")
                end)
            end
            
            return
        end

        if viva.inputEvent then
            viva.inputEvent(key)
        end
    end
end)

hook.add("mouseWheeled","_viva",function(delta)
    for i,window in pairs(viva.windows) do
        if cursor and window.active and cursor:withinAABox(Vector(window.x,window.y),Vector(window.x+window.width,window.active and window.y+window.height or window.y+12)) then
            window.scroll=math.clamp(window.scroll+(delta*22),-(window.length-window.height),0)
            --max scroll math off a bit ^

            hitboxes.purge() --optimize to clear window specific hitboxes
        end
    end
end)