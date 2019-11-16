note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_CHESS
inherit
	ETF_SETUP_CHESS_INTERFACE
create
	make
feature -- command
	setup_chess(c: INTEGER_32 ; row: INTEGER_32 ; col: INTEGER_32)
		require else
			setup_chess_precond(c, row, col)
    	do
			-- perform some update on the model state
			if (model.game_started = TRUE) then
				model.set_error ("  Error: Game already started%N")
			elseif row < 1 or row > 4 or col < 1 or col > 4 then
				model.set_error ("  Error: (" + row.out + ", " + col.out + ") not a valid slot%N")
			elseif model.chess_board.board.item (row, col).type /~ "NULL" then
				model.set_error ("  Error: Slot @ (" + row.out + ", " + col.out + ") already occupied%N")
			elseif model.game_started = FALSE and model.chess_board.board.item (row, col).type ~ "NULL" then
				model.set_error ("  Game being Setup...%N")
				model.setup_chess(c, row, col)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
