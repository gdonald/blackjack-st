Object subclass: Hand [
    | game cards stood played |

    Hand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    Hand >> initialize: aGame [
        game := aGame.
        stood := false.
        played := false.
        cards := OrderedCollection new.

        ^ self
    ]

    Hand >> cards [
        ^ cards
    ]

    Hand >> played [
        ^ played
    ]

    Hand >> played: aBoolean [
        played := aBoolean.
    ]

    Hand >> dealCard [
        cards add: game shoe getNextCard.
    ]

    Hand >> isBlackjack [
        ^ (cards size = 2) and: [ (self getValue: CountMethod Hard) = 21 ]
    ]
]
