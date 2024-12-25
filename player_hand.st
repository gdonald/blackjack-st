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

    PlayerHand >> game [ ^ game ]

    PlayerHand >> bet [ ^ bet ]
    PlayerHand >> bet: aBet [ bet := aBet ]

    PlayerHand >> cards [ ^ cards ]
    PlayerHand >> cards: aCards [ cards := aCards ]

    PlayerHand >> paid [ ^ paid ]
    PlayerHand >> paid: aBoolean [ paid := aBoolean ]

    PlayerHand >> status: aStatus [ status := aStatus ]

    PlayerHand >> getValue: countMethod [
        | v total tmpV |

        v := 0.
        total := 0.

        cards doWithIndex: [ :card :index |
            tmpV := card value.
            v := tmpV > 9 ifTrue: [ 10 ] ifFalse: [ tmpV ].

            ((countMethod = CountMethod Soft) and: [ v = 1 and: [ total < 11 ] ])
                ifTrue: [
                    v := 11.
                ].

            total := total + v.
        ].

        ((countMethod = CountMethod Soft) and: [ total > 21 ]) ifTrue: [
            ^ self getValue: CountMethod Hard.
        ].

        ^ total
    ]

    PlayerHand >> drawHand: currentHand [
        | cardsString index cardCount |

        index := 1.
        cardCount := cards size.
        cardsString := ' '.

        cards do: [:card |
                    cardsString := cardsString, (game drawCard: card).
                    cardsString := cardsString, ' '.
                    index := index + 1.
                  ].

        cardsString := cardsString, ' ⇒  '.
        cardsString := cardsString, (self getValue: CountMethod Soft) asString.
        cardsString := cardsString, '  '.

        (status = HandStatus Lost)
            ifTrue: [
                cardsString := cardsString, '-'.
            ].
        (status = HandStatus Won)
            ifTrue: [
                cardsString := cardsString, '+'.
            ].
        cardsString := cardsString, '$', (game formatMoney: bet).

        ((played not) and: [currentHand = game currentHand])
            ifTrue: [
                cardsString := cardsString, ' ⇐'.
            ].
        cardsString := cardsString, '  '.

        (status = HandStatus Lost)
            ifTrue: [
                (self isBusted)
                    ifTrue: [
                        cardsString := cardsString, 'Busted!'.
                    ] ifFalse: [
                        cardsString := cardsString, 'Lose!'.
                    ].
            ].

        (status = HandStatus Won)
            ifTrue: [
                (self isBlackjack)
                    ifTrue: [
                        cardsString := cardsString, 'Blackjack!'.
                    ] ifFalse: [
                        cardsString := cardsString, 'Win!'.
                    ].
            ].

        (status = HandStatus Push)
            ifTrue: [
                cardsString := cardsString, 'Push!'.
            ].

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
                (self isBusted)
                    ifTrue: [
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
        (game money < ((game allBets) + bet)) ifTrue: [ ^ false ].
        ((cards size = 2) and: [(cards at: 1) value = (cards at: 2) value]) ifTrue: [ ^ true ].

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

        (self isDone)
            ifTrue: [
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

        (self isDone)
            ifTrue: [
                self process.
            ].
    ]

    PlayerHand >> stand [
        stood := true.
        played := true.

        (game moreHandsToPlay)
            ifTrue: [
                game playMoreHands.
                ^ self.
            ].

        game playDealerHand.
        game drawHands.
        game gameOptions.
    ]

    PlayerHand >> process [
        (game moreHandsToPlay)
            ifTrue: [
                game playMoreHands.
                ^ self.
            ].

        game playDealerHand.
        game drawHands.
        game gameOptions.
    ]

    PlayerHand >> getAction [
        | out c |

        out := ' '.
        (self canHit)   ifTrue: [ out := out, '(H) Hit  ' ].
        (self canStand) ifTrue: [ out := out, '(S) Stand  ' ].
        (self canSplit) ifTrue: [ out := out, '(P) Split  ' ].
        (self canDbl)   ifTrue: [ out := out, '(D) Double  ' ].

        Transcript show: out; cr.
        c := (game getChar).

        ((c = $h) and: [self canHit]) ifTrue: [
            self hit.
            ^ self.
        ].

        ((c = $s) and: [self canStand]) ifTrue: [
            self stand.
            ^ self.
        ].

        ((c = $p) and: [self canSplit]) ifTrue: [
            game splitCurrentHand.
            ^ self.
        ].

        ((c = $d) and: [self canDbl]) ifTrue: [
            self dbl.
            ^ self.
        ].

        game drawHands.
        ^ self getAction.
    ]
]
