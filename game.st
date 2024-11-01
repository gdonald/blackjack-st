FileStream fileIn: 'shoe.st'.

Object subclass: Game [
    |shoe dealerHand playerHands money numDecks deckType faceType currentBet currentHand quitting|

    Game class >> new [
        ^super new initialize.
    ]
    
    Game >> initialize [
        quitting := false.
        shoe := Shoe new.
    ]

    Game >> quitting [
        ^quitting
    ]

    Game >> dealNewHand [
        (true) ifTrue: [shoe shuffle].
    ]
]
