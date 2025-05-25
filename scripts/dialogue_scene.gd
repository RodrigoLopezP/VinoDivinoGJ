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

func set_dialogue_scenario(customer_id:int, customer_line_id:int) -> void:
	var customer_name = get_customer_name(customer_id)
	$CustomerName.text = customer_name
	
	var customer_line = get_customer_line(customer_line_id)
	$CustomerLine.text= customer_line
	
	var wine_list = get_wine_description(1)
	$WineDescription.text = wine_list
	
	var answers_raw = get_answers_for_line(customer_id)
	
	var ansObj: Array[Answer] = answers_raw as Array[Answer]
	
	set_multiple_answers(ansObj)
	
	current_line_id = customer_line_id
	current_customer_id = customer_id
	pass

func set_multiple_answers(answers) -> void:
	print("Setting multiple answers for the line")
	
	$CustomerLine/Answer1.text = answers[0].line
	#$CustomerLine/Answer1.next_line_id= answers[0].id_next_line
	
	$CustomerLine/Answer2.text = answers[1].line
	#$CustomerLine/Answer2.next_line_id= answers[1].id_next_line
	
	$CustomerLine/Answer3.text = answers[2].line
	#$CustomerLine/Answer3.next_line_id= answers[2].id_next_line
	
	pass

func get_answers_for_line(customer_line_id:int) -> Array[Answer]:
	var file = FileAccess.open("res://resources/json/CharacterLines.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_data = JSON.parse_string(content)
		
		if json_data and json_data.has("CharacterLines"):
			var character_lines = json_data["CharacterLines"]
			
			for character_line in character_lines:
				if character_line["id"] == customer_line_id:
					var out : Array[Answer] = []
					for entry in character_line["answers"]:
						var txt = entry.get("line", "")
						var next_id = entry.get("IdNextLine", 0)
						var flags = entry.get("Requiredflags", [])
						var ans : Answer = Answer.new(txt, next_id, flags)
						out.append(ans)
					return out
		else:
			print("JSON non valido o manca 'characters'")
	else:
		print("Errore nell'apertura del file")
	var emptyArray : Array = [Answer]
	return emptyArray

func get_wine_description(wine_id:int):
	var file = FileAccess.open("res://resources/json/Wines.json", FileAccess.READ)
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

func get_customer_name(customer_id:int):
	var file = FileAccess.open("res://resources/json/Characters.json", FileAccess.READ)
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
	return null

func get_customer_line(customer_line_id:int):
	var file = FileAccess.open("res://resources/json/CharacterLines.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_data = JSON.parse_string(content)
		
		if json_data and json_data.has("CharacterLines"):
			var character_lines = json_data["CharacterLines"]
			
			for character_line in character_lines:
				if character_line["id"] == customer_line_id:
					return character_line["line"]
		else:
			print("JSON non valido o manca 'characters'")
	else:
		print("Errore nell'apertura del file")
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_label_answer1_clicked():
	print("Answer 1 clicked")
	
	var label: Label
