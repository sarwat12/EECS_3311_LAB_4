note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

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
			num_pieces := 0
			game_started:= FALSE
			game_finished:= FALSE
			start := 1
		ensure
			no_pieces: num_pieces = 0
		end

feature --Implementation

	chess_board: CHESS_UNDO_BOARD
	error: STRING
	num_pieces: INTEGER
	game_started: BOOLEAN
	game_finished: BOOLEAN
	start: INTEGER


feature -- chess operations

	undo
		do

		end

	redo
		do

		end

	setup_chess(c: INTEGER ; row: INTEGER_32 ; col: INTEGER_32)
		require
			game_did_not_start:
				game_started = FALSE

			valid_slot:
				row > 0 or row < 5 or col > 0 or col < 5

			slot_not_occupied:
				chess_board.board.item (row, col) = 0
		do
			chess_board.board.put (c, row, col)
			num_pieces := num_pieces + 1
			set_start
		ensure
			piece_incremented: num_pieces = old num_pieces + 1
		end

	start_game
		require
			game_did_not_start: game_started = FALSE
		do
			game_started := TRUE
			set_start
		end

	moves(row: INTEGER_32 ; col: INTEGER_32)
		require
			game_start:
				game_started = TRUE

			game_not_finished:
				start /= 0

			occupied_slot:
				chess_board.board.item (row, col) /= 0

			valid_slot:
				row > 0 or row < 5 or col > 0 or col < 5
		do
			set_start
			chess_board.set_x (row)
			chess_board.set_y (col)
			chess_board.set_moves_trigger
		end

	move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)
		require
			game_start:
				game_started = TRUE

			game_not_finished:
				start /= 0

			occupied_slot:
				chess_board.board.item (r1, c1) /= 0 and
				chess_board.board.item (r2, c2) /= 0

			valid_slot:
				(r1 > 0 or r1 < 5 or c1 > 0 or c1 < 5) and
				(r2 > 0 or r2 < 5 or c2 > 0 or c2 < 5)
		local
			track: INTEGER
		do
			set_start
			--in case of bishop
			if chess_board.piece_mapping.item (chess_board.board.item (r1, c1)) ~ "B" then
				if chess_board.bishop_is_valid_move (r1, c1, r2, c2) then
					if chess_board.block_exists_bishop(r1,c1,r2,c2) then
						set_error ("  Error: Block exists between ("
						+ r1.out + ", " + c1.out + ") and (" + r2.out + ", " + c2.out + ")%N")
					else
						chess_board.capture (r1, c1, r2, c2)
						num_pieces := num_pieces - 1
						if num_pieces = 1 then
							set_error ("  Game Over: You Win!%N")
							game_finished := TRUE
						elseif num_pieces > 1 then
							track := num_pieces
							across 1 |..| 4 is i loop
								across 1 |..| 4 is j loop
									if (chess_board.board.item (i, j) /= 0) and
									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) /~ "B") then
										if (not chess_board.bishop_is_valid_move (r2, c2, i, j)) and (track = 0) then
											set_error ("  Game Over: You Lose!%N")
											game_finished := TRUE
										end
										track := track - 1
									end
								end
							end
						else
							set_error ("  Game In Progress...%N")
						end
					end
				else
					set_error ("  Error: Invalid move of B from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
				end
			--in case of knight
			elseif chess_board.piece_mapping.item (chess_board.board.item (r1, c1)) ~ "N" then
				if chess_board.knight_is_valid_move (r1, c1, r2, c2) then
					if chess_board.knight_block = TRUE then
						set_error ("  Error: Block exists between ("
						+ r1.out + ", " + c1.out + ") and (" + r2.out + ", " + c2.out + ")%N")
					else
						chess_board.capture (r1, c1, r2, c2)
						num_pieces := num_pieces - 1
						if num_pieces = 1 then
							set_error ("  Game Over: You Win!%N")
							game_finished := TRUE
						elseif num_pieces = 2 then
							across 1 |..| 4 is i loop
								across 1|..| 4 is j loop
--									if (chess_board.board.item (i, j) /= 0) and
--									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) /~ "N") then
--										if not chess_board.knight_is_valid_move (r2, c2, i, j) then
--											set_error ("  Game Over: You Lose!%N")
--											game_finished := TRUE
--										end
									if (chess_board.board.item (i, j) /= 0) and
									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) ~ "R") then
										if not chess_board.rook_is_valid_move (i, j, r2, c2) then
											set_error ("  Game Over: You Lose!%N")
											game_finished := TRUE
										end
									end
								end
							end
						else
							set_error ("  Game In Progress...%N")
						end
					end
				else
					set_error ("  Error: Invalid move of B from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
				end
			--in case of king
			elseif chess_board.piece_mapping.item (chess_board.board.item (r1, c1)) ~ "K" then
				if chess_board.king_is_valid_move (r1, c1, r2, c2) then
					chess_board.capture (r1, c1, r2, c2)
					num_pieces := num_pieces - 1
					if num_pieces = 1 then
						set_error ("  Game Over: You Win!%N")
						game_finished := TRUE
					elseif num_pieces = 2 then
							across 1 |..| 4 is i loop
								across 1|..| 4 is j loop
									if (chess_board.board.item (i, j) /= 0) and
									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) /~ "K") then
										if not chess_board.king_is_valid_move (r2, c2, i, j) then
											set_error ("  Game Over: You Lose!%N")
											game_finished := TRUE
										end
									end
								end
							end
					else
						set_error ("  Game In Progress...%N")
					end
				else
					set_error ("  Error: Invalid move of B from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
				end
			--in case of queen
			elseif chess_board.piece_mapping.item (chess_board.board.item (r1, c1)) ~ "Q" then
				if chess_board.queen_is_valid_move (r1, c1, r2, c2) then
					if chess_board.block_exists_queen(r1,c1,r2,c2) then
						set_error ("  Error: Block exists between ("
						+ r1.out + ", " + c1.out + ") and (" + r2.out + ", " + c2.out + ")%N")
					else
						chess_board.capture (r1, c1, r2, c2)
						num_pieces := num_pieces - 1
						if num_pieces = 1 then
							set_error ("  Game Over: You Win!%N")
							game_finished := TRUE
						elseif num_pieces = 2 then
							across 1 |..| 4 is i loop
								across 1|..| 4 is j loop
									if (chess_board.board.item (i, j) /= 0) and
									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) /~ "Q") then
										if not chess_board.queen_is_valid_move (r2, c2, i, j) then
											set_error ("  Game Over: You Lose!%N")
											set_game_finished (TRUE)
										end
									end
								end
							end
						else
							set_error ("  Game In Progress...%N")
						end
					end
				else
					set_error ("  Error: Invalid move of B from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
				end
			--in case of rook
			elseif chess_board.piece_mapping.item (chess_board.board.item (r1, c1)) ~ "R" then
				if chess_board.rook_is_valid_move (r1, c1, r2, c2) then
					if chess_board.block_exists_rook(r1,c1,r2,c2) then
						set_error ("  Error: Block exists between ("
						+ r1.out + ", " + c1.out + ") and (" + r2.out + ", " + c2.out + ")%N")
					else
						chess_board.capture (r1, c1, r2, c2)
						num_pieces := num_pieces - 1
						if num_pieces = 1 then
							set_error ("  Game Over: You Win!%N")
							game_finished := TRUE
						elseif num_pieces = 2 then
							across 1 |..| 4 is i loop
								across 1|..| 4 is j loop
									if (chess_board.board.item (i, j) /= 0) and
									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) /~ "R") then
										if not chess_board.rook_is_valid_move (r2, c2, i, j) then
											set_error ("  Game Over: You Lose!%N")
											game_finished := TRUE
										end
									end
								end
							end
						else
							set_error ("  Game In Progress...%N")
						end
					end
				else
					set_error ("  Error: Invalid move of B from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
				end
				--in case of pawn
			else
				if chess_board.pawn_is_valid_move (r1, c1, r2, c2) then
					chess_board.capture (r1, c1, r2, c2)
					num_pieces := num_pieces - 1
						if num_pieces = 1 then
							set_error ("  Game Over: You Win!%N")
							game_finished := TRUE
						elseif num_pieces = 2 then
							across 1 |..| 4 is i loop
								across 1|..| 4 is j loop
									if (chess_board.board.item (i, j) /= 0) and
									(chess_board.piece_mapping.item (chess_board.board.item (i, j)) /~ "P") then
										if not chess_board.pawn_is_valid_move (r2, c2, i, j) then
											set_error ("  Game Over: You Lose!%N")
											game_finished := TRUE
										end
									end
								end
							end
						else
							set_error ("  Game In Progress...%N")
						end
				else
					set_error ("  Error: Invalid move of B from ("
					+ r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")%N")
				end
			end
		end

	set_start
		do
			start := start + 1
		end

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
			start := 0
		end


feature -- queries
	out : STRING
		do
			create Result.make_empty

			Result.append ("  # of chess pieces on board: " + num_pieces.out + "%N")

			if start = 1 then
				Result.append("  Game being Setup...%N")
			end

			if not error.is_empty then
				Result.append (error)
			end
			Result.append (chess_board.out)
		end

invariant
	fixed_number_pieces:
		num_pieces >=0 and num_pieces <= 16
end




