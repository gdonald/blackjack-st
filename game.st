FileStream fileIn: 'shoe.st'.

Object subclass: Game [
    |shoe dealerHand playerHands money numDecks deckType faceType currentBet currentHand quitting|

    Game class >> new [
        ^ super new initialize.
    ]
    
    Game >> initialize [
        quitting := false.
        numDecks := 1.
        shoe := Shoe game: self.
    ]

    Game >> quitting [
        ^ quitting
    ]

    Game >> numDecks [
        ^ numDecks
    ]

    Game >> shoe [
        ^ shoe
    ]

    Game >> shuffle: aShoe [
        
    ]
    
    Game >> dealNewHand [
        (true) ifTrue: [shoe shuffle].
        
        
    ]
]
