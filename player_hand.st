FileStream fileIn: 'hand.st'.

Hand subclass: PlayerHand [
    PlayerHand class >> new [
        ^ super new initialize
    ]

    PlayerHand >> initialize [
        super initialize.

        ^ self
    ]
]
