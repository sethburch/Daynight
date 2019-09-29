extends Control

func _ready():
	pass
	
func set_alert_text(text):
	$Alert/AnimationPlayer.stop()
	$Alert/AnimationPlayer.play("alert_fade")
	$Alert.text = text
	
func set_item_text(text):
	$Pickup/AnimationPlayer.stop()
	$Pickup/AnimationPlayer.play("pickup_fade")
	$Pickup.text = text
	
func set_current_tome(tome_texture, aura_color):
	$CenterContainer/CurrentTome.texture = tome_texture
	$CurrentAura.modulate = aura_color

func set_aura_visible(visibility):
	$CurrentAura.visible = visibility