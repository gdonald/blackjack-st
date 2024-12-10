FileStream fileIn: 'hand.st'.

Hand subclass: DealerHand [
    DealerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    DealerHand >> initialize: aGame [
        super initialize: aGame.

        ^ self
    ]
]
