import Foundation

class Day22: DayNN {
	init() {
		super.init("Crab Combat")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "306"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "291"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let game = Game(inputLines)
		return String(game.playGame1())
	}

	override func solvePart2(inputLines: [String]) -> String {
		let game = Game(inputLines)
		return String(game.playGame2())
	}

	class Game {
		enum Player { case one, two }

		var deck1: [Int]
		var deck2: [Int]

		init(_ deck1: [Int], _ deck2: [Int]) {
			self.deck1 = deck1
			self.deck2 = deck2
		}

		convenience init(_ inputLines: [String]) {
			func makeDeck(_ lines: [String]) -> [Int] {
				// Start the range at 1 to ignore the first line in the group, which is
				// not a card number -- it just says which player the deck is for.
				return lines[1..<lines.count].map { Int($0)! }
			}

			let groups = groupedLines(inputLines)
			self.init(makeDeck(groups[0]), makeDeck(groups[1]))
		}

		/// Plays plain old non-recursive Combat.
		func playGame1() -> Int {
			while deck1.count > 0 && deck2.count > 0 {
				let (card1, card2) = (deck1.removeFirst(), deck2.removeFirst())
				if card1 > card2 {
					deck1.append(card1)
					deck1.append(card2)
				} else {
					deck2.append(card2)
					deck2.append(card1)
				}
			}

			if deck1.isEmpty {
				return score(deck2)
			} else {
				return score(deck1)
			}
		}

		/// Plays Recursive Combat.  Returns the score of the player that wins.
		func playGame2() -> Int {
			let winner = playOneGameOfRecursiveCombat()
			switch winner {
			case .one: return score(deck1)
			case .two: return score(deck2)
			}
		}

		/// Returns the player that wins.
		private func playOneGameOfRecursiveCombat() -> Player {
			var history = Set<[[Int]]>()

			// A **game** consists of one or more **rounds**.
			while true {
				// Test for end-of-game.
				if history.contains([deck1, deck2]) {
					// Game ends because the two decks have returned to a state they had
					// in an earlier round of the game.
					return .one
				} else if deck2.isEmpty {
					return .one
				} else if deck1.isEmpty {
					return .two
				}

				// Remember the state of the two decks so we can check if it's repeated.
				history.insert([deck1, deck2])

				// Play a round: each player deals a card, then we figure out which wins.
				playOneRoundOfRecursiveCombat()
			}
		}

		/// Assumes we are playing Recursive Combat.  Plays one round.  Each player deals
		/// a card, then we figure out which player wins.
		private func playOneRoundOfRecursiveCombat() {
			var winnerOfRound: Player
			let (card1, card2) = (deck1.removeFirst(), deck2.removeFirst())
			if card1 > deck1.count || card2 > deck2.count {
				// We can't recurse, which means we decide the winner of this round
				// based on which card is higher.
				winnerOfRound = (card1 > card2 ? .one : .two)
			} else {
				// We recurse to determine the winner of this round.
				let subgame = Game(Array(deck1[0..<card1]),
								   Array(deck2[0..<card2]))
				winnerOfRound = subgame.playOneGameOfRecursiveCombat()
			}

			// Add the cards that were dealt this round to the winner's deck.
			switch winnerOfRound {
			case .one:
				deck1.append(card1)
				deck1.append(card2)
			case .two:
				deck2.append(card2)
				deck2.append(card1)
			}
		}

		private func score(_ deck: [Int]) -> Int {
			var result = 0
			let reversedDeck = deck.reversed().map { Int($0) }
			for i in 0..<reversedDeck.count {
				result += (i + 1) * reversedDeck[i]
			}
			return result
		}
	}
}


