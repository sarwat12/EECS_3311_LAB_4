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
    	do
			-- perform some update on the model state
			if model.game_started = TRUE then
				model.set_error ("  Error: Game already started%N")
			else
				model.start_game
				if model.num_pieces = 1 then
					model.set_error ("  Game Over: You Win!%N")
					model.set_game_finished (TRUE)
				else
					model.set_error ("  Game In Progress...%N")
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
