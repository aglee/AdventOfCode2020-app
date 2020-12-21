import Foundation

class Day21: DayNN {
	init() {
		super.init("Allergen Assessment")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "5"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "mxmxvkd,sqjhc,fvjkl"),
		]
	}

	// MARK: - Solving

	class MenuItem {
		let ingredients: Set<String>
		let allergens: Set<String>

		init(_ s: String) {
			let parts = s.components(separatedBy: " (contains ")
			let ingredientsPart = parts[0]
			var allergensPart = parts[1]
			allergensPart.removeLast()  // Remove trailing ")".

			self.ingredients = Set(ingredientsPart.components(separatedBy: " "))
			self.allergens = Set(allergensPart.components(separatedBy: ", "))
		}
	}

	override func solvePart1(inputLines: [String]) -> String {
		func onePass() -> Bool {
			var didReducePossibilities = false

			for ingr in allIngredients {
				let candidateAllergens = maybeAllergens[ingr]!
				for allergen in candidateAllergens {
					for menuItem in menuItems {
						if menuItem.allergens.contains(allergen) && !menuItem.ingredients.contains(ingr) {
							maybeAllergens[ingr]!.remove(allergen)
							didReducePossibilities = true
						}
					}
				}
			}

			return didReducePossibilities
		}

		let menuItems = inputLines.map { MenuItem($0) }
		var allIngredients = Set<String>()
		var allAllergens = Set<String>()
		for menuItem in menuItems {
			allIngredients.formUnion(menuItem.ingredients)
			allAllergens.formUnion(menuItem.allergens)
		}

		var maybeAllergens = [String: Set<String>]()
		for ingr in allIngredients {
			maybeAllergens[ingr] = Set()
		}
		for menuItem in menuItems {
			for ingr in menuItem.ingredients {
				maybeAllergens[ingr]?.formUnion(menuItem.allergens)
			}
		}

		while onePass() {}

		var safeIngredients = [String]()
		for (ingr, allergens) in maybeAllergens {
			if allergens.isEmpty {
				safeIngredients.append(ingr)
			}
		}
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

	override func solvePart2(inputLines: [String]) -> String {
		func onePass() -> Bool {
			var didReducePossibilities = false

			for ingr in allIngredients {
				let candidateAllergens = maybeAllergens[ingr]!
				for allergen in candidateAllergens {
					for menuItem in menuItems {
						if menuItem.allergens.contains(allergen) && !menuItem.ingredients.contains(ingr) {
							maybeAllergens[ingr]!.remove(allergen)
							didReducePossibilities = true
						}
					}
				}
			}

			return didReducePossibilities
		}

		let menuItems = inputLines.map { MenuItem($0) }
		var allIngredients = Set<String>()
		var allAllergens = Set<String>()
		for menuItem in menuItems {
			allIngredients.formUnion(menuItem.ingredients)
			allAllergens.formUnion(menuItem.allergens)
		}

		var maybeAllergens = [String: Set<String>]()
		for ingr in allIngredients {
			maybeAllergens[ingr] = Set()
		}
		for menuItem in menuItems {
			for ingr in menuItem.ingredients {
				maybeAllergens[ingr]?.formUnion(menuItem.allergens)
			}
		}

		while onePass() {}

		var safeIngredients = [String]()
		for (ingr, allergens) in maybeAllergens {
			if allergens.isEmpty {
				safeIngredients.append(ingr)
			}
		}

//		func onePassPart2() -> Bool {
//			var didReducePossibilities = false
//
//			for ingr in badIngredients {
//				let candidateAllergens = maybeAllergens[ingr]!
//				for allergen in candidateAllergens {
//					for menuItem in menuItems {
//						if menuItem.allergens.contains(allergen) && !menuItem.ingredients.contains(ingr) {
//							maybeAllergens[ingr]!.remove(allergen)
//							didReducePossibilities = true
//						}
//					}
//				}
//			}
//
//			return didReducePossibilities
//		}

		let badIngredients = allIngredients.subtracting(safeIngredients)
//		print(badIngredients)
//		for ingr in badIngredients {
//			print(maybeAllergens[ingr]!)
//		}

		while true {
			var didReduce = false
			for ingr in badIngredients {
				if maybeAllergens[ingr]!.count == 1 {
					let matchedAllergen = maybeAllergens[ingr]!.first!
					for otherIngr in badIngredients {
						if maybeAllergens[otherIngr]!.count > 1 && maybeAllergens[otherIngr]!.contains(matchedAllergen) {
							maybeAllergens[otherIngr]!.remove(matchedAllergen)
							didReduce = true
						}
					}
				}
			}
			if !didReduce {
				break
			}
		}
		var allergenToIngredient = [String: String]()
		for ingr in badIngredients {
			allergenToIngredient[maybeAllergens[ingr]!.first!] = ingr
		}
//		print(allergenToIngredient)
		let ingredientsSortedByAllergen = allergenToIngredient.keys.sorted().map { allergenToIngredient[$0]! }
//		print(ingredientsSortedByAllergen)

		return ingredientsSortedByAllergen.joined(separator: ",")
	}
}


