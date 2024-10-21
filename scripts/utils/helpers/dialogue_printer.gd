class_name DialoguePrinter extends Printer

@export var dialogue: JSON;
var state: Dictionary = {};
var dialogue_handler: EzDialogue;

func _ready():
	dialogue_handler = EzDialogue.new();
	dialogue_handler.dialogue_generated.connect(_on_dialogue_generated)
	dialogue_handler.start_dialogue(dialogue, state);
	add_child(dialogue_handler)
	
func _on_dialogue_generated(response: DialogueResponse):
	print(response.text);
