class MenuItem {
	let ingredients: Set<String>
	let allergens: Set<String>

	/// Parses a line of input.
	///
	/// Example input:
	///
	/// `mxmxvkd kfcds sqjhc nhms (contains dairy, fish)`
	init(_ s: String) {
		let parts = s.components(separatedBy: " (contains ")
		let ingredientsPart = parts[0]
		var allergensPart = parts[1]
		allergensPart.removeLast()  // Remove trailing ")".

		self.ingredients = Set(ingredientsPart.components(separatedBy: " "))
		self.allergens = Set(allergensPart.components(separatedBy: ", "))
	}
}

/// Maps ingredients to sets of suspected allergens.
class AllergenSuspectsLookup {
	private var lookup = [String: Set<String>]()
	var unexoneratedIngredients: [String] { lookup.keys.map { String($0) } }

	func addAllSuspects(_ menuItems: [MenuItem]) {
		for menuItem in menuItems {
			for ingr in menuItem.ingredients {
				if lookup[ingr] == nil {
					lookup[ingr] = menuItem.allergens
				} else {
					lookup[ingr]!.formUnion(menuItem.allergens)
				}
			}
		}
	}

	func exonerate(ingredient: String, ofHavingAllergen allergen: String) {
		if var allergens = lookup[ingredient] {
			allergens.remove(allergen)
			if allergens.isEmpty {
				lookup[ingredient] = nil
			} else {
				lookup[ingredient] = allergens
			}
		}
	}

	func suspectedAllergens(_ ingredient: String) -> Set<String> {
		return lookup[ingredient] ?? Set<String>()
	}
}

class Menu {
	let menuItems: [MenuItem]
	let allIngredients: Set<String>
	private let suspects = AllergenSuspectsLookup()

	init(_ inputLines: [String]) {
		self.menuItems = inputLines.map { MenuItem($0) }

		self.suspects.addAllSuspects(menuItems)
		self.allIngredients = Set(suspects.unexoneratedIngredients)

		doFirstReductionOfSuspects()
		doSecondReductionOfSuspects()
	}

	/// Called by `init`.  This solves Part 1.  We can rule out an ingredient-allergen
	/// mapping if there exists a menu item that mentions the allergen but **not** the
	/// ingredient.  We remove all such mappings from the lookup.
	private func doFirstReductionOfSuspects() {
		func canRuleOut(ingredient: String, asHavingAllergen allergen: String) -> Bool {
			for menuItem in menuItems {
				if menuItem.allergens.contains(allergen) && !menuItem.ingredients.contains(ingredient) {
					return true
				}
			}
			return false
		}

		for ingr in allIngredients {
			for allergen in suspects.suspectedAllergens(ingr) {
				if canRuleOut(ingredient: ingr, asHavingAllergen: allergen) {
					suspects.exonerate(ingredient: ingr, ofHavingAllergen: allergen)
				}
			}
		}
	}

	/// Called by `init`.  This solves Part 2.  Assumes `doFirstReductionOfSuspects` has
	/// already been called.  According to the puzzle description, this means the
	/// remaining ingredients in the lookup are definitely bad.  Here we figure out
	/// **which** allergen each ingredient contains, by a process of elimination.  If an
	/// ingredient only has one suspected allergen, then that's a match, and we can rule
	/// out that allergen being in the other ingredients.
	private func doSecondReductionOfSuspects() {
		let badIngredients = suspects.unexoneratedIngredients
		while true {
			var didReduceSuspects = false
			for ingr in badIngredients {
				if suspects.suspectedAllergens(ingr).count == 1 {
					let confirmedAllergen = suspects.suspectedAllergens(ingr).first!
					for otherIngr in badIngredients {
						if otherIngr != ingr && suspects.suspectedAllergens(otherIngr).contains(confirmedAllergen) {
							suspects.exonerate(ingredient: otherIngr, ofHavingAllergen: confirmedAllergen)
							didReduceSuspects = true
						}
					}
				}
			}
			if !didReduceSuspects {
				break
			}
		}
	}

	func solvePart1() -> String {
		let safeIngredients = allIngredients.subtracting(suspects.unexoneratedIngredients)
		var numTimes = 0
		for ingr in safeIngredients {
			for menuItem in menuItems {
				if menuItem.ingredients.contains(ingr) {
					numTimes += 1
				}
			}
		}
		return String(numTimes)
	}

	func solvePart2() -> String {
		let badIngredients = suspects.unexoneratedIngredients
		var allergenToIngredient = [String: String]()
		for ingr in badIngredients {
			allergenToIngredient[suspects.suspectedAllergens(ingr).first!] = ingr
		}
		let ingredientsSortedByAllergen = allergenToIngredient.keys.sorted().map { allergenToIngredient[$0]!
		}
		return ingredientsSortedByAllergen.joined(separator: ",")
	}
}

