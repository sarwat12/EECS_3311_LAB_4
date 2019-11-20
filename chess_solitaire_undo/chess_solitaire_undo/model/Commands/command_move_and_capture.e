note
	description: "Summary description for {COMMAND_MOVE_AND_CAPTURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_MOVE_AND_CAPTURE

inherit
	COMMAND

create
	make

feature --Constructor
	make(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)
		do
			row1 := r1
			col1 := c1
			row2 := r2
			col2 := c2
			predator := chess.chess_board.board.item (r1, c1)
			prey := chess.chess_board.board.item (r2, c2)
		end

feature --Attributes specific to move and capture
	row1: INTEGER
	col1: INTEGER
	row2: INTEGER
	col2: INTEGER
	predator: CHESS_PIECE
	prey: CHESS_PIECE

feature --features specific to move_and_capture

	execute
		do
			chess.move_and_capture (row1, col1, row2, col2)
		end

	undo
		do
			if chess.game_finished = TRUE then
				chess.set_game_finished (FALSE)
			end
			chess.chess_board.board.put (predator, row1, col1)
			chess.chess_board.board.put (prey, row2, col2)
			chess.increase_num_pieces
			chess.set_error ("  Game In Progress...%N")
		end

	redo
		do
			chess.move_and_capture (row1, col1, row2, col2)
		end

end
