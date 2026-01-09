--
--RPC Weapon actions
--

GRPC.methods.getWeaponTransform = function(params)
  local weapon = GRPC.weaponsLookup[params.id]
  if weapon and weapon:isExist() then
    return GRPC.success({
      time = timer.getTime(),
      rawTransform = GRPC.exporters.rawTransform(weapon)
    })
  else
    GRPC.weaponsLookup[params.id] = nil
    return GRPC.success({
      time = timer.getTime(),
      rawTransform = nil
    })
  end
end
