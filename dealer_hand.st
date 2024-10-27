FileStream fileIn: 'hand.st'.

Hand subclass: DealerHand [
    DealerHand class >> new [
        ^ super new initialize
    ]

    DealerHand >> initialize [
        super initialize.

        ^ self
    ]
]