# TODO later

Issues found while reviewing the `claude-init` branch against `main` (for the CHANGELOG/STATUS update).

## Bugs

- [ ] **Helicopter spawn passes the wrong data.** In `lua/DCS-gRPC/methods/coalitions.lua` (`GRPC.methods.spawnGroup`),
  the `helicopter` branch calls `spawnAircraftGroup(params.groupData.airplane)`. It should use
  `params.groupData.helicopter`. As it is, helicopter spawns get `nil` data.
- [ ] **Wind RPCs still read the old field.** `getWind` and `getWindWithTurbulence` in
  `lua/DCS-gRPC/methods/atmosphere.lua` use `params.position.lat/lon/alt`, but the proto field is now
  `InputCoordinates point`. Switch them to `GRPC.Common.extractPosition(params.point)` like
  `getTemperatureAndPressure`.
- [ ] **`require "inspect"` in the mission environment.** `methods/common.lua` and `methods/coalitions.lua` call
  `require "inspect"`, but a standard `MissionScripting.lua` sanitizes `require`. Those files fail to load unless your
  setup puts `require` back. The `Inspect` local in `coalitions.lua` is unused.
- [ ] **The unimplemented-event log can crash.** In `methods/mission.lua`:
  `"Skipping unimplemented event id " .. GRPC.dcsEventsMap[event.id] or tostring(event.id)`. `..` binds tighter
  than `or`, so it concatenates `nil` and throws for unmapped events. Add brackets:
  `.. (GRPC.dcsEventsMap[event.id] or tostring(event.id))`.
- [ ] **`onPlayerConnect` can fail on a nil `playerInfo`.** In `lua/DCS-gRPC/grpc-hook.lua`,
  `playerId = playerInfo.id` sits outside the `if playerInfo` guard. Use the `playerId` argument instead.
- [ ] **The stubs test probably fails.** The uncommitted edit in `stubs/src/lib.rs` expects `runtime_id: 37`, but the
  test JSON has no `runtimeId`. `UnitIntermediate.runtime_id` is a non-optional `u32`, so deserialization fails. Add
  `"runtimeId": 37` to the JSON or make the field `#[serde(default)]`.

## To verify

- [ ] Check the `or true` defaults in `coalitions.lua`. `common.hiddenOnMfd or true`, `common.taskSelected or true`,
  `unitParams.playerCanDrive or true` and `params.communication or true` are always `true`, even when the client
  sends `false`.
- [ ] Check whether `groupData.communitcation` in `spawnAircraftGroup` is a typo for `communication`.
- [ ] `HumanAircraftRepairStart` / `HumanAircraftRepairFinish` are defined in the proto but nothing in
  `GRPC.onDcsEvent` emits them.

## Cleanup

- [ ] Remove the noisy debug logging: the `GRPC.logInfo` calls in `Common.extractPosition` and the weapon exporter
  (`"Export Weapon category ..."`) run on every call, and the `landingAfterEjection` event logs every time.
  `log.debug("GRPC mission.lue entry")` in `mission.lua` also has a typo.
- [ ] `src/stream.rs`: the heading/speed checks in `velocity_equalish` are commented out rather than removed, and
  there is trailing whitespace in the `UnitGone` literals (`cargo fmt` will flag it).
- [ ] Remove the leftover `--dcsme` / `---dcsme` markers at the top of the Lua files.
