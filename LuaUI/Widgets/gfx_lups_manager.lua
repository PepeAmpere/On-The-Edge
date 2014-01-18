-- $Id: gfx_lups_manager.lua 3638 2009-01-02 23:42:29Z licho $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  author:  jK
--
--  Copyright (C) 2007,2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "LupsManager",
    desc      = "",
    author    = "jK",
    date      = "Feb, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 10,
    enabled   = true,
    handler   = true,
  }
end


include("Configs/lupsFXs.lua")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function MergeTable(table1,table2)
  local result = {}
  for i,v in pairs(table2) do 
    if (type(v)=='table') then
      result[i] = MergeTable(v,{})
    else
      result[i] = v
    end
  end
  for i,v in pairs(table1) do 
    if (result[i]==nil) then
      if (type(v)=='table') then
        if (type(result[i])~='table') then result[i] = {} end
        result[i] = MergeTable(v,result[i])
      else
        result[i] = v
      end
    end
  end
  return result
end


local function blendColor(c1,c2,mix)
  if (mix>1) then mix=1 end
  local mixInv = 1-mix
  return {
    c1[1]*mixInv + c2[1]*mix,
    c1[2]*mixInv + c2[2]*mix,
    c1[3]*mixInv + c2[3]*mix,
    (c1[4] or 1)*mixInv + (c2[4] or 1)*mix
  }
end


local function blend(a,b,mix)
  if (mix>1) then mix=1 end
  return a*(1-mix) + b*mix
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local UnitEffects = {}

local function AddFX(unitname,fx)
  local ud = UnitDefNames[unitname]
  if ud then
    UnitEffects[ud.id] = fx
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--// ENERGY STORAGE //--------------------

AddFX("roost", {
    {class='SimpleParticles',options=roostDirt},
    {class='SimpleParticles',options=MergeTable({delay=60},roostDirt)},
    {class='SimpleParticles',options=MergeTable({delay=120},roostDirt)},
  })

--AddFX("armrad", {
  --  {class='RadarParticles',options=radarBlink},
--  })
--AddFX("corrad", {
--    {class='RadarParticles',options=radarBlink},
--  })


--// SEA PLANES //----------------------------
AddFX("armseap", {
    {class='AirJet',options={color={0.6,0.4,0.1}, width=3.7, length=13, piece="nozzle", onActive=true}},
  })
AddFX("armsfig", {
    {class='AirJet',options={color={0.6,0.4,0.1}, width=3.3, length=13, piece="nozzle", onActive=true}},
  })
AddFX("corsfig", {
    {class='AirJet',options={color={0.6,0.4,0.1}, width=3.5, length=13, piece="nozzle", onActive=true}},
  })
AddFX("corseap", {
    {class='AirJet',options={color={0.1,0.4,0.6}, width=3.5, length=13, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.1,0.4,0.6}, width=3.5, length=13, piece="nozzle2", onActive=true}},
  })

--// PLANES //----------------------------
AddFX("armfig", {
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=12, piece="rearthrustbox1", onActive=true}},
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=12, piece="rearthrustbox2", onActive=true}},
  })
AddFX("armhawk", {
    {class='AirJet',options={color={0.5,0.1,0}, width=5, length=12, piece="rearthrust", onActive=true}},
  })
AddFX("blade", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=15, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=15, piece="nozzle2", onActive=true}},
  })
AddFX("armtoad", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle", onActive=true}},
  })
AddFX("armhell", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle", onActive=true}},
  })
AddFX("armawac", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle", onActive=true}},
  })
AddFX("armangel", {
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=22, piece="nozzle", onActive=true}},
    {class='Ribbon',options={piece="wingtip1"}},
    {class='Ribbon',options={piece="wingtip2"}},
  })
AddFX("armthund", {
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=10, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=10, piece="nozzle2", onActive=true}},
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=10, piece="nozzle3", onActive=true}},
    {class='AirJet',options={color={0.0,0.1,0.6}, width=3.5, length=10, piece="nozzle4", onActive=true}},
  })
