note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_START_GAME
inherit
	ETF_START_GAME_INTERFACE
create
	make
feature -- command
	start_game
    	local
    		command: COMMAND_START_GAME
    	do
			-- perform some update on the model state
			if model.game_started = TRUE then
				model.set_error ("  Error: Game already started%N")
			else
				create command.make(TRUE)
				model.history.add_command (command)
				command.execute
				model.set_start_game_redo_trigger (TRUE)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
