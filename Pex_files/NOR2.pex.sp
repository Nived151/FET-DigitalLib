* File: NOR2.pex.sp
* Created: Wed Oct 26 08:21:32 2022
* Program "Calibre xRC"
* Version "v2013.2_18.13"
* 
.include "NOR2.pex.sp.pex"
.subckt NOR2  GND! OUT VDD! A B
* 
* B	B
* A	A
* VDD!	VDD!
* OUT	OUT
* GND!	GND!
XD0_noxref N_GND!_D0_noxref_pos N_VDD!_D0_noxref_neg DIODENWX  AREA=6.63075e-12
+ PERIM=1.0394e-05
XMMN0 N_OUT_MMN0_d N_A_MMN0_g N_GND!_MMN0_s N_GND!_D0_noxref_pos NFET L=7e-08
+ W=1e-06 AD=3.645e-13 AS=2.24e-13 PD=1.729e-06 PS=2.448e-06 NRD=0.463 NRS=0.119
+ M=1 NF=1 CNR_SWITCH=0 PCCRIT=0 PAR=1 PTWELL=0 SA=2.24e-07 SB=9.72e-07 SD=0
+ PANW1=0 PANW2=0 PANW3=0 PANW4=9.1e-16 PANW5=3.5e-15 PANW6=7e-15 PANW7=1.4e-14
+ PANW8=1.4e-14 PANW9=2.8e-14 PANW10=2.59e-15
XMMN1 N_OUT_MMN0_d N_B_MMN1_g N_GND!_MMN1_s N_GND!_D0_noxref_pos NFET L=7e-08
+ W=1e-06 AD=3.645e-13 AS=1.73e-13 PD=1.729e-06 PS=2.346e-06 NRD=0.266 NRS=0.104
+ M=1 NF=1 CNR_SWITCH=0 PCCRIT=0 PAR=1 PTWELL=0 SA=1.023e-06 SB=1.73e-07 SD=0
+ PANW1=0 PANW2=0 PANW3=0 PANW4=9.1e-16 PANW5=3.5e-15 PANW6=7e-15 PANW7=1.4e-14
+ PANW8=1.4e-14 PANW9=2.8e-14 PANW10=2.59e-15
XMMP0 NET8 N_A_MMP0_g N_VDD!_MMP0_s N_VDD!_D0_noxref_neg PFET L=7e-08 W=2e-06
+ AD=7.29e-13 AS=4.32e-13 PD=2.729e-06 PS=4.432e-06 NRD=0.18225 NRS=0.052 M=1
+ NF=1 CNR_SWITCH=0 PCCRIT=0 PAR=1 PTWELL=1 SA=2.16e-07 SB=9.73e-07 SD=0 PANW1=0
+ PANW2=2.17e-15 PANW3=3.5e-15 PANW4=3.5e-15 PANW5=3.5e-15 PANW6=7e-15
+ PANW7=1.6604e-13 PANW8=2.8e-14 PANW9=5.6e-14 PANW10=2.24e-13
XMMP1 N_OUT_MMP1_d N_B_MMP1_g NET8 N_VDD!_D0_noxref_neg PFET L=7e-08 W=2e-06
+ AD=3.48e-13 AS=7.29e-13 PD=4.348e-06 PS=2.729e-06 NRD=0.054 NRS=0.18225 M=1
+ NF=1 CNR_SWITCH=0 PCCRIT=0 PAR=1 PTWELL=1 SA=1.015e-06 SB=1.74e-07 SD=0
+ PANW1=0 PANW2=2.17e-15 PANW3=3.5e-15 PANW4=3.5e-15 PANW5=3.5e-15 PANW6=7e-15
+ PANW7=1.6604e-13 PANW8=2.8e-14 PANW9=5.6e-14 PANW10=2.24e-13
c_138 NET8 0 1.71304e-19
*
.include "NOR2.pex.sp.NOR2.pxi"
*
.ends
*
*
