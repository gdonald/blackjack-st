FileStream fileIn: 'card.st'.

Object subclass: Shoe [
    | game cards |

    Shoe class >> game: aGame [
        ^ self new initialize: aGame
    ]

    Shoe >> initialize: aGame [
        game := aGame.
        cards := OrderedCollection new.

        ^ self
    ]

    Shoe class >> ShuffleSpecs [
        ^ #(80 81 82 84 86 89 92 95)
    ]

    Shoe >> cards [ ^ cards ]

    Shoe >> getNextCard [
        | card |
        card := cards first.
        cards removeFirst.
        ^ card
    ]

    Shoe >> needToShuffle [
        | totalCards cardsDealt used |

        cards isEmpty ifTrue: [ ^ true ].

        totalCards := game getTotalCards.
        cardsDealt := totalCards - cards size.
        used := (cardsDealt / totalCards) * 100.0.

        ^ used > (Shoe ShuffleSpecs at: game numDecks)
    ]

    Shoe >> buildNewShoe [
        (game deckType = 2) ifTrue: [ ^ self newAces ].
        (game deckType = 3) ifTrue: [ ^ self newJacks ].
        (game deckType = 4) ifTrue: [ ^ self newAcesJacks ].
        (game deckType = 5) ifTrue: [ ^ self newSevens ].
        (game deckType = 6) ifTrue: [ ^ self newEights ].

        self newRegular
    ]

    Shoe >> newShoeWithValues: values [
        | totalCards suit value |

        cards := OrderedCollection new.
        totalCards := game getTotalCards.

        [(cards size) < totalCards] whileTrue: [
            (1 to: 4) do: [ :suit |
                ((cards size) >= totalCards)
                    ifFalse: [
                        values do: [ :value |
                            ((cards size) >= totalCards)
                                ifFalse: [
                                    cards add: (Card initializeWithValue: value suit: suit).
                                ].
                        ].
                    ].
            ].
        ].

        self shuffle.
    ]

    Shoe >> newAces      [ self newShoeWithValues: #(1) ]
    Shoe >> newJacks     [ self newShoeWithValues: #(11) ]
    Shoe >> newAcesJacks [ self newShoeWithValues: #(1 11) ]
    Shoe >> newRegular   [ self newShoeWithValues: (1 to: 13) ]
    Shoe >> newSevens    [ self newShoeWithValues: #(7) ]
    Shoe >> newEights    [ self newShoeWithValues: #(8) ]

    Shoe >> shuffle [
        | size randIndex tmp |

        size := cards size.

        (1 to: size) do: [ :i |
            randIndex := (1 to: size) atRandom.
            tmp := cards at: i.
            cards at: i put: (cards at: randIndex).
            cards at: randIndex put: tmp.
        ].
    ]
]
