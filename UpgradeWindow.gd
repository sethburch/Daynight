extends Control

onready var playerstats = get_parent().get_parent().get_parent().get_node("../Player/Stats");

func _on_firesizebutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.size, 1)


func _on_firedamagebutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.damage, 1)


func _on_firespeedbutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.speed, 1)


func _on_icesizebutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.size, 1)


func _on_icedamagebutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.damage, 1)


func _on_icespeedbutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.speed, 1)


func _on_lightningsizebutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.size, 1)


func _on_lightningdamagebutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.damage, 1)


func _on_lightningspeedbutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.speed, 1)


func _on_firecostbutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.cost, 1)


func _on_firetimebutton_pressed():
	playerstats.updatestat(playerstats.schools.fire, playerstats.stats.time, 1)


func _on_icecostbutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.cost, 1)


func _on_icetimebutton_pressed():
	playerstats.updatestat(playerstats.schools.ice, playerstats.stats.time, 1)


func _on_lightningcostbutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.cost, 1)


func _on_lightningtimebutton_pressed():
	playerstats.updatestat(playerstats.schools.lightning, playerstats.stats.time, 1)
