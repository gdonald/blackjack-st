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

    PlayerHand >> bet [
        ^ bet
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
        ^ (self getValue: CountMethod Soft) > 21
    ]

    PlayerHand >> isDone [
        | softValue hardValue |

        softValue := self getValue: CountMethod Soft.
        hardValue := self getValue: CountMethod Hard.

        stood ifTrue: [ played := true ].
        (self isBlackjack) ifTrue: [ played := true ].
        (self isBusted) ifTrue: [ played := true ].
        (softValue = 21) ifTrue: [ played := true ].
        (hardValue = 21) ifTrue: [ played := true ].

        played ifTrue: [
            paid ifFalse: [
                (self isBusted) ifTrue: [
                    paid := true.
                    status := HandStatus Lost.
                    game money: game money - bet.
                ].
            ].

            ^ true.
        ].

        ^ false.
    ]

    PlayerHand >> canSplit [
        stood ifTrue: [ ^ false ].
        (game playerHands size >= Game MaxPlayerHands) ifTrue: [ ^ false ].
        (game money < (game allBets + bet)) ifTrue: [ ^ false ].
        (cards size = 2 and: [(cards at: 1) value = (cards at: 2) value]) ifTrue: [ ^ true ].

        ^ false.
    ]

    PlayerHand >> canDbl [
        (game money < (game allBets + bet)) ifTrue: [ ^ false ].

        stood ifTrue: [ ^ false ].
        (cards size ~= 2) ifTrue: [ ^ false ].
        (self isBusted) ifTrue: [ ^ false ].
        (self isBlackjack) ifTrue: [ ^ false ].

        ^ true.
    ]

    PlayerHand >> canStand [
        stood ifTrue: [ ^ false ].
        (self isBusted) ifTrue: [ ^ false ].
        (self isBlackjack) ifTrue: [ ^ false ].

        ^ true.
    ]

    PlayerHand >> canHit [
        played ifTrue: [ ^ false ].
        stood ifTrue: [ ^ false ].
        (self getValue: CountMethod Hard) = 21 ifTrue: [ ^ false ].
        (self isBlackjack) ifTrue: [ ^ false ].
        (self isBusted) ifTrue: [ ^ false ].

        ^ true.
    ]

    PlayerHand >> hit [
        self dealCard.

        (self isDone) ifTrue: [
            self process.
            ^ self.
        ].

        game drawHands.
        (game playerHands at: game currentHand) getAction.
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

    PlayerHand >> getAction [
        | out br c |

        out := ' '.

        (self canHit) ifTrue: [ out := out, '(H) Hit  ' ].
        (self canStand) ifTrue: [ out := out, '(S) Stand  ' ].
        (self canSplit) ifTrue: [ out := out, '(P) Split  ' ].
        (self canDbl) ifTrue: [ out := out, '(D) Double  ' ].

        Transcript show: out; cr.

        br := false.

        [ br not ] whileTrue: [
            c := (FileStream stdin next: 1) asLowercase.

            (c = 'h') ifTrue: [
                br := true.
                self hit.
            ].
            (c = 's') ifTrue: [
                br := true.
                self stand.
            ].
            (c = 'p') ifTrue: [
                (self canSplit) ifTrue: [
                    br := true.
                    self game splitCurrentHand.
                ].
            ].
            (c = 'd') ifTrue: [
                br := true.
                self dbl.
            ].
        ].
    ]
]
