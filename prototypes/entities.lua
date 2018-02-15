require ("circuit-connector-sprites")

local Sequencer = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
Sequencer.name = "Sequencer"
Sequencer.icon = "__GUI_TEST__/graphics/ITEM.png"
Sequencer.icon_size = 40
Sequencer.item_slot_count = 1
Sequencer.minable.result = "Sequencer"

local sprite = {
  filename = "__GUI_TEST__/graphics/ITEM.png",
  width = 40,
  height = 40,
  frame_count = 1,
  shift = {0.0, 0.0},
}

Sequencer.sprites = {
  north = sprite,
  east = sprite,
  south = sprite,
  west = sprite,
}

local activity_led_light_offset = {0, 0}
local activity_led_sprite = {
  filename = "__GUI_TEST__/graphics/ITEM.png",
  width = 40,
  height = 40,
  frame_count = 1,
  shift = activity_led_light_offset,
}

Sequencer.activity_led_sprites = {
  north = activity_led_sprite,
  east  = activity_led_sprite,
  south = activity_led_sprite,
  west  = activity_led_sprite, }

activity_led_light = {
  intensity = 0.0,
  size = 0.0,}

local circuit_wire_connection_points = {
  shadow = {
    red = {-0.35, 0.45},
    green = {-0.4, 0.45},
  },
  wire = {
    red = {-0.35, 0.45},
    green = {-0.4, 0.45},
  }}

Sequencer.circuit_wire_connection_points = {
  circuit_wire_connection_points,
  circuit_wire_connection_points,
  circuit_wire_connection_points,
  circuit_wire_connection_points,
}

circuit_wire_max_distance = default_circuit_wire_max_distance,
data:extend{Sequencer}
