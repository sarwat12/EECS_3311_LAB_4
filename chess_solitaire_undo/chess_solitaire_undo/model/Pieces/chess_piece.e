note
	description: "Summary description for {CHESS_PIECE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CHESS_PIECE


feature --Attributes
	type: INTEGER --type of chess piece enumeration

	chess_board: CHESS_UNDO_BOARD
		local
			chess_access: CHESS_UNDO_ACCESS
		once
			Result := chess_access.m.chess_board
		end


feature --Deferred features: checking validity for moves of specific chess pieces

	--Checking whether a move from r1, c1 to r2, c2 is possible for a particular chess piece
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		deferred
		end

	--Checking whether a block exists between r1, c1 and r2, c2 for a particular chess piece
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		deferred
		end


feature --Checking validity for general chess piece moves

	--Checking whether valid index for any piece
	is_valid_index(row: INTEGER; col: INTEGER): BOOLEAN
		do
			Result := not (row < 1 or row > 4 or col < 1 or col > 4)
		end

	--Checking any up-down blocks for a piece
	up_down_block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE

			if r2 - r1 = 2  and c2 = c1 then --checking down blocks
				if chess_board.board.item (r1 + 1, c1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = 3  and c2 = c1 then --checking down blocks
				if (chess_board.board.item (r1 + 1, c1) /= 0) or (chess_board.board.item (r1 + 2, c1) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = -2  and c2 = c1 then --checking up blocks
				if chess_board.board.item (r1 - 1, c1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = -3  and c2 = c1 then --checking up blocks
				if (chess_board.board.item (r1 - 1, c1) /= 0) or (chess_board.board.item (r1 - 2, c1) /= 0) then
					Result := TRUE
				end
			end
		end

	--Checking any left-right blocks for a piece
	left_right_block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if c2 - c1 = 2  and r2 = r1 then --checking right blocks
				if chess_board.board.item (r1, c1 + 1) /= 0 then
					Result := TRUE
				end
			end
			if c2 - c1 = 3  and r2 = r1 then --checking right blocks
				if (chess_board.board.item (r1, c1 + 1) /= 0) or (chess_board.board.item (r1, c1 + 2) /= 0) then
					Result := TRUE
				end
			end

			if c2 - c1 = -2  and r2 = r1 then --checking left blocks
				if chess_board.board.item (r1, c1 - 1) /= 0 then
					Result := TRUE
				end
			end
			if c2 - c1 = -3  and r2 = r1 then --checking left blocks
				if (chess_board.board.item (r1, c1 - 1) /= 0) or (chess_board.board.item (r1, c1 - 2) /= 0) then
					Result := TRUE
				end
			end
		end

	--Checking any diagonal blocks for a piece
	diagonal_block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			--If immediate diagonal, then no blocks
			if (r2 = r1 + 1 and c2 = c1 + 1) or (r2 = r1 - 1 and c2 = c1 - 1) then
				Result := FALSE
			end
			if (r2 = r1 - 1 and c2 = c1 + 1) or (r2 = r1 + 1 and c2 = c1 - 1) then
				Result := FALSE
			end

			if r2 - r1 = 2 and c2 - c1 = 2 then  --checking down-right diagonal
				if chess_board.board.item (r1 + 1, c1 + 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = 3 and c2 - c1 = 3 then --checking down-right diagonal
				if (chess_board.board.item (r1 + 1, c1 + 1) /= 0) or (chess_board.board.item (r1 + 2, c1 + 2) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = -2 and c2 - c1 = -2 then --checking up-left diagonal
				if chess_board.board.item (r1 - 1, c1 - 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = -3 and c2 - c1 = -3 then --checking up-left diagonal
				if (chess_board.board.item (r1 - 1, c1 - 1) /= 0) or (chess_board.board.item (r1 - 2, c1 - 2) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = -2 and c2 - c1 = 2 then  --checking up-right diagonal
				if chess_board.board.item (r1 - 1, c1 + 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = -3 and c2 - c1 = 3 then --checking up-right diagonal
				if (chess_board.board.item (r1 - 1, c1 + 1) /= 0) or (chess_board.board.item (r1 - 2, c1 + 2) /= 0) then
					Result := TRUE
				end
			end

			if r2 - r1 = 2 and c2 - c1 = -2 then  --checking down-left diagonal
				if chess_board.board.item (r1 + 1, c1 - 1) /= 0 then
					Result := TRUE
				end
			end
			if r2 - r1 = 3 and c2 - c1 = -3 then --checking down-left diagonal
				if (chess_board.board.item (r1 + 1, c1 - 1) /= 0) or (chess_board.board.item (r1 + 2, c1 - 2) /= 0) then
					Result := TRUE
				end
			end
		end

end
