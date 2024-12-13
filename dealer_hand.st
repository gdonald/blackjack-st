FileStream fileIn: 'hand.st'.

Hand subclass: DealerHand [
    DealerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    DealerHand >> initialize: aGame [
        super initialize: aGame.

        ^ self
    ]

    DealerHand >> drawHand [
        |cardsString index cardCount|
        
        index := 1.
        cardCount := cards size.
        cardsString := ''.

        cards do: [:card |
                    cardsString := cardsString, (game drawCard: card).
                    (index < cardCount) ifTrue: [cardsString := cardsString, ' '].
                    index := index + 1.
                  ].

        ^ cardsString
    ]
]
