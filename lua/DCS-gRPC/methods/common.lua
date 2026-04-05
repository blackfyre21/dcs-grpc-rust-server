local Inspect = require "inspect"
local GRPC = GRPC
Common = {}

function Common.extractPosition(position)
  GRPC.logInfo("extractPosition = " .. Inspect(position))
  local coords = position.coordinates
  local pos = { x = 0, y = 0, z = 0 }
  if coords and coords.cartesian then
    pos.z = coords.cartesian.u --east-west 
    pos.x = coords.cartesian.v --north-south
    pos.y = coords.cartesian.alt
    GRPC.logInfo("extractPosition returning = " .. Inspect(pos))
  elseif coords and coords.geodetic then
    pos = coord.LLtoLO(coords.geodetic.lat,
                       coords.geodetic.lon,
                       coords.geodetic.alt)
  end
  return pos
end

function Common.getAltitudeType(val)
  local dict = {
    [1] = AI.Task.AltitudeType.BARO,
    [2] = AI.Task.AltitudeType.RADIO,
  }
  return dict[val] or AI.Task.AltitudeType.BARO
end

function Common.getSkill(val)
  local dict = {
    [1] = AI.Skill.AVERAGE,
    [2] = AI.Skill.GOOD,
    [3] = AI.Skill.HIGH,
    [4] = AI.Skill.EXCELLENT,
    [5] = AI.Skill.PLAYER,
  }
  return dict[val] or AI.Skill.EXCELLENT
end

function Common.getWaypointType(val)
  local dict = {
    [1] = AI.Task.WaypointType.TAKEOFF,
    [2] = AI.Task.WaypointType.TAKEOFF_PARKING,
    [3] = AI.Task.WaypointType.TURNING_POINT,
    [4] = AI.Task.WaypointType.TAKEOFF_PARKING_HOT,
    [5] = AI.Task.WaypointType.LAND,
    [6] = "TakeOffGround",
    [7] = "TakeOffGroundHot", --because there is no constant
  }
  return dict[val] or AI.Task.WaypointType.TURNING_POINT
end

function Common.getWaypointAction(val)
 local dict = {
    [1] = "Off Road",
    [2] = "On Road",
    [3] = "Turning Point",
    [4] = "Landing",
  }
  return dict[val] or ""
end
GRPC.Common = Common
