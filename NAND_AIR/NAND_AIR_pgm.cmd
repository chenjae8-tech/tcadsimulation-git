# =====================================================================
# SDEVICE 커맨드 - NAND_AIR (IGS Air Gap 구조) PGM 검증런
# 작성: 2026-10-27
#
# 목적: "이 구조에서 PGM이 실제로 되는가"를 짧게 확인한다.
#       단일 PGM 펄스(WL2, 18V) 1회 + 전후 read 1회씩. ISPP 계단과 Erase는 없음.
#       이게 통과하면 그다음에 ISPP/Erase 풀세트로 확장한다.
#
# [NAND_BASE_pgm.cmd 와의 관계]
#   파일 이름(Grid / Plot / Current / Output / FilePrefix) 말고는 글자 하나까지
#   동일하다. Air Gap 유무만 비교하는 실험이라 다른 변수가 섞이면 안 된다.
#   한쪽을 고치면 반대쪽도 같이 고칠 것.
#
# [출처] nand_pgm_erase_base 실험의 기준 커맨드
#        pecycle_A-ispp-gidl-erase_v5_20261018.txt 의 Physics / Math / Solve /
#        전극 파형 패턴을 그대로 가져옴. 아래 "바뀐 곳"만 이 구조에 맞게 수정.
#
# [기준 커맨드 대비 바뀐 곳]
#  1) Math 에서 Cylindrical(xAxis=0.0) 제거
#     - 기준 구조는 원통형(macaroni)이지만 이 구조는 평면 2D다. 그대로 두면
#       x를 반지름으로 해석해 완전히 다른 소자가 된다.
#  2) 전극 이름 매핑 (기준 -> 우리)
#       SL      -> Source   (오른쪽 끝 x=0.215)
#       BL      -> Drain    (왼쪽 끝 x=0, 전류 측정)
#       SG, DG  -> SSL, DSL (선택 게이트)
#       WL_PASS -> WL1, WL3 (pass 게이트 2개)
#       WL_SEL  -> WL2      (선택 셀, 가운데 x 0.095~0.120)
#  3) NonLocal "NL_Tox" 의 RegionInterface 를 이 구조의 region 이름으로 교체
#     (채널 region_N_b0 / 터널산화막 region_N_b1, N=1~11)
#  4) CurrentPlot 을 좌표 Window 대신 Region= 으로 지정 (우리 region이 게이트별로
#     이미 나뉘어 있어서 더 정확하고, Material+Window 조합의 -1e300 함정도 피함)
#  5) Al2O3(Insulator1) 관련 없음 - 이 구조에는 Al2O3 라이너가 없다
#  6) 출력 파일명에서 n@node@ 제거 (SWB가 아니라 터미널에서 sdevice 직접 실행)
#  7) 시퀀스를 ISPP 15계단 -> 단일 펄스 1회로 축소
#
# [파라미터 파일] models_jh.par 그대로 사용.
#   기준 커맨드의 20261017_models_v3.par 와 비교한 결과 Oxide / Nitride / PolySi /
#   Tungsten 섹션이 동일하다(줄 번호까지 일치). 차이는 models_jh.par 쪽의
#   SiC_4H·SiC_6H 와 v3 쪽의 Insulator1(Al2O3)뿐인데, 이 구조는 Al2O3를 쓰지
#   않으므로 바꿀 이유가 없다. 터널링에 필요한 Oxide BarrierTunneling
#   (mt = 0.36, 0.38) 도 들어 있다.
#
# [주의 - 기준 구조와 다른 점 때문에 수치는 다르게 나온다]
#   - 평면 2D(원통 아님) -> 터널산화막 쪽 전계 집중이 없어 같은 전압에서 PGM이 느릴 수 있다
#   - 질화막 4nm (기준 5nm), Al2O3 라이너 없음, 채널 도핑 1e17 (기준 1e14)
#   -> 초기 Vt, PGM 후 Vt 모두 기준값(-4.00 / +5.60 V)과 다른 게 정상이다.
#      이번 런은 "절대값 맞추기"가 아니라 "전하가 잡히는가" 확인이 목적.
#
# [판정 기준]
#   .plt 의 Sel eTrappedCharge 가 PGM 펄스(33~58us) 동안 뚜렷하게 올라가면 성공.
#   Pass_WL1 / Pass_WL3 는 Sel 보다 훨씬 작아야 한다(크로스토크 감시).
#   점유율 분모: eTrappedCharge -> Tacc 총밀도 1.003e20 cm^-3
#                hTrappedCharge -> Tdon 총밀도 6.267e19 cm^-3
#                (eTrappedCharge는 Acceptor+eNeutral만, hTrappedCharge는
#                 Donor+hNeutral만 집계 - knowledge/PITFALLS.md 2026-08-22)
#
# [실행] 실행 폴더에 NAND_AIR_msh.tdr, datexcodes.txt, models_jh.par 가 있어야 한다.
#          sdevice NAND_AIR_pgm.cmd
# =====================================================================