AddFX("armlance", {
    {class='AirJet',options={color={0.6,0.1,0}, width=7.0, length=16, piece="nozzle", onActive=true}},
  })
AddFX("armpnix", {
    {class='AirJet',options={color={0.6,0.4,0}, width=4.5, length=10, piece="nozzle", onActive=true}},
  })
AddFX("armwing", {
    {class='AirJet',options={color={0.6,0.3,0.3}, width=4.5, length=10, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.6,0.3,0.3}, width=4.5, length=10, piece="nozzle2", onActive=true}},
    {class='AirJet',options={color={0.6,0.3,0.3}, width=4.5, length=10, piece="nozzle3", onActive=true}},
  })

AddFX("cortitan", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle", onActive=true}},
  })
AddFX("corshad", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle2", onActive=true}},
  })
AddFX("corhurc", {
    {class='AirJet',options={color={0.6,0.1,0}, width=5.0, length=11, piece="nozzle", onActive=true}},
  })
AddFX("corevashp", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle", onActive=true}},
  })
AddFX("corveng", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle2", onActive=true}},
  })
AddFX("corgryp", {
    {class='AirJet',options={color={0.6,0.4,0}, width=4.5, length=15, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.6,0.4,0}, width=4.5, length=15, piece="nozzle2", onActive=true}},
  })
AddFX("corerb", {
    {class='AirJet',options={color={0.6,0.2,0.1}, width=3.5, length=13, piece="nozzle1", onActive=true}},
    {class='AirJet',options={color={0.6,0.2,0.1}, width=3.5, length=13, piece="nozzle2", onActive=true}},
  })
AddFX("corvamp", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=12, piece="nozzle", onActive=true}},
  })
AddFX("corawac", {
    {class='AirJet',options={color={0.6,0.1,0}, width=3.5, length=11, piece="nozzle", onActive=true}},
  })
AddFX("armkam", {
	{class='AirJet',options={color={0.1,0.4,0.6}, width=3.5, length=12, piece="lfx", onActive=true, emitVector = {0, 0, 1}}},
	{class='AirJet',options={color={0.1,0.4,0.6}, width=3.5, length=12, piece="rfx", onActive=true, emitVector = {0, 0, 1}}},
  })


--// ^-^
local t = os.date('*t')
if (t.month==12) then
  AddFX("armcom", {
    {class='SantaHat',options={color={0,0.7,0,1}, pos={0,4,0.35}, emitVector={0.3,1,0.2}, width=2.7, height=6, ballSize=0.7, piece="head"}},
  })
  AddFX("corcom", {
    {class='SantaHat',options={pos={0,6,2}, emitVector={0.4,1,0.2}, width=2.7, height=6, ballSize=0.7, piece="head"}},
  })
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local abs = math.abs
local min = math.min
local max = math.max
local spGetSpectatingState = Spring.GetSpectatingState
local spGetUnitDefID       = Spring.GetUnitDefID
local spGetUnitRulesParam  = Spring.GetUnitRulesParam

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Lups  -- Lua Particle System
local LupsAddFX
local particleIDs = {}
local initialized = false --// if LUPS isn't started yet, we try it once a gameframe later
local tryloading  = 1     --// try to activate lups if it isn't found

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function ClearFxs(unitID)
  if (particleIDs[unitID]) then
    for _,fxID in ipairs(particleIDs[unitID]) do
      Lups.RemoveParticles(fxID)
    end
    particleIDs[unitID] = nil
  end
end


