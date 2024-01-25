extends Area3D



func _on_body_entered(body):
	if body.name == "PlayerToken":
		GameEvent.reached_finish_line.emit()
