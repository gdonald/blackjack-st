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

    Game class >> SaveFile [
        ^ 'blackjack.txt'
    ]

    Game class >> CardsPerDeck [
        ^ 52
    ]

    Game class >> MaxPlayerHands [
        ^ 7
    ]

    Game class >> MinBet [
        ^ 500
    ]

    Game class >> MaxBet [
        ^ 10000000
    ]

    Game >> money [
        ^ money
    ]

    Game >> money: aMoney [
        money := aMoney.
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

    Game >> currentHand [
        ^ currentHand
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

        1 to: 2 do: [ :x |
            (playerHands at: 1) dealCard.
            dealerHand dealCard.
        ].

        (dealerHand upcardIsAce) ifTrue: [
            self drawHands.
            self askInsurance.
            ^ self.
        ].

        ((playerHands at: 1) isDone) ifTrue: [
            dealerHand hideDownCard: false.
        ].

        ((playerHands at: 1) isDone) ifTrue: [
            self payHands.
            self drawHands.
            self betOptions.
            ^ self.
        ].

        self drawHands.
        (playerHands at: 1) getAction.
        self saveGame.
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

    Game >> allBets [
        | bets |
        bets := 0.

        playerHands do: [ :playerHand |
            bets := bets + playerHand bet.
        ].

        ^ bets.
    ]

    Game >> askInsurance [
        | br c |
        Transcript show: ' Insurance? (Y) Yes  (N) No'; cr.
        br := false.

        [ br not ] whileTrue: [
            c := (FileStream stdin next: 1) asLowercase.

            (c = 'y') ifTrue: [
                br := true.
                self insureHand.
            ].

            (c = 'n') ifTrue: [
                br := true.
                self noInsurance.
            ].
        ].
    ]

    Game >> noInsurance [
        | playerHand |

        (dealerHand isBlackjack) ifTrue: [
            dealerHand hideDownCard: false.
            dealerHand played: true.
            self payHands.
            self drawHands.
            self betOptions.
            ^ self.
        ].

        playerHand := playerHands at: currentHand.

        (playerHand isDone) ifTrue: [
            self playDealerHand.
            self drawHands.
            self betOptions.
            ^ self.
        ].

        self drawHands.
        playerHand getAction.
    ]

    Game >> insureHand [
        | playerHand |

        playerHand := playerHands at: currentHand.

        playerHand bet: (playerHand bet / 2).
        playerHand played: true.
        playerHand paid: true.
        playerHand status: HandStatus Lost.
        self money: money - (playerHand bet).

        self drawHands.
        self betOptions.
    ]

    Game >> normalizeBet [
        (currentBet < Game MinBet) ifTrue: [
            currentBet := Game MinBet.
        ] ifFalse: [
            (currentBet > Game MaxBet) ifTrue: [
                currentBet := Game MaxBet.
            ].
        ].

        (currentBet > money) ifTrue: [
            currentBet := money.
        ].
    ]

    Game >> payHands [
        | dhv dhb phv |

        dhv := dealerHand getValue: CountMethod Soft.
        dhb := dealerHand isBusted.

        playerHands do: [ :playerHand |
            playerHand paid ifTrue: [ ^ self ].

            playerHand paid: true.
            phv := playerHand getValue: CountMethod Soft.

            " (dhb = true or: (phv > dhv)) ifTrue: [
                (playerHand isBlackjack) ifTrue: [
                    playerHand bet: playerHand bet * 1.5.
                ].
                self money: self money + playerHand bet.
                playerHand status: HandStatus Won.
            ] ifFalse: [
                (phv < dhv) ifTrue: [
                    self money: self money - playerHand bet.
                    playerHand status: HandStatus Lost.
                ] ifFalse: [
                    playerHand status: HandStatus Push.
                ].
            ]. "
        ].

        self normalizeBet.
        self saveGame.
    ]

    Game >> needToPlayDealerHand [
        | playerHand |

        playerHands do: [ :playerHand |
            (playerHand isBusted or: [ playerHand isBlackjack ]) ifFalse: [ ^ true ].
        ].

        ^ false.
    ]

    Game >> playDealerHand [
        | softCount hardCount |

        (dealerHand isBlackjack) ifTrue: [
            dealerHand hideDownCard: false.
        ].

        (self needToPlayDealerHand not) ifTrue: [
            dealerHand played: true.
            self payHands.
            ^ self.
        ].

        dealerHand hideDownCard: false.

        softCount := dealerHand getValue: CountMethod Soft.
        hardCount := dealerHand getValue: CountMethod Hard.

        (softCount < 18 and: [hardCount < 17]) ifTrue: [
            [ (softCount < 18 and: [hardCount < 17]) ] whileTrue: [
                dealerHand dealCard.
                softCount := dealerHand getValue: CountMethod Soft.
                hardCount := dealerHand getValue: CountMethod Hard.
            ].
        ].

        dealerHand played: true.
        self payHands.
    ]

    Game >> saveGame [
        | file |

        [ 
            file := FileStream fileNamed: Game SaveFile mode: 'w'.
        ] on: Error do: [ :ex | file := nil ].

        file ifNotNil: [
            file nextPutAll: (String streamContents: [ :stream |
                stream nextPutAll: shoe numDecks asString; nextPut: $|.
                stream nextPutAll: money asString; nextPut: $|.
                stream nextPutAll: currentBet asString; nextPut: $|.
                stream nextPutAll: deckType asString; nextPut: $|.
                stream nextPutAll: faceType asString.
            ]).
            file close.
        ].
    ]

    Game >> betOptions [
        | br c |

        Transcript show: ' (D) Deal Hand  (B) Change Bet  (O) Options  (Q) Quit'; cr.
        br := false.

        [ br not ] whileTrue: [
            c := (FileStream stdin next: 1) asLowercase.

            (c = 'd') ifTrue: [
                br := true
            ].
            (c = 'b') ifTrue: [
                br := true.
                self getNewBet.
            ].
            (c = 'o') ifTrue: [
                br := true.
                self gameOptions.
            ].
            (c = 'q') ifTrue: [
                br := true.
                quitting := true.
                self clear.
            ].
        ].
    ]

    Game >> moreHandsToPlay [
        ^ currentHand < (playerHands size).
    ]
]
