extends Control

onready var playerstats = get_parent().get_parent().get_parent().get_node("../Player/Stats");

func _on_firesizebutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.size, 1)


func _on_firedamagebutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.damage, 1)


func _on_firespeedbutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.speed, 1)


func _on_firecritbutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.critchance, 1)


func _on_firewavebutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.wavyness, 1)


func _on_firefeatherbutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.featheryness, 1)


func _on_icesizebutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.size, 1)


func _on_icedamagebutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.damage, 1)


func _on_icespeedbutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.speed, 1)


func _on_icecritbutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.critchance, 1)


func _on_icewavebutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.wavyness, 1)


func _on_icefeatherbutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.featheryness, 1)


func _on_lightningsizebutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.size, 1)


func _on_lightningdamagebutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.damage, 1)


func _on_lightningspeedbutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.speed, 1)


func _on_lightningcritbutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.critchance, 1)


func _on_lightningwavebutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.wavyness, 1)


func _on_lightningfeatherbutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.featheryness, 1)
