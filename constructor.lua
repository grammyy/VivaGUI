viva=class("vivagui")
viva.windows={}
viva.widgets={}

function viva.init(flags)
    if !flags or !flags.config or !flags.style then
        flags={
            config=flag and (flag.config or {}) or {},
            style=flag and (flag.style or {}) or {},
        }

        if !flags.style.colors or !flags.style.fonts then
            flags.style.colors={}
            flags.style.fonts={}
        end
    end

    return{
        config={
            noMouse=flags.config.noMouse or false,
            dockingEnable=flags.config.dockingEnable or true,
            dockingNoSplit=flags.config.dockingNoSplit or false,
            dockingWithShift=flags.config.dockingWithShift or false,
            dockingAlwaysTabBar=flags.config.dockingAlwaysTabBar or false,
            dockingTransparentPayload=flags.config.dockingTransparentPayload or false,

            cursorBlink=flags.config.cursorBlink or true,
            textEnterKeepActive=flags.config.textEnterKeepActive or false,
            dragClickToInputText=flags.config.dragClickToInputText or false,
            windowResizeFromEdges=flags.config.windowResizeFromEdges or true,
            windowsMoveFromTitleBarOnly=flags.config.windowsMoveFromTitleBarOnly or true,
        },
        backend={},
        style={
            colors={
                text=flags.style.colors.text or Color(255,255,255),
                textDisabled=flags.style.colors.textDisabled or Color(128,128,128),

                windowBg=flags.style.colors.windowBg or Color(15,15,15,240),
                childBg=flags.style.colors.childBg or Color(0,0,0,0),
                popupBg=flags.style.colors.popupBg or Color(20,20,20,240),
                border=flags.style.colors.border or Color(110,110,128,128),
                borderShadow=flags.style.colors.borderShadow or Color(0,0,0,0),
                frameBg=flags.style.colors.frameBg or Color(41,74,122,138),
                frameBgHovered=flags.style.colors.frameBgHovered or Color(66,150,250,102),
                frameBgActive=flags.style.colors.frameBgActive or Color(66,150,250,171),
                titleBg=flags.style.colors.titleBg or Color(10,10,10),
                titleBgActive=flags.style.colors.titleBgActive or Color(41,74,122),
                titleBigCollapsed=flags.style.colors.titleBigCollapsed or Color(0,0,0,130),
                menuBarBg=flags.style.colors.menuBarBg or Color(36,36,36),

                scrollbarBg=flags.style.colors.scrollbarBg or Color(5,5,5,135),
                scrollbarGrab=flags.style.colors.scrollbarGrab or Color(79,79,79),
                scrollbarGrabHovered=flags.style.colors.scrollbarGrabHovered or Color(105,105,105),
                scrollbarGrabActive=flags.style.colors.scrollbarGrabActive or Color(130,130,130),

                checkMark=flags.style.colors.checkMark or Color(66,150,250),
                sliderGrab=flags.style.colors.sliderGrab or Color(61,133,224),
                sliderGrabActive=flags.style.colors.sliderGrabActive or Color(66,150,250),
                button=flags.style.colors.button or Color(66,150,250,102),
                buttonHovered=flags.style.colors.buttonHovered or Color(66,150,250),
                buttonActive=flags.style.colors.buttonActive or Color(15,13,250),
                header=flags.style.colors.header or Color(66,150,250,79),
                headerHovered=flags.style.colors.headerHovered or Color(66,150,250,204),
                headerActive=flags.style.colors.headerActive or Color(66,150,250),
                separator=flags.style.colors.separator or Color(110,110,128,128),
                separatorHovered=flags.style.colors.separatorHovered or Color(26,102,191,199),
                separatorActive=flags.style.colors.separatorActive or Color(26,102,191),

                resizeGrip=flags.style.colors.resizeGrip or Color(66,150,250,51),
                resizeGripHovered=flags.style.colors.resizeGripHovered or Color(66,150,250,171),
                resizeGripActive=flags.style.colors.resizeGripActive or Color(66,150,250,242),
                tab=flags.style.colors.tab or Color(46,89,148,220),
                tabHovered=flags.style.colors.tabHovered or Color(66,150,250,204),
                tabActive=flags.style.colors.tabActive or Color(51,105,173),
                tabUnfocused=flags.style.colors.tabUnfocused or Color(17,26,38,248),
                tabUnfocusedActive=flags.style.colors.tabUnfocusedActive or Color(35,67,108),
                dockingPreview=flags.style.colors.dockingPreview or Color(66,150,250,179),
                dockingEmptyBg=flags.style.colors.dockingEmptyBg or Color(51,51,51),

                plotLines=flags.style.colors.plotLines or Color(156,156,156),
                plotLinesHovered=flags.style.colors.plotLinesHovered or Color(255,110,89),
                plotHistogram=flags.style.colors.plotHistogram or Color(230,179,0),
                plotHistogramHovered=flags.style.colors.plotHistogramHovered or Color(255,153,0),
                
                tableHeaderBg=flags.style.colors.tableHeaderBg or Color(48,48,51),
                tableBorderStrong=flags.style.colors.tableBorderStrong or Color(79,79,89),
                tableBorderLight=flags.style.colors.tableBorderLight or Color(59,59,64),
                tableRowBg=flags.style.colors.tableRowBg or Color(0,0,0,0),
                tableRowBgAlt=flags.style.colors.tableRowBgAlt or Color(255,255,255,15),
                textSelectedBg=flags.style.colors.textSelectedBg or Color(66,150,250,89),
                dragDropTarget=flags.style.colors.dragDropTarget or Color(255,255,0,230),
                navHighlight=flags.style.colors.navHighlight or Color(66,150,250),
                navWindowingHighlighting=flags.style.colors.navWindowingHighlighting or Color(255,255,255,179),
                navWindowingDimBg=flags.style.colors.navWindowingDimBg or Color(204,204,204,51),
                modelWindowDimBg=flags.style.colors.modelWindowDimBg or Color(204,204,204,89)
            },
            fonts={
                [1]="DermaDefault"
            },
            windowBorder=flags.style.windowBorder or true,
            childBorder=flags.style.childBorder or true,
            frameBorder=flags.style.frameBorder or false,
            popupBorder=flags.style.popupBorder or true,
            tabBorder=flags.style.tabBorder or false,
            tabBarBorder=flags.style.tabBarBorder or true,

            windowPadding=flags.style.windowPadding or {8,8},
            framePadding=flags.style.framePadding or {4,3},
            itemSpacing=flags.style.itemSpacing or {8,4},
            itemInnerSpacing=flags.style.itemInnerSpacing or {4,4},
            indentSpacing=flags.style.indentSpacing or 21,
            scrollBarSize=flags.style.scrollBarSize or 14,
            grabMinSize=flags.style.grabMinSize or 12,

            windowRounding=flags.style.windowRounding or 3,
            childRounding=flags.style.childRounding or 3,
            frameRounding=flags.style.frameRounding or 3,
            popupRounding=flags.style.popupRounding or 3,
            scrollbarRounding=flags.style.scrollbarRounding or 12,
            grabRounding=flags.style.grabRounding or 0,
            tabRounding=flags.style.tabRounding or 3,

            cellPadding=flags.style.cellPadding or {4,2},
            tableAngledHeadersAngle=flags.style.tableAngledHeadersAngle or 35,

            windowTitleAlign=flags.style.windowTitleAlign or {0,0.5},
            windowMenuButtonPosition=flags.style.windowMenuButtonPosition or "left",
            colorButtonPosition=flags.style.colorButtonPosition or "right",
            buttonTextAlign=flags.style.buttonTextAlign or {0.5,0.5},
            selectableTextAlign=flags.style.selectableTextAlign or {0,0},
            separatorTextBorderSize=flags.style.separatorTextBorderSize or 3,
            separatorTextAlign=flags.style.separatorTextAlign or {0,0.5},
            separatorTextPadding=flags.style.separatorTextPadding or {20,3},
            logSliderDeadzone=flags.style.logSliderDeadzone or 4,

            dockingSplitterSize=flags.style.dockingSplitterSize or 2,

            hoveredFlagsDelayNone=flags.style.hoveredFlagsDelayNone or false,
            hoveredFlagsDelayShort=flags.style.hoveredFlagsDelayShort or true,
            hoveredFlagsDelayNormal=flags.style.hoveredFlagsDelayNormal or false,
            hoveredFlagsDelayStationary=flags.style.hoveredFlagsDelayStationary or true,
            hoveredFlagsNoSharedDelay=flags.style.hoveredFlagsNoSharedDelay or false,

            DisplaySafeAreaPadding=flags.style.DisplaySafeAreaPadding or {3,3}
        }
    }
end

function viva.constructor(flags)
    return{
        noTitlebar=flags.noTitlebar or false,
        noScrollbar=flags.noScrollbar or false,
        noMenu=flags.noMenu or false,
        noMove=flags.noMove or false,
        noResize=flags.noResize or false,
        noCollapse=flags.noCollapse or false,
        noNav=flags.noNav or false,
        noBackground=flags.noBackground or false,
        noBringToFront=flags.noBringToFront or false,
        noDocking=flags.noDocking or false,
        noClose=flags.noClose or false,
        popup=flags.popup or false,
    }
end

function viva.registerWidget(name,stack,func,rule)
    viva[name]=function(self,...)
        local arguments={
            type=name,
            rule=rule!=nil and rule or false
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
        viva.registerWidget(widget[1],widget[2],widget[3],widget[4])
    end
end