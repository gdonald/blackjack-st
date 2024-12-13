FileStream fileIn: 'game.st'.

| game |
game := Game new.

"[ game quitting ] whileFalse: ["
    game dealNewHand.
"]"

game drawHands.
