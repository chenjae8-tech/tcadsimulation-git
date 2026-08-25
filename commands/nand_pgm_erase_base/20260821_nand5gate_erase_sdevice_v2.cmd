# =====================================================================
# SDEVICE 커맨드 - nand_pgm_erase_base 실험, Erase 테스트 (v2: GIDL Erase로 전환)
# 구조: 20260821_nand5gate_sde_v1.scm (PGM cmd와 동일 구조/메시 재사용)
#
# [v1 -> v2 변경점] "게이트 네거티브 FN erase"(WL_SEL만 음전압)에서 nand_erase_GIDL-HCI
# 실험과 동일한 GIDL(Gate-Induced Drain Leakage) Erase로 전환. SL/BL을 같이 높은 전압
# (20V)으로 올리고 SG/WL_PASS/WL_SEL/DG는 전부 0V로 고정 - SG(SL쪽)/DG(BL쪽) 게이트-접합
# 오버랩에서 GIDL(Band2Band + Avalanche)이 발생해 채널에 정공을 공급하고, 이 정공들이
# 채널 전체(0V로 고정된 모든 게이트 아래)에서 CTN으로 hBarrierTunneling되어 PGM으로 채워진
# 전자와 반대 극성의 전하 상태를 만드는 것이 목표 (nand_erase_GIDL-HCI 0001 런에서 검증된
# SL+BL 동시 인가 "floating channel" 구성과 동일 - 그 실험의 RUN_LOG 0001 "[정정]" 주석 참고).
#
# [베이스라인 가정 - 검토 필요]
# - GIDL 물리(Band2Band(Model=Nonlocalpath), eAvalanche/hAvalanche(Eparallel
#   vanOverstraeten), Mobility(DopingDependence HighFieldSaturation Enormal))는
#   nand_erase_GIDL-HCI v11의 PolySi Physics를 그대로 재사용함. 그 실험의 HCI 전용
#   요소(GateCurrent Fowler/eLucky/hLucky, InjectionRegion)는 이 base 실험의 목적
#   (GIDL erase 자체 확인)과 무관해서 제외함.
# - Math 섹션의 강건성 옵션(Iterations=150, Notdamped=50, ErrRef 등)도
#   nand_erase_GIDL-HCI에서 GIDL/Avalanche 수렴이 까다로워 추가됐던 값을 그대로 가져옴.
# =====================================================================

File {
    Grid = "n@node|-1@_msh.tdr"
##    Parameter = "tcad_fix.par"
    Parameter = "/home/daeyeol05/Original/models_jh.par"
    Plot    = "n@node@_v2_des.tdr"
    Current = "n@node@_v2_des.plt"
    Output  = "n@node@_v2_des.log"
}

Electrode {
    # [GIDL 핵심] SL/BL을 동시에 같은 파형으로 램프 (한쪽만 올리면 반대쪽 접합이
    # 채널 전위를 붙잡아버려 floating 채널이 안 만들어짐 - GIDL-HCI 0001 런에서 확인됨)
    { Name="SL" Voltage=0.0
      Voltage=(
          0.0    at 0.0,
          20.0   at 1e-4,     # 100us 동안 0->20V Rising
          20.0   at 3e-4,     # 200us 유지 (Total 300us)
          0.0    at 3.5e-4    # 50us 동안 0V로 Discharge (Total 350us)
      )
    }
    { Name="BL" Voltage=0.0
      Voltage=(
          0.0    at 0.0,
          20.0   at 1e-4,
          20.0   at 3e-4,
          0.0    at 3.5e-4
      )
    }

    # SG/WL_PASS/WL_SEL/DG 전부 접지 고정 - 이 아래 채널 전체에서 정공이 CTN으로
    # 터널링되도록 함 (WL_SEL도 포함되므로 이 구간의 Erase 여부를 그대로 관찰 가능)
    { Name="SG"      Voltage=0.0 WorkFunction=4.53 }
    { Name="WL_PASS" Voltage=0.0 WorkFunction=4.53 }
    { Name="WL_SEL"  Voltage=0.0 WorkFunction=4.53 }
    { Name="DG"      Voltage=0.0 WorkFunction=4.53 }
}

