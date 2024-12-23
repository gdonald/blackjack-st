FileStream fileIn: 'hand.st'.
FileStream fileIn: 'card.st'.

Hand subclass: DealerHand [
    | hideDownCard |

    DealerHand class >> game: aGame [
        ^ super new initialize: aGame
    ]

    DealerHand >> initialize: aGame [
        super initialize: aGame.
        hideDownCard := true.

        ^ self
    ]

    DealerHand >> hideDownCard [ ^ hideDownCard ]
    DealerHand >> hideDownCard: aBoolean [ hideDownCard := aBoolean ]

    DealerHand >> upcardIsAce [
        ^ (cards at: 1) isAce
    ]

    DealerHand >> getValue: countMethod [
        | v total tmpV |

        v := 0.
        total := 0.

        cards doWithIndex: [ :card :index |
            (hideDownCard and: [index = 2])
                ifFalse: [
                    tmpV := card value.
                    v := tmpV > 9 ifTrue: [ 10 ] ifFalse: [ tmpV ].

                    ((countMethod = CountMethod Soft) and: [ v = 1 and: [ total < 11 ] ])
                        ifTrue: [
                            v := 11.
                        ].

                    total := total + v.
                ].
        ].
        
        ((countMethod = CountMethod Soft) and: [ total > 21 ])
            ifTrue: [
                ^ self getValue: CountMethod Hard.
            ].     

        ^ total
    ]

    DealerHand >> drawHand [
        | cardsString index cardCount cardToDraw |

        index := 1.
        cardCount := cards size.
        cardsString := ' '.

        cards do: [:card |
                    (hideDownCard and: [index = 2])
                        ifTrue: [
                            cardToDraw := Card initializeWithValue: 14 suit: 1.
                        ]
                        ifFalse: [
                            cardToDraw := card.
                        ].
                    
                    cardsString := cardsString, (game drawCard: cardToDraw).
                    cardsString := cardsString, ' '.
                    index := index + 1.
                  ].

        cardsString := cardsString, ' ⇒  '.
        cardsString := cardsString, (self getValue: CountMethod Soft) asString.

        ^ cardsString
    ]

    DealerHand >> isBusted [
        ^ (self getValue: (CountMethod Soft)) > 21
    ]
]
