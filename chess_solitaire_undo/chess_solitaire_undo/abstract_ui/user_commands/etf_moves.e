note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVES
inherit
	ETF_MOVES_INTERFACE
create
	make
feature -- command
	moves(row: INTEGER_32 ; col: INTEGER_32)
    	do
			-- perform some update on the model state
			if model.game_finished = TRUE then
				model.set_error ("  Error: Game already over%N")
			elseif model.game_started = FALSE then
				model.set_error ("  Error: Game not yet started%N")
			elseif row < 1 or row > 4 or col < 1 or col > 4 then
				model.set_error ("  Error: (" + row.out + ", " + col.out + ") not a valid slot%N")
			elseif model.chess_board.board.item (row, col) = 0 then
				model.set_error ("  Error: Slot @ (" + row.out + ", " + col.out + ") not occupied%N")
			else
				model.moves(row, col)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
