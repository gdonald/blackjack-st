FileStream fileIn: 'hand.st'.

Hand subclass: PlayerHand [
    | bet |

    PlayerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    PlayerHand >> initialize: aGame [
        super initialize: aGame.
        bet := aGame currentBet.

        ^ self
    ]

    PlayerHand >> getValue: countMethod [
        | v total tmpV |

        v := 0.
        total := 0.

        cards doWithIndex: [ :card :index |
            tmpV := card value.
            v := tmpV > 9 ifTrue: [ 10 ] ifFalse: [ tmpV ].

            ((countMethod = CountMethod Soft) and: [ v = 1 and: [ total < 11 ] ]) ifTrue: [
                v := 11.
            ].

            total := total + v.
        ].
        
        ((countMethod = CountMethod Soft) and: [ total > 21 ]) ifTrue: [
            ^ self getValue: CountMethod Hard.
        ].        

        ^ total
    ]

    PlayerHand >> drawHand: currentCardIndex [
        | cardsString index cardCount |
        
        index := 1.
        cardCount := cards size.
        cardsString := ''.

        cards do: [:card |
                    cardsString := cardsString, (game drawCard: card).
                    cardsString := cardsString, ' '.
                    index := index + 1.
                  ].

        cardsString := cardsString, ' ⇒  '.
        cardsString := cardsString, (self getValue: CountMethod Soft) asString.

        ^ cardsString
    ]
]
