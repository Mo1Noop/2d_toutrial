extends StaticBody2D


func _ready() -> void:
	if SaveManager.presistent_data.get_or_add( unique_name(), "" ) == "destroyed":
		queue_free()


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + owner.name + "/" + get_parent().name + "/" + name
	return u_name
