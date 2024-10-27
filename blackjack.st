FileStream fileIn: 'card.st'.
FileStream fileIn: 'hand.st'.
FileStream fileIn: 'dealer_hand.st'.

| card card2 |
card := Card value: 13 suit: 1.
card2 := Card value: 2 suit: 2.

Transcript show: card toString; cr.
Transcript show: card2 toString; cr.


| dealerHand |
dealerHand := DealerHand new.

Transcript show: dealerHand toString; cr.

dealerHand cards add: card.

Transcript show: dealerHand toString; cr.

dealerHand cards add: card2.

Transcript show: dealerHand toString; cr.

dealerHand played: true.

Transcript show: dealerHand toString; cr.
