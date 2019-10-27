extends Spell

var spell_name = "Frozen"
var spell_color = Color("#77d6c1")

func _ready():
	._ready()
	type = SCHOOL.ICE

func _spell_finish():
	._spell_finish()