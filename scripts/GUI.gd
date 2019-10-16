extends Control

func _process(delta):
	if Input.is_action_just_pressed("inventory_open"):
		$UpgradeWindow.visible = !$UpgradeWindow.visible

func set_alert_text(text):
	$Alert/AnimationPlayer.stop()
	$Alert/AnimationPlayer.play("alert_fade")
	$Alert.text = text
	
func set_item_text(text):
	#$Pickup/Tween.stop_all()
	#$Pickup/Tween.interpolate_property($Pickup, "rect_position", $Pickup.rect_position, Vector2($Pickup.rect_position.x, $Pickup.rect_position.y-65), 0.2, Tween.TRANS_BACK, Tween.EASE_IN, 0.0)
	#$Pickup/Tween.start()
	$Pickup/AnimationPlayer.stop()
	$Pickup/AnimationPlayer.play("pickup_fade")
	$Pickup.text = text
	
func set_current_tome(tome_texture, aura_color):
	$CenterContainer/CurrentTome.texture = tome_texture
	$CurrentAura.modulate = aura_color

func set_aura_visible(visibility):
	$CurrentAura.visible = visibility
	
func set_health(health, max_health):
	$Health.value = health
	$HealthText.text = str(health) + "/" + str(max_health);