extends Node

######################### NUMBERS ##############################

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

const EXPONENT_CUTOFF = 1e12

static func formatPisIntString(number:String, seperator) -> String:
	if seperator == SEPERATOR.NONE: return number
	var spots = range(int((len(number)-1)/3))
	spots.reverse()
	var string = number
	for spot in spots:
		string = string.insert(len(string)-3*(spot+1),("," if seperator == SEPERATOR.COMMA else "."))
	return string

static func formatPisInt(number:int, seperator) -> String:
	if number == -9223372036854775808: return "TOO LONG; CHOOSE DIFFERENT FORMAT"
	assert(number >= 0, "int not pisitive")
	return formatPisIntString(str(number), seperator)
	

static func formatInt(number:int, seperator) -> String:
	var affix = ""
	if number < 0: affix = "-"
	return affix + formatPisInt(abs(number), seperator)

static func snapFloat(number:float, digitsAfter) -> float:
	return snapped(number, 10.0**-digitsAfter)

static func formatPisResidueToDigits(number:float, digitsAfter, decimalPoint, preventFlickering) -> String:
	var snapped = snapFloat(number, digitsAfter)
	assert(0 <= number and number < 1, "invalid residue")
	assert(digitsAfter >= 0, "invalid digitsAfter")
	assert(snapped != 1, "residue rounds up")
	if snapped == 0 and digitsAfter == 0: return ""
	var zeros = ""
	if preventFlickering: for i in (digitsAfter+(1 if snapped == 0 else 2)-len(str(snapped))): zeros += "0"
	if snapped == 0: return ("." + zeros if preventFlickering else "")
	return ("." if decimalPoint == SEPERATOR.PERIOD else ",") + str(snapped).erase(0,2) + zeros

static func formatPisFloat(number:float, digitsAfter, seperator, decimalPoint, preventFlickering) -> String:
	assert(number >= 0, "float not pisitive")
	var whole = floor(number)
	var residue = (fmod(number, 1) if number < 1e16 else 0)
	if snapFloat(residue, digitsAfter) == 1:
		residue = (10.0**digitsAfter-1)/10.0**digitsAfter
	return formatPisIntString(str(whole), seperator) + formatPisResidueToDigits(residue, digitsAfter, decimalPoint, preventFlickering)

static func formatFloat(number:float, digitsAfter, seperator, decimalPoint, preventFlickering) -> String:
	var affix = ""
	if number < 0: affix = "-"
	return affix + formatPisFloat(abs(number), digitsAfter, seperator, decimalPoint, preventFlickering)

static func formatDecimalLong(number:Dec.Decimal, digitsAfter, seperator, decimalPoint, preventFlickering) -> String:
	if number.e > 308: return formatFloat(number.m, digitsAfter, seperator, decimalPoint, preventFlickering) + "e" + formatFloat(number.e, digitsAfter, seperator, decimalPoint, preventFlickering)
	else: return formatFloat(number.ToFloat(), digitsAfter, seperator, decimalPoint, preventFlickering)

static func formatDecimalScientific(number:Dec.Decimal, digitsAfter, seperator, decimalPoint, preventFlickering) -> String:
	if number.Eq(0): return "0"
	var exponent = formatInt(number.e, seperator) if number.e < EXPONENT_CUTOFF else formatDecimalScientific(Dec.D(number.e), digitsAfter, seperator, decimalPoint, preventFlickering)
	return formatFloat(number.m, digitsAfter, seperator, decimalPoint, preventFlickering) + "e" + exponent

static func formatDecimalStandard(number:Dec.Decimal, digitsAfter, affixLen, seperator, decimalPoint, preventFlickering) -> String:
	var mod = (int(number.e)%3+3)%3
	var whole = int(number.e - (2 if number.e < 0 else 0))/3
	if number.e < EXPONENT_CUTOFF: return formatFloat(number.m * 10**mod, digitsAfter, seperator, decimalPoint, preventFlickering) + getStandardAffix(whole, affixLen)
	else: return formatFloat(number.m, digitsAfter, seperator, decimalPoint, preventFlickering) + "e" + ("(" if affixLen == AFFIX_LENS.LONG else "") + formatDecimalStandard(Dec.D(number.e), digitsAfter, affixLen, seperator, decimalPoint, preventFlickering) + (")" if affixLen == AFFIX_LENS.LONG else "")
	

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

######################### TIME ##############################

const UNITVALUES = [0.001, 1, 60, 3600, 86400, 31556941] # round(86400 *  365.242374) (or maybe its 365.242189??? i dont know; apparently there are random variations in years and i dont know where these numbers are even coming from
const UNITNAMES = ["millisecond", "second", "minute", "hour", "day", "year"]
enum UNITS {MS, S, M, H, D, Y}

func formatTimeWithOneUnit(number, unit, stable, floor) -> String:
	if floor: return number.Div(UNITVALUES[unit]).Floor().F(UNITNAMES[unit], stable)
	else: return number.Div(UNITVALUES[unit]).F(UNITNAMES[unit], stable)

func getLargestUnit(number) -> UNITS:
	if number.GE(UNITVALUES[5]): return UNITS.Y
	if number.GE(UNITVALUES[4]): return UNITS.D
	if number.GE(UNITVALUES[3]): return UNITS.H
	if number.GE(UNITVALUES[2]): return UNITS.M
	if number.GE(UNITVALUES[1]): return UNITS.S
	return UNITS.MS

func formatTimeWithUnits(number, units, stable:=false, And:=false, commas:=true, oxford:=true) -> String:
	var largestUnit = getLargestUnit(number)
	var current = Dec.D(number)
	var toReturn = ""
	var actualUnits = min(units, largestUnit+1)
	var unitStrings = []
	var stableActualUnits = 0
	for unitNum in range(actualUnits):
		if current.Neq(0): stableActualUnits += 1
		var unit = largestUnit-unitNum
		unitStrings.append(formatTimeWithOneUnit(current, unit, stable or unitNum != actualUnits-1, unitNum != actualUnits-1))
		current.Modr(UNITVALUES[unit])
	
	if stable: actualUnits = stableActualUnits
	
	for unitNum in range(actualUnits):
		toReturn += unitStrings[unitNum]
		if unitNum < actualUnits-1:
			if unitNum == actualUnits-2:
				if oxford: toReturn += ","
				if And: toReturn += " and"
			elif commas: toReturn += ","
			toReturn += " "
	return toReturn
