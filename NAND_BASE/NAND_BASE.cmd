# =====================================================================
# SDEVICE 커맨드 - NAND_BASE (기준 구조, Air Gap 없음)
# 작성: 2026-10-27
#
# 목적: 전압 0V 평형 상태만 풀어서 구조/도핑/메시가 제대로 들어갔는지 확인한다.
#       (Id-Vg 같은 스윕은 이게 통과한 뒤에 추가)
#
# [기존 .cmd에서 고친 것]
#  1) Electrode 이름: SL/BL/SG/WL_PASS/WL_SEL/DG -> Source/Drain/SSL/WL1/WL2/WL3/DSL
#     NAND_BASE.sat에 저장된 실제 전극 이름이 후자다. 전자는 다른 실험
#     (nand_pgm_erase_base)의 이름이라 이 구조에는 존재하지 않아 그대로 쓰면 멈춘다.
#  2) Parameter: 절대경로 -> 같은 폴더의 "models_jh.par" 상대경로
#  3) Recombination에서 Auger 제외 (아래 설명 참고)
#
# [Auger를 뺀 이유]
#  manual/sdevice/02_Specifying_Physical_Devices.md Table 4(997번째 줄)에 따르면
#  Auger는 group=Semiconductor 재질에서 체크되는 critical model이고, 정의돼 있지
#  않으면 시뮬레이션이 에러로 멈춘다. 그런데 models_jh.par 전체에 Auger 파라미터가
#  0건이고, datexcodes.txt에서 PolySi는 group=Semiconductor다. 평형 해석에서는
#  Auger가 기여하는 게 없으므로 일단 빼둔다.
#  (쓰고 싶으면 models_jh.par의 PolySi 섹션에 Auger 파라미터를 추가해야 한다.)
#
# [실행] sdevice NAND_BASE.cmd
#        같은 폴더에 datexcodes.txt, models_jh.par, NAND_BASE_msh.tdr이 있어야 함
# =====================================================================

File {
    Grid      = "NAND_BASE_msh.tdr"
    Parameter = "models_jh.par"

    Plot    = "NAND_BASE_des.tdr"
    Current = "NAND_BASE_des.plt"
    Output  = "NAND_BASE_des.log"
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

    Plot ( FilePrefix="NAND_BASE_equilibrium_0V" )
}
