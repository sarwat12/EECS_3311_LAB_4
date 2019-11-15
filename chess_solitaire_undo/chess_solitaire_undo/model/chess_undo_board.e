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
	knight_block: BOOLEAN --used for verifying blocks for knight movements


feature --Queries about chess pieces
	king_is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER):BOOLEAN
		do
			Result := FALSE
			if is_valid_index (r2, c2) then
				if (r2 = r1 + 1 or r2 = r1 - 1) and c2 = c1 then
					Result := TRUE
				end
				if (c2 = c1 + 1 or c2 = c1 - 1) and r2 = r1 then
					Result := TRUE
				end
				if ((r2 = r1 + 1) or (r2 = r1 - 1)) and ((c2 = c1 + 1) or (c2 = c1 - 1))  then
					Result := TRUE
				end
			end
		end

	queen_is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER):BOOLEAN
		local
			a, b: INTEGER
		do
			Result := FALSE
			a := r2 - r1
			b := c2 - c1
			if is_valid_index (r2, c2) then
				if a.abs = b.abs then
					Result := TRUE
				end
				if r2 = r1 then
					Result := TRUE
				end
				if c2 = c1 then
					Result := TRUE
				end
			end
		end

	block_exists_queen(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if up_down_block_exists (r1, c1, r2, c2) then
				Result := TRUE
			end
			if left_right_block_exists(r1, c1, r2, c2) then
				Result := TRUE
			end
			if diagonal_block_exists (r1, c1, r2, c2) then
				Result:= TRUE
			end
		end

	knight_is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER):BOOLEAN
		do
			knight_block := FALSE
			Result := FALSE
			if is_valid_index (r2, c2) then
				if r2 = r1 + 2 and c2 = c1 + 1 then --checking down-right
					if board.item (r1 + 1, c1) /= 0 then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if r2 = r1 + 2 and c2 = c1 - 1 then --checking down-left
					if board.item (r1 + 1, c1) /= 0 then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if r2 = r1 - 2 and c2 = c1 + 1 then --checking up-right
					if board.item (r1 - 1, c1) /= 0 then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if r2 = r1 - 2 and c2 = c1 - 1 then --checking up-left
					if board.item (r1 - 1, c1) /= 0 then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if r2 = r1 + 1 and c2 = c1 + 2 then --checking down-right again
					if board.item (r1 + 1, c1) /= 0 then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if r2 = r1 +- 1 and c2 = c1 - 2 then --checking down-right again
					if board.item (r1 - 1, c1) /= 0 then
						knight_block := TRUE
					end
					Result := TRUE
				end
			end
		end

	bishop_is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER):BOOLEAN
		local
			a,b :INTEGER
		do
			Result := FALSE
			a := r2 - r1
			b := c2 - c1
			if is_valid_index (r2, c2) then
				if (a.abs = b.abs) then
					Result := TRUE
				end
			end
		end

	block_exists_bishop(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := diagonal_block_exists(r1, c1, r2, c2)
		end

	rook_is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER):BOOLEAN
		do
			Result := FALSE
			if is_valid_index (r2, c2) then
				if c2 = c1 then
					Result := TRUE
				end
				if r2 = r1 then
					Result := TRUE
				end
			end
		end

	block_exists_rook(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if up_down_block_exists (r1, c1, r2, c2) then
				Result := TRUE
			end
			if left_right_block_exists(r1, c1, r2, c2) then
				Result := TRUE
			end
		end

	pawn_is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER):BOOLEAN
		do
			Result := FALSE

			if is_valid_index (r2, c2)  and (r2 = r1 - 1) and (c2 = c1 + 1) then
				Result := TRUE
			end
		end

	left_right_block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if c2 - c1 = 2  and r2 = r1 then --checking right blocks
				if board.item (r1, c1 + 1) /= 0 then
					Result := TRUE
				end
			end
			if c2 - c1 = 3  and r2 = r1 then --checking right blocks
				if (board.item (r1, c1 + 1) /= 0) or (board.item (r1, c1 + 2) /= 0) then
					Result := TRUE
				end
			end

			if c2 - c1 = -2  and r2 = r1 then --checking left blocks
				if board.item (r1, c1 - 1) /= 0 then
					Result := TRUE
				end
			end
			if c2 - c1 = -3  and r2 = r1 then --checking left blocks
				if (board.item (r1, c1 - 1) /= 0) or (board.item (r1, c1 - 2) /= 0) then
					Result := TRUE
				end
			end
		end

	up_down_block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE

			if r2 - r1 = 2  and c2 = c1 then --checking down blocks
				if board.item (r1 + 1, c1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = 3  and c2 = c1 then --checking down blocks
				if (board.item (r1 + 1, c1) /= 0) or (board.item (r1 + 2, c1) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = -2  and c2 = c1 then --checking up blocks
				if board.item (r1 - 1, c1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = -3  and c2 = c1 then --checking up blocks
				if (board.item (r1 - 1, c1) /= 0) or (board.item (r1 - 2, c1) /= 0) then
					Result := TRUE
				end
			end
		end

	diagonal_block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if (r2 = r1 + 1 and c2 = c1 + 1) or (r2 = r1 - 1 and c2 = c1 - 1) then
				Result := FALSE
			end
			if (r2 = r1 - 1 and c2 = c1 + 1) or (r2 = r1 + 1 and c2 = c1 - 1) then
				Result := FALSE
			end

			if r2 - r1 = 2 and c2 - c1 = 2 then  --checking down-right diagonal
				if board.item (r1 + 1, c1 + 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = 3 and c2 - c1 = 3 then --checking down-right diagonal
				if (board.item (r1 + 1, c1 + 1) /= 0) or (board.item (r1 + 2, c1 + 2) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = -2 and c2 - c1 = -2 then --checking up-left diagonal
				if board.item (r1 - 1, c1 - 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = -3 and c2 - c1 = -3 then --checking up-left diagonal
				if (board.item (r1 - 1, c1 - 1) /= 0) or (board.item (r1 - 2, c1 - 2) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = -2 and c2 - c1 = 2 then  --checking up-right diagonal
				if board.item (r1 - 1, c1 + 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = -3 and c2 - c1 = 3 then --checking up-right diagonal
				if (board.item (r1 - 1, c1 + 1) /= 0) or (board.item (r1 - 2, c1 + 2) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = 2 and c2 - c1 = -2 then  --checking down-left diagonal
				if board.item (r1 + 1, c1 - 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = 3 and c2 - c1 = -3 then --checking down-left diagonal
				if (board.item (r1 + 1, c1 - 1) /= 0) or (board.item (r1 + 2, c1 - 2) /= 0) then
					Result := TRUE
				end
			end
		end

		is_valid_index(row: INTEGER; col: INTEGER): BOOLEAN
		do
			Result := not (row < 1 or row > 4 or col < 1 or col > 4)
		end

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
