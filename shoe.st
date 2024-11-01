Object subclass: Shoe [
    |cards|

    Shoe class >> new [
        ^super new initialize
    ]

    Shoe >> initialize [
        cards := OrderedCollection new.

        ^self
    ]

    Shoe >> shuffle [
        cards := OrderedCollection new.
        
    ]
]
