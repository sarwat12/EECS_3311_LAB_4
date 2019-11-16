note
	description: "Summary description for {PAWN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PAWN

inherit
	CHESS_PIECE

feature --Constructor
	make(t: INTEGER)
		do
			type := t
		end

feature --Block existence and move validity

	--Valid moves for Pawn
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
			if is_valid_index (r2, c2) then
				if (r2 = r1 - 1) and (c2 = c1 + 1 or c2 = c1 - 1) then
					Result := TRUE
				end
			end
		end

	--Checking block existence for Pawn
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
		end

end
