FileStream fileIn: 'hand.st'.
FileStream fileIn: 'hand_status.st'.

Hand subclass: PlayerHand [
    | bet status paid |

    PlayerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    PlayerHand >> initialize: aGame [
        super initialize: aGame.
        bet := aGame currentBet.
        status := HandStatus Unknown.
        paid := false.

        ^ self
    ]

    PlayerHand >> paid [
        ^ paid
    ]

    PlayerHand >> paid: aBoolean [
        paid := aBoolean.
    ]

    PlayerHand >> getValue: countMethod [
        | v total tmpV |

        v := 0.
        total := 0.

        cards doWithIndex: [ :card :index |
            tmpV := card value.
            v := tmpV > 9 ifTrue: [ 10 ] ifFalse: [ tmpV ].

            ((countMethod = CountMethod Soft) and: [ v = 1 and: [ total < 11 ] ]) ifTrue: [
                v := 11.
            ].

            total := total + v.
        ].
        
        ((countMethod = CountMethod Soft) and: [ total > 21 ]) ifTrue: [
            ^ self getValue: CountMethod Hard.
        ].        

        ^ total
    ]

    PlayerHand >> drawHand: currentCardIndex [
        | cardsString index cardCount |
        
        index := 1.
        cardCount := cards size.
        cardsString := ''.

        cards do: [:card |
                    cardsString := cardsString, (game drawCard: card).
                    cardsString := cardsString, ' '.
                    index := index + 1.
                  ].

        cardsString := cardsString, ' ⇒  '.
        cardsString := cardsString, (self getValue: CountMethod Soft) asString.

        ^ cardsString
    ]

    PlayerHand >> isBusted [
        ^ self getValue: CountMethod Soft > 21
    ]

    PlayerHand >> isDone [
        " | softValue hardValue |

        softValue := self getValue: CountMethod Soft.
        hardValue := self getValue: CountMethod Hard.

        ((played or: stood) or: (self isBlackjack or: self isBusted)) or: ([21 = softValue] or: [21 = hardValue]) ifTrue: [
            played := true.

            paid ifFalse: [
                (self isBusted) ifTrue: [
                    paid := true.
                    status := HandStatus Lost.
                    game money: game money - bet.
                ].
            ].

            ^ true.
        ].

        ^ false. "

        ^ true.
    ]

    PlayerHand >> canSplit [
        (stood or: (game playerHands size >= PlayerHand maxPlayerHands)) ifTrue: [ ^ false ].

        (game money < (game allBets + bet)) ifTrue: [ ^ false ].

        (cards size = 2 and: [(cards at: 1) value = (cards at: 2) value]) ifTrue: [ ^ true ].

        ^ false.
    ]

    PlayerHand >> canDbl [
        (game money < (game allBets + bet)) ifTrue: [ ^ false ].

        (stood or: (cards size ~= 2) or: self isBusted or: self isBlackjack) ifTrue: [ ^ false ].

        ^ true.
    ]

    PlayerHand >> canStand [
        (stood or: self isBusted or: self isBlackjack) ifTrue: [ ^ false ].

        ^ true.
    ]

    PlayerHand >> canHit [
        (played or: stood or: (self getValue: CountMethod Hard) = 21 or: self isBlackjack or: self isBusted) ifTrue: [ ^ false ].

        ^ true.
    ]

    PlayerHand >> hit [
        self dealCard.

        (self isDone) ifTrue: [
            self process.
            ^ self.
        ].

        game drawHands.
        (game playerHands at: game currentPlayerHand) getAction.
    ]

    PlayerHand >> dbl [
        self dealCard.
        played := true.
        bet := bet * 2.

        (self isDone) ifTrue: [
            self process.
        ].
    ]

    PlayerHand >> stand [
        stood := true.
        played := true.

        (game moreHandsToPlay) ifTrue: [
            game playMoreHands.
            ^ self.
        ].

        game playDealerHand.
        game drawHands.
        game betOptions.
    ]

    PlayerHand >> process [
        (game moreHandsToPlay) ifTrue: [
            game playMoreHands.
            ^ self.
        ].

        game playDealerHand.
        game drawHands.
        game betOptions.
    ]
]
