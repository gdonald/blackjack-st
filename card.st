Object subclass: Card [
    | value suit |

    Card class >> value: aValue suit: aSuit [
        ^ self new initializeValue: aValue suit: aSuit
    ]
    
    Card >> initializeValue: aValue suit: aSuit [
        value := aValue.
        suit := aSuit.
        ^ self
    ]

    Card >> toString [
        ^ (Card faces at: value) at: suit
    ]

    Card class >> faces [
        ^ #(
           ('🂡' '🂱' '🃁' '🃑')
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
].
