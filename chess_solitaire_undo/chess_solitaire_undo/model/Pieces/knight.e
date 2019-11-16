note
	description: "Summary description for {KNIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KNIGHT

inherit
	CHESS_PIECE

create
	make

feature --Attributes
	knight_block: BOOLEAN --used for verifying blocks for knight movements

feature --Constructor
	make(t: STRING)
		do
			type := t
		end

feature --Block existence and move validity

	--Valid moves for Knight
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			knight_block := FALSE
			Result := FALSE
			if is_valid_index (r2, c2) then
				if (r2 = r1 + 2) and (c2 = c1 + 1 or c2 = c1 - 1) then --checking down2 and (right1 or left1)
					if chess_board.board.item (r1 + 1, c1).type /~ "NULL" or chess_board.board.item (r1 + 2, c1).type /~ "NULL" then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if (r2 = r1 - 2) and (c2 = c1 + 1 or c2 = c1 - 1) then --checking up2 and (right1 or left1)
					if chess_board.board.item (r1 - 1, c1).type /~ "NULL" or chess_board.board.item (r1 - 2, c1).type /~ "NULL" then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if (r2 = r1 + 1 or r2 = r1 - 1) and (c2 = c1 - 2) then --checking left2 and (up1 or down1)
					if chess_board.board.item (r1, c1 - 1).type /~ "NULL" or chess_board.board.item (r1, c1 - 2).type /~ "NULL" then
						knight_block := TRUE
					end
					Result := TRUE
				end
				if (r2 = r1 + 1 or r2 = r1 - 1) and (c2 = c1 + 2) then --checking right2 and (up1 or down1)
					if chess_board.board.item (r1, c1 + 1).type /~ "NULL" or chess_board.board.item (r1, c1 + 2).type /~ "NULL" then
						knight_block := TRUE
					end
					Result := TRUE
				end
			end
		end

	--Checking block existence for Knight
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		local
			a: BOOLEAN
		do
			a := is_valid_move (r1, c1, r2, c2)
			Result := knight_block
		end

end
