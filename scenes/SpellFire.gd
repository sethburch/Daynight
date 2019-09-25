extends Spell

var spell_name = "Blazing"

func _ready():
	._ready()
	type = SCHOOL.FIRE
	
func _spell_finish():
	._spell_finish()