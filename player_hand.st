FileStream fileIn: 'hand.st'.

Hand subclass: PlayerHand [
    |bet|

    PlayerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    PlayerHand >> initialize: aGame [
        super initialize: aGame.
        bet := aGame currentBet.

        ^ self
    ]

    PlayerHand >> drawHand: currentCardIndex [
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
