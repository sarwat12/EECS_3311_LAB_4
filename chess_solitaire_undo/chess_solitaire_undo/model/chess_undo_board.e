note
	description: "Summary description for {CHESS_UNDO_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHESS_UNDO_BOARD
inherit
	ANY
		redefine
			out
		end

create
	make

feature --Constructor
	make
		do
			create board.make_filled (create {EMPTY}.make ("NULL"), 4, 4)
		ensure
			empty_board:
				across 1 |..| 4 is i all
					across 1 |..| 4 is j all
						board.item (i, j).type ~ "NULL"
					end
				end
		end

feature --Board Implementation
	board: ARRAY2[CHESS_PIECE] --multi-dimesional board for storing and representing chess pieces
	x: INTEGER --for later use in ETF_MOVES
	y: INTEGER --for later use in ETF_MOVES
	moves_trigger: INTEGER  --signal for initiating ET_MOVES output

feature --Commands

	capture(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER)
		do
			board.force (board.item (r1, c1), r2, c2)
			board.force (create {EMPTY}.make ("NULL"), r1, c1)
		end

	print_moves(row: INTEGER_32 ; col: INTEGER_32): STRING
	do
		create Result.make_empty
		across 1 |..| 4 is i loop
			Result.append ("  ")
			across 1 |..| 4 is j loop
				if i = row and j = col then
					Result.append(board.item (i, j).type)
				else
					if board.item (row, col).is_valid_move (row, col, i, j) then
						Result.append("+")
					else
						Result.append (".")
					end
				end
			end
			if i /= 4 then
				Result.append ("%N")
			end
		end
	end

	print_board: STRING
		do
			create Result.make_empty
			across 1 |..| 4 is i loop
				Result.append ("  ")
				across 1 |..| 4 is j loop
					if board.item (i, j).type ~ "NULL" then
						Result.append(".")
					else
						Result.append (board.item (i, j).type)
					end
				end
				if i /= 4 then
					Result.append ("%N")
				end
			end
		end

		set_moves_trigger
			do
				moves_trigger := 1
			end

		set_x(row : INTEGER)
			do
				x := row
			end

		set_y(col : INTEGER)
			do
				y := col
			end

feature --Redefined 'out' feature
	out: STRING
		do
			create Result.make_empty
			if moves_trigger = 1 then
				Result.append(print_moves(x,y))
				moves_trigger := 0
			else
				Result.append (print_board)
			end
		end

invariant
	--Maximum available slots are '16'
	four_by_four_board:
		board.count <= 16
end
