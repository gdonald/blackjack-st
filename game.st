FileStream fileIn: 'shoe.st'.
FileStream fileIn: 'dealer_hand.st'.
FileStream fileIn: 'player_hand.st'.
FileStream fileIn: 'count_method.st'.

Object subclass: Game [
    | shoe dealerHand playerHands money numDecks deckType faceType currentBet currentHand quitting |

    Game class >> new [
        ^ super new initialize.
    ]
    
    Game >> initialize [
        | playerHand |

        numDecks := 1.
        deckType := 1.
        faceType := 1.
        currentBet := 500.
        money := 10000.
        shoe := Shoe game: self.
        quitting := false.
    ]

    Game class >> CardsPerDeck [
        ^ 52
    ]

    Game class >> MaxPlayerHands [
        ^ 7
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

    Game >> currentBet [
        ^ currentBet
    ]

    Game >> clear [

    ]

    Game >> dealerHand [
        ^ dealerHand
    ]

    Game >> playerHands [
        ^ playerHands
    ]

    Game >> drawHands [
        self clear.

        Transcript show: ''; cr.
        Transcript show: 'Dealer:'; cr.
        Transcript show: dealerHand drawHand; cr; cr.

        Transcript show: 'Player $'.
        Transcript show: (Game FormatMoney: money).
        Transcript show: ':'; cr.

        playerHands doWithIndex: [ :playerHand :index |
            Transcript show: (playerHand drawHand: index); cr.
        ].
    ]

    Game class >> FormatMoney: money [
        | dollars cents formattedCents |

        dollars := (money // 100) asInteger.
        cents := (money \\ 100) asInteger.
        formattedCents := (cents < 10) 
            ifTrue: ['0', cents asString] 
            ifFalse: [cents asString].
        
        ^ dollars asString , '.' , formattedCents
    ]
    
    Game >> dealNewHand [
        | playerHand |

        (shoe needToShuffle) ifTrue: [shoe buildNewShoe: deckType].

        playerHand := PlayerHand game: self.
        playerHands := OrderedCollection new.
        playerHands add: playerHand.
        currentHand := 1.

        dealerHand := DealerHand game: self.

        playerHand dealCard.
        dealerHand dealCard.
        playerHand dealCard.
        dealerHand dealCard.
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
