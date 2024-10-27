FileStream fileIn: 'card.st'.

| card card2 |
card := Card value: 13 suit: 1.
card2 := Card value: 2 suit: 2.

Transcript show: card toString; cr.
Transcript show: card2 toString; cr.
