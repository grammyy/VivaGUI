--@name Viva Demo
--@author Elias
--@include VivaGUI/vivagui.lua
--@client

require("VivaGUI/vivagui.lua")

testColor=Color(255,255,0)
samples={}
bool=false
size=10
offsetx=-512/2
offsety=0
debug=false

viva:new("My first tool",{
    width=170,
    height=140
},nil,function(self)
    self:newMenu("File",{
        {
            "Open..",
            function()end,
            "Ctrl+O"
        },
        {
            "Save",
            function()end,
            "Ctrl+S"
        },
        {
            "Close",
            function(self)
                table.removeByValue(viva.windows,self)

                hitboxes.purge()
            end,
            "Ctrl+W"
        }
    })

    self:colorEdit4("Color","testColor")

    self:plotLines("Samples",samples)
    
    self:textColored("Important stuff!",testColor)
    
    self:checkbox("debug hitboxes","debug")
    
    self:ratioButton("size: 10","size",10)

    self:sameLine()

    self:ratioButton("size: 20","size",20)
    
    self:sameLine()

    self:ratioButton("size: 30","size",30)
end)

viva:new("style editor",{
    width=150,
    height=270,
    y=200
    --active=false
},nil,function(self)
    --self:newMenu("Menu",{})
    
    --self:newMenu("Examples",{})
    
    --self:newMenu("Help",{})
    self:treeNode("testin shit")
        
    self:endNode()
    
    self:collapsingHeader("Help")
    self:endHeader()
    
    self:collapsingHeader("Configuration")
        self:treeNode("Configuration")
        self:endNode()

        self:treeNode("Backend")
        self:endNode()

        self:treeNode("Style")
        self:endNode()

        self:treeNode("Capture/Logging")
        self:endNode()
    self:endHeader()
    
    self:collapsingHeader("Window options")
    self:endHeader()
    
    self:collapsingHeader("Widgets")
        self:treeNode("Basic")
            self:separatorText("General")
            
            self:button("Button",nil)
        
            self:checkbox("checkbox","bool")
            
            self:ratioButton("ratio a",size,0) 
            self:sameLine()
            
            self:ratioButton("ratio b",size,1) 
            self:sameLine()
            
            self:ratioButton("ratio c",size,2)
            
            for i=1,5 do
                if i>1 then
                    self:sameLine()
                end
                
                self:pushStyle({
                    button=Color((i-1)*(360/5),0.6,0.6):hsvToRGB(),
                    buttonHovered=Color((i-1)*(360/5),0.7,0.7):hsvToRGB()
                })
                
                self:button("Click",nil)
            end
            
            self:popStyle()
            
            self:separatorText("Inputs")
            self:separatorText("Drags")
            self:separatorText("Sliders")
            
            int=0
            
            self:slider("slider int","int",{
                min=-1,
                max=3,
            },function(float)
                return math.round(float)
            end)
            
            float=0
            
            self:slider("slider float","float",{
                min=0,
                max=100,
            },function(float,ratio)
                return "ratio = "..string.format("%.3f",ratio)
            end)
            
            floatlog=0
            
            self:slider("slider float (log)","floatlog",{
                min=-10,
                max=10,
            },function(float)
                return string.format("%.3f",float)
            end)
            
            deg=0
            
            self:slider("slider deg","deg",{
                min=-360,
                max=360,
            },function(float)
                return string.format("%.0f",float).." deg"
            end)
            
            enum=0
            
            self:slider("slider enum","enum",{ --add option to force math.round
                min=0,
                max=3,
            },function(float)
                local enum=math.round(float)
                
                if enum==0 then
                    return "Fire"
                end
                
                if enum==1 then
                    return "Earth"
                end
                
                if enum==2 then
                    return "Air"
                end
                
                if enum==3 then
                    return "Water"
                end
            end)
            
            self:separatorText("Selectors/Pickers")
        self:endNode()
        
        self:treeNode("Tooltips")
        self:endNode()
        
        self:treeNode("Tree Nodes")
        self:endNode()
        
        self:treeNode("Collapsing Headers")
        self:endNode()
        
        self:treeNode("Bullets")
        self:endNode()
    self:endHeader()
    
    self:collapsingHeader("Layout & Scrolling")
    self:endHeader()
    
    self:collapsingHeader("Popups & Modal windows")
    self:endHeader()
    
    self:collapsingHeader("Tables & Columns")
    self:endHeader()
    
    self:collapsingHeader("Inputs & Focus")
    self:endHeader()
end)

hook.add("render","",function()
    frameBg=colors.frameBg
    
    for i=1,25 do
        samples[i]=math.sin(i*0.4+timer.realtime()*3)*5
    end
    
    render.drawRect(512-size/2+offsetx,512/2-size/2+offsety,size,size)
    
    viva.render()
    
    if debug then
        hitboxes.renderDebug()
    end
end)