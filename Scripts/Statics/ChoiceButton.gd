extends Button

##a button class for storing a choice; emitting it's choice_id when clicked
class_name ChoiceButton

##id of choice
var id : String = ""

##emitted when player selects choicec
signal choice_id(id : String)

func _init(c_id : String, choice_name : String = "") -> void:
	id = c_id
	if choice_name.is_empty(): self.text = c_id
	else: self.text = choice_name


func _pressed() -> void:
	choice_id.emit(id)
