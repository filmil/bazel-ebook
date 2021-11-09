# initialize the signals
POWER=0, FIRE=0, ARMED=0, LED=OFF, COUNT=N.
# turn on the power
POWER=1 => LED=GREEN.
# fire once to arm
FIRE=1.
FIRE => ARMED=1.
FIRE=0.
# fire a second time
FIRE=1.
FIRE, ARMED => LED=RED;
FIRE => COUNT="N+1".

