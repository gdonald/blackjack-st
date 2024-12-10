FileStream fileIn: 'shoe.st'.
FileStream fileIn: 'dealer_hand.st'.
FileStream fileIn: 'player_hand.st'.

Object subclass: Game [
    |shoe dealerHand playerHands money numDecks deckType faceType currentBet currentHand quitting|

    Game class >> new [
        ^ super new initialize.
    ]
    
    Game >> initialize [
        |playerHand|

        numDecks := 1.
        deckType := 1.
        faceType := 1.
        currentBet := 500.
        money := 10000.
        
        shoe := Shoe game: self.
        
        dealerHand := DealerHand game: self.
        
        playerHand := PlayerHand game: self.
        playerHands := OrderedCollection new.
        playerHands add: playerHand.
        currentHand := 1.

        quitting := false.
    ]

    Game class >> CardsPerDeck [
        ^ 52
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
    
    Game >> dealNewHand [
        (true) ifTrue: [shoe newRegular].
    ]

    Game >> getTotalCards [
        ^ numDecks * (Game CardsPerDeck)
    ]

    Game >> drawCard: aCard [
        faceType = 2 ifTrue: [
            ^ (Card faces2 at: (aCard value)) at: (aCard suit).
        ].
        
        ^ (Card faces at: (aCard value)) at: (aCard suit).
    ]
]
