* title card
= simple pipe 1 + heat structures
*================================================================
* problem type   option
100       new    transnt
*================================================================
* input / output units
102 si *optional, default are si units
* Restart-Plot Control Card
104 ncmpress
*================================================================
*define non condensable gases
110 helium nitrogen
*================================================================
*define non condensable gases MASS FRACTIONS
*    helium  nitrogen
115 0.      1.
*================================================================
* Initial Time Value
200 0.
*================================================================
* time step control card
*   endtime  min.dt  max.dt  control  minor  major    restart
201 600.       1.e-8      1e-3      0        50000     100000       100000
202 40000.       1.e-8      1e-2      0        50000     100000       100000
*================================================================
* extra variables to print
*         var param
20800001  tmassv 110010000 
20800002  tmassv 110020000 
20800003  tmassv 110030000 
20800004  tmassv 110040000 
20800005  tmassv 110050000 
20800006  tmassv 110060000 
20800007  tmassv 112010000 
20800008  tmassv 112020000 
20800009  tmassv 120010000 
20800010  tmassv 120020000 
20800011  tmassv 120030000 
20800012  tmassv 120040000 
20800013  tmassv 120050000 
20800014  tmassv 120060000 
20800015  tmassv 120070000 
20800016  tmassv 120080000 
20800017  tmassv 120090000 
20800018  tmassv 120100000 
20800019  tmassv 120110000 
20800020  tmassv 120120000 
20800021  tmassv 120130000 
20800022  tmassv 120140000 
20800023  tmassv 120150000 
20800024  tmassv 121010000 
20800025  tmassv 121020000 
20800026  tmassv 121030000 
20800027  tmassv 121040000 
20800028  tmassv 121050000 
20800029  tmassv 121060000 
20800030  tmassv 121070000 
20800031  tmassv 121080000 
20800032  tmassv 121090000 
20800033  tmassv 121100000 
20800034  tmassv 121110000 
20800035  tmassv 121120000 
20800036  tmassv 121130000 
20800037  tmassv 121140000 
20800038  tmassv 121150000 
* component data
*----------------------------------------------------------------
*-----------------------------------------------------------------INNER TEST PIPE
* component 110 - full heater
*        name   type
1100000  pipe  pipe
*        no.volumes
1100001  6 
*        area                             vol.no.
1100101  5.502256e-03                               6 
*        length                           vol.no.
1100301  0.08                               6 
*        v-ang                            vol.no.
1100601  90.                              6 
*        rough   dhy                      vol.no.
1100801  0.      0.                       6 
*        tlpvbfe                          vol.no.
1101001  0001000                          6 
*        efvcahs                          jun.no.
1101101  0000000                          5 
*        ebt  pressure  stat_qual         vol.no.
1101201  002  23650.    0.     0.  0.  0.     6 
*        mass flow (=1)
1101300  1
*        flowf  flowg      velj           jun.no.
1101301  0.     0.         0.             5 
*----------------------------------------------------------------
* component 111 - heater junction
*        name   type
1110000  injun  sngljun
*        from       to         area  floss rloss  jefvcahs
1110101  110060002  112010001  5.502256e-03    0.    0.     00000000
*        junctionD  CCFL  gasintercept     slope
1110110  0.         0.        1.               1.
*        ctl  velflowf  velflowg     interface velocity
1110201  0.   0.       0.             0.
*----------------------------------------------------------------
* component 112 - empty heater
*        name   type
1120000  pipe  pipe
*        no.volumes
1120001  2 
*        area                             vol.no.
1120101  5.502256e-03                               2 
*        length                           vol.no.
1120301  0.08                               2 
*        v-ang                            vol.no.
1120601  90.                              2 
*        rough   dhy                      vol.no.
1120801  0.      0.                       2 
*        tlpvbfe                          vol.no.
1121001  0001000                          2 
*        efvcahs                          jun.no.
1121101  0000000                          1 
*        ebt press temp stat_qual vol.no.
1121201  004 23650.    289.2972   0.92237   0. 0.   2 
*        mass flow (=1)
1121300  1
*        flowf  flowg  velj  jun.no.
1121301  0.     0.     0.    1 
*----------------------------------------------------------------
* component 115 - inlet junction to inner pipe
*        name       type
1150000  inpipe sngljun
*        from       to        area  floss rloss  jefvcahs  
1150101  112020002  120010001 0.00025447    1.    1.     00100100 
*        junctionD flooding gasintercept slope
1150110  0.        0.       1.           1.
*        ctl  velflowf  velflowg     interface velocity
1150201  0.   0.       0.            0.
*----------------------------------------------------------------
* component 116 - inlet junction to annulus
*        name       type
1160000  inannu  sngljun
*        from       to         area  floss rloss  jefvcahs
1160101  112020002  121010001  5.969e-05    1.    1.     00100000
*        junctionD  flooding  gasintercept slope
1160110  0.         0.        1.           1.
*        ctl  velflowf  velflowg     interface velocity
1160201  0.   0.       0.            0.
*----------------------------------------------------------------
* component 120 inner column
*        name    type
1200000  inpipe  pipe
*        no.volumes
1200001  15 
*        area                             vol.no.
1200101  0.00025447                               15 
*        length                           vol.no.
1200301  0.08                               15 
*        v-ang                            vol.no.
1200601  90.                              15 
*        rough   dhy                      vol.no.
1200801  0.      0.                       15 
*        tlpvbfe                          vol.no.
1201001  0001000                          15 
*        efvcahs                          jun.no.
1201101  0100000                          14 
*        ebt press temp stat_qual       vol.no.
1201201  004 23650.    289.2972  0.92237  0. 0.   15 
*        mass flow (=1)
1201300  1
*        flowf  flowg      velj           jun.no.
1201301  0.     0.         0.             14 
*----------------------------------------------------------------
* component 121 annulus 
*        name    type
1210000  annulus annulus
*        no.volumes
1210001  15 
*        area                             vol.no.
1210101  5.969e-05                               15 
*        length                           vol.no.
1210301  0.08                               15 
*        v-ang                            vol.no.
1210601  90.                              15 
*        rough   dhy                      vol.no.
1210801  0.      0.002                       15 
*        tlpvbfe                          vol.no.
1211001  0001000                          15 
*        efvcahs                          jun.no.
1211101  0100000                          14 
*        ebt press temp stat_qual       vol.no.
1211201  004 23650.    289.2972  0.92237  0. 0.   15 
*        mass flow (=1)
1211300  1
*        flowf  flowg      velj           jun.no.
1211301  0.     0.         0.             14 
*        jnct_hydr_d CCFL gas_intcpt slope jun.no.
1211401  0.002          0.   1.         1.    14 
*----------------------------------------------------------------
*        name     type
1300000  horzjun  mtpljun
*        no_of_jun   init_cond_ctrl
1300001  15          0
*        from  to area  floss rloss  efvcahs  W7 W8 W9  from_incr to_incr  W12  junction_lim
1300011  120010004 121010003 0.0045239 1. 1. 0000000 1. 1. 1. 10000 10000 0 15
*        initflow_f initflow_g  junction_lim
1301011  0.         0.          15
*        hydrD  CCFL gas_intcpt slope junction_lim
1302011  0.018     0.   1.         1.    15
*----------------------------------------------------------------OUTER COOLING JACKET
* component 140 - inlet volume
*        name     type
1400000  inletC   tmdpvol
*        area    length  volume  h-ang  v-ang  delz   rough  dhy    tlpvbfe
1400101  0.0086416      1.      0.      0.     90.    1.     0.     0.     0000000 
*        ctl
1400200  003
*        time  pressure    temperature
1400201  0.    119688.3787          373.6526 
*----------------------------------------------------------------
* component 150 - inlet junction
*        name   type
1500000  injunC tmdpjun
*        from       to         area    *     floss rloss  jefvcahs
1500101  140010002  155010001  0.0086416      *     0.    0.     00000000
*        ctl
1500200  1
*        time  flowf      flowg  interval velocity
1500201  100.    0.52772         0.     0
*----------------------------------------------------------------
* component 155 - pipes
*        name   type
1550000  pipeC  annulus
*        no.volumes
1550001  10 
*        area                             vol.no.
1550101  0.0086416                               10
*        length                           vol.no.
1550301  0.08                               10
*        v-ang                            vol.no.
1550601  90.                              10
*        rough   dhy                      vol.no.
1550801  0.      0.0052                       10
*        tlpvbfe                          vol.no.
1551001  0000000                          10
*        efvcahs                          jun.no.
1551101  0000000                          9
*        ebt  pressure  temperature       vol.no.
1551201  003  119688.3787       373.6526    0.  0.  0.  10
*        mass flow (=1)
1551300  1
*        flowf      flowg  velj          jun.no.
1551301  0.52772    0.     0.                 9 
*----------------------------------------------------------------
* component 160 - outlet junction
*        name    type
1600000  outjunC sngljun
*        from  to           area fwd. loss  rev. loss   jefvcahs
1600101  155100002    165010001    0.0086416   0.0        0.0         00000000
*        hydraulic_d  flooding_correlation gas_intercept slope
1600110  0            0                    1.0           1.0
*        ctl  flowf      flowg
1600201  1    0.52772         0. 
*----------------------------------------------------------------
* component 165 - outlet volume
*        name    type
1650000  outvolC tmdpvol
*        area    length  volume h-ang v-ang  delz  rough  dhy  tlpvbfe
1650101  0.0086416      1.      0.     0.    90.    1.    0.     0.   0000000
*        ctl
1650200  003
*        time  pressure    temperature
1650201  0.    119688.3787          373.6526 

