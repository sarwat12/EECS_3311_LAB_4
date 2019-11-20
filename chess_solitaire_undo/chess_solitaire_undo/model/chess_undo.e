note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

--Fix move and cpature and game_status

class
	CHESS_UNDO

inherit
	ANY
		redefine
			out
		end

create {CHESS_UNDO_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create chess_board.make
			create error.make_empty
			create piece_mapping.make_empty
			set_mapping
			num_pieces := 0
			game_started:= FALSE
			game_finished:= FALSE
			create start.make_from_string("  Game being Setup...%N")
			create history.make
			start_game_redo_trigger := FALSE
		ensure
			no_pieces: num_pieces = 0
		end

feature --Implementation

	history: HISTORY --A history of commands to be stored for later use in undo/redo pattern
	chess_board: CHESS_UNDO_BOARD --reference to chess board
	error: STRING	--reference for error reporting
	num_pieces: INTEGER  --number of pieces
	game_started: BOOLEAN
	game_finished: BOOLEAN
	start: STRING
	piece_mapping: ARRAY[STRING]  --Mapping for each chess piece to its corresponding integer
	start_game_redo_trigger: BOOLEAN


feature -- chess operations

	undo
		do
			if history.after then
				history.history.back
			end

			if history.on_item then
				history.item.undo
				history.history.back
			else
				set_error ("  Error: Nothing to undo%N")
			end
		end

	redo
		do
			if history.before or (not history.after) then
				history.history.forth
			end

			if history.on_item then
				history.item.redo
			else
				set_error ("  Error: Nothing to redo%N")
			end
		end

	setup_chess(c: INTEGER ; row: INTEGER_32 ; col: INTEGER_32)
		require
			game_did_not_start:
				game_started = FALSE

			valid_slot:
				row > 0 or row < 5 or col > 0 or col < 5

			slot_not_occupied:
				chess_board.board.item (row, col).type ~ "NULL"
		local
			chess: CHESS_PIECE
		do
			if piece_mapping.at (c) ~ "K" then
				create {KING} chess.make (piece_mapping.at (c))
			elseif piece_mapping.at (c) ~ "Q" then
				create {QUEEN} chess.make (piece_mapping.at (c))
			elseif piece_mapping.at (c) ~ "N" then
				create {KNIGHT} chess.make (piece_mapping.at (c))
			elseif piece_mapping.at (c) ~ "R" then
				create {ROOK} chess.make (piece_mapping.at (c))
			elseif piece_mapping.at (c) ~ "B" then
				create {BISHOP} chess.make (piece_mapping.at (c))
			else
				create {PAWN} chess.make (piece_mapping.at (c))
			end
			chess_board.board.put (chess, row, col)
			num_pieces := num_pieces + 1
		ensure
			piece_incremented: num_pieces = old num_pieces + 1
		end

	start_game
		require
			game_did_not_start: game_started = FALSE
		local
			track: ARRAY[TUPLE[a: CHESS_PIECE; row: INTEGER; col: INTEGER]]
		do
			game_started := TRUE
			if num_pieces = 0 then
				set_error ("  Game Over: You Lose!%N")
				game_finished := TRUE
			elseif num_pieces = 1 then
				set_error ("  Game Over: You Win!%N")
				game_finished := TRUE
			elseif num_pieces = 2 then
				create track.make_empty
				across 1 |..| 4 is i loop
					across 1 |..| 4 is j loop
						if chess_board.board.item (i, j).type /~ "NULL" then
							track.force ([chess_board.board.item (i, j), i, j], track.count + 1)
						end
					end
				end
				if not (track.item (1).a.is_valid_move (track.item (1).row, track.item (1).col, track.item (2).row, track.item (2).col) or
					track.item (2).a.is_valid_move (track.item (2).row, track.item (2).col, track.item (1).row, track.item (1).col)) then
					set_error ("  Game Over: You Lose!%N")
					game_finished := TRUE
				else
					set_error ("  Game In Progress...%N")
				end
			else
				set_error ("  Game In Progress...%N")
			end
		end

	moves(row: INTEGER_32 ; col: INTEGER_32)
		require
			game_start:
				game_started = TRUE

			game_not_finished:
				start /= 0

			occupied_slot:
				chess_board.board.item (row, col).type /~ "NULL"

			valid_slot:
				row > 0 or row < 5 or col > 0 or col < 5
		do
			chess_board.set_x (row)
			chess_board.set_y (col)
			chess_board.set_moves_trigger
			set_error ("  Game In Progress...%N")
		end

	move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)
		require
			game_start:
				game_started = TRUE

			game_not_finished:
				start /= 0

			occupied_slot:
				chess_board.board.item (r1, c1).type /~ "NULL" and
				chess_board.board.item (r2, c2).type /~ "NULL"

			valid_slot:
				(r1 > 0 or r1 < 5 or c1 > 0 or c1 < 5) and
				(r2 > 0 or r2 < 5 or c2 > 0 or c2 < 5)
		local
			track: ARRAY[TUPLE[a: CHESS_PIECE; row: INTEGER; col: INTEGER]]
		do
			if chess_board.board.item (r1, c1).is_valid_move (r1, c1, r2, c2) then
				if chess_board.board.item (r1, c1).block_exists (r1, c1, r2, c2) then
					set_error ("  Error: Block exists between ("
						+ r1.out + ", " + c1.out + ") and (" + r2.out + ", " + c2.out + ")%N")
				else
					chess_board.capture (r1, c1, r2, c2)
					num_pieces := num_pieces - 1
					if num_pieces = 1 then
						set_error ("  Game Over: You Win!%N")
						game_finished := TRUE
					elseif num_pieces = 2 then
						create track.make_empty
						across 1 |..| 4 is i loop
							across 1 |..| 4 is j loop
								if chess_board.board.item (i, j).type /~ "NULL" then
									track.force ([chess_board.board.item (i, j), i, j], track.count + 1)
								end
							end
						end
						if not (track.item (1).a.is_valid_move (track.item (1).row, track.item (1).col, track.item (2).row, track.item (2).col) or
							track.item (2).a.is_valid_move (track.item (2).row, track.item (2).col, track.item (1).row, track.item (1).col)) then
							set_error ("  Game Over: You Lose!%N")
							game_finished := TRUE
						else
							set_error ("  Game In Progress...%N")
						end
					else
						set_error ("  Game In Progress...%N")
					end
				end
			else
				set_error ("  Error: Invalid move of " + chess_board.board.item (r1, c1).type + " from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
			end
		end

--	game_status(pieces: INTEGER)
--		local
--			track: ARRAY[TUPLE[a: CHESS_PIECE; row: INTEGER; col: INTEGER]]
--			trigger: INTEGER
--		do
--			if num_pieces = 1 then
--				set_error ("  Game Over: You Win!%N")
--				game_finished := TRUE
--			elseif num_pieces = 2 then
--				create track.make_empty
--				across 1 |..| 4 is i loop
--					across 1 |..| 4 is j loop
--						if chess_board.board.item (i, j).type /~ "NULL" then
--							track.force ([chess_board.board.item (i, j), i, j], track.count + 1)
--						end
--					end
--				end
--				if not (track.item (1).a.is_valid_move (track.item (1).row, track.item (1).col, track.item (2).row, track.item (2).col) or
--					track.item (2).a.is_valid_move (track.item (2).row, track.item (2).col, track.item (1).row, track.item (1).col)) then
--					set_error ("  Game Over: You Lose!%N")
--					game_finished := TRUE
--				end
----			elseif pieces > 1 then

----				create track.make_empty
----				trigger := num_pieces * (num_pieces - 1)
----				across 1 |..| 4 is i loop
----					across 1 |..| 4 is j loop
----						if chess_board.board.item (i, j).type /~ "NULL" then
----							track.force ([chess_board.board.item (i, j), i, j], track.count + 1)
----						end
----					end
----				end
----				across 1 |..| num_pieces is m loop
----					across 1 |..| track.count is n loop
----						if (track.item (n).row /~ track.item (m).row) and (track.item (n).col /~ track.item (m).col) then
----							if (not track.item (m).a.is_valid_move (track.item (m).row, track.item (m).col, track.item (n).row, track.item (n).col))
----							and (track.item (m).a.block_exists (track.item (m).row, track.item (m).col, track.item (n).row, track.item (n).col))then
----								trigger := trigger - 1
----							end
----						end
----					end
----				end
----				if trigger = 0 then
----					set_error ("  Game Over: You Lose!%N")
----					game_finished := TRUE
----				else
----					set_error ("  Game In Progress...%N")
----				end
--			else
--				set_error ("  Game In Progress...%N")
--			end
--		end

	reset_game
		require
			game_start:
				game_started = TRUE
		do
			make
		end

	reset
			-- Reset model state.
		do
			make
		end

	set_error(s: STRING)
		do
			error := s
		end

	set_game_started(b: BOOLEAN)
		do
			game_started := b
		end

	set_game_finished(b: BOOLEAN)
		do
			game_finished := b
			--start := 0
		end

	set_start_game_redo_trigger(b: BOOLEAN)
		do
			start_game_redo_trigger := b
		end

	increase_num_pieces
		do
			num_pieces := num_pieces + 1
		end

	decrease_num_pieces
		do
			num_pieces := num_pieces - 1
		end


feature -- queries

	set_mapping
		do
			piece_mapping.force ("K", piece_mapping.count + 1)
			piece_mapping.force ("Q", piece_mapping.count + 1)
			piece_mapping.force ("N", piece_mapping.count + 1)
			piece_mapping.force ("B", piece_mapping.count + 1)
			piece_mapping.force ("R", piece_mapping.count + 1)
			piece_mapping.force ("P", piece_mapping.count + 1)
		end

	out : STRING
		do
			create Result.make_empty

			Result.append ("  # of chess pieces on board: " + num_pieces.out + "%N")

			if not start.is_empty then
				Result.append(start)
				start.make_empty
			end

			if not error.is_empty then
				Result.append (error)
				error.make_empty
			end
			Result.append (chess_board.out)
		end

invariant
	fixed_number_pieces:
		num_pieces >=0 and num_pieces <= 16
end




