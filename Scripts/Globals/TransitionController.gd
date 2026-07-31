extends Control


##Controlls what is displayed infront of the screen background/transitions
class_name _ScreenController

@export var _black_screen: ColorRect
@export var _background: TextureRect
@export var _cg: TextureRect

##Fades out
func fade_out(lengthSeconds : float = 1, screenColor : Color = Color.BLACK, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	_black_screen.show()
	_black_screen.self_modulate = screenColor
	_black_screen.self_modulate.a = 0
	
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(_black_screen, "self_modulate:a", 1, lengthSeconds).set_ease(_ease)

	return tween.finished

##func fades in 
func fade_in(lengthSeconds : float = 1, fadeColor : Color = Color.BLACK, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	_black_screen.show()
	_black_screen.self_modulate = fadeColor
	_black_screen.self_modulate.a = 1
	
	var tween : Tween = get_tree().create_tween()
	tween.finished.connect(_black_screen.hide)
	
	tween.tween_property(_black_screen, "self_modulate:a", 0, lengthSeconds).set_ease(_ease)
	
	return tween.finished

##fades to black and changes background
func fade_to_black_background_change(bg : Texture, lengthSeconds : float = 1, fadeColor : Color = Color.BLACK, _ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT) -> Signal:
	await ScreenManager.fade_out(lengthSeconds,fadeColor,_ease)
	ScreenManager.change_background(bg )
	return ScreenManager.fade_in(lengthSeconds,fadeColor,_ease)

func change_background(bg : Texture) -> void:
	_background.texture = bg
	
func change_cg(cg : Texture) -> void:
	_cg.texture = cg
