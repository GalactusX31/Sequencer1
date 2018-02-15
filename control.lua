script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  player.cheat_mode=true
  player.character_mining_speed_modifier=1000
  player.force.research_all_technologies()
  player.surface.always_day=true
end)

script.on_event({
  defines.events.on_player_joined_game,
  defines.events.on_player_respawned},
  function(event)
    init_gui()
end)

function init_gui()
	if game ~= nil then
		for k, player in pairs(game.players) do
		end
	end
end

ItemIDTable = {}
local IDItem = ''
local TaskCount = 0


local function onBuilt(event)
  local ModItem = event.created_entity

  if ModItem == "Sequencer" then
    local control = ModItem.get_or_create_control_behavior()
    control.enabled=false
    IDItem = tostring(ModItem.unit_number)
    table.insert(ItemIDTable,ModItem.unit_number)
  end
end

local function onPaste(event)
  local ModItem = event.destination
  if ModItem.name == "Sequencer" then
    local control = ModItem.get_or_create_control_behavior()
    control.enabled=false
  end
end

script.on_event(defines.events.on_gui_opened, function(event)
  local MainFrame = game.players[event.player_index].gui.center['MainFlow']
  local player = game.players[event.player_index]
  local entity = player.selected
  if entity == nil and MainFrame ~= nil then
    MainFrame.destroy()
    tabletext.destroy()
  elseif entity ~= nil and entity.name == "Sequencer" then
    player.opened = nil
    if MainFrame == nil then
      IDItem = tostring(entity.unit_number)
      game.print(entity.unit_number)
      SpawnGUI(player)
    elseif MainFrame ~= nil then
      MainFrame.destroy()
      tabletext.destroy()
    end
  end
end)

script.on_event(defines.events.on_gui_closed, function(event)
  local MainFrame = game.players[event.player_index].gui.center['frame']
  if MainFrame ~= nil then
    MainFrame.destroy()
    tabletext.destroy()
  end
end)

function SpawnGUI(player,EntityName)
  MainFrame = player.gui.center.add{type='flow',name='MainFlow',direction='vertical'}
    MainFrame.style.width = 310
---------------------------------------------------------------------------------------------------------
  tabletext = player.gui.center.add{type='frame',name='tabletext',direction='vertical'}
    tabletext.style.minimal_width = 300
    tabletext.style.minimal_height = 300
    tabletext.add{type='button',name='loadtable',caption='Load Table'}
    tabletext.add{type='text-box',name='texttable'}
    tabletext.texttable.style.minimal_width = tabletext.style.minimal_width
    tabletext.texttable.style.maximal_width = tabletext.style.maximal_width
    tabletext.texttable.style.minimal_height = 300--tabletext.style.minimal_height
    tabletext.texttable.style.maximal_height = 300--tabletext.style.maximal_height
---------------------------------------------------------------------------------------------------------
  MainTable = MainFrame.add{type='table',name='MainTable',column_count=4}
    MainTable.add{type='sprite-button',name='Config',sprite='Config-icon',tooltip='Configuration'}
    MainTable.add{type='sprite-button',name='Sequential',sprite='Sequential-icon',tooltip='Sequential task panel'}
    MainTable.add{type='flow',name='flowSeparator1'}
    MainTable.add{type='sprite-button',name='InfoConfig',sprite='Info-icon',tooltip='Info'}
    MainFrame.add{type='frame',name='frameConfig',direction='vertical'}
      MainFrame.frameConfig.style.width = 300
      MainTable.flowSeparator1.style.minimal_width = MainFrame.frameConfig.style.minimal_width - 125

  FlowConfig1 = MainFrame.frameConfig.add{type='flow',name='FlowConfig1',direction='vertical'}

  TableConfig = FlowConfig1.add{type='table',name='TableConfig',column_count=2}
    TableConfig.add{type='label',name='EnabledCondition',caption='Enabled Signal Condition'} TableConfig.add{type='flow'}
    TableConfig.add{type="choose-elem-button", name="chooseitem", caption='1',elem_type="signal"} TableConfig.add{type='flow'}
  ON_OFF = FlowConfig1.add{type='table',name='ON_OFF',column_count=2}
    ON_OFF.add{type="radiobutton", name="Work_ON", caption="On",state=false}
    ON_OFF.add{type="radiobutton", name="Work_OFF", caption="Off",state=true}
  separator1 = FlowConfig1.add{type='frame',name='separator1'}
    separator1.style.minimal_width = MainFrame.frameConfig.style.minimal_width - 20
    separator1.style.maximal_height = 5
  TableConfig2 = FlowConfig1.add{type='table',name='TableConfig2',column_count=3} TableConfig2.style.align='center'
    TableConfig2.add{type='label',name='ConfigTime',caption='Time'}
    TableConfig2.add{type='label',name='SignaltoSend',caption='Signal'}
    TableConfig2.add{type='flow'}
    TableConfig2.add{type='textfield',name='InputConfigTime1',text='0'}
      TableConfig2.InputConfigTime1.style.width = MainFrame.frameConfig.style.minimal_width - 105
      TableConfig2.add{type='choose-elem-button', name='ChoseSignalTask', elem_type='signal'}
      TableConfig2.add{type='sprite-button',name='OKAdd',sprite='OK-icon',tooltip='Sequential task panel',valid=false}
