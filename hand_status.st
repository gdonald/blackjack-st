Object subclass: HandStatus [
    HandStatus class >> Unknown [
        ^ 0
    ]

    HandStatus class >> Won [
        ^ 1
    ]

    HandStatus class >> Lost [
        ^ 2
    ]

    HandStatus class >> Push [
        ^ 3
    ]
]
