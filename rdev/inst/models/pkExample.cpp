$PARAM  KA = 0.5, CL = 1, VC = 10, Q=2, VP=20
$CMT GUT CENT PERIPH
$SET end=36, delta=0.5

$ODE
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT - (CL/VC)*CENT - (Q/VC)*CENT + (Q/VP)*PERIPH;
dxdt_PERIPH = (Q/VC)*CENT  - (Q/VP)*PERIPH;

$TABLE
table(CP) = CENT/VC;
table(RATEIN) = KA*GUT;
