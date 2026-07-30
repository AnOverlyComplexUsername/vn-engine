extends SetScript

func _ready() -> void:
	var t : VNCharacters = Chars.test_girl.instantiate()
	self.add_child(t)
	
	ScreenManager.change_background(Backgrounds.ice)
	
	t.place(%SpawnPoint)
	await t.say("hi xdxwefawerfewfefaewfawefawefawefaewfawefawefewfwea")
	ScreenManager.change_background(Backgrounds.ice)
	await t.say("bye bye")	
	await t.move(%ExitPoint)
	
	await DialogueBox.fade_out()
	await ScreenManager.fade_to_black_background_change(Backgrounds.suisei)
