extends Node2D

@onready var healthBar: Sprite2D = $HealthProgress
@onready var defaultWidth = healthBar.region_rect.size.x
@onready var defaultHeight = healthBar.region_rect.size.y

func updateHealth(newHealth):
	var newWidth = (newHealth/100.0) * defaultWidth
	healthBar.region_rect = Rect2(0, 0, newWidth, defaultHeight)
