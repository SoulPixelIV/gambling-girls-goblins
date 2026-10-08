extends TextureProgressBar

@onready var marker: TextureRect = $Player_Healthbar_Marker

func _process(_delta: float) -> void:
	var percentage = (value - min_value) / (max_value - min_value)
	var offset = 16.0

	if value < max_value:
		offset += 2.0

	marker.position.x = percentage * size.x - marker.size.x / 2 + offset
