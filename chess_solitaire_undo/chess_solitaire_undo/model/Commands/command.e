note
	description: "Summary description for {COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMMAND

feature --Attributes
	chess: CHESS_UNDO
	local
		chess_access: CHESS_UNDO_ACCESS
	do
		Result := chess_access.m
	end

feature --Deferred features required for implementing the undo/redo pattern

	--feature for execution
	execute
		deferred
		end

	--feature for undo operation
	undo
		deferred
		end

	--feature for redo operation
	redo
		deferred
		end

end