Physics {
    EffectiveIntrinsicDensity(BandGapNarrowing(OldSlotboom))

    eBarrierTunneling "NL_Tox"
    hBarrierTunneling "NL_Tox"
}

Physics(Material="PolySi") {
    Recombination (
        SRH
        Auger

        # GIDL 발생 원동력: 게이트-접합 오버랩(SG/y1, DG/y10)에서의 밴드간 터널링 +
        # 충돌 이온화 (nand_erase_GIDL-HCI v11과 동일)
        eAvalanche ( Eparallel vanOverstraeten )
        hAvalanche ( Eparallel vanOverstraeten )
        Band2Band ( Model=Nonlocalpath )
    )
    Mobility( DopingDependence HighFieldSaturation Enormal )
}

Physics(Material="Si3N4") {
    Mobility(ConstantMobility)

    Traps(
        # Donor 트랩 (정공 포획이 주 역할, Ev+1.1eV 기준) - PGM cmd와 동일
        ( Donor Level EnergyMid= 1.1 fromValBand
          Conc= 1.5e19
          eXSection= 1e-12 hXSection= 1e-13
          eBarrierTunneling(NonLocal= "NL_Tox" )
          hBarrierTunneling(NonLocal= "NL_Tox" )
          PooleFrenkel(Electron)
          TrapVolume= 1e-15
       )

        # Acceptor 트랩 (전자 포획이 주 역할, Ec-1.3eV 기준) - PGM cmd와 동일
        ( Acceptor Level EnergyMid=1.3 fromCondBand
          Conc=2.5e19
          eXsection=1e-13 hXsection=1e-12
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
    Band2BandGeneration AvalancheGeneration
}

CurrentPlot {
    eTrappedCharge( Integral( Material="Si3N4" ) )
    hTrappedCharge( Integral( Material="Si3N4" ) )
    eTrappedCharge( Average(  Material="Si3N4" ) )
    SpaceCharge(    Average(  Material="Si3N4" ) )

    # WL_SEL 위치(Sel 서브리전)만 국소로 분리 추출 - PGM cmd와 동일 Window (직접 비교용)
    eTrappedCharge( Integrate( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    hTrappedCharge( Integrate( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    SpaceCharge(    Average(   Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ConductionBandEnergy( Average( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ConductionBandEnergy( Minimum( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ValenceBandEnergy(    Average( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ValenceBandEnergy(    Maximum( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )

    eBarrierTunneling( Integral( RegionInterface="R.Channel_Sel/R.TunnelOx_Sel" ) )
    hBarrierTunneling( Integral( RegionInterface="R.Channel_Sel/R.TunnelOx_Sel" ) )

    # GIDL 발생 확인용: SG(SL쪽, y1~y2)/DG(BL쪽, y9~y10) 접합-게이트 오버랩 부근에서
    # Band2Band 생성 및 채널->Tox 경계 전류를 국소로 추출
    Band2BandGeneration( Integral( Material="PolySi" Window[(0.025 0.010) (0.033 0.055)] Name="GIDL_SG" ) )
    Band2BandGeneration( Integral( Material="PolySi" Window[(0.025 0.190) (0.033 0.235)] Name="GIDL_DG" ) )
    eBarrierTunneling( Integral( MaterialInterface="SiO2/PolySi" Window[(0.030 0.010) (0.036 0.055)] Name="GIDL_SG_eBT" ) )
    hBarrierTunneling( Integral( MaterialInterface="SiO2/PolySi" Window[(0.030 0.010) (0.036 0.055)] Name="GIDL_SG_hBT" ) )
}

Math {
    Cylindrical( xAxis=0.0 )
    -CheckUndefinedModels
    Extrapolate
    Derivatives
    RelErrControl
    Method=Pardiso
    Transient=BE

    Iterations=150
    Notdamped=50
    Digits=6

    ErrRef(Electron)=1e8
    ErrRef(Hole)=1e8

    NonLocal "NL_Tox" (
        RegionInterface="R.Channel_Below/R.TunnelOx_Below"
        RegionInterface="R.Channel_Sel/R.TunnelOx_Sel"
        RegionInterface="R.Channel_Above/R.TunnelOx_Above"
        Length= 1e-6
        Digits= 4
        EnergyResolution= 1e-4
    )

    Number_of_Threads= 4
}

Solve {
    # PGM 직후가 아니라, Erase 단독 거동을 보기 위해 트랩을 "가득 채운 상태"에서 시작.
    # (TrapFilling=Full, 대문자 F - manual/sdevice/40_Tcl_Interfaces.md Table 347 /
    # manual/sdevice/17_Traps_and_Fixed_Charges.md "Explicit Trap Occupation" 참고)
    Set(TrapFilling=Full)
    Coupled (Iterations=100) { Poisson }
    Coupled (Iterations=100) { Poisson Electron }
    Coupled (Iterations=100 Digits=8) { Poisson Electron Hole }

    Plot ( FilePrefix="n@node@_v2_00_Initial_0V" )

    Unset(TrapFilling)

    # 시뮬레이션 타임 0 ~ 350us: GIDL Erase 펄스 1회 (Rising-Hold-Discharge)
    Transient (
        InitialTime=0.0 FinalTime=3.5e-4
        InitialStep=1e-12 MaxStep=1e-5 MinStep=1e-15
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (0 3.5e-4) intervals = 500))

        Plot ( FilePrefix="n@node@_v2_01_0V"       Time=( 0.0   ) )
        Plot ( FilePrefix="n@node@_v2_02_10V"      Time=( 5e-5  ) )
        Plot ( FilePrefix="n@node@_v2_03_20V"      Time=( 1e-4  ) )
        Plot ( FilePrefix="n@node@_v2_04_20V_Hold" Time=( 3e-4  ) )
        Plot ( FilePrefix="n@node@_v2_05_Discharged" Time=( 3.5e-4 ) )
    }

    # -------------------------------------------------------------
    # [검증] Read 동작: Erase pulse 직후 트랩 점유를 고정(Frozen)하고,
    # WL_SEL을 게이트로 하는 Id-Vgs(Id=BL 전류, Vgs=WL_SEL 전압) 스윕을 수행해
    # 셀 문턱전압(Vt)이 실제로 낮아졌는지 확인. Frozen은 read 중 게이트 전압
    # 변화가 트랩 점유 자체를 다시 바꾸지 않도록 고정하는 것이 목적
    # (manual/sdevice/17_Traps_and_Fixed_Charges.md "Explicit Trap Occupation").
    # -------------------------------------------------------------
    Set(TrapFilling=Frozen)

    # 1) SG/WL_PASS/DG를 pass 전압(6V)으로 올리고 BL에 작은 read 드레인 전압(0.5V)
    #    인가. 여러 Goal을 한 Quasistationary에 같이 넣으면 동일 비율로 동시에
    #    램프됨 (manual/sdevice/04_Performing_Numeric_Experiments.md "Quasistationary
    #    Ramps").
    Quasistationary (
        InitialStep=0.02 Increment=1.3 MaxStep=0.05 MinStep=1e-4
        Goal { Name="SG"      Voltage=6.0 }
        Goal { Name="WL_PASS" Voltage=6.0 }
        Goal { Name="DG"      Voltage=6.0 }
        Goal { Name="BL"      Voltage=0.5 }
    ) { Coupled { Poisson Electron Hole } }

    Plot ( FilePrefix="n@node@_v2_10_ReadBias_On" )

    # 2) Id-Vgs 스윕: WL_SEL(게이트) 0V->6V 램프. CurrentPlot 없이도 Quasistationary는
    #    기본적으로 매 반복마다 전극 전류를 Current 파일(.plt)에 기록함
    #    (manual/sdevice/05_Simulation_Results.md "When to Write to the Current File").
    #    Inspect에서 "WL_SEL OuterVoltage" vs "BL TotalCurrent"로 Id-Vgs 커브를 그려서
    #    PGM cmd의 동일 스윕과 Vt를 비교.
    Quasistationary (
        InitialStep=0.02 Increment=1.3 MaxStep=0.05 MinStep=1e-4
        Goal { Name="WL_SEL" Voltage=6.0 }
    ) { Coupled { Poisson Electron Hole } }

    Plot ( FilePrefix="n@node@_v2_11_IdVg_End" )
}
