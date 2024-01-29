require "Vehicles/ISUI/ISVehicleDashboard"
require "ISUI/ISImage"

local emergencyLightsIcon = getTexture("media/ui/vehicles/icon_headlights_light.png");
local emergencySirenIcon = getTexture("Icon_Radio_Speaker");
local emergencyBackground = getTexture("media/ui/emergency_dashboard_background.png");

local ISVehicleDashboard_createChildren = ISVehicleDashboard.createChildren;
function ISVehicleDashboard:createChildren()
    ISVehicleDashboard_createChildren(self);

    local w = emergencyLightsIcon:getWidthOrig();
    local h = emergencyLightsIcon:getHeightOrig();

    self.toggleEmergencyBackground = ISImage:new(0, 0,
        emergencyBackground:getWidthOrig(), emergencyBackground:getHeightOrig(), emergencyBackground);
    self.toggleEmergencyBackground:initialise();
    self.toggleEmergencyBackground:instantiate();
    self:addChild(self.toggleEmergencyBackground);

    self.toggleEmergencyLightsButton = ISImage:new(0, 0, w, h, emergencyLightsIcon);
    self.toggleEmergencyLightsButton.scaledWidth = 16;
    self.toggleEmergencyLightsButton.scaledHeight = 16;
    self.toggleEmergencyLightsButton:initialise();
    self.toggleEmergencyLightsButton.backgroundColor = { r = 1, g = 1, b = 1, a = 0.8 };
    self.toggleEmergencyLightsButton:instantiate();
    self.toggleEmergencyLightsButton.onclick = ISVehicleDashboard.onToggleEmergencyLightsClicked;
    self.toggleEmergencyLightsButton.target = self;
    self.toggleEmergencyLightsButton.mouseovertext = getText("UI_CDELASB_toggleLights");
    self:addChild(self.toggleEmergencyLightsButton);

    self.toggleEmergencySirenButton = ISImage:new(0, 0, w, h, emergencySirenIcon);
    self.toggleEmergencySirenButton.scaledWidth = 16;
    self.toggleEmergencySirenButton.scaledHeight = 16;
    self.toggleEmergencySirenButton:initialise();
    self.toggleEmergencySirenButton.backgroundColor = { r = 1, g = 1, b = 1, a = 0.8 };
    self.toggleEmergencySirenButton:instantiate();
    self.toggleEmergencySirenButton.onclick = ISVehicleDashboard.onToggleEmergencySirenClicked;
    self.toggleEmergencySirenButton.target = self;
    self.toggleEmergencySirenButton.mouseovertext = getText("UI_CDELASB_toggleSiren");
    self:addChild(self.toggleEmergencySirenButton);
end

local ISVehicleDashboard_setVehicle = ISVehicleDashboard.setVehicle;
function ISVehicleDashboard:setVehicle(vehicle)
    ISVehicleDashboard_setVehicle(self, vehicle);

    if vehicle and vehicle:hasLightbar() then
        local y = self.fuelGauge:getCentreY() - 47;
        local xCenter = self.backgroundTex:getWidth() / 2;
        local xLights = xCenter - 25;
        local xSiren = xCenter + 11;

        self.toggleEmergencyLightsButton:setX(xLights);
        self.toggleEmergencyLightsButton:setY(y);
        self.toggleEmergencyLightsButton:setVisible(true);

        self.toggleEmergencySirenButton:setX(xSiren);
        self.toggleEmergencySirenButton:setY(y);
        self.toggleEmergencySirenButton:setVisible(true);

        self.toggleEmergencyBackground:setX(xCenter - 77);
        self.toggleEmergencyBackground:setY(y - 19);
        self.toggleEmergencyBackground:setVisible(true);

        self:updateEmergencyLightsIconColor();
        self:updateEmergencySirenIconColor();
    else
        self.toggleEmergencyLightsButton:setVisible(false);
        self.toggleEmergencySirenButton:setVisible(false);
        self.toggleEmergencyBackground:setVisible(false);
    end
end

function ISVehicleDashboard:onToggleEmergencyLightsClicked(button, x, y)
    if getGameSpeed() == 0 then return; end
    if getGameSpeed() > 1 then setGameSpeed(1); end

    local vehicle = self.vehicle;
    local lightmode = vehicle:getLightbarLightsMode() + 1;
    if lightmode > 3 then
        lightmode = 0;
    end
    vehicle:setLightbarLightsMode(lightmode);
    self:updateEmergencyLightsIconColor();
end

function ISVehicleDashboard:onToggleEmergencySirenClicked(button, x, y)
    if getGameSpeed() == 0 then return; end
    if getGameSpeed() > 1 then setGameSpeed(1); end

    local sirenmode = self.vehicle:getLightbarSirenMode() + 1;
    if sirenmode > 3 then
        sirenmode = 0;
    end
    self.vehicle:setLightbarSirenMode(sirenmode);
    self:updateEmergencySirenIconColor();
end

function ISVehicleDashboard:updateEmergencyLightsIconColor()
    self:updateEmergencyLightbarIconColor(self.toggleEmergencyLightsButton,
        self.vehicle:getLightbarLightsMode());
end

function ISVehicleDashboard:updateEmergencySirenIconColor()
    self:updateEmergencyLightbarIconColor(self.toggleEmergencySirenButton,
        self.vehicle:getLightbarSirenMode());
end

function ISVehicleDashboard:updateEmergencyLightbarIconColor(button, mode)
    if mode == 1 then
        button.backgroundColor = { r = 0, g = 1, b = 0, a = 0.65 };
    elseif mode == 2 then
        button.backgroundColor = { r = 0, g = 0, b = 1, a = 0.65 };
    elseif mode == 3 then
        button.backgroundColor = { r = 1, g = 0, b = 0, a = 0.65 };
    else
        button.backgroundColor = { r = 0.5, g = 0.5, b = 0.5, a = 0.65 };
    end
end

