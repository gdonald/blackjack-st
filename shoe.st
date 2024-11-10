FileStream fileIn: 'card.st'.

Object subclass: Shoe [
    |game cards|

    Shoe class >> game: aGame [
        ^ self new initialize: aGame
    ]

    Shoe >> initialize: aGame [
        game := aGame.
        cards := OrderedCollection new.
        ^ self
    ]

    Shoe >> cards [
        ^ cards
    ]

    Shoe >> shuffle [
        cards := OrderedCollection new.

        (game numDecks) timesRepeat: [
            (1 to: 4) do: [ :suit |
                             (1 to: 13) do: [ :value |
                                               cards add: (Card initializeWithGame: game value: value suit: suit).
                                             ].
                           ].
        ].
    ]
]
