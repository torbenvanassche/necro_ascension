extends Node

@export var packed_donors: Dictionary[String, PackedScene];
var donors: Dictionary[String, BodyPartDonor];

func get_donor(donor_name: String) -> BodyPartDonor:
	if donors.has(donor_name):
		return donors[donor_name];
	elif packed_donors.has(donor_name):
		donors.set(donor_name, packed_donors[donor_name].instantiate())
		return donors[donor_name];
	Debug.err("%s was not found on BodyPartManager" % donor_name)
	return null;
