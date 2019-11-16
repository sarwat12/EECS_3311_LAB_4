note
	description: "Summary description for {EMPTY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--Class representing a null piece

class
	EMPTY

inherit
	CHESS_PIECE

create
	make

feature

	make(t: STRING)
		do
			type := t
		end

	is_valid_move(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
		end

	block_exists(r1:INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER): BOOLEAN
		do
			Result := FALSE
		end

end
