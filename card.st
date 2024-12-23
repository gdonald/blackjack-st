Object subclass: Card [
    | value suit |

    Card class >> initializeWithValue: aValue suit: aSuit [
        ^ self new initialize: aValue suit: aSuit
    ]
    
    Card >> initialize: aValue suit: aSuit [
        value := aValue.
        suit := aSuit.

        ^ self
    ]

    Card >> value [ ^ value ]
    Card >> suit [ ^ suit ]

    Card >> isAce [ ^ value = 1 ]
    Card >> isTen [ ^ value > 9 ]

    Card class >> faces [
        ^ #(('A♠' 'A♥' 'A♣' 'A♦')
            ('2♠' '2♥' '2♣' '2♦')
            ('3♠' '3♥' '3♣' '3♦')
            ('4♠' '4♥' '4♣' '4♦')
            ('5♠' '5♥' '5♣' '5♦')
            ('6♠' '6♥' '6♣' '6♦')
            ('7♠' '7♥' '7♣' '7♦')
            ('8♠' '8♥' '8♣' '8♦')
            ('9♠' '9♥' '9♣' '9♦')
            ('T♠' 'T♥' 'T♣' 'T♦')
            ('J♠' 'J♥' 'J♣' 'J♦')
            ('Q♠' 'Q♥' 'Q♣' 'Q♦')
            ('K♠' 'K♥' 'K♣' 'K♦')
            ('??'))
    ]

    Card class >> faces2 [
        ^ #(('🂡' '🂱' '🃁' '🃑')
            ('🂢' '🂲' '🃂' '🃒')
            ('🂣' '🂳' '🃃' '🃓')
            ('🂤' '🂴' '🃄' '🃔')
            ('🂥' '🂵' '🃅' '🃕')
            ('🂦' '🂶' '🃆' '🃖')
            ('🂧' '🂷' '🃇' '🃗')
            ('🂨' '🂸' '🃈' '🃘')
            ('🂩' '🂹' '🃉' '🃙')
            ('🂪' '🂺' '🃊' '🃚')
            ('🂫' '🂻' '🃋' '🃛')
            ('🂭' '🂽' '🃍' '🃝')
            ('🂮' '🂾' '🃎' '🃞')
            ('🂠'))
    ]
]
