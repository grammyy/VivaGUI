function viva.tooltip(x,y,width,height,func)
    render.setColor(colors.border)
    render.drawOutlineRounded(x-1,y-1,width+1,height+1,style.popupRounding,5)

    render.setColor(colors.popupBg)
    render.drawRoundedBox(style.windowRounding,x,y,width,height)
end