--#Sequential_task_panel
  MainFrame.add{type='frame',name='SequentialPanel',direction='vertical'}
    MainFrame.SequentialPanel.style.visible=false
    MainFrame.SequentialPanel.style.minimal_width = MainFrame.frameConfig.style.minimal_width
    MainFrame.SequentialPanel.style.maximal_width = MainFrame.frameConfig.style.minimal_width
    MainFrame.SequentialPanel.style.height = 395
    MainFrame.SequentialPanel.add{type='label',name='TaskPanelLabel',caption='Sequential task panel'}
  TaskPanelScroll = MainFrame.SequentialPanel.add{type='scroll-pane',name='TaskPanelScroll',align='left',direction='vertical'}
    TaskPanelScroll.style.width = MainFrame.frameConfig.style.minimal_width - 23
    TaskPanelScroll.style.minimal_height = MainFrame.SequentialPanel.style.minimal_height - 45
end

function LoadTable()
  tabletext.texttable.text = ''
  local ID = tostring(IDItem)
    if ItemIDTable.ID ~= nil then
      for key, v in pairs(ItemIDTable.ID) do
        local a = ItemIDTable.ID[key][1]
        local b = ItemIDTable.ID[key][2]
        tabletext.texttable.text =  tabletext.texttable.text .. key .. ' - ' .. 'Time: ' .. a .. '  Signal:' .. b.name ..'\n'
      end
    end
end

function AddTask()
  local VALUE = TableConfig2.ChoseSignalTask.elem_value
  local TEXTIME = TableConfig2.InputConfigTime1.text
  local TOOLTIP = TableConfig2.ChoseSignalTask.tooltip
  local ID = IDItem

  if TEXTIME ~= '0' and TEXTIME ~= '' and VALUE ~= nil then
    if ItemIDTable.ID ~= ID then
    ItemIDTable = {ID = {}}
  elseif ItemIDTable.ID == ID then
    table.insert(ItemIDTable.ID,{TEXTIME,VALUE})
    Task = TaskPanelScroll.add{type='flow',name='' .. TaskCount}
    Task.add{type='label', name='label',caption=TaskCount}
    Task.add{type='textfield',name='InputConfigTime2',align='right'} Task.InputConfigTime2.style.height=36
    Task.add{type='choose-elem-button', name='ChoseSignalTask', elem_type='signal'}
    Task.ChoseSignalTask.elem_value = VALUE
    Task.add{type='sprite-button',name='RemoveTask',sprite='Remove-icon',tooltip='Remove signal task'}
    Task.InputConfigTime2.text = TEXTIME
    Task.add{type='label',caption=index}
    TaskCount = TaskCount +1
    game.print(VALUE.type .. '/' .. VALUE.name)
  end
  end
end

script.on_event(defines.events.on_gui_text_changed, function(event)
  local elementname = event.element.name

  if elementname == 'InputConfigTime1' then
    local text = TableConfig2.InputConfigTime1.text
    i = string.match(text, "[0-9]+")
    if i ~= nil then
      TableConfig2.InputConfigTime1.text = i
    end
  elseif elementname == 'InputConfigTime2' then
    game.print(tostring(Task.name))
    local text = Task.InputConfigTime2.text
    i = string.match(text, "[0-9]+")
    if i ~= nil then
      Task.InputConfigTime2.text = i
    end
  end
end)

--# This control the events when we click on any gui element
script.on_event(defines.events.on_gui_click, function(event)
  local player = game.players[event.player_index]
  local Elementparent = event.element.parent
  local elementname = event.element.name
    if elementname == 'Work_OFF' then
      ON_OFF.Work_ON.state=false
    elseif elementname == 'Work_ON' then
      ON_OFF.Work_OFF.state=false
    elseif elementname == 'Sequential' then
      MainFrame.frameConfig.style.visible = false
      MainFrame.SequentialPanel.style.visible = true
    elseif elementname == 'Config' then
      MainFrame.frameConfig.style.visible = true
      MainFrame.SequentialPanel.style.visible = false
    elseif elementname == 'OKAdd' then
      AddTask()
    elseif elementname == 'RemoveTask' then
      event.element.parent.destroy()
    elseif elementname == 'loadtable' then
      LoadTable()
    end
end)

script.on_event(defines.events.on_built_entity, onBuilt)
script.on_event(defines.events.on_robot_built_entity, onBuilt)
script.on_event(defines.events.on_entity_settings_pasted,onPaste)
