note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_AND_CAPTURE
inherit
	ETF_MOVE_AND_CAPTURE_INTERFACE
create
	make
feature -- command
	move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)
    	do
			-- perform some update on the model state
			if model.game_finished = TRUE then
				model.set_error ("  Error: Game already over%N")
			elseif model.game_started = FALSE then
				model.set_error ("  Error: Game not yet started%N")
			elseif r1 = r2 and c1 = c2 then
				model.set_error ("  Error: Invalid move of " + model.chess_board.board.item (r1, c1).type + " from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
			elseif r1 < 1 or r1 > 4 or c1 < 1 or c1 > 4 then
				model.set_error ("  Error: (" + r1.out + ", " + c1.out + ") not a valid slot%N")
			elseif r2 < 1 or r2 > 4 or c2 < 1 or c2 > 4 then
				model.set_error ("  Error: (" + r2.out + ", " + c2.out + ") not a valid slot%N")
			elseif model.chess_board.board.item (r1, c1).type ~ "NULL" then
				model.set_error ("  Error: Slot @ (" + r1.out + ", " + c1.out + ") not occupied%N")
			elseif model.chess_board.board.item (r2, c2).type ~ "NULL" then
				model.set_error ("  Error: Slot @ (" + r2.out + ", " + c2.out + ") not occupied%N")
			else
				model.move_and_capture(r1, c1, r2, c2)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
