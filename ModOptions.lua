
--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local options = {
	{
		key 	= "ote",
		name 	= "OTE Options",
		desc 	= "OTE Options",
		type	= "section",
	},
	{
		key 	= "mission_name",
		name 	= "Mission",
		desc 	= "Mission selection",
		type 	= "string",
		def 	= "none",
		section = "ote",
	},
	{
		key 	= "startoptions",
		name 	= "Game Modes",
		desc 	= "Change the game mode",
		type 	= "list",
		def 	= "normal",
		section = "ote",
		items 	= {
			{key = "normal", name = "Normal", desc = "Normal game mode"},
		}
	},
	-- updates
	{
		key 	= "noe",
		name 	= "NOE options",
		desc 	= "Options of NOE framework",
		type	= "section",
	},
	{
		key 	= "noeautooff",
		name 	= "autoOFF",
		desc 	= "Is framework OFF when no NOE AI is added in game (as any other purpose?)",
		type 	= "bool",
		def 	= false,
		section = "noe",
	},
}

return options

