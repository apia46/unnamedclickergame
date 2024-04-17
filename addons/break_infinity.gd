extends Node

# credit to @m_rld; idk what half of this does
# probably credit to Big (https://github.com/ChronoDK/GodotBigNumberClass) as well
# and of course to break_infinity.js (https://github.com/Patashu/break_infinity.js)

# ===== CONSTANTS =====

# For example: if two exponents are more than 17 apart,
# consider adding them together pointless, just return the larger one
const MAX_SIGNIFICANT_DIGITS = 17;

# Highest value you can safely put here is Number.MAX_SAFE_INTEGER-MAX_SIGNIFICANT_DIGITS
const EXP_LIMIT = 9e15;

# The largest exponent that can appear in a Number, though not all mantissas are valid here.
const NUMBER_EXP_MAX = 308;

# The smallest exponent that can appear in a Number, though not all mantissas are valid here.
const NUMBER_EXP_MIN = -324;

# Tolerance which is used for Number conversion to compensate for floating-point error.
const ROUND_TOLERANCE = 1e-10;

# Tolerance which is used for equality checks to compensate for floating point error
const EPSILON = 1e-10

# ===== CONSTANTS =====

#func _init(mantissa, exponent := 0.0):
#	if typeof(m) == TYPE_STRING:
#		var scientific = mantissa.split("e")
#		m = float(scientific[0])
#		if scientific.size() > 1:
#			e = int(scientific[1])
#		else:
#			e = 0
#	elif typeof(mantissa) == TYPE_OBJECT:
#		if mantissa.is_class("Big"):
#			m = mantissa.mantissa
#			e = mantissa.exponent
#	else:
#		m = mantissa
#		e = exponent
#	#calculate(self)
#	pass

# to decimal
static func D(value):
	if value is Decimal:
		return value
	if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
		return Dec.FromFloat(value)
	if value == null or value == NAN:
		return D(0)
	if typeof(value) == TYPE_DICTIONARY:
		if "mantissa" in value and "exponent" in value:
			return ME(value.mantissa, value.exponent)
	push_error("Unsupported Decimal source type.")


# to decimal; using mantisa and exponent
static func ME(mantissa, exponent=0):
	var new = Decimal.new()
	new.SetMantissaExponent(mantissa, exponent)
	return new
static func ME_NN(mantissa, exponent=0):
	var new = Decimal.new()
	new.SetMantissaExponent_NoNormalize(mantissa, exponent)
	return new

static func FromFloat(value):
	var new = Decimal.new()
	new.SetFromFloat(value)
	return new
static func FromString(value):
	var new = Decimal.new()
	new.SetFromString(value)
	return new

# We need this lookup table because Math.pow(10, exponent)
# when exponent's absolute value is large is slightly inaccurate.
# You can fix it with the power of math... or just make a lookup table.
# Faster AND simpler

func _ready():
	for i in range(NUMBER_EXP_MIN + 1, NUMBER_EXP_MAX + 1):
		powersOf10.append(pow(10, i))
var powersOf10 = []
const indexOf0InPowersOf10 = 323;
func PowerOf10(power):
	return powersOf10[power + indexOf0InPowersOf10]

static func log10(n): return log(n) / log(10)

const LN10 = log(10)
const MATH_E = 2.71828182845904523536

static func trunc(n:float) -> float:
	if n > 1e9:
		return n
	var excess = (abs(n) - floor(abs(n))) * sign(n)
	return (n - excess)

const POW_TWO_53 = 2**53
static func IsSafeInteger(n) -> bool:
	return n > -(POW_TWO_53 - 1) and n < POW_TWO_53 - 1 and n == floor(n)
static func IsFinite(n:float) -> bool:
	return abs(n) != INF

