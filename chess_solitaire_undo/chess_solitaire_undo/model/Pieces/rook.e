note
	description: "Summary description for {ROOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROOK

inherit
	CHESS_PIECE

feature --Constructor
	make(t: INTEGER)
		do
			type := t
		end

feature --Block existence and move validity

	--Valid moves for Rook
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
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

	--Checking block existence for Rook
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if up_down_block_exists (r1, c1, r2, c2) then
				Result := TRUE
			end
			if left_right_block_exists(r1, c1, r2, c2) then
				Result := TRUE
			end
		end

end
