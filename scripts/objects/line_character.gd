extends Object

class_name line_character

var id_line: int
var character_id: int
var line_text: String
var answers: Array[Answer]
var flags: Array

func _init(_id_line:int , _character_id:int, _line: String = "" , _answer: Array = [Answer], _flags: Array =[]):
	id_line = _id_line
	character_id = _character_id
	line_text = _line
	answers = _answer.duplicate()
	flags = _flags.duplicate()
