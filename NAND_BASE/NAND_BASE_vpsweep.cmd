# =====================================================================
# SDEVICE 커맨드 - NAND_BASE (기준 구조) Vpass 스윕 (WL-WL interference)
# 작성: 2026-11-10
#
# 목적: IMEC 논문(reference/논문/Hole-Side_Airgap_Integration_as_Enabler_for_
#       3D_NAND_Flash_Z-Pitch_Scaling.pdf, Fig.3~5)과 동일한 방식으로
#       "이웃 게이트(WL1/WL3) Vpass 레벨이 바뀔 때 선택 셀(WL2) 자신의 read Vt가
#       얼마나 흔들리는지"를 측정한다. PGM 펄스는 전혀 없음 - 순수 read-only
#       (논문의 "fresh state" 측정과 동일 조건: Tdon=0.139/Tacc=0.0 고정, Frozen 유지).
#
# [RUN 0001/0002(PGM 펄스 기반 크로스토크)와의 차이 - runs/nand_igs_airgap/0003 참고]
#   0001/0002는 WL1/WL3를 고정 6V로 두고 "PGM 펄스가 이웃 셀 전하트랩에 주는 영향"을
#   쟀다. 이건 완전히 다른 지표 - WL1/WL3 자체의 전압 레벨(4/5/6/7V)을 바꿔가며
#   WL2의 read Id-Vg가 정전용량 결합으로 얼마나 움직이는지를 본다.
#
# [출처 / 재사용] NAND_BASE_pgm.cmd 에서 File/Physics/Traps/NonLocal/Plot/Math
#   섹션을 그대로 가져옴(동일 구조이므로 바꿀 이유 없음). Electrode 파형과
#   Solve 시퀀스만 새로 설계함.
#
# [파라미터 파일] models_jh.par 그대로 (사용자 확인, 2026-11-10).
#
# [전극 파형 설계 - 단위: 초, PWL]
#   t=0~10us     periphery 켜기: SSL/DSL 0->6V, Drain 0->0.5V(유지),
#                WL1/WL3 0->4V(첫 Vpass 레벨). WL2는 0V 유지.
#   t=10~33us    [Vpass=4V] WL2 read: -7 -> 12V (원래 S0 read와 동일 타이밍: 2us
#                settle + 19us 스윕 + 2us settle = 23us)
#   t=33~34us    WL1/WL3 4->5V 전환 (1us), WL2는 0V 유지
#   t=34~57us    [Vpass=5V] WL2 read: -7 -> 12V (동일 23us 패턴)
#   t=57~58us    WL1/WL3 5->6V 전환
#   t=58~81us    [Vpass=6V] WL2 read
#   t=81~82us    WL1/WL3 6->7V 전환
#   t=82~105us   [Vpass=7V] WL2 read
#   t=105~106us  전부 0V로 램프다운
#
#   static Voltage 값은 전부 파형의 t=0 값(0.0)과 일치 (PITFALLS 2026-08-17).
#   Traps는 t=10us부터 끝까지(모든 read + Vpass 전환 구간) Frozen 유지 - PGM이
#   없으므로 트랩 상태가 4번의 read 동안 전혀 안 바뀌어야 "같은 fresh 상태에서
#   Vpass만 바꿨다"는 논문과 동일한 비교가 됨.
#
# [판정 기준]
#   .plt 의 "WL2 InnerVoltage" vs "Drain TotalCurrent" 로 각 Vpass(4/5/6/7V) 구간의
#   WL2 read Vt(예: 1nA 또는 기존 기준전류)를 추출 -> Vt(Vpass) 커브.
#   AveSel/AvePass_WL3/AvePass_WL1/AveDSL/AveSSL eTrappedCharge 는 4번의 read
#   내내 거의 완전히 고정돼 있어야 정상(트랩이 안 움직였다는 sanity check).
#
# [실행] 실행 폴더에 NAND_BASE_msh.tdr, datexcodes.txt, models_jh.par 가 있어야 한다.
#          sdevice NAND_BASE_vpsweep.cmd
# =====================================================================

File {
    Grid      = "NAND_BASE_msh.tdr"
    Parameter = "models_jh.par"

    Plot    = "NAND_BASE_vpsweep_des.tdr"
    Current = "NAND_BASE_vpsweep_des.plt"
    Output  = "NAND_BASE_vpsweep_des.log"
}

