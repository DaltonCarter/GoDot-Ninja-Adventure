extends StaticBody2D


var can_interact: bool = false
var has_sword: bool = false
@export var repeat_dialogue: bool = false

@export var dialogue: Array[String] =["You are either brave or foolish to come without a sword.", "I will give you this, may it serve you well.", "Now hurry onward and collect the Sacred Treasures!", "Do not delay! We must liberate our village!"]
var dialogue_index: int = 0



func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_interact:
		$AudioStreamPlayer2D.play()
		if dialogue_index < dialogue.size():
			$CanvasLayer.visible = true
			get_tree().paused = true
			$CanvasLayer/DialogueLabel.text =  dialogue[dialogue_index]
			if dialogue_index == 3 or has_sword == true:
				$CanvasLayer/DialogueLabel.text =  dialogue[dialogue_index]
				dialogue_index += 1
			
			else:
				dialogue_index += 1
			

		else:
			if  repeat_dialogue:
				$CanvasLayer.visible = false
				get_tree().paused = false
				dialogue_index = 0
			else:
				$CanvasLayer.visible = false
				get_tree().paused = false
				dialogue_index = 3
		
	
