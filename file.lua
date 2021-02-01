local localPlayerClient;
local localPlayer;
local endingAngle;

local function degreesToRadians(degree)
    return degree * math.pi / 180.0;
end

local function fromAngle(angle)
    return Vector.new(math.cos(degreesToRadians(angle.pitch)) * math.cos(degreesToRadians(angle.yaw)), math.cos(degreesToRadians(angle.pitch)) * math.sin(degreesToRadians(angle.yaw)), -1 * math.sin(degreesToRadians(angle.pitch)));
end

cheat.RegisterCallback("draw", function()
    localPlayerClient = g_EngineClient:GetLocalPlayer();
    localPlayer = g_EntityList:GetClientEntity(localPlayerClient);
    local lp = localPlayer:GetPlayer();

    if (localPlayer and lp) then
        local viewOffset = lp:GetEyePosition()
        local crosshairLocation = viewOffset + endingAngle * 10000;

        local trace = g_EngineTrace:TraceRay(viewOffset, crosshairLocation, localPlayer, 0x46004009);
        local crosshairEndPos = trace.endpos;
        g_Render:Circle3D(crosshairEndPos, 58, 10.0, Color.new(1.0, 1.0, 1.0))

        local localPlayerOrigin = localPlayer:GetRenderOrigin();
        local localPlayerPos = g_EngineTrace:TraceRay(localPlayerOrigin, Vector.new(localPlayerOrigin.x, localPlayerOrigin.y, localPlayerOrigin.z - 10000), localPlayer, 0xFFFFFFFF).endpos;
        local size = 100;
        local boxSize = 25;

        local boxes = size / boxSize;
        for i = 0, boxes do
            local y = localPlayerPos.y - ((size / 2) - (i * boxSize));
            local xStart = localPlayerPos.x - (size / 2);
            local xEnd = localPlayerPos.x + (size / 2);

            local pos1 = g_Render:ScreenPosition(Vector.new(xStart, y, localPlayerPos.z))
            local pos2 = g_Render:ScreenPosition(Vector.new(xEnd, y, localPlayerPos.z))
            g_Render:Line(pos1, pos2, Color.new(1.0, 1.0, 1.0, 1.0))

            local x = localPlayerPos.x - ((size / 2) - (i * boxSize));
            local yStart = localPlayerPos.y - (size / 2);
            local yEnd = localPlayerPos.y + (size / 2);

            local pos3 = g_Render:ScreenPosition(Vector.new(x, yStart, localPlayerPos.z))
            local pos4 = g_Render:ScreenPosition(Vector.new(x, yEnd, localPlayerPos.z))
            g_Render:Line(pos3, pos4, Color.new(1.0, 1.0, 1.0, 1.0))
        end
    end
end);

cheat.RegisterCallback("override_view", function(e)
    endingAngle = fromAngle(e.angles);
end);
