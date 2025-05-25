extends Node2D
@onready var Answer        := preload("res://scripts/answer.gd")
var current_customer_id: int
var current_line_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$CustomerLine/Answer1.connect("label_clicked", Callable(self, "_on_label_answer1_clicked"))
	
	var customer_id = 1;
	var customer_line_id = 1;
	
	set_dialogue_scenario(customer_id, customer_line_id)
	
	pass # Replace with function body.

func get_customer_line_obj(customer_id:int, customer_line_id:int) -> line_character:
	var result: line_character
	var file = FileAccess.open(Globals.CHARACTER_LINES_FILE_PATH, FileAccess.READ)
	if file == null:
		print("Errore nell'apertura del file")
		
	else:
		var content = file.get_as_text()
		var json_data = JSON.parse_string(content)
		
		if json_data == null or json_data.has("CharacterLines") == false:
			print("Errore nell'apertura del file")
			
		else:
			var character_lines = json_data["CharacterLines"]
			for character_line in character_lines:
				if character_line["id"] != customer_line_id:
					break
				else:
					var line_text = character_line["line"]
					var flags: Array = character_line["flags"]
					
					var answers_array : Array[Answer] = []
					for entry in character_line["answers"]:
						var txt = entry.get("line", "")
						var next_id = entry.get("IdNextLine", 0)
						var answer_flags = entry.get("Requiredflags", [])
						var ans : Answer = Answer.new(txt, next_id, answer_flags)
						answers_array.append(ans)
					result =  line_character.new(customer_line_id, customer_id, line_text, answers_array, flags)
					return result

	return result
	
func set_dialogue_scenario(customer_id:int, customer_line_id:int) -> void:
	
	var customer_name = get_customer_name(customer_id)
	$CustomerName.text = customer_name
	
	var customer_line_obj = get_customer_line_obj(customer_id, customer_line_id)
	$CustomerLine.text= customer_line_obj.line_text
	set_multiple_answers(customer_line_obj.answers)
	
	
	var wine_list = get_wine_description(1)
	$WineDescription.text = wine_list
	
	current_line_id = customer_line_id
	current_customer_id = customer_id
	pass

func get_line_character_object(customer_id:int, line_id:int)->line_character:
	var file = FileAccess.open(Globals.WINES_FILE_PATH, FileAccess.READ)
	
	return 

func set_multiple_answers(answers) -> void:
	print("Setting multiple answers for the line")
	
	$CustomerLine/Answer1.text = answers[0].line
	$CustomerLine/Answer1.next_line_id= answers[0].id_next_line
	
	$CustomerLine/Answer2.text = answers[1].line
	#$CustomerLine/Answer2.next_line_id= answers[1].id_next_line
	
	$CustomerLine/Answer3.text = answers[2].line
	#$CustomerLine/Answer3.next_line_id= answers[2].id_next_line
	
	pass

func get_wine_description(wine_id:int):
	var file = FileAccess.open(Globals.WINES_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_data = JSON.parse_string(content)
		
		if json_data and json_data.has("wines"):
			var wines = json_data["wines"]
			for wine in wines:
				if wine["id"] == wine_id:
					return wine["name"]
		else:
			print("JSON non valido o manca 'characters'")
	else:
		print("Errore nell'apertura del file")
	return null

func get_customer_name(customer_id:int) -> String:
	var file = FileAccess.open(Globals.CHARACTERS_FILE_PATH, FileAccess.READ)
	
	if file:
		var content = file.get_as_text()
		var json_data = JSON.parse_string(content)
		
		if json_data and json_data.has("characters"):
			var characters = json_data["characters"]
			
			for character in characters:
				if character["id"] == customer_id:
					return character["name"] +" " +character["surname"]
		else:
			print("JSON non valido o manca 'characters'")
	else:
		print("Errore nell'apertura del file")
	return "NAME_NOT_FOUND"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_label_answer1_clicked():
	print("Answer 1 clicked")
	
	var label: Label
