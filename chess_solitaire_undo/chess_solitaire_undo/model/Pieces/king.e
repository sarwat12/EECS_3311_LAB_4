note
	description: "Summary description for {KING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KING

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

	--Valid moves for King
	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
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

	--No block exists for King
	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
		end

end
