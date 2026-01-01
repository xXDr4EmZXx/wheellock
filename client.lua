-- =============================================================
-- Script: Wheellock
-- Author: xXDr4EmZXx
-- Copyright © 2026
-- All rights reserved.
--
-- Description:
--   Locks the steering wheel angle when vehicle is stationary.
--   Prevents unwanted steering reset in FiveM vehicles.
--
-- License:
--   Free to use on personal FiveM servers only.
--   Redistribution, sale, or public sharing is prohibited.
--   Modifications allowed for personal use only.
--   See LICENSE.txt for full license details.
-- =============================================================

local lastAngle = 0.0
local active = false

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        active = IsPedInAnyVehicle(ped, false)
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        if not active then
            Wait(1000)
            goto continue
        end

        local ped = PlayerPedId()
        if not DoesEntityExist(ped) then
            Wait(1000)
            goto continue
        end

        local veh = GetVehiclePedIsIn(ped, false)
        if veh == 0 or not DoesEntityExist(veh) then
            Wait(1000)
            goto continue
        end

        local speed = GetEntitySpeed(veh)

        if speed > 0.2 then
            local steering = GetVehicleSteeringAngle(veh)
            if math.abs(steering) > 10.0 then
                lastAngle = steering
            end
            Wait(100)
        else
            if DoesEntityExist(veh)
            and not GetIsTaskActive(ped, 151)
            and not GetIsVehicleEngineRunning(veh) then
                SetVehicleSteeringAngle(veh, lastAngle)
            end
            Wait(300)
        end

        ::continue::
    end
end)
