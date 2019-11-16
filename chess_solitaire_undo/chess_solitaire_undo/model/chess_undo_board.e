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
			create board.make_filled (0, 4, 4)
			create piece_mapping.make_empty
			set_mapping
		ensure
			empty_board:
				across 1 |..| 4 is i all
					across 1 |..| 4 is j all
						board.item (i, j) = 0
					end
				end
		end

feature --Board Implementation
	board: ARRAY2[INTEGER] --multi-dimesional board for storing and representing chess pieces
	piece_mapping: ARRAY[STRING]  --Mapping for each chess piece to its corresponding integer
	x: INTEGER --for later use in ETF_MOVES
	y: INTEGER --for later use in ETF_MOVES
	moves_trigger: INTEGER  --signal for initiating ET_MOVES output

feature --Commands

	capture(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER)
		do
			board.force (board.item (r1, c1), r2, c2)
			board.force (0, r1, c1)
		end

    set_mapping
		do
			piece_mapping.force ("K", piece_mapping.count + 1)
			piece_mapping.force ("Q", piece_mapping.count + 1)
			piece_mapping.force ("N", piece_mapping.count + 1)
			piece_mapping.force ("B", piece_mapping.count + 1)
			piece_mapping.force ("R", piece_mapping.count + 1)
			piece_mapping.force ("P", piece_mapping.count + 1)
		end

	print_moves(row: INTEGER_32 ; col: INTEGER_32): STRING
	do
		create Result.make_empty
		across 1 |..| 4 is i loop
				Result.append ("  ")
				across 1 |..| 4 is j loop
					if i = row and j = col then
						Result.append(piece_mapping.item (board.item (i, j)))
					else
						if piece_mapping.item (board.item (row, col)) ~ "K" then
							if king_is_valid_move (row, col, i, j) then
								Result.append("+")
							else
								Result.append (".")
							end  --and (not block_exists_queen (row, col, i, j))
						elseif piece_mapping.item (board.item (row, col)) ~ "Q" then
							if queen_is_valid_move (row, col, i, j) then
								Result.append("+")
							else
								Result.append (".")
							end
						elseif piece_mapping.item (board.item (row, col)) ~ "B" then
							if bishop_is_valid_move (row, col, i, j) then
								Result.append("+")
							else
								Result.append (".")
							end
						elseif piece_mapping.item (board.item (row, col)) ~ "N" then
							if knight_is_valid_move (row, col, i, j) then
								Result.append("+")
							else
								Result.append (".")
							end
						elseif piece_mapping.item (board.item (row, col)) ~ "R" then
							if rook_is_valid_move (row, col, i, j) then
								Result.append("+")
							else
								Result.append (".")
							end
						elseif piece_mapping.item (board.item (row, col)) ~ "P" then
							if pawn_is_valid_move (row, col, i, j) then
								Result.append("+")
							else
								Result.append (".")
							end
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
					if board.item (i, j) ~ 0 then
						Result.append(".")
					else
						Result.append (piece_mapping.item (board.item (i, j)))
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
