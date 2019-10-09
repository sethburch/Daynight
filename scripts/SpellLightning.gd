extends Spell

var spell_name = "Electrifying"
var spell_color = Color("#ffd832")

func _ready():
	._ready()
	type = SCHOOL.LIGHTNING
	
func _spell_finish():
	._spell_finish()