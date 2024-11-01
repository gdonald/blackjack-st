Object subclass: Hand [
    | cards played |

    Hand class >> new [
        ^ super new initialize
    ]

    Hand >> initialize [
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
