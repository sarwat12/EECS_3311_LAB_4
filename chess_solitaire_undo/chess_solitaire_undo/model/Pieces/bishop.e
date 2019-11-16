note
	description: "Summary description for {BISHOP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BISHOP

inherit
	CHESS_PIECE

create
	make

feature --Constructor
	make(t: STRING)
		do
			type := t
		end

feature --Block existence and move validity

	--Valid moves for Bishop
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
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

	--Checking block existence for Bishop
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := diagonal_block_exists(r1, c1, r2, c2)
		end

end
