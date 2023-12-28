local mat=material.create("UnlitGeneric")
local _drawText=render.drawText
local _drawPoly=render.drawPoly

function render.drawPoly(coords)
    render.setMaterial(mat)
    _drawPoly(coords)
end

function render.drawText(x,y,text,alignment,bounds)
    if bounds then
        for i=1,#text do
            local w,_=render.getTextSize(string.sub(text,1,i))

            if (x+w)*0.7>=bounds then
                text=string.sub(text,1,i-1)

                break
            end 
        end
    end
    
    _drawText(x,y,text,alignment)
end

function viva.roundedBox(x,y,w,h,r,f,func)
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

    func(coords)
end

function render.drawOutlineRounded(x,y,w,h,r,f)
    viva.roundedBox(x,y,w,h,r,f,function(coords)
        for i=1,#coords do
            render.drawLine(coords[i][1],coords[i][2],(coords[i+1] or coords[1])[1],(coords[i+1] or coords[1])[2])
        end
    end)
end

function render.drawRoundedBoxEx(x,y,w,h,r,f)
    viva.roundedBox(x,y,w,h,r,f,function(coords)
        render.drawPoly(coords)
    end)
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

function render.drawExMark(x,y,width,height)
    render.drawLine(x,y,x+width,y+height)
    render.drawLine(x,y+height,x+width,y)
end

viva.registerWidgets({
    {
        "newMenu",
        {
            "name",
            "options"
        },
        function(window,self)
            window.menuItems[self.name]=self.options
        end,
        "rule"
    },
    {
        "sameLine",
        {},
        nil,
        "rule"
    },
    {
        "pushStyle",
        {
            "style"
        },
        function(_,self)
            return {
                style=self.style
            }
        end,
        "rule"
    },
    {
        "popStyle",
        {},
        function(_,_,stack)
            stack.style=nil
        end,
        "rule"
    }
})