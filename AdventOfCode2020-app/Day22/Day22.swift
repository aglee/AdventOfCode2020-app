import Foundation

func score(_ deck: [Int]) -> Int {
	var result = 0
	let reversedDeck = deck.reversed().map { Int($0) }
	for i in 0..<reversedDeck.count {
		result += (i + 1) * reversedDeck[i]
	}
	return result
}

func makeDeck(_ lines: [String]) -> [Int] {
	var result = [Int]()
	for i in 1..<lines.count {
		result.append(Int(lines[i])!)
	}
	return result
}

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
		let groups = groupedLines(inputLines)
		var deck1 = makeDeck(groups[0])
		var deck2 = makeDeck(groups[1])

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

		let winner = (deck1.isEmpty ? deck2 : deck1)
		return String(score(winner))
	}

	class Game {
		struct Hand: Hashable {
			var deck1: [Int]
			var deck2: [Int]

			mutating func pop() -> (Int, Int) {
				return (deck1.removeFirst(), deck2.removeFirst())
			}
		}

		var hand: Hand

		var gameNumber: Int
		static var nextGameNumber = 1

		init(_ deck1: [Int], _ deck2: [Int]) {
			self.gameNumber = Game.nextGameNumber
			Game.nextGameNumber += 1
			self.hand = Hand(deck1: deck1, deck2: deck2)
		}

		convenience init(_ inputLines: [String]) {
			let groups = groupedLines(inputLines)
			self.init(makeDeck(groups[0]), makeDeck(groups[1]))
		}

		func playGame() -> Int {
			let winner = _playGameRecursively()
			DEBUGPRINT("")
			DEBUGPRINT("== Post-game results ==")
			DEBUGPRINT("Player 1's deck: \(hand.deck1.map { String($0) }.joined(separator: ", "))")
			DEBUGPRINT("Player 2's deck: \(hand.deck2.map { String($0) }.joined(separator: ", "))")
			if winner == 1 {
				return score(hand.deck1)
			} else if winner == 2 {
				return score(hand.deck2)
			}
			abort()
		}

		private func _playGameRecursively() -> Int {
			DEBUGPRINT("=== Game \(gameNumber) ===")

			var pastHands = Set<Hand>()
			var roundNumber = 1
			var winnerOfGame = -1

			while true {
				// Test for end-of-game.
				if pastHands.contains(hand) {
					winnerOfGame = 1
					break
				} else if hand.deck2.isEmpty {
					winnerOfGame = 1
					break
				} else if hand.deck1.isEmpty {
					winnerOfGame = 2
					break
				}

				// Remember this state in history.
				pastHands.insert(hand)

				// Play a round.
				DEBUGPRINT("")
				DEBUGPRINT("-- Round \(roundNumber) (Game \(gameNumber)) --")
				DEBUGPRINT("Player 1's deck: \(hand.deck1.map { String($0) }.joined(separator: ", "))")
				DEBUGPRINT("Player 2's deck: \(hand.deck2.map { String($0) }.joined(separator: ", "))")
				DEBUGPRINT("Player 1 plays: \(hand.deck1[0])")
				DEBUGPRINT("Player 2 plays: \(hand.deck2[0])")
				var winnerOfRound: Int
				let (card1, card2) = hand.pop()
				if card1 > hand.deck1.count || card2 > hand.deck2.count {
					winnerOfRound = (card1 > card2 ? 1 : 2)
				} else {
					// If we got here, we need to recurse.
					DEBUGPRINT("Playing a sub-game to determine the winner...")
					DEBUGPRINT("")
					let subgame = Game(Array(hand.deck1[0..<card1]),
									   Array(hand.deck2[0..<card2]))
					winnerOfRound = subgame._playGameRecursively()
					DEBUGPRINT("")
					DEBUGPRINT("...anyway, back to game \(gameNumber).")
				}

				DEBUGPRINT("Player \(winnerOfRound) wins round \(roundNumber) of game \(gameNumber)!")
				if winnerOfRound == 1 {
					hand.deck1.append(card1)
					hand.deck1.append(card2)
				} else {
					hand.deck2.append(card2)
					hand.deck2.append(card1)
				}

				roundNumber += 1
			}

			DEBUGPRINT("The winner of game \(gameNumber) is player \(winnerOfGame)!")
			return winnerOfGame
		}
	}

	override func solvePart2(inputLines: [String]) -> String {
		DEBUGPRINT_ENABLED = false
		let game = Game(inputLines)
		return String(game.playGame())
	}
}


