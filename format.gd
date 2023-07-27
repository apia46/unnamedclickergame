extends Node

const SCIENTIFICCUTOFF = 1e5
var defaultnumberformat = "scientific"


func time(seconds: int) -> String:
	@warning_ignore("integer_division")
	var minutes = seconds/60
	@warning_ignore("integer_division")
	var hours = minutes/60
	@warning_ignore("integer_division")
	var days = hours/24
	if days > 0:
		return "%s day%s, %s hour%s, %s minute%s, and %s second%s" % [str(numbercomma(days, 0)), "" if days == 1 else "s",
hours % 24, "" if hours % 24 == 1 else "s",
minutes % 60, "" if minutes % 60 == 1 else "s",
seconds % 60, "" if seconds % 60 == 1 else "s"]
	elif hours > 0:
		return "%s hour%s, %s minute%s, and %s second%s" % [hours, "" if hours == 1 else "s",
minutes % 60, "" if minutes % 60 == 1 else "s",
seconds % 60, "" if seconds % 60 == 1 else "s"]
	elif minutes > 0:
		return "%s minute%s and %s second%s" % [minutes, "" if minutes == 1 else "s",
seconds % 60, "" if seconds % 60 == 1 else "s"]
	else:
		return "%s second%s" % [seconds, "" if seconds == 1 else "s"]

func numbercomma(inputnum, trim := 2) -> String:
	if is_inf(inputnum): return str(inputnum)
	var formattednumber = str(snapped(inputnum, float(10) ** -trim))
	var fullnumlen = len(str(floor(inputnum)))
	
	for i in range(int((fullnumlen-1)/3.0)): # godot bug, wont let me @warning_ignore the integer division
		formattednumber = formattednumber.insert(fullnumlen - (3 * i) - 3, ",")
	return formattednumber

func number(inputnum, trim := 2, style := "default", scientifictrim := 2) -> String:
	if is_inf(inputnum): return str(inputnum)
	if style == "default": style = defaultnumberformat
	var formattednumber = str(snapped(inputnum, float(10) ** -trim))
	var fullnumberlen = len(str(floor(inputnum)))
	
	match style:
		"scientific":
			if inputnum >= SCIENTIFICCUTOFF: # make it work with small numbers later
				# this should in theory be faster than dividing it by power of 10
				formattednumber = formattednumber.rpad(fullnumberlen + scientifictrim + 1, "0").left(scientifictrim + 1)
				if scientifictrim > 0: formattednumber = formattednumber.insert(1, ".")
				formattednumber = formattednumber + "e" + numbercomma((fullnumberlen - 1), trim)
			else:
				return numbercomma(inputnum, trim)
		"comma":
			numbercomma(inputnum, trim)
	return formattednumber
