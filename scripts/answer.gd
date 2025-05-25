extends Object  # o “extends Object” / “extends Resource”

class_name Answer

var line: String
var id_next_line: int
var required_flags: Array

func _init(_line: String = "", _id_next_line: int = 0, _required_flags: Array = []):
	line = _line
	id_next_line = _id_next_line
	required_flags = _required_flags.duplicate()
