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

    Shoe >> newShoeWithValues: values [
        | totalCards suit value card |
        cards := OrderedCollection new.
        totalCards := game getTotalCards.

        [ (cards size) < totalCards ] whileTrue: [
            (1 to: 4) do: [ :suit |
                ((cards size) >= totalCards) ifTrue: [ ^ self ].

                values do: [ :value |
                    ((cards size) >= totalCards) ifTrue: [ ^ self ].
                    cards add: (Card initializeWithValue: value suit: suit).
                ].
            ].
        ].

        self shuffle.
    ]

    Shoe >> newRegular [
        | values |
        values := (1 to: 13) asArray.
        self newShoeWithValues: values.
    ]

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
