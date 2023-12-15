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