note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_RESET_GAME
inherit
	ETF_RESET_GAME_INTERFACE
create
	make
feature -- command
	reset_game
    	do
			-- perform some update on the model state
			if model.game_started = FALSE then
				model.set_error ("  Error: Game not yet started%N")
			else
				model.reset_game
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