File {
    Grid      = "NAND_AIR_msh.tdr"
    Parameter = "models_jh.par"

    Plot    = "NAND_AIR_pgm_des.tdr"
    Current = "NAND_AIR_pgm_des.plt"
    Output  = "NAND_AIR_pgm_des.log"
}

# ---------------------------------------------------------------------
# 전극 파형 (단위: 초. PWL 이고 구간 사이는 선형 보간)
#
#   t=0~10us    periphery 켜기 (SSL/DSL/WL1/WL3 6V, Drain 0.5V)
#   t=10~33us   S0 read : WL2 -7 -> 12V, 1 V/us   (초기 Vt)
#   t=33~58us   PGM 펄스: WL2 18V (상승 2.5us / 유지 15us / 하강 2.5us)
#   t=58~4812us PGM 후 read : WL2 -7 -> 12V, 0.004 V/us
#
#   static Voltage 값은 전부 파형의 t=0 값(0.0)과 일치시킨다
#   (불일치 시 Transient 전 Coupled 단계에서 엉뚱한 전압이 걸림 - PITFALLS 2026-08-17)
# ---------------------------------------------------------------------
Electrode {

    # ---- Source : 전 구간 0V (기준 커맨드의 SL)
    { Name="Source" Voltage=0.0
      Voltage=(
            0.00 at 0.0000e-6,
            0.00 at 4812.0000e-6
      )
    }

    # ---- Drain : PGM 중 0V, read 구간에만 0.5V (기준 커맨드의 BL)
    { Name="Drain" Voltage=0.0
      Voltage=(
            0.00 at 0.0000e-6,
            0.00 at 6.0000e-6,
            0.50 at 7.0000e-6,
            0.50 at 31.5000e-6,
            0.00 at 32.0000e-6,
            0.00 at 54.0000e-6,
            0.50 at 55.0000e-6,
            0.50 at 4810.5000e-6,
            0.00 at 4811.0000e-6,
            0.00 at 4812.0000e-6
      )
    }

    # ---- 선택 게이트 SSL / DSL (기준 커맨드의 SG, DG)
    #      PGM 중 6V가 아니라 1.9V. SSL/DSL도 셀과 같은 CTN 스택이라 6V를 걸면
    #      선택 게이트 아래 질화막이 같이 프로그램된다.
    { Name="SSL" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            6.00 at 10.0000e-6,
            6.00 at 32.0000e-6,
            0.00 at 33.0000e-6,
            1.90 at 34.0000e-6,
            1.90 at 52.0000e-6,
            0.00 at 53.0000e-6,
            0.00 at 58.0000e-6,
            6.00 at 59.0000e-6,
            6.00 at 4811.0000e-6,
            0.00 at 4812.0000e-6
      )
    }

    { Name="DSL" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            6.00 at 10.0000e-6,
            6.00 at 32.0000e-6,
            0.00 at 33.0000e-6,
            1.90 at 34.0000e-6,
            1.90 at 52.0000e-6,
            0.00 at 53.0000e-6,
            0.00 at 58.0000e-6,
            6.00 at 59.0000e-6,
            6.00 at 4811.0000e-6,
            0.00 at 4812.0000e-6
      )
    }

    # ---- Pass 게이트 WL1 / WL3 (기준 커맨드의 WL_PASS)
    #      PGM 중 DC로 고정하지 않는다. WL2와 "같은 기울기"로 올라가 6V에서 홀드,
    #      WL2와 "같은 시각"에 0V 도달. DC로 두면 방전 때 WL2-Pass 전위차로
    #      Pass 셀이 프로그램되는 인공 현상이 생긴다.
    #      기울기 = 18V / 2.5us = 7.2 V/us -> 6V 까지 0.8333us
    { Name="WL1" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            6.00 at 10.0000e-6,
            6.00 at 32.0000e-6,
            0.00 at 33.0000e-6,
            6.00 at 33.8333e-6,
            6.00 at 52.1667e-6,
            0.00 at 53.0000e-6,
            0.00 at 58.0000e-6,
            6.00 at 59.0000e-6,
            6.00 at 4811.0000e-6,
            0.00 at 4812.0000e-6
      )
    }

    { Name="WL3" Voltage=0.0 WorkFunction=4.5
      Voltage=(
            0.00 at 0.0000e-6,
            6.00 at 10.0000e-6,
            6.00 at 32.0000e-6,
            0.00 at 33.0000e-6,
            6.00 at 33.8333e-6,
            6.00 at 52.1667e-6,
            0.00 at 53.0000e-6,
            0.00 at 58.0000e-6,
            6.00 at 59.0000e-6,
            6.00 at 4811.0000e-6,
            0.00 at 4812.0000e-6
      )
    }

    # ---- 선택 셀 WL2 (기준 커맨드의 WL_SEL) - 가운데 게이트, x 0.095~0.120
    { Name="WL2" Voltage=0.0 WorkFunction=4.5
      Voltage=(
        # periphery 올라오는 동안 0V
            0.00 at 0.0000e-6,
            0.00 at 10.0000e-6,

        # [S0] 초기 Id-Vgs : -7 -> 12V, 1 V/us (19us)
           -7.00 at 12.0000e-6,
           12.00 at 31.0000e-6,
            0.00 at 33.0000e-6,

        # [PGM] V_PGM = 18.0 V, 상승 2.5us / 유지 15us / 하강 2.5us
           18.00 at 35.5000e-6,
           18.00 at 50.5000e-6,
            0.00 at 53.0000e-6,
            0.00 at 58.0000e-6,

        # [S1] PGM 후 Id-Vgs : -7 -> 12V, 0.004 V/us (4750us)
           -7.00 at 60.0000e-6,
           12.00 at 4810.0000e-6,
            0.00 at 4812.0000e-6
      )
    }
}

