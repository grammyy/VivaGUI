hitboxes.filter=function(key,hitbox)
    if (key==107 or key==15) and (!hitbox or hitbox.window==viva.windows[#viva.windows]) then
        return true
    end
end