*================================================================
* heat structure data - HEATER TANK
*----------------------------------------------------------------
* heat structure 110 - HEATER WALL HEATED
*         no.HS  no.m.p  geo  s.s.flag  left
11101000  1      5       2    0         0.04185 
*         mesh flag  format
11101100  0          1
*         intvl   right.cord.
11101101  4       0.04445 
*         comp    intvl
11101201  001     4
*         source  intvl
11101301  0.0     4
*         temp    no.m.p
11101401  489.2972     5
*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.
11101501  110010000  10000  101  1       0.08        1 
*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.
11101601  0          0      2555 1       0.08        1 
*         s.type     mult   dir.left     dir.right  HS.no.
11101701  0          1.     1.           1.         1 
*         dhy                                HS.no.
11101801  0.0  20.  20.  0.  0.  0.  0.  1.  1 
*         dhy                                HS.no.
11101901  0.0  20.  20.  0.  0.  0.  0.  1.  1 
*----------------------------------------------------------------

* heat structure data - HEATER TANK
*----------------------------------------------------------------
* heat structure 111 - HEATER WALL NOT HEATED BUT WET
*         no.HS  no.m.p  geo  s.s.flag  left
11111000  5      5       2    0         0.04185 
*         mesh flag  format
11111100  0          1
*         intvl   right.cord.
11111101  4       0.04445 
*         comp    intvl
11111201  001     4
*         source  intvl
11111301  0.0     4
*         temp    no.m.p
11111401  489.2972     5
*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.
11111501  110020000  10000  101  1       0.08        5 
*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.
11111601  0          0      0    1       0.08        5 
*         s.type     mult   dir.left     dir.right  HS.no.
11111701  0          1.     1.           1.         5 
*         dhy                                HS.no.
11111801  0.0  20.  20.  0.  0.  0.  0.  1.  5 
*         dhy                                HS.no.
11111901  0.0  20.  20.  0.  0.  0.  0.  1.  5 
*----------------------------------------------------------------

