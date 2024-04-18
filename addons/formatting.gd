extends Node

# credit to https://github.com/antimatter-dimensions/notations
# and https://kyodaisuu.github.io/illion/conway.html

const STANDARD_ABBREVIATIONS = [
	["", "K", "M", "B", "T", "Qa", "Qt", "Sx", "Sp", "Oc", "No"],
	["", " thousand", " million", " billion", " trillion", " quadrillion", " quintillion", " sextillion", " septillion", " octillion", " nonillion"]
]

const STANDARD_PREFIXES = [[
  ["", "U", "D", "T", "Qa", "Qt", "Sx", "Sp", "O", "N"],
  ["", "Dc", "Vg", "Tg", "Qd", "Qi", "Se", "St", "Og", "Nn"],
  ["", "Ce", "Dn", "Tc", "Qe", "Qu", "Sc", "Si", "Oe", "Ne"]
],[# and yes, there is a story behind this. please feel free to ask me
  ["", "un", "duo", "tres", "quattuor", "quin", "sex", "septen", "octo", "novem"],
  ["", "deci", "viginti", "triginta", "quadraginta", "quinquaginta", "sexaginta", "septuaginta", "octoginta", "nonaginta"],
  ["", "centi", "ducenti", "trecenti", "quadrigenti", "quingenti", "sescenti", "septingenti", "octingenti", "nongenti"]
]]

const STANDARD_PREFIXES_2 = [
	["", "MI-", "MC-", "NA-", "PC-", "FM-", "AT-", "ZP-", "YC-", "XN-"],
	["ni", "mi", "bi", "tri", "quadri", "quinti", "sexti", "septi", "octi", "noni" ]];

enum AFFIX_LENS {SHORT, LONG}

enum SEPERATOR {COMMA, PERIOD, NONE}

static func formatPisInt(number:int, seperator) -> String:
	if number == -9223372036854775808: return "TOO LONG; CHOOSE DIFFERENT FORMAT"
	assert(number >= 0, "int not pisitive")
	var string = str(number)
	if seperator == SEPERATOR.NONE: return string
	var spots = range(int((len(string)-1)/3))
	spots.reverse()
	for spot in spots:
		string = string.insert(len(string)-3*(spot+1),("," if seperator == SEPERATOR.COMMA else "."))
	return string

static func formatInt(number:int, seperator) -> String:
	var affix = ""
	if number < 0: affix = "-"
	return affix + formatPisInt(abs(number), seperator)

static func snapFloat(number:float, digitsAfter) -> float:
	return snapped(number, 10.0**-digitsAfter)

static func formatPisResidueToDigits(number:float, digitsAfter, decimalPoint) -> String:
	assert(0 <= number and number < 1, "invalid residue")
	assert(digitsAfter >= 0, "invalid digitsAfter")
	assert(snapFloat(number, digitsAfter) != 1, "residue rounds up")
	if snapFloat(number, digitsAfter) == 0: return ""
	return ("." if decimalPoint == SEPERATOR.PERIOD else ",") + str(snapFloat(number, digitsAfter)).erase(0,2)

static func formatPisFloat(number:float, digitsAfter, seperator, decimalPoint) -> String:
	assert(number >= 0, "float not pisitive")
	var whole = int(number)
	var residue = fmod(number, 1)
	if snapFloat(residue, digitsAfter) == 1:
		whole += 1
		residue = 0
	return formatPisInt(whole, seperator) + formatPisResidueToDigits(residue, digitsAfter, decimalPoint)

static func formatFloat(number:float, digitsAfter, seperator, decimalPoint) -> String:
	if snapFloat(number, digitsAfter) == 0: return "0"
	var affix = ""
	if number < 0: affix = "-"
	return affix + formatPisFloat(abs(number), digitsAfter, seperator, decimalPoint)

static func formatDecimalLong(number:Dec.Decimal, digitsAfter, seperator, decimalPoint) -> String:
	if abs(number.ToFloat()) == INF: return "TOO LONG; CHOOSE DIFFERENT FORMAT"
	else: return formatFloat(number.ToFloat(), digitsAfter, seperator, decimalPoint)

static func formatDecimalScientific(number:Dec.Decimal, digitsAfter, seperator, decimalPoint) -> String:
	if number.Eq(0): return "0"
	return formatFloat(number.m, digitsAfter, seperator, decimalPoint) + "e" + formatInt(number.e, seperator)

static func formatDecimalStandard(number:Dec.Decimal, digitsAfter, affixLen, seperator, decimalPoint) -> String:
	var mod = (int(number.e)%3+3)%3
	var whole = int(number.e - (2 if number.e < 0 else 0))/3
	return formatFloat(number.m * 10**mod, digitsAfter, seperator, decimalPoint) + getStandardAffix(whole, affixLen)

# directly copying from antimatter dimensions, lmao
static func getStandardAffix(number, affixLen) -> String:
	# less than 10, return first set
	var th = "ths" if number < 0 else ""
	if abs(number) < 11: return STANDARD_ABBREVIATIONS[affixLen][abs(number)] + th
	# build with second set; how? no fucking clue
	var prefix = []
	var e = str(abs(number)-1)
	# go through digits and pick the thingy
	for i in range(len(e)):
		var to_add = STANDARD_PREFIXES[affixLen][len(prefix) % 3][int(e[-(i+1)])]
		prefix.append(to_add)
	# append extra for. reasons
	while len(prefix) % 3 != 0:
		prefix.append("")
	# apply them to a string
	var abbreviation = ""
	for i in range(len(prefix)/3-1, -1, -1):
		if affixLen == AFFIX_LENS.SHORT:
			abbreviation += prefix[i*3] + prefix[i*3+1] + prefix[i*3+2] + STANDARD_PREFIXES_2[0][i]
		else:
			if prefix[i*3+1] == prefix[i*3+2] and prefix[i*3+1] == "":
				# group is less than 10, return first* set
				abbreviation += STANDARD_PREFIXES_2[1][int(e[-i*3-1])]
				if i != 0: abbreviation += "lli"
			else:
				abbreviation += prefix[i*3] + prefix[i*3+1] + prefix[i*3+2]
	if affixLen == AFFIX_LENS.LONG: return " " + abbreviation + "llion" + th
	var regex = RegEx.new()
	regex.compile("-[A-Z]{2}-")
	abbreviation = regex.sub(abbreviation, "-")
	regex.compile("U([A-Z]{2}-)")
	abbreviation = regex.sub(abbreviation, "$1")
	regex.compile("-$")
	abbreviation = regex.sub(abbreviation, "")
	return abbreviation + th
