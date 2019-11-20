note
	description: "Summary description for {COMMAND_SETUP_CHESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_SETUP_CHESS

inherit
	COMMAND

create
	make

feature --Constructor
	make(piece: INTEGER_32 ; r: INTEGER_32 ; c: INTEGER_32)
		do
			chess_piece := piece
			row:= r
			col := c
		end

feature --Attributes specific to setup chess
	chess_piece: INTEGER_32
	row: INTEGER_32
	col: INTEGER_32

feature --Features specific to setup chess
	execute
		do
			chess.setup_chess (chess_piece, row, col)
		end

	undo
		do
			chess.chess_board.board.put (create {EMPTY}.make ("NULL"), row, col)
			chess.decrease_num_pieces
			chess.set_error ("  Game being Setup...%N")
		end

	redo
		do
			chess.setup_chess (chess_piece, row, col)
			chess.set_error ("  Game being Setup...%N")
		end

end