* heat structure 112 - HEATER WALL INSULATED
*         no.HS  no.m.p  geo  s.s.flag  left
11121000  2      5       2    0         0.04185 
*         mesh flag  format
11121100  0          1
*         intvl   right.cord.
11121101  4       0.04445 
*         comp    intvl
11121201  001     4
*         source  intvl
11121301  0.0     4
*         temp    no.m.p
11121401  489.2972     5
*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.
11121501  112010000  10000  101  1       0.08        2 
*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.
11121601  0          0      0    1       0.08        2 
*         s.type     mult   dir.left     dir.right  HS.no.
11121701  0          1.     1.           1.         2 
*         dhy                                HS.no.
11121801  0.0  20.  20.  0.  0.  0.  0.  1.  2 
*         dhy                                HS.no.
11121901  0.0  20.  20.  0.  0.  0.  0.  1.  2 
*----------------------------------------------------------------

* heat structure data - wall shielding primary flow from environment
*----------------------------------------------------------------
* heat structure 120 - ADIABATIC WALL
*         no.HS  no.m.p  geo  s.s.flag  left
11201000  5     5       2    0         0.01 
*         mesh flag  format
11201100  0          1
*         intvl   right.cord.
11201101  4       0.015 
*         comp    intvl
11201201  001     4
*         source  intvl
11201301  0.0     4
*         temp    no.m.p
11201401  489.2972     5
*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.
11201501  121010000  10000  101  1       0.08         5 
*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.
11201601  0          0      0    1       0.08         5 
*         s.type     mult   dir.left     dir.right  HS.no.
11201701  0          1.     1.           1.         5 
*         dhy
11201801  0.02  20.  20.  0.  0.  0.  0.  1.  5 
*         dhy
11201901  0.02  20.  20.  0.  0.  0.  0.  1.  5 
*----------------------------------------------------------------