# ---------------------------------------------------------------------
# 물리 모델 - 기준 커맨드 그대로 (B-0: 요청 없으면 Physics/Traps 는 바꾸지 않는다)
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
# CurrentPlot - region 이름으로 지정 (게이트별로 region이 이미 나뉘어 있음)
#   질화막(CT) 층 region 대응:  region_13=DSL  region_15=WL3  region_17=WL2
#                               region_19=WL1  region_21=SSL
# ---------------------------------------------------------------------
CurrentPlot {
    # ---- [핵심 지표] 선택 셀(WL2) 아래 질화막. 이게 올라가야 PGM이 된 것
    eTrappedCharge( Average( Region="region_17" Name="Sel" ) )
    hTrappedCharge( Average( Region="region_17" Name="Sel" ) )

    # ---- Pass 셀 크로스토크 감시 (Sel 보다 훨씬 작아야 정상)
    eTrappedCharge( Average( Region="region_15" Name="Pass_WL3" ) )
    eTrappedCharge( Average( Region="region_19" Name="Pass_WL1" ) )

    # ---- 선택 게이트 아래 질화막 (1.9V로 눌러둔 효과 확인)
    eTrappedCharge( Average( Region="region_13" Name="DSL" ) )
    eTrappedCharge( Average( Region="region_21" Name="SSL" ) )

    # ---- 주입 경로: WL2 아래 채널/터널산화막 계면의 터널링 전류
    eBarrierTunneling( Integral( RegionInterface="region_6_b0/region_6_b1" ) )
    hBarrierTunneling( Integral( RegionInterface="region_6_b0/region_6_b1" ) )
}