local function AddFxs(unitID,fxID)
  if (not particleIDs[unitID]) then
    particleIDs[unitID] = {}
  end

  local unitFXs = particleIDs[unitID]
  unitFXs[#unitFXs+1] = fxID
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Shutdown()
  if (initialized) then
    for _,unitFxIDs in pairs(particleIDs) do
      for _,fxID in ipairs(unitFxIDs) do
        Lups.RemoveParticles(fxID)
      end
    end
    particleIDs = {}
  end

  Spring.SendLuaRulesMsg("lups shutdown","allies")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function UnitFinished(_,unitID,unitDefID)
  local effects = UnitEffects[unitDefID]
  if (effects) then
    for _,fx in ipairs(effects) do
      if (fx.class=="GroundFlash") then
        fx.options.pos = { Spring.GetUnitBasePosition(unitID) }
      end
      fx.options.unit = unitID
      AddFxs( unitID,LupsAddFX(fx.class,fx.options) )
      fx.options.unit = nil
    end
  end
end

local function UnitDestroyed(_,unitID,unitDefID)
  ClearFxs(unitID)
end


local function UnitEnteredLos(_,unitID)
  local spec, fullSpec = spGetSpectatingState()
  if (spec and fullSpec) then return end
  local unitDefID = spGetUnitDefID(unitID)
  local effects   = UnitEffects[unitDefID]
  if (effects) then
    for _,fx in ipairs(effects) do
      if (fx.class=="GroundFlash") then
        fx.options.pos = { Spring.GetUnitBasePosition(unitID) }
      end
      fx.options.unit = unitID
      AddFxs( unitID,LupsAddFX(fx.class,fx.options) )
      fx.options.unit = nil
    end
  end
end


local function UnitLeftLos(_,unitID)
  local spec, fullSpec = spGetSpectatingState()
  if (spec and fullSpec) then return end
  ClearFxs(unitID)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local color1 = {0,0,0}
local color2 = {1,0.5,0}

local function GameFrame(_,n)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Update()
  if (Spring.GetGameFrame()<1) then 
    return
  end

  Lups  = WG['Lups']
  local LupsWidget = widgetHandler.knownWidgets['Lups'] or {}

  --// Lups running?
  if (Lups and LupsWidget.active) then
    if (tryloading==-1) then
      Spring.Echo("LuaParticleSystem (Lups) activated.")
    end
    initialized=true
  else
    if (tryloading==1) then
      Spring.Echo("Lups not found! Trying to activate it.")
      widgetHandler:EnableWidget("Lups")
      tryloading=-1
      return
    else
      Spring.Echo("LuaParticleSystem (Lups) couldn't be loaded!")
      widgetHandler:RemoveWidgetCallIn("Update",self)
      return
    end
  end

  --// send errorlog if me (jK) is in the game
  local allPlayers = Spring.GetPlayerList()
  for i=1,#allPlayers do
    local playerName = Spring.GetPlayerInfo(allPlayers[i])
    if (playerName == "[LCC]jK") then
      local errorLog = Lups.GetErrorLog(1)
      if (errorLog~="") then
        local cmds = {
          "say ------------------------------------------------------",
          "say LUPS: jK is here! Sending error log (so he can fix your problems):",
        }
        --// the str length is limited with "say ...", so we split it
        for line in errorLog:gmatch("[^\r\n]+") do
          cmds[#cmds+1] = "say " .. line
        end
        cmds[#cmds+1] = "say ------------------------------------------------------"
        Spring.SendCommands(cmds)
      end
      break
    end
  end

  LupsAddFX = Lups.AddParticles

  Spring.SendLuaRulesMsg("lups running","allies")

  --// initialize effects for existing units
  local allUnits = Spring.GetAllUnits(); allUnits.n = nil;
  for _,unitID in ipairs(allUnits) do
    local unitDefID = Spring.GetUnitDefID(unitID)
    UnitFinished(nil,unitID,unitDefID)
  end

  self.UnitFinished   = UnitFinished
  self.UnitDestroyed  = UnitDestroyed
  self.UnitEnteredLos = UnitEnteredLos
  self.UnitLeftLos    = UnitLeftLos
  self.GameFrame      = GameFrame
  widgetHandler:UpdateWidgetCallIn("UnitFinished",self)
  widgetHandler:UpdateWidgetCallIn("UnitDestroyed",self)
  widgetHandler:UpdateWidgetCallIn("UnitEnteredLos",self)
  widgetHandler:UpdateWidgetCallIn("UnitLeftLos",self)
  widgetHandler:UpdateWidgetCallIn("GameFrame",self)

  widgetHandler:RemoveWidgetCallIn("Update",self)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
