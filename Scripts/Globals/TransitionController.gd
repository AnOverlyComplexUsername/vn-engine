extends Control


##Controlls what is displayed infront of the screen background/transitions
class_name _ScreenController

@export var _black_screen: ColorRect
@export var _background: TextureRect
@export var _cg: TextureRect

##makes [member _black_screen] fade out. [br]
##
##Use this after using [method _ScreenController.fade_in] as it sets [member _black_screen]
##to visible for fade out [br]
##
##[param fadeColor] changes the color of [member _black_screen]; by default [constant Color.BLACK] [br]
##can insert a [param _tween] to control transition type and ease type
func fade_out(lengthSeconds : float = 1, fadeColor : Color = Color.BLACK,  _tween : Tween = null) -> Signal:
	_black_screen.show()
	_black_screen.self_modulate = fadeColor
	_black_screen.self_modulate.a = 1
	
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	
	tween.tween_property(_black_screen, "self_modulate:a", 0, lengthSeconds) 

	return tween.finished

##makes [member _black_screen] fade in. [br]
##[param fadeColor] changes the color of [member _black_screen]; by default [constant Color.BLACK] [br]
##can insert a [param _tween] to set transition type and ease type
func fade_in(lengthSeconds : float = 1, fadeColor : Color = Color.BLACK,  _tween : Tween = null) -> Signal:
	_black_screen.show()
	_black_screen.self_modulate = fadeColor
	_black_screen.self_modulate.a = 0
	
	var tween : Tween = _tween if _tween else get_tree().create_tween()
	tween.finished.connect(_black_screen.hide)
	
	tween.tween_property(_black_screen, "self_modulate:a", 1, lengthSeconds) 
	
	return tween.finished

##makes [member _black_screen] to fade in from [param fadeColor] in [param lengthSeconds] [br]
##then changes the background with [param bg] texture and fades [member _black_screen] out [br]
##can insert a [param _tween] to set transition type and ease type
func fade_to_black_background_change(bg : Texture, lengthSeconds : float = 1, fadeColor : Color = Color.BLACK,  _tween : Tween = null) -> Signal:
	await ScreenManager.fade_in(lengthSeconds,fadeColor,_tween)
	ScreenManager.change_background(bg )
	return ScreenManager.fade_out(lengthSeconds,fadeColor,_tween)

func change_background(bg : Texture) -> void:
	_background.texture = bg
	
func change_cg(cg : Texture) -> void:
	_cg.texture = cg
