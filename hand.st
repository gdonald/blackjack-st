Object subclass: Hand [
    | game cards played |

    Hand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    Hand >> initialize: aGame [
        game := aGame.
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
]
