note
	description: "Summary description for {QUEEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUEEN

inherit
	CHESS_PIECE

feature --Constructor
	make(t: INTEGER)
		do
			type := t
		end

feature --Block existence and move validity

	--Valid moves for Queen
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
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

	--Checking block existence for Queen
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
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

end