* heat structure data - HEAT EXCHANGER
*----------------------------------------------------------------
* heat structure 121 - HEAT EXCHANGER
*         no.HS  no.m.p  geo  s.s.flag  left
11211000  10     5       2    0         0.01 
*         mesh flag  format
11211100  0          1
*         intvl   right.cord.
11211101  4       0.015 
*         comp    intvl
11211201  001     4
*         source  intvl
11211301  0.0     4
*         temp    intvl
11211401  489.2972     5
*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.
11211501  121060000  10000  101  1       0.08         10 
*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.
11211601  155010000  10000  101  1       0.08         10 
*         s.type     mult   dir.left     dir.right  HS.no.
11211701  0          1.     1.           1.         10 
*         dhy
11211801  0.02  10.  10.  0.  0.  0.  0.  1.  10 
*         dhy
11211901  0.02  10.  10.  0.  0.  0.  0.  1.  10 
*----------------------------------------------------------------

* heat structure data - OUTER WALL (insulation)
*----------------------------------------------------------------
* heat structure 150 - OUTER WALL
*         no.HS  no.m.p  geo  s.s.flag  left
11501000  10     5       2    0         0.05455 
*         mesh flag  format
11501100  0          1
*         intvl   right.cord.
11501101  4       0.05715 
*         comp    intvl
11501201  001     4
*         source  intvl
11501301  0.0     4
*         temp    intvl
11501401  373.6526     5
*         left.vol   incr.  b.c  Surfcode  Surffactor      HS.no.
11501501  155010000  10000  101  1       0.08         10 
*         right.vol  incr.  b.c  Surfcode  Surffactor      HS.no.
11501601  0          0      0    1       0.08         10 
*         s.type     mult   dir.left     dir.right  HS.no.
11501701  0          1.     1.           1.         10 
*         dhy
11501801  0.0 20.  20.  0.  0.  0.  0.  1.  10 
*         dhy
11501901  0.0 20.  20.  0.  0.  0.  0.  1.  10 
=================================================================

* heat structure thermal property data
*----------------------------------------------------------------
** stainless steel 
20100100  tbl/fctn  1  1 
*conduct. vs temp.     
20100101  265.0  7.58 
20100102  295.0  7.58 
20100103  550.0  13.43 
20100104  700.0  16.87 
20100105  873.0  20.85 
20100106  1173.0 27.73 
20100107  1671.0 29.16 
20100108  1727.0 20.0 
20100109  4000.0 20.0 
*vol.ht.cap. vs temp. 
20100151  263.0  4.000e6 
20100152  293.0  4.000e6 
20100153  373.0  4.008e6 
20100154  473.0  4.080e6 
20100155  573.0  4.152e6 
20100156  673.0  4.224e6 
20100157  773.0  4.296e6 
20100158  873.0  4.368e6 
20100159  10973.0  4.440e6 
*----------------------------------------------------------------
* HEAT SOURCE TABLE
*        tableType 
20255500 htrnrate 
*        time heat flux 
20255501 100.   -14951.5986  
*----------------------------------------------------------------
. end of input
