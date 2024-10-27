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
        | cardsString |
        cardsString := ''.

        cards do: [:card | 
            cardsString := cardsString, card toString, ' '.
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
