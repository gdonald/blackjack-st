FileStream fileIn: 'hand.st'.

Hand subclass: PlayerHand [
    PlayerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    PlayerHand >> initialize: aGame [
        super initialize: aGame.

        ^ self
    ]
]
