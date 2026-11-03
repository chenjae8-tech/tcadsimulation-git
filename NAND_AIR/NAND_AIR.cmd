# =====================================================================
# SDEVICE 커맨드 - NAND_AIR (IMEC형 IGS Air Gap 구조)
# 작성: 2026-10-27
#
# 목적: 전압 0V 평형 상태만 풀어서 구조/도핑/메시가 제대로 들어갔는지 확인한다.
#
# NAND_BASE.cmd와 다른 점은 File 섹션의 파일 이름뿐이다. Physics/Math/Solve는
# 글자 하나까지 같게 맞췄다 - (a) vs (b) 비교에서 Air Gap 외의 변수가 섞이면
# 안 되기 때문이다.
#
# [AirGap material에 대해]
#  AirGap은 datexcodes.txt에 group=Insulator로 선언했고, models_jh.par에
#  Epsilon(epsilon=1.0) 블록을 넣어뒀다. Table 4(1002/1009번째 줄)에 따르면
#  Insulator에서 "항상" 체크되는 critical model은 Epsilon뿐이므로 이걸로 충분하다.
#  Insulator라서 아래 반도체용 Physics 블록들도 AirGap에는 걸리지 않는다.
#
# [실행] sdevice NAND_AIR.cmd
#        같은 폴더에 datexcodes.txt, models_jh.par, NAND_AIR_msh.tdr이 있어야 함
# =====================================================================

File {
    Grid      = "NAND_AIR_msh.tdr"
    Parameter = "models_jh.par"

    Plot    = "NAND_AIR_des.tdr"
    Current = "NAND_AIR_des.plt"
    Output  = "NAND_AIR_des.log"
}

Electrode {
    { Name="Source" Voltage=0.0 }
    { Name="Drain"  Voltage=0.0 }

    { Name="SSL"    Voltage=0.0 WorkFunction=4.53 }
    { Name="WL1"    Voltage=0.0 WorkFunction=4.53 }
    { Name="WL2"    Voltage=0.0 WorkFunction=4.53 }
    { Name="WL3"    Voltage=0.0 WorkFunction=4.53 }
    { Name="DSL"    Voltage=0.0 WorkFunction=4.53 }
}

Physics {
    EffectiveIntrinsicDensity( BandGapNarrowing(OldSlotboom) )
}

Physics(Material="PolySi") {
    Recombination( SRH )
    Mobility( DopingDependence HighFieldSaturation Enormal )
}

Physics(Material="Si3N4") {
    Mobility( ConstantMobility )
}

Plot {
    eDensity hDensity
    Potential
    ElectricField/Vector
    ConductionBandEnergy ValenceBandEnergy BandGap
    Doping DonorConcentration AcceptorConcentration
    SpaceCharge
}

Math {
    Extrapolate
    Derivatives
    RelErrControl
    Method=Pardiso
    Iterations=20
    Number_of_Threads=4
}

Solve {
    Coupled(Iterations=100) { Poisson }
    Coupled(Iterations=100) { Poisson Electron }
    Coupled(Iterations=100 Digits=8) { Poisson Electron Hole }

    Plot ( FilePrefix="NAND_AIR_equilibrium_0V" )
}
