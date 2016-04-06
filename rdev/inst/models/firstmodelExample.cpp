
$PARAM CL=1, VC=20, KA=0.2
$INIT DEPOT = 1000, CENT = 0
$SET end=72, delta=0.25

$ODE

dxdt_DEPOT = -KA*DEPOT;
dxdt_CENT = KA*DEPOT - (CL/VC)*CENT;

$TABLE
table(CP) = CENT/VC;
