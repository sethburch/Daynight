extends Spell

var spell_name = "Blazing"
var spell_color = Color("#ff6157")

func _ready():
	._ready()
	type = SCHOOL.FIRE
	
func _spell_finish():
	._spell_finish()