--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 25.01.2015
-- Time: 14:33
-- To change this template use File | Settings | File Templates.
--

cSkinImageCreator = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cSkinImageCreator:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// begin       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cSkinImageCreator:begin()
    -- Basic sachen --
    setCloudsEnabled(false);
    setTime(0, 00)
    setWeather(0)
    setRainLevel(0)
    setHeatHaze(0)
    local r, g, b = unpack(self.m_uBackgroundColor)
    setSkyGradient(r, g, b, r, g, b)
    setMinuteDuration(tonumber(string.rep("9", 4)));   -- wow, such innovation

    setCameraMatrix(unpack(self.m_tblCamPos));
    setTimer(function()
        self.m_uThread:start(self.m_iTimeCount)

    end, 1050, 1)
    --

    addEventHandler("onClientRender", getRootElement(), self.m_funcOnRender)
end

-- ///////////////////////////////
-- ///// onRender       	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cSkinImageCreator:onRender()
    localPlayer:setPosition(unpack(self.m_tblSpielerPos))
    localPlayer:setRotation(0, 0, -45)
end

-- ///////////////////////////////
-- ///// onSkinImageLaunch  //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cSkinImageCreator:onSkinImageLaunch()
    for i = self.m_iMinSkinID, self.m_iMaxSkinID, 1 do
        localPlayer:setModel(i);
        outputChatBox(i)
        dxUpdateScreenSource(self.m_uRT, true);
        local pixels;

        if(self.m_bJustHead) then
            pixels        = dxGetTexturePixels(self.m_uRT, self.m_iOffsetHeadX/self.m_Aesx*self.x, self.m_iOffsetHeadY, self.m_iOffsetHeadXTo/self.m_Aesx*self.x, self.y-self.m_iOffsetHeadY2);
        else
            pixels        = dxGetTexturePixels(self.m_uRT, self.m_iOffsetX/self.m_Aesx*self.x, self.m_iOffsetY2-(15/self.m_Aesy*self.y), self.m_iOffsetXTo/self.m_Aesx*self.x, self.y-self.m_iOffsetY2-(25/self.m_Aesy*self.y));
        end

        if(self.m_bTransparent) then
            local maxX, maxY = 300, 300
            if(self.m_bJustHead) then

            else
                maxX, maxY = 260, 775
            end
                for x = 0, maxX, 1 do
                    for y = 0, maxY, 1 do
                        local ra, ga, ba = dxGetPixelColor(pixels, x, y)
                        local bla = self.m_uBackgroundColor
                        if(ra == bla[1]) and (ga == bla[2]) and (ba == bla[3]) then       --
                            dxSetPixelColor(pixels, x, y, ra, ga, ba, 0);
                        end
                    end
                end

        end


        local format        = dxConvertPixels(pixels, self.m_sImageCompression, self.m_iImageQuality)

        local ext           = self.m_sImageCompression;
        if(ext == "JPEG") then
            ext = "jpg"
        end
        local fileName      = ("images/%s.%s"):format(i-1, string.lower(ext));

        file            = File.new(fileName);
        file:write(format)
        file:flush()
        file:close()

        coroutine.yield()
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cSkinImageCreator:constructor(...)
    -- Klassenvariablen --
    self.m_iMinSkinID       = 0;            -- Von
    self.m_iMaxSkinID       = 320;          -- Bis

    self.x, self.y          = guiGetScreenSize()

    self.m_Aesx, self.m_Aesy = 1600, 900
    self.m_uRT              = dxCreateScreenSource(self.x, self.y);

    self.m_tblSpielerPos    = {468.86404418945, -1159.2972412109, 1930.7220458984-1000}  -- Die Spieler Position
    self.m_tblCamPos        = {470.86602783203, -1157.0272216797, 1931.0688476563-1000, 405.18841552734, -1231.6334228516, 1920.0975341797-1000}  -- Kamerapostion

    self.m_bJustHead            = true;     -- Nur der Kopf?
    self.m_bTransparent         = false    -- Hintergrund Transparent? Achtung: nur bei Weiss moeglich

    self.m_uBackgroundColor     = {50, 50, 50};  -- Hintergrundfarbe
    self.m_bCreateOnly1Texture  = false;    -- Nur 1. Texture?
    self.m_sImageCompression    = "JPEG"     -- Kompressionsverfahren
    self.m_iImageQuality        = 80        -- Qualitaet (Nur bei JPEG Komprimierung, mit Verlust behaftet)
    self.m_iImageSize           = 1;        -- 0 - 1, groesse der Bilder die gespeichert werden sollen (1 = Max.)
    self.m_iTimeCount           = 100;      -- Anzahl der MS die er warten soll, bevor der Naechste Skin genommen wird, das erhoehen falls der Rechnr zu langsam ist und doppelte Skins vorkommen

    self.m_iOffsetX             = 680;      -- Muss eventuell angepasst werden
    self.m_iOffsetXTo           = 260;      -- Muss eventuell angepasst werden
    self.m_iOffsetY             = 30;      -- Muss eventuell angepasst werden
    self.m_iOffsetY2            = 100;      -- Muss eventuell angepasst werden

    self.m_iOffsetHeadX         = 650;      -- Muss eventuell angepasst werden
    self.m_iOffsetHeadXTo       = 300;      -- Muss eventuell angepasst werden
    self.m_iOffsetHeadY         = 110;      -- Muss eventuell angepasst werden
    self.m_iOffsetHeadY2        = 600;      -- Muss eventuell angepasst werden -- Sollte so stimmen alles


    -- Funktionen --

    self.m_funcOnRender         = function(...) self:onRender(...) end
    self.m_funcDoIt             = function(...)
        self:onSkinImageLaunch(...)
    end

    self.m_uThread              = cThread:new("Skin Process Thread", self.m_funcDoIt, 1);

    self:begin();
    -- Events --
end

-- EVENT HANDLER --

cSkinImageCreator:new()

