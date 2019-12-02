extends Node2D

enum schools  {fire, ice, lightning, last}
enum stats {speed, size, damage, cost, time, last}

var schoolstats = []

func _ready():
	for x in range(schools.last):
		schoolstats.append([])
		for y in range(stats.last):
			schoolstats[x].append(1)

func updatestat(school, stat, increase):
	if Global.SkillPoints > 0:
		Global.SkillPoints-=1
		schoolstats[school][stat] += increase
		print(school)
		print(stat)
		print(schoolstats[school][stat])