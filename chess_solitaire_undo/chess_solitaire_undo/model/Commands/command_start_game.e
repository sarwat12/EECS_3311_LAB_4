note
	description: "Summary description for {COMMAND_START_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_START_GAME

inherit
	COMMAND

create
	make

feature --Constructor
	make(s: BOOLEAN)
		do
			start:= s
		end

feature --Attributes specific to start game
	start: BOOLEAN

feature --features specific to start_game
	execute
		do
			chess.start_game
		end

	undo
		do
			start:= FALSE
			chess.set_game_started (start)
			chess.set_error ("  Game being Setup...%N")
		end

	redo
		do
			if chess.start_game_redo_trigger = TRUE then
				chess.set_error ("  Error: Nothing to redo%N")
			else
				chess.start_game
				chess.set_error ("  Game In Progress...%N")
			end
		end

end
