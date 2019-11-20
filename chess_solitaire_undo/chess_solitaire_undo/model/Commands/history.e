note
	description: "History class for storing particular chess commands."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature --Constructor
	make
		do
			create history.make
		end


feature --List for history class

	history: LINKED_LIST[COMMAND]

feature --Queries on the history list

	item: COMMAND
		do
			Result := history.item;
		end

	on_item: BOOLEAN
		do
			Result := not (history.before or history.after)
		end

	before: BOOLEAN
		do
			Result := history.index = 0
		end

	after: BOOLEAN
		do
			Result := history.index = history.count + 1
		end

feature --Commands to be performed for the history list

	--Add a new command to the history list after removing commands to the right
	add_command(new_command: COMMAND)
		do
			remove_right_commands   --Remove right commands to make room for new_command
			history.extend (new_command)   --Add new command
			history.finish   --Move cursor to last position after adding new command
		end

	--Remove remaining elements to the right of current cursor: Needed for redo
	remove_right_commands
		do
			if not (history.islast or history.after) then
				from
					history.forth
				until
					history.after
				loop
					history.remove
				end
			end
		end

end