Electrode {

    # ---- Source : 전 구간 0V
    { Name="Source" Voltage=0.0
      Voltage=(
            0.00 at 0.0000e-6,
            0.00 at 106.0000e-6
      )
    }

    # ---- Drain : periphery 켜질 때 0.5V로 올라가서 끝까지 유지 (read 전용, PGM 없음)
    { Name="Drain" Voltage=0.0
      Voltage=(
            0.00 at 0.0000e-6,
            0.00 at 6.0000e-6,
            0.50 at 7.0000e-6,
            0.50 at 105.0000e-6,
            0.00 at 106.0000e-6
      )
    }

    # ---- 선택 게이트 SSL / DSL : periphery 켜질 때 6V로 올라가서 끝까지 유지
    { Name="SSL" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            6.00 at 10.0000e-6,
            6.00 at 105.0000e-6,
            0.00 at 106.0000e-6
      )
    }

    { Name="DSL" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            6.00 at 10.0000e-6,
            6.00 at 105.0000e-6,
            0.00 at 106.0000e-6
      )
    }

    # ---- Pass 게이트 WL1 / WL3 : Vpass 스윕 변수 (4 -> 5 -> 6 -> 7V 계단)
    #      각 레벨에서 23us read 동안 flat, 전환은 1us
    { Name="WL1" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            4.00 at 10.0000e-6,
            4.00 at 33.0000e-6,
            5.00 at 34.0000e-6,
            5.00 at 57.0000e-6,
            6.00 at 58.0000e-6,
            6.00 at 81.0000e-6,
            7.00 at 82.0000e-6,
            7.00 at 105.0000e-6,
            0.00 at 106.0000e-6
      )
    }

    { Name="WL3" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            4.00 at 10.0000e-6,
            4.00 at 33.0000e-6,
            5.00 at 34.0000e-6,
            5.00 at 57.0000e-6,
            6.00 at 58.0000e-6,
            6.00 at 81.0000e-6,
            7.00 at 82.0000e-6,
            7.00 at 105.0000e-6,
            0.00 at 106.0000e-6
      )
    }

    # ---- 선택 셀 WL2 : -7 -> 12V read 스윕을 Vpass 4번 레벨에서 각각 반복
    { Name="WL2" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            0.00 at 10.0000e-6,

        # [Vpass=4V] read
           -7.00 at 12.0000e-6,
           12.00 at 31.0000e-6,
            0.00 at 33.0000e-6,

        # [Vpass=5V] read
            0.00 at 34.0000e-6,
           -7.00 at 36.0000e-6,
           12.00 at 55.0000e-6,
            0.00 at 57.0000e-6,

        # [Vpass=6V] read
            0.00 at 58.0000e-6,
           -7.00 at 60.0000e-6,
           12.00 at 79.0000e-6,
            0.00 at 81.0000e-6,

        # [Vpass=7V] read
            0.00 at 82.0000e-6,
           -7.00 at 84.0000e-6,
           12.00 at 103.0000e-6,
            0.00 at 105.0000e-6,
            0.00 at 106.0000e-6
      )
    }
}

# ---------------------------------------------------------------------
# 물리 모델 - NAND_BASE_pgm.cmd 와 동일 (구조 안 바뀌므로 그대로 재사용)
# ---------------------------------------------------------------------
Physics {
    eBarrierTunneling "NL_Tox"
    hBarrierTunneling "NL_Tox"
}

Physics(Material="PolySi") {
    Recombination(
      SRH
      Band2Band(Model=NonlocalPath)
    )
    Mobility(DopingDependence)
}

Physics(Material="Si3N4") {
    Mobility(ConstantMobility)

    # 총 밀도 = Conc * EnergySig * sqrt(2pi):
    #   Tdon 6.267e19 cm^-3  /  Tacc 1.003e20 cm^-3  <- 점유율 분모
    Traps(
        ( Name="Tdon" Donor Gaussian EnergyMid= 2.50 EnergySig= 0.50 fromCondBand
          Conc= 5.0e19
          eXSection= 1e-15 hXSection= 1e-15
          eBarrierTunneling(NonLocal= "NL_Tox" )
          hBarrierTunneling(NonLocal= "NL_Tox" )
          PooleFrenkel(Electron)
          TrapVolume= 1e-15
       )

        ( Name="Tacc" Acceptor Gaussian EnergyMid= 1.00 EnergySig= 0.50 fromCondBand
          Conc= 8.0e19
          eXsection= 1e-15 hXsection= 1e-15
          eBarrierTunneling(NonLocal= "NL_Tox" )
          hBarrierTunneling(NonLocal= "NL_Tox" )
          PooleFrenkel(Electron)
          TrapVolume= 1e-15
        )
    )
}

Plot {
    eDensity hDensity
    Potential
    ElectricField/Vector
    ConductionBandEnergy ValenceBandEnergy BandGap
    Doping
    eTrappedCharge hTrappedCharge
    eBarrierTunneling hBarrierTunneling
    SpaceCharge
    Band2BandGeneration
}

# ---------------------------------------------------------------------
# CurrentPlot - NAND_BASE_pgm.cmd 와 동일. 트랩량은 4번의 read 내내 고정돼
# 있어야 정상(sanity check) - 변하면 Frozen 설정이 깨졌다는 뜻.
# ---------------------------------------------------------------------
CurrentPlot {
    eTrappedCharge( Average( Region="region_17" Name="Sel" ) )
    hTrappedCharge( Average( Region="region_17" Name="Sel" ) )

    eTrappedCharge( Average( Region="region_15" Name="Pass_WL3" ) )
    eTrappedCharge( Average( Region="region_19" Name="Pass_WL1" ) )

    eTrappedCharge( Average( Region="region_13" Name="DSL" ) )
    eTrappedCharge( Average( Region="region_21" Name="SSL" ) )

    eBarrierTunneling( Integral( RegionInterface="region_6_b0/region_6_b1" ) )
    hBarrierTunneling( Integral( RegionInterface="region_6_b0/region_6_b1" ) )
}

