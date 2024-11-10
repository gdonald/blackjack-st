Object subclass: Card [
    | game value suit |

    " Card class >> game: aGame value: aValue suit: aSuit [
        ^ self new initialize: aGame value: aValue suit: aSuit
    ] "

    Card class >> initializeWithGame: aGame value: aValue suit: aSuit [
        ^ self new initialize: aGame value: aValue suit: aSuit
    ]
    
    Card >> initialize: aGame value: aValue suit: aSuit [
        game := aGame.
        value := aValue.
        suit := aSuit.
        ^ self
    ]

    Card >> toString [
        ^ (Card faces at: value) at: suit
    ]

    Card class >> faces [
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