# ---------------------------------------------------------------------
# Math - 기준 커맨드와 같되 Cylindrical 제거, NonLocal 계면을 이 구조 이름으로
# ---------------------------------------------------------------------
Math {
    # [중요] 기준 커맨드에 있던 Cylindrical( xAxis=0.0 ) 는 넣지 않는다.
    #        이 구조는 평면 2D다.

    Method=Pardiso
    -CheckUndefinedModels
    Derivatives
    RelErrControl

    TrapDLN(PeakSampling)=13

    # 채널(region_N_b0) / 터널산화막(region_N_b1) 계면 11곳.
    # 기준 커맨드는 채널이 3개 region(Below/Sel/Above)이라 3줄이었고,
    # 이 구조는 11개 column으로 나뉘어 있어 11줄이 된다(덮는 면적은 같다).
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
# Solve - 방식 1 (한 런 연속). Save/Load 안 씀
#   read 구간은 Set(Traps(Frozen)) 으로 얼려서 read가 트랩을 바꾸지 않게 한다.
#   풀 때는 Set(Traps(-Frozen)). Unset(TrapFilling) 은 쓰지 않는다
#   (점유율이 평형값으로 재계산돼 PGM으로 넣은 전하가 사라진다).
# ---------------------------------------------------------------------
Solve {
    # 초기 소거 상태. 0.139 는 기준 구조에서 Vt -4.0V 가 나오던 값이라
    # 이 구조의 초기 Vt 는 다르게 나온다 - S0 read 로 실제값을 측정한다.
    Set( Traps( "Tdon" = 0.139  "Tacc" = 0.0  Frozen ) )

    Coupled (Iterations=100) { Poisson }
    Coupled (Iterations=100) { Poisson Electron }
    Coupled (Iterations=100 Digits=8) { Poisson Electron Hole }
    Plot ( FilePrefix="NAND_AIR_pgm_00_InitState" )

    Set( Traps( -Frozen ) )

    # ---- periphery 켜기 (0 ~ 10us)
    NewCurrentPrefix = "NAND_AIR_pgm_pon_"
    Transient ( InitialTime=0.0 FinalTime=10.0000e-6
        InitialStep=1e-12 MaxStep=1e-7 MinStep=1e-15 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (0 10.0000e-6) intervals = 100))
        Plot ( FilePrefix="NAND_AIR_pgm_01_PeripheryOn" Time=( 10.0000e-6 ) )
    }

    # ---- S0 read : 초기 Vt (10 ~ 33us)
    Set( Traps( Frozen ) )
    NewCurrentPrefix = "NAND_AIR_pgm_s0vt_"
    Transient ( InitialTime=10.0000e-6 FinalTime=33.0000e-6
        InitialStep=1e-9 MaxStep=5e-8 MinStep=1e-12 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (10.0000e-6 33.0000e-6) intervals = 460))
    }
    Set( Traps( -Frozen ) )

    # ---- PGM 펄스 18V (33 ~ 58us) : 트랩이 움직이는 구간
    NewCurrentPrefix = "NAND_AIR_pgm_pulse_"
    Transient ( InitialTime=33.0000e-6 FinalTime=58.0000e-6
        InitialStep=1e-9 MaxStep=2e-7 MinStep=1e-15 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (33.0000e-6 58.0000e-6) intervals = 250))
        Plot ( FilePrefix="NAND_AIR_pgm_02_HoldEnd" Time=( 50.5000e-6 ) )
    }

    # ---- PGM 후 read : 프로그램된 Vt (58 ~ 4812us)
    Set( Traps( Frozen ) )
    NewCurrentPrefix = "NAND_AIR_pgm_s1vt_"
    Transient ( InitialTime=58.0000e-6 FinalTime=4812.0000e-6
        InitialStep=1e-9 MaxStep=1e-5 MinStep=1e-12 ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (58.0000e-6 4812.0000e-6) intervals = 477))
        Plot ( FilePrefix="NAND_AIR_pgm_03_AfterRead" Time=( 4810.0000e-6 ) )
    }
}
