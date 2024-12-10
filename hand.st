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

    Hand >> toString [
        | cardsString index cardCount |
        cardsString := ''.
        index := 1.
        cardCount := cards size.

        cards do: [:card |
                   cardsString := cardsString, card toString.
                   (index < cardCount) ifTrue: [cardsString := cardsString, ' '].
                   index := index + 1.
                  ].

        ^ 'played: ', played printString, ' cards: [', cardsString, ']'
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
]
