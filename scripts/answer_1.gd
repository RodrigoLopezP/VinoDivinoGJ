extends Label

signal label_clicked  #  Segnale personalizzato

var next_line_id : int

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP  # Rende la label cliccabile

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Label Answer1 - Label cliccata!")
		emit_signal("label_clicked")
