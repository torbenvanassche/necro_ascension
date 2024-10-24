class_name FileUtils

static func load_json(file_path: String) -> Dictionary:
	if(FileAccess.file_exists(file_path)):
		var data_file := FileAccess.open(file_path, FileAccess.READ)
		var parsed_result: Dictionary = JSON.parse_string(data_file.get_as_text())
		return parsed_result
	return {};

static func load_items(file_path: String) -> Dictionary:
	if(FileAccess.file_exists(file_path)):
		var data_file := FileAccess.open(file_path, FileAccess.READ)
		var parsed_result: Dictionary = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			for item: Dictionary in parsed_result:
				parsed_result[item].id = item;
				pass
			return parsed_result
		else:
			printerr("Error reading file.")
			return {}
	else:
		printerr("File does not exist!")
		return {};
	
static func get_item(dict: Dictionary, item_name: String) -> Dictionary:
	for item: Dictionary in dict.values():
		if item["name"] == item_name:
			return item["name"]
	return {}
