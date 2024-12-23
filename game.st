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

    Game class >> Run [
        | game |

        game := Game new.
        game loadSavedGame.

        [ game quitting ]
            whileFalse: [
                game dealNewHand.
            ].
    ]

    Game class >> SaveFile [ ^ 'blackjack.txt' ]
    Game class >> CardsPerDeck [ ^ 52 ]
    Game class >> MaxPlayerHands [ ^ 7 ]
    Game class >> MinBet [ ^ 500 ]
    Game class >> MaxBet [ ^ 10000000 ]

    Game >> money [ ^ money ]
    Game >> money: aMoney [ money := aMoney ]

    Game >> quitting [ ^ quitting ]

    Game >> numDecks [ ^ numDecks ]
    Game >> numDecks: aNumDecks [ numDecks := aNumDecks ]

    Game >> shoe [ ^ shoe ]

    Game >> currentBet [ ^ currentBet ]
    Game >> currentBet: aBet [ currentBet := aBet ]

    Game >> currentHand [ ^ currentHand ]
    Game >> currentHand: aCurrentHand [ currentHand := aCurrentHand ]

    Game >> deckType [ ^ deckType ]
    Game >> deckType: aDeckType [ deckType := aDeckType ]

    Game >> faceType [ ^ faceType ]
    Game >> faceType: aFaceType [ faceType := aFaceType ]

    Game >> dealerHand [ ^ dealerHand ]
    Game >> playerHands [ ^ playerHands ]

    Game class >> FormatMoney: money [
        | dollars cents formattedCents |

        dollars := (money // 100) asInteger.
        cents := (money \\ 100) asInteger.
        formattedCents := (cents < 10)
            ifTrue: ['0', cents asString]
            ifFalse: [cents asString].

        ^ dollars asString , '.' , formattedCents
    ]

    Game >> formatMoney: money [
        ^ Game FormatMoney: money
    ]

    Game >> drawHands [
        self clear.

        Transcript show: ''; cr.
        Transcript show: ' Dealer:'; cr.
        Transcript show: dealerHand drawHand; cr; cr.

        Transcript show: ' Player $'.
        Transcript show: (Game FormatMoney: money).
        Transcript show: ':'; cr.

        playerHands doWithIndex: [ :playerHand :index |
            Transcript show: (playerHand drawHand: index); cr; cr.
        ].
    ]
    
    Game >> dealNewHand [
        | playerHand |

        (shoe needToShuffle) ifTrue: [ shoe buildNewShoe ].

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
            self gameOptions.
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
            self gameOptions.
            ^ self.
        ].

        playerHand := playerHands at: currentHand.

        (playerHand isDone) ifTrue: [
            self playDealerHand.
            self drawHands.
            self gameOptions.
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
        self gameOptions.
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
            (playerHand paid)
                ifFalse: [
                    playerHand paid: true.
                    phv := playerHand getValue: CountMethod Soft.

                    (dhb = true or: [phv > dhv])
                        ifTrue: [
                            (playerHand isBlackjack)
                                ifTrue: [
                                    playerHand bet: playerHand bet * 1.5.
                                ].
                            self money: self money + playerHand bet.
                            playerHand status: HandStatus Won.
                        ] ifFalse: [
                            (phv < dhv)
                                ifTrue: [
                                    self money: self money - playerHand bet.
                                    playerHand status: HandStatus Lost.
                                ] ifFalse: [
                                    playerHand status: HandStatus Push.
                                ].
                        ].
                ].
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

    Game >> gameOptions [
        | br c |

        Transcript show: ' (D) Deal Hand  (B) Change Bet  (O) Options  (Q) Quit'; cr.
        br := false.

        [ br not ] whileTrue: [
            c := (FileStream stdin next: 1) asLowercase.

            (c = 'd') ifTrue: [
                br := true.
            ].
            (c = 'b') ifTrue: [
                br := true.
                self betOptions.
            ].
            (c = 'o') ifTrue: [
                br := true.
                self configOptions.
            ].
            (c = 'q') ifTrue: [
                br := true.
                quitting := true.
                self clear.
            ].
        ].
    ]

    Game >> configOptions [
        | br c |

        self clear.
        self drawHands.

        Transcript show: ' (N) Number of Decks  (T) Deck Type  (F) Face Type  (B) Back'; cr.
        br := false.

        [ br not ] whileTrue: [
            c := (FileStream stdin next: 1) asLowercase.

            (c = 'n') ifTrue: [
                br := true.
                self numDecksOptions.
            ].
            (c = 't') ifTrue: [
                br := true.
                self deckTypeOptions.
            ].
            (c = 'f') ifTrue: [
                br := true.
                self faceTypeOptions.
            ].
            (c = 'b') ifTrue: [
                br := true.
                self clear.
                self drawHands.
                self gameOptions.
            ].
        ].
    ]

    Game >> deckTypeOptions [
        | c |

        self clear.
        self drawHands.

        Transcript show: ' (1) Regular  (2) Aces  (3) Jacks  (4) Aces & Jacks  (5) Sevens  (6) Eights'; cr.
        c := self getChar.

        ('123456' includes: c)
            ifTrue: [
                self deckType: (c digitValue).
                deckType > 1 ifTrue: [ self numDecks: 8. ].
                self saveGame.
                shoe buildNewShoe.
                self dealNewHand.
            ]
            ifFalse: [
                self deckTypeOptions.
            ].
    ]

    Game >> faceTypeOptions [
        | c |

        self clear.
        self drawHands.

        Transcript show: ' (1) A♠  (2) 🂡'; cr.
        c := self getChar.

        ('12' includes: c)
            ifTrue: [
                self faceType: (c digitValue).
                self saveGame.
                self dealNewHand.
            ]
            ifFalse: [
                self faceTypeOptions.
            ].
    ]

    Game >> numDecksOptions [
        | c |

        self clear.
        self drawHands.

        Transcript show: ' Number of Decks: '.
        Transcript show: numDecks asString.
        Transcript show: '  Enter New Number of Decks (1-8):'; cr.
        c := self getChar.

        ('12345678' includes: c)
            ifTrue: [
                self numDecks: (c digitValue).
                self saveGame.
                shoe buildNewShoe.
                self dealNewHand.
            ]
            ifFalse: [
                self numDecksOptions.
            ].
    ]

    Game >> moreHandsToPlay [
        ^ currentHand < (playerHands size).
    ]

    Game >> betOptions [
        | br c |

        br := false.

        self clear.
        self drawHands.

        Transcript show: ' (1) $5  (2) $10  (3) $25  (4) $100'; cr.

        [ br not ] whileTrue: [
            c := (FileStream stdin next: 1) asInteger.

            (c = 1) ifTrue: [
                br := true.
                currentBet := 500.
            ].
            (c = 2) ifTrue: [
                br := true.
                currentBet := 1000.
            ].
            (c = 3) ifTrue: [
                br := true.
                currentBet := 2500.
            ].
            (c = 4) ifTrue: [
                br := true.
                currentBet := 10000.
            ].
        ].

        self normalizeBet.
    ]

    Game >> getChar [
        [ FileStream stdin peek isSeparator ]
            whileTrue: [ FileStream stdin next ]. 

        ^ (FileStream stdin next: 1) first.
    ]

    Game >> splitCurrentHand [
        | handCount newHand currentPlayerHand splitHand h card |
        
        handCount := self playerHands size.
        newHand := PlayerHand game: self.
        self playerHands add: newHand.
        
        [ handCount > self currentHand ] whileTrue: [
            h := (self playerHands at: handCount) copy.
            self playerHands at: handCount + 1 put: h.
            handCount := handCount - 1
        ].
        
        currentPlayerHand := self playerHands at: self currentHand.
        splitHand := self playerHands at: (self currentHand + 1).
        
        card := (currentPlayerHand cards at: 2) copy.
        splitHand cards: OrderedCollection new.
        splitHand cards add: card.

        card := (currentPlayerHand cards at: 1) copy.
        currentPlayerHand cards: OrderedCollection new.
        currentPlayerHand cards add: card.
        
        currentPlayerHand dealCard.
        
        (currentPlayerHand isDone)
            ifTrue: [ 
                currentPlayerHand process.
                ^ self
            ].
        
        self drawHands.
        currentPlayerHand getAction
    ]

    Game >> playMoreHands [
        | playerHand |

        self currentHand: self currentHand + 1.
        playerHand := playerHands at: currentHand.
        playerHand dealCard.
        
        (playerHand isDone)
            ifTrue: [ 
                playerHand process.
                ^self
            ].
            
        self drawHands.
        playerHand getAction
    ]

    Game >> saveGame [
        | file |

        [
            file := FileStream open: (Game SaveFile) mode: #write.
        ] on: Error do: [ :ex | file := nil ].

        file ifNotNil: [
            file nextPutAll: (String streamContents: [ :stream |
                stream nextPutAll: numDecks asString; nextPut: $|.
                stream nextPutAll: money asString; nextPut: $|.
                stream nextPutAll: currentBet asString; nextPut: $|.
                stream nextPutAll: deckType asString; nextPut: $|.
                stream nextPutAll: faceType asString.
            ]).

            file close.
        ].

        ^ true.
    ]

    Game >> loadSavedGame [
        | file str array |

        str := ''.
        
        [
            file := FileStream open: (Game SaveFile) mode: #read.
        ] on: Error do: [ :ex | file := nil ].
        
        file notNil ifTrue: [
            str := file contents.
            file close.
            str := str trimSeparators
        ].
        
        array := str subStrings: '|'.

        (array size = 5)
            ifTrue: [
                self numDecks: ((array at: 1) asInteger).
                self money: ((array at: 2) asInteger).
                self currentBet: ((array at: 3) asInteger).
                self deckType: ((array at: 4) asInteger).
                self faceType: ((array at: 5) asInteger).
            ].
        
        (self money < Game MinBet)
            ifTrue: [
                self money: 10000.
                self currentBet: Game MinBet
            ].
    ]

    Game >> clear [
        FileStream stdout nextPutAll: (Character value: 27) asString, '[H', (Character value: 27) asString, '[J'.
    ]
]