class Decimal:
	
	var m: float = 0.0
	var e: float = 0.0
	
	func SetMantissaExponent(mantissa, exponent):
		self.m = mantissa
		self.e = exponent
		self.Normalize()
	func SetMantissaExponent_NoNormalize(mantissa, exponent):
		self.m = mantissa
		self.e = exponent

	func Normalize():
		if self.m >= 1.0 && self.m < 9.99:
			return self
		
		if self.m == 0.0:
			self.m = 0
			self.e = 0
			return self
		
		var tempExponent = floor(Dec.log10(abs(self.m)))
		if tempExponent == NUMBER_EXP_MIN:
			self.m = self.m * 10 / 1e-323
		else:
			self.m = self.m / Dec.PowerOf10(tempExponent)
		self.e += tempExponent
		
		#print(str(self.m) + " || " + str(self.e))
		if self.m > 9.99:
			self.m /= 10
			self.e += 1
		
		return self
	
	
	
	func Clone():
		return Dec.ME_NN(self.m, self.e)
	
	func SetFromFloat(value):
		#var before = str(value)
		if value == 0:
			self.m = 0
			self.e = 0
			return
		
		self.e = floor(Dec.log10(abs(value)))
		if self.e == NUMBER_EXP_MIN:
			self.m = value * 10 / 1e-323
		else:
			self.m = value / Dec.PowerOf10(self.e)
		self.Normalize()
		#print(before + " ||| " + str(self.m) + "e" + str(self.e))
	
	func SetFromString(value_:String):
		var value = value_.to_lower()
		
		if value.find("e") != -1:
			var parts = value.split("e")
			self.m = float(parts[0])
			if is_nan(self.m):
				self.m = 1
			self.e = float(parts[1])
			self.Normalize()
			return
		
		self.SetFromFloat(float(value))
		
	
	func ToFloat() -> float:
		if self.e > NUMBER_EXP_MAX:
			if self.m > 0:
				return INF
			return -INF
		if self.e < NUMBER_EXP_MIN:
			return 0
		if self.e == NUMBER_EXP_MIN:
			if self.m > 0:
				return 5e-324
			return -5e-324
		
		var result = self.m * Dec.PowerOf10(self.e)
		if abs(round(result) - result) < ROUND_TOLERANCE:
			return round(result)
		return result
	
	func ToInt() -> int:
		return int(self.ToFloat())
	
	# ===== MATH OPERATIONS =====
	
	
	func Abs() -> Decimal:
		return Dec.ME_NN(abs(self.m), self.e)
	
	func Neg() -> Decimal:
		return Dec.ME_NN(-self.m, self.e)
	
	func Sign() -> int:
		return sign(self.m)
	
	func Round() -> Decimal:
		if self.e < -1:
			return Dec.ME(0,0)
		if self.e < MAX_SIGNIFICANT_DIGITS:
			return Dec.FromFloat(round(self.ToFloat()))
		return self
	func Floor() -> Decimal:
		if self.e < -1:
			if sign(self.m) >= 0:
				return Dec.ME(0,0)
			return Dec.ME(1,0)
		if self.e < MAX_SIGNIFICANT_DIGITS:
			return Dec.FromFloat(floor(self.ToFloat()))
		return self
	func Ceil() -> Decimal:
		if self.e < -1:
			if sign(self.m) > 0:
				return Dec.ME(0,0)
			return Dec.ME(1,0)
		if self.e < MAX_SIGNIFICANT_DIGITS:
			return Dec.FromFloat(ceil(self.ToFloat()))
		return self
	
	func IsNaN() -> bool:
		return self.m != self.m
	
	func Incr(value):
		var added = self.Add(value)
		self.m = added.m
		self.e = added.e
	
	func Decr(value):
		var added = self.Sub(value)
		self.m = added.m
		self.e = added.e
	
	func Mulr(value):
		var added = self.Mul(value)
		self.m = added.m
		self.e = added.e
	
	func Divr(value):
		var added = self.Div(value)
		self.m = added.m
		self.e = added.e
	
	func Add(value) -> Decimal:
		
		var decimal = Dec.D(value)
		if self.m == 0:
			return decimal
		if decimal.m == 0:
			return self
		
		var biggerDecimal 
		var smallerDecimal 
		if self.e >= decimal.e:
			biggerDecimal = self
			smallerDecimal = decimal
		else:
			biggerDecimal = decimal
			smallerDecimal = self
		
		if biggerDecimal.e - smallerDecimal.e > MAX_SIGNIFICANT_DIGITS:
			return biggerDecimal
		
		# Have to do this because adding numbers that were once integers but scaled down is imprecise.
		# Example: 299 + 18
		var mantissa = round(1e14 * biggerDecimal.m + 
			1e14 * smallerDecimal.m * Dec.PowerOf10(smallerDecimal.e - biggerDecimal.e))
		return Dec.ME(mantissa, biggerDecimal.e - 14)
	func Plus(value) -> Decimal:
		return self.Add(value)
	
	func Sub(value) -> Decimal:
		return self.Add(Dec.D(value).Neg())
	func Minus(value) -> Decimal: 
		return self.Sub(value)
	
	func Mul(value) -> Decimal:
		if typeof(value) == TYPE_FLOAT:
			if value < 1e307 and value > 1e-307:
				return Dec.ME(self.m * value, self.e)
			return Dec.ME(self.m * 1e-307 * value, self.e + 307)
		var decimal = Dec.D(value)
		return Dec.ME(self.m * decimal.m, self.e + decimal.e)
	func Times(value) -> Decimal:
		return self.Mul(value)
	
	func Reciprocal() -> Decimal:
		return Dec.ME(1 / self.m, -self.e)
	
	func Rc() -> Decimal:
		return Reciprocal()
	
	func Div(value) -> Decimal:
		return self.Mul(Dec.D(value).Reciprocal())
	func DividedBy(value) -> Decimal:
		return self.Div(value)
	
	func Cmp(value) -> int: # Compares NaN values
		var decimal = Dec.D(value)
		if self.IsNaN():
			if decimal.IsNaN():
				return 0
			return 1
		if decimal.IsNaN():
			return -1
		return Dec.D(self).Cmp(decimal)
	
	func Eq(value) -> bool:
		var decimal = Dec.D(value)
		return self.e == decimal.e and abs(self.m - decimal.m) < EPSILON
	func Equals(value) -> bool:
		return self.Eq(value)
	func Neq(value) -> bool:
		return !self.Eq(value)
	func NotEquals(value) -> bool:
		return !self.Eq(value)
	
	func LessThan(value) -> bool:
		var decimal = Dec.D(value)
		if self.m == 0:
			return decimal.m > 0
		if decimal.m == 0:
			return self.m <= 0
		if self.e == decimal.e:
			return self.m < decimal.m
		if self.m > 0:
			return decimal.m > 0 and self.e < decimal.e
		return decimal.m > 0 or self.e > decimal.e
	
	func GreaterThan(value) -> bool:
		var decimal = Dec.D(value)
		if self.m == 0:
			return decimal.m < 0
		if decimal.m == 0:
			return self.m > 0
		if self.e == decimal.e:
			return decimal.m < 0 or self.e > decimal.e 
		return decimal.m < 0 and self.e < decimal.e
	
	func LessThanOrEqualTo(value) -> bool:
		return !self.GreaterThan(value)
	func GreaterThanOrEqualTo(value) -> bool:
		return !self.LessThan(value)
	
	func GE(value) -> bool:
		return self.GreaterThanOrEqualTo(value)
	func L(value) -> bool:
		return self.LessThan(value)
	
	static func Max(value1, value2) -> Decimal:
		var decimal1 = Dec.D(value1)
		var decimal2 = Dec.D(value2)
		if decimal1.LessThan(decimal2):
			return decimal2
		return decimal1
	static func Min(value1, value2) -> Decimal:
		var decimal1 = Dec.D(value1)
		var decimal2 = Dec.D(value2)
		if decimal1.GreaterThan(decimal2):
			return decimal2
		return decimal1
	
	func Clamp(min, max) -> Decimal:
		return Min(Max(self, min), max)
	
	func Log10() -> float:
		return self.e + Dec.log10(self.m)
	func AbsLog10() -> float:
		return self.e + Dec.log10(abs(self.m))
	func Log(base) -> Decimal:
		return Dec.D(self.Log10()).Mul(LN10 / log(base))
	func Log2() -> float:
		return 3.321928094887362 * self.Log10()
	func Ln() -> float:
		return 2.302585092994045 * self.Log10()
	
	static func Pow10(value) -> Decimal:
		if typeof(value) == TYPE_INT:
			return Dec.ME_NN(1, value)
		return Dec.ME(pow(10, fmod(value, 1)), Dec.trunc(value))
	
	func PowOf(value) -> Decimal:
		if self.m == 0:
			return self
		
		var numberValue: float
		if typeof(value) == TYPE_FLOAT:
			numberValue = value
		else:
			numberValue = value.ToFloat()
		
		# Fast track: If (this.e*value) is an integer and mantissa^value
		# fits in a Number, we can do a very fast method.
		
		var temp = self.e * numberValue
		var newMantissa
		if Dec.IsSafeInteger(temp):
			newMantissa = pow(self.m, numberValue)
			if Dec.IsFinite(newMantissa) and newMantissa != 0:
				return Dec.ME(newMantissa, temp)
		
		# Same speed and usually more accurate.
		
		var newExponent = Dec.trunc(temp)
		
		var residue = temp - newExponent
		newMantissa = pow(10, numberValue * Dec.log10(self.m) + residue)
		if Dec.IsFinite(newMantissa) and newMantissa != 0:
			return Dec.ME(newMantissa, newExponent)
		
		var result = Pow10(numberValue * self.AbsLog10())
		if self.Sign() == -1:
			if abs(fmod(numberValue, 2)) == 1:
				return result.Neg()
			elif abs(fmod(numberValue, 2)) == 0:
				return result
			return Dec.ME_NN(NAN,0)
		return result
	
	static func Pow(value, other) -> Decimal:
		# Fast track: 10^integer
		if value == 10 and typeof(other) == TYPE_INT:
			return Dec.ME_NN(1, other)
		return Dec.D(value).PowOf(other)
	
	func Squared() -> Decimal:
		return Dec.ME(pow(self.m, 2), self.e * 2)
	func Cubed() -> Decimal:
		return Dec.ME(pow(self.m, 3), self.e * 3)
	
	func Sqrt() -> Decimal:
		if self.m < 0:
			return Dec.ME_NN(NAN,0)
		if fmod(self.e, 2) != 0:
			return Dec.ME(sqrt(self.m) * 3.16227766016838, floor(self.e / 2))
		return Dec.ME(sqrt(self.m), floor(self.e / 2))
	
	func Cbrt() -> Decimal:
		var sign = 1
		var mantissa = self.m
		if mantissa < 0:
			sign = -1
			mantissa = -mantissa
		var newMantissa = sign * pow(mantissa, 1.0/3)
		var mod = round(fmod(self.e, 3))
		if mod == 1 or mod == -2:
			return Dec.ME(newMantissa * 2.154434690031883, floor(self.e / 3))
		if mod != 0:
			return Dec.ME(newMantissa * 4.641588833612778, floor(self.e / 3))
		return Dec.ME(newMantissa, floor(self.e / 3))
	
	func DecimalPlaces() -> int:
		if self.e >= MAX_SIGNIFICANT_DIGITS or self.e > 2**63-1:
			return 0
		var places = -self.e
		var e_ = 1
		while abs(round(self.m * e_) / e_ - self.m) > ROUND_TOLERANCE:
			e_ *= 10
			places += 1
		if places > 0:
			return places
		return 0
	
	func Factorial() -> Decimal:
		# Using Stirling's Approximation.
		# https://en.wikipedia.org/wiki/Stirling%27s_approximation#Versions_suitable_for_calculators
		var n = self.ToFloat() + 1
		return Pow(
			(n / MATH_E) * sqrt(n * sinh(1/n) + 1 /
			(810 * pow(n,6))), n).Mul(sqrt(TAU / n)
		)
	
	func Plural() -> bool:
		return self.NotEquals(1)
	
	func F(noun:="") -> String:
		return Format(noun)
	
	func Format(noun:="") -> String:
		# affix a noun for convenience
		var affix = ""
		if noun != "":
			affix = " " + (getPluralForm(noun) if self.Plural() else noun)
		
		var num = self
		var prefix = ""
		if num.L(0):
			num = num.Neg()
			prefix = "-"
		var selfLog10 = num.Clone().Log10()
		if selfLog10 < 6:
			# to not display scientific notation
			var toFloat = num.Clone().ToFloat()
			var residue = fmod(toFloat, 1)
			var truncated
			if residue > 0.995:
				truncated = toFloat - residue + 1
				residue = 0
			else:
				truncated = toFloat - residue
			truncated = str(truncated)
			if selfLog10 >= 6:
				truncated = truncated.insert(len(truncated)-6,",")
			if selfLog10 >= 3:
				truncated = truncated.insert(len(truncated)-3,",")
			if residue == 0:
				return prefix+truncated+affix
			else:
				return prefix+truncated + str(snapped(residue, 0.01)).erase(0)+affix
		else:
			# to display scientific notation
			var toReturn = ""
			if selfLog10 < 1000000:
				toReturn = str(snapped(num.m, 0.01))
			elif selfLog10 < 1e9:
				toReturn = str(snapped(num.m, 0.1))
			elif selfLog10 < 1e12:
				toReturn = str(snapped(num.m, 1))
			toReturn += "e" + str(Dec.D(floor(num.e)).Format())
			return prefix+toReturn+affix
	
	func getPluralForm(noun) -> String:
		return noun + "s"
