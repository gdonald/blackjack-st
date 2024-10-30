FileStream fileIn: 'card.st'.
FileStream fileIn: 'hand.st'.
FileStream fileIn: 'dealer_hand.st'.
FileStream fileIn: 'player_hand.st'.

| card card2 |
card := Card value: 13 suit: 1.
card2 := Card value: 2 suit: 2.

Transcript show: card toString; cr.
Transcript show: card2 toString; cr.


| playerHand |
playerHand := PlayerHand new.

Transcript show: playerHand toString; cr.

playerHand cards add: card.

Transcript show: playerHand toString; cr.

playerHand cards add: card2.

Transcript show: playerHand toString; cr.

playerHand played: true.

Transcript show: playerHand toString; cr.
