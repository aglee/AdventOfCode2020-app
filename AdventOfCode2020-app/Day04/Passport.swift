import Foundation

/// Collection of fields with names and values.  Basically a wrapper around a dictionary
/// that maps field name => field value.
class Passport {
	/// Maps field names to field values.
	private(set) var fields = [String: String]()

	static func passports(linesToParse: [String]) -> [Passport] {
		var passports = [Passport]()
		var currentPassport: Passport?
		for line in linesToParse {
			if line.count == 0 {
				if let p = currentPassport {
					passports.append(p)
				}
				currentPassport = nil
			} else {
				if currentPassport == nil {
					currentPassport = Passport()
				}
				currentPassport?.addFields(line)
			}
		}
		if let p = currentPassport {
			passports.append(p)
		}

		return passports
	}

	/// Parses fields and adds them to the passport.
	///
	/// `line` should look like this:
	///
	/// `ecl:gry pid:860033327 eyr:2020 hcl:#fffffd`
	func addFields(_ line: String) {
		for fieldInfo in line.split(separator: " ") {
			let nameAndValue = fieldInfo.split(separator: ":").map { String($0) }
			let name = nameAndValue[0]
			let value = nameAndValue[1]
			fields[name] = value
		}
	}

	/// Passport validation used for Part 1.
	///
	/// Returns true if all required fields are present.
	///
	/// Assumes all fields have valid names, which is true for the input we're given.
	func hasRequiredFields() -> Bool {
		return (fields.count == 8) || (fields.count == 7 && fields["cid"] == nil)
	}

	/// Passport validation used for Part 2.
	///
	/// Returns true if the required fields are all present **and** have valid values.
	///
	/// Assumes all fields have valid names, which is true for the input we're given.
	func hasRequiredValidFields() -> Bool {
		if !hasRequiredFields() {
			return false
		}

		for (fieldName, fieldValue) in fields {
			if !Self.isValid(fieldName: fieldName, fieldValue: fieldValue) {
				return false
			}
		}
		return true
	}

	// MARK: - Private -- field validation

	static func isValid(fieldName: String, fieldValue: String) -> Bool {
		switch fieldName {
		case "byr": return Self.isValidBirthYear(fieldValue)
		case "iyr": return Self.isValidIssueYear(fieldValue)
		case "eyr": return Self.isValidExpirationYear(fieldValue)
		case "hgt": return Self.isValidHeight(fieldValue)
		case "hcl": return Self.isValidHairColor(fieldValue)
		case "ecl": return Self.isValidEyeColor(fieldValue)
		case "pid": return Self.isValidPassportID(fieldValue)
		case "cid": return true
		default: abort()
		}
	}

	static func isValidBirthYear(_ s: String) -> Bool {
		return isValidNumber(s, requiredLength: 4, range: (1920, 2002))
	}

	static func isValidIssueYear(_ s: String) -> Bool {
		return isValidNumber(s, requiredLength: 4, range: (2010, 2020))
	}

	static func isValidExpirationYear(_ s: String) -> Bool {
		return isValidNumber(s, requiredLength: 4, range: (2020, 2030))
	}

	static func isValidHeight(_ s: String) -> Bool {
		if s.count < 3 {
			return false
		}
		let num = String(s.prefix(s.count - 2))
		let units = String(s.suffix(2))
		if !isValidNumber(num) {
			return false
		}
		if units == "cm" {
			if !isValidNumber(num, requiredLength: nil, range: (150, 193)) {
				return false
			}
		} else if units == "in" {
			if !isValidNumber(num, requiredLength: nil, range: (59, 76)) {
				return false
			}
		} else {
			return false
		}

		// If we got this far, the input passed all tests.
		return true
	}

	private static let hairColorRE = try! NSRegularExpression(pattern: "#[0-9a-f]{6}", options: [])
	static func isValidHairColor(_ s: String) -> Bool {
		let wholeRange = NSRange(location: 0, length: s.count)
		return (hairColorRE.rangeOfFirstMatch(in: s, options: [], range: wholeRange) == wholeRange)
	}

	private static let validEyeColors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
	static func isValidEyeColor(_ s: String) -> Bool {
		return validEyeColors.contains(s)
	}

	static func isValidPassportID(_ s: String) -> Bool {
		return isValidNumber(s, requiredLength: 9)
	}

	static func isValidNumber(_ s: String, requiredLength: Int? = nil, range: (min: Int, max: Int)? = nil) -> Bool {
		if let requiredLength = requiredLength {
			if s.count != requiredLength { return false }
		}
		guard let n = Int(s) else { return false }
		if let range = range {
			if n < range.min { return false }
			if n > range.max { return false }
		}

		// If we got this far, the input passed all tests.
		return true
	}
}

