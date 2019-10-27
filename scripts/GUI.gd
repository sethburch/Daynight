extends Control

var new_health = 100

func _process(delta):
	if Input.is_action_just_pressed("inventory_open"):
		$UpgradeWindow.visible = !$UpgradeWindow.visible
	$Cursor.rect_position = get_local_mouse_position() + Vector2(10, 10)
	$HealthOver/Health.value = lerp($HealthOver/Health.value, new_health, 0.1)

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
	$Cursor.visible = true
	$Cursor/Tome.texture = tome_texture
	$Cursor/Aura.modulate = aura_color

func set_aura_visible(visibility):
	$CurrentAura.visible = visibility
	
func set_health(health, max_health):
	#$HealthOver/Health.value = health
	new_health = health
	$HealthText.text = str(health) + " / " + str(max_health);