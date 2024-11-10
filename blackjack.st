FileStream fileIn: 'game.st'.

|game|
game := Game new.

"[ game quitting ] whileFalse: ["
    game dealNewHand.
"]"

(game shoe cards) do: [ :card |
    Transcript show: card toString; cr.
].
