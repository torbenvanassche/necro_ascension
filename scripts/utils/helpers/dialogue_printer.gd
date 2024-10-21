class_name DialoguePrinter extends Printer

@export var dialogue: JSON;
var state: Dictionary = {};
var dialogue_handler: EzDialogue;

func _ready():
	dialogue_handler = EzDialogue.new();
	add_child(dialogue_handler)
	
	dialogue_handler.dialogue_generated.connect(_on_dialogue_generated)
	dialogue_handler.end_of_dialogue_reached.connect(clear)
	dialogue_handler.start_dialogue(dialogue, state);
	print_done.connect(_on_print_done.bind(0))
	
func _on_dialogue_generated(response: DialogueResponse):
	self.show_text(response.text)
	
func _on_print_done(index: int = 0):
	dialogue_handler.next(index)
