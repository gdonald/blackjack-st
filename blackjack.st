FileStream fileIn: 'game.st'.

|game|
game := Game new.

"[ game quitting ] whileFalse: ["
    game dealNewHand.
"]"

" (game shoe cards) do: [ :card |
    Transcript show: (game drawCard: card); cr.
]. "

" Transcript show: (game shoe cards size) asString; cr. "

" (game dealerHand cards) do: [ :card |
    Transcript show: (game drawCard: card); cr.
]. "

game drawHands.