# ---------------------------------------------------------------------
# Math - NAND_BASE_pgm.cmd 와 동일 (NonLocal 계면 11개, Cylindrical 없음)
# ---------------------------------------------------------------------
Math {
    Method=Pardiso
    -CheckUndefinedModels
    Derivatives
    RelErrControl

    TrapDLN(PeakSampling)=13

    NonLocal "NL_Tox" (
        RegionInterface="region_1_b0/region_1_b1"
        RegionInterface="region_2_b0/region_2_b1"
        RegionInterface="region_3_b0/region_3_b1"
        RegionInterface="region_4_b0/region_4_b1"
        RegionInterface="region_5_b0/region_5_b1"
        RegionInterface="region_6_b0/region_6_b1"
        RegionInterface="region_7_b0/region_7_b1"
        RegionInterface="region_8_b0/region_8_b1"
        RegionInterface="region_9_b0/region_9_b1"
        RegionInterface="region_10_b0/region_10_b1"
        RegionInterface="region_11_b0/region_11_b1"
        Length= 1e-6
        Digits= 4
        EnergyResolution= 1e-4
    )

    Digits=3
    Iterations=150
    Notdamped=8
    Number_of_Threads= 4
    Transient=BE
}

# ---------------------------------------------------------------------
# Solve - periphery on(+Vpass=4V 램프) -> 4개 Vpass 레벨에서 WL2 read -> 램프다운
#   PGM이 없으므로 Set(Traps(-Frozen))은 periphery-on 구간에서만 쓰고,
#   t=10us 이후로는 끝까지(전환 구간 포함) Frozen 유지 - 4번의 read가 전부
#   "같은 트랩 상태"에서 이뤄져야 Vpass만의 효과를 보는 논문 비교와 맞는다.
# ---------------------------------------------------------------------
Solve {
    Set( Traps( "Tdon" = 0.139  "Tacc" = 0.0  Frozen ) )

    Coupled (Iterations=100) { Poisson }
    Coupled (Iterations=100) { Poisson Electron }
    Coupled (Iterations=100 Digits=8) { Poisson Electron Hole }
    Plot ( FilePrefix="NAND_BASE_vpsweep_00_InitState" )

    Set( Traps( -Frozen ) )

    # ---- periphery 켜기 + Vpass=4V 램프업 (0 ~ 10us)
    NewCurrentPrefix = "NAND_BASE_vpsweep_pon_"
    Transient ( InitialTime=0.0 FinalTime=10.0000e-6
        InitialStep=1e-12 MaxStep=1e-7 MinStep=1e-15 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (0 10.0000e-6) intervals = 100))
        Plot ( FilePrefix="NAND_BASE_vpsweep_01_PeripheryOn" Time=( 10.0000e-6 ) )
    }

    Set( Traps( Frozen ) )

    # ---- [Vpass=4V] WL2 read (10 ~ 33us)
    NewCurrentPrefix = "NAND_BASE_vpsweep_vp4_"
    Transient ( InitialTime=10.0000e-6 FinalTime=33.0000e-6
        InitialStep=1e-9 MaxStep=5e-8 MinStep=1e-12 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (10.0000e-6 33.0000e-6) intervals = 460))
    }

    # ---- Vpass 4->5V 전환 + [Vpass=5V] WL2 read (33 ~ 57us)
    NewCurrentPrefix = "NAND_BASE_vpsweep_vp5_"
    Transient ( InitialTime=33.0000e-6 FinalTime=57.0000e-6
        InitialStep=1e-9 MaxStep=5e-8 MinStep=1e-12 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (33.0000e-6 57.0000e-6) intervals = 480))
    }

    # ---- Vpass 5->6V 전환 + [Vpass=6V] WL2 read (57 ~ 81us)
    NewCurrentPrefix = "NAND_BASE_vpsweep_vp6_"
    Transient ( InitialTime=57.0000e-6 FinalTime=81.0000e-6
        InitialStep=1e-9 MaxStep=5e-8 MinStep=1e-12 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (57.0000e-6 81.0000e-6) intervals = 480))
    }

    # ---- Vpass 6->7V 전환 + [Vpass=7V] WL2 read (81 ~ 105us)
    NewCurrentPrefix = "NAND_BASE_vpsweep_vp7_"
    Transient ( InitialTime=81.0000e-6 FinalTime=105.0000e-6
        InitialStep=1e-9 MaxStep=5e-8 MinStep=1e-12 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (81.0000e-6 105.0000e-6) intervals = 480))
        Plot ( FilePrefix="NAND_BASE_vpsweep_02_AfterVp7" Time=( 105.0000e-6 ) )
    }

    # ---- 전부 0V로 램프다운 (105 ~ 106us)
    NewCurrentPrefix = "NAND_BASE_vpsweep_off_"
    Transient ( InitialTime=105.0000e-6 FinalTime=106.0000e-6
        InitialStep=1e-9 MaxStep=1e-7 MinStep=1e-15 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (105.0000e-6 106.0000e-6) intervals = 20))
    }
}
