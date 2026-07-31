extends SetScript


func _ready() -> void:
	var t : VNCharacters = Chars.test_girl.instantiate()
	self.add_child(t)
	
	ScreenManager.change_background(Backgrounds.ice)
	
	t.place(%SpawnPoint)
	
	DialogueBox.set_choices("hi", "bye")
	t.say("hi xdxwefawerfewfefaewfawefawefawefaewfawefawefewfwea")
	
	var answer : String = await DialogueBox.choice_picked
	
	if answer == "hi": 
		await t.say("no")
		
		var choices : Dictionary[String,String] = {
			"blah":"first_option", ##emits "first_option" when chosen 
			"blewh" : "second_option"
		}
		DialogueBox.set_secret_choices(choices)
		t.say("a?")
		print(await DialogueBox.choice_picked)
	
	elif answer == "bye":
		await t.say("bye bye")	
		await CameraController.move_cam(%SpawnPoint)
		await t.move(%ExitPoint)
		
		await DialogueBox.fade_out()
		await ScreenManager.fade_to_black_background_change(Backgrounds.suisei)
		CameraController.move_to_center()
