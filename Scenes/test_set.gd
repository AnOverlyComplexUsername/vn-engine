extends SetScript

##Demo of how a scene could be handled in engine; scenes should extent set script 

##Test SFX
const WEIRD_ROUTE_JINGLE = preload("uid://dgtxb7w3o3aaw")
const EVIL_BOO = preload("uid://cosbay64uj72x")



func _ready() -> void:
	var t : VNCharacters = Chars.test_girl.instantiate()
	self.add_child(t) ##TODO: Maybe make a function for intiating 
	
	
	ScreenManager.change_background(Backgrounds.ice)
	
	t.say("")
	t.place(%SpawnPoint)
	DialogueBox.fade_in()
	await t.fade_in()
	
	##Sets the choice buttons to the given parameters
	DialogueBox.set_choices("hi", "bye")
	DialogueBox.play_voice_line(EVIL_BOO)
	await t.say("Boo! Did I scare you?")
	
	var answer : String = await DialogueBox.choice_picked
	
	if answer == "hi": 
		
		##can await SFX until it is finished before moving on 
		await play_audio(WEIRD_ROUTE_JINGLE)
		
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
