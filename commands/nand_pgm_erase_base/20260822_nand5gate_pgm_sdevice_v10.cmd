# =====================================================================
# SDEVICE 커맨드 - nand_pgm_erase_base 실험, PGM(Program) 테스트 (v10)
# 구조: 20260821_nand5gate_sde_v1.scm (Cylindrical, x=0 축대칭)
# 게이트 스택: SL - SG - WL_PASS - WL_SEL - WL_PASS - DG - BL
#
# [v9 -> v10 변경점] v9 결과 확인: Pass1 점유율이 28.5%(v8) -> 26.8%(v9)로 거의
# 안 줄어듦(6% 상대감소). Channel-WL_PASS 전위차를 8V->2V로 크게 줄였는데도 개선이
# 미미했던 이유를 재검토한 결과: **SG/DG까지 WL_PASS와 함께 discharge시킨 게 오히려
# 역효과였을 수 있다는 가설**.
#
# SG(SL쪽)/DG(BL쪽)는 채널을 SL/BL(0V 고정)에 연결하는 "통로"(select gate) 역할.
# 채널이 discharge 순간 음전위로 오버슈트되는 걸 억제하려면 이 통로가 열려 있어야
# SL/BL의 0V가 채널 중간(Sel/Pass1)까지 효과적으로 전달됨. 그런데 v9에서는 정확히
# 채널이 가장 흔들리는 그 순간에 SG/DG 자신도 0V로 꺼버려서, SL/BL과 채널 사이의
# 저항이 오히려 커진(통로가 막힌) 상태였을 수 있음 - 이러면 SL/BL이 아무리 0V로
# 고정돼 있어도 그 "붙잡는 힘"이 중간까지 잘 전달되지 못함.
#
# WL_PASS(내부 pass 트랜지스터, SL/BL과 직접 연결 안 됨)는 v9 그대로 discharge
# 유지하고, **SG/DG만 원래(v8 방식)대로 discharge 없이 6V로 계속 켜둬서** 채널-SL/BL
# 통로를 discharge 내내 열어두도록 되돌림. 이러면 채널이 SL/BL에 더 강하게 "붙잡혀"
# 오버슈트가 줄어들고, 그 결과 Pass1 disturb도 줄어드는지 확인.
#
# [이전 변경 이력 - v1~v9 요약]
# - v1->v2: Read/Id-Vgs 검증 단계 추가.
# - v2->v3: Quasistationary+Goal(zero-pivot 원인) 제거, 전극 파형 기반으로 재구성.
# - v3->v4: Math의 Extrapolate 제거 (PGM Transient 시작 직후 |RHS|>1e15 발산 해결).
# - v4->v5: Id-Vgs 스윕 범위를 -2V ~ 6V로 확장.
# - v5->v6: Id-Vgs 스윕/복귀 구간을 NewCurrentPrefix로 완전 분리, SG/WL_PASS/DG에
#   WL_SEL과 동일한 PGM Rising Time 추가.
# - v6->v7: eTrappedCharge(Average(...)) 점유율 진단 추가, discharge 300us 테스트
#   (결과: rate-independent).
# - v7->v8: 포획 단면적을 보수적 대칭값 1e-15/1e-15로 낮춤(결과: Pass1 disturb 거의
#   불변, 29.4%->28.5%), discharge 50us로 원복.
# - v8->v9: 채널(PolySi) Potential 진단 추가, SG/WL_PASS/DG를 WL_SEL과 같이
#   discharge(결과: Pass1 28.5%->26.8%, 개선 미미 - hold 구간 baseline은 사실상
#   0(8.85e11)이라 discharge 이벤트가 disturb의 거의 전부라는 것도 확인됨).
#   자세한 근거는 runs/nand_pgm_erase_base/0001_*.md, 0002_*.md 참고.
#
# [Parameter 파일] model_parameter/20260822_models_v1.par 기준
# (서버 경로: /home/daeyeol05/Original/models_jh.par).
# =====================================================================

File {
    Grid = "n@node|-1@_msh.tdr"
    Parameter = "/home/daeyeol05/Original/models_jh.par"   # = model_parameter/20260822_models_v1.par (2026-08-22 기준)
    Plot    = "n@node@_v10_des.tdr"
    Current = "n@node@_v10_des.plt"
    Output  = "n@node@_v10_des.log"
}

Electrode {
    { Name="SL" Voltage=0.0 }

    # BL: 0V(초기) -> 0.5V(pre-PGM read bias, t=0~1e-5 ramp, 1e-5~2e-5 유지) ->
    #     0V(PGM 펄스 동안, t=2e-5~3.8e-4) -> 0.5V(post-PGM read bias) -> 0V(종료)
    { Name="BL" Voltage=0.0
      Voltage=(
          0.0    at 0.0,
          0.5    at 1e-5,      # periphery-on ramp과 동시에 read 드레인 전압도 램프
          0.5    at 2e-5,      # pre-PGM Id-Vgs 스윕 구간 동안 유지
          0.0    at 3e-5,      # PGM 펄스 전에 0V로 복귀
          0.0    at 3.8e-4,    # PGM 펄스(rising+hold+discharge 50us) 동안 0V 유지
          0.5    at 3.9e-4,    # post-PGM read 드레인 전압 재인가
          0.5    at 4.0e-4,    # post-PGM Id-Vgs 스윕 구간 동안 유지
          0.0    at 4.1e-4     # 종료
      )
    }

    # [v10] SG/DG: 채널을 SL/BL에 연결하는 select gate라서, discharge 순간에도
    # 계속 켜둬서(v8 방식으로 되돌림) 채널-SL/BL 통로를 열어둠 - discharge를 안 함.
    { Name="SG" Voltage=0.0 WorkFunction=4.53
      Voltage=(
          0.0    at 0.0,
          6.0    at 1e-5,      # pre-PGM Id-Vgs 스윕용 periphery-on
          6.0    at 2e-5,      # pre-PGM 스윕 구간 동안 유지
          0.0    at 3e-5,      # PGM Rising 시작 전 0V로 복귀 (WL_SEL과 동시)
          6.0    at 1.3e-4,    # WL_SEL과 같은 100us 동안 0->6V Rising (PGM 채널 통전)
          6.0    at 4.0e-4,    # [v10] hold~discharge~post-PGM 스윕까지 6V 유지(discharge 안 함)
          0.0    at 4.1e-4     # 종료
      )
    }

    # [v10] WL_PASS: v9와 동일하게 WL_SEL과 같이 discharge 유지 (이건 CTN 쪽
    # 크로스토크 테스트라 SG/DG 실험과 별개 변수 - 그대로 둠)
    { Name="WL_PASS" Voltage=0.0 WorkFunction=4.53
      Voltage=(
          0.0    at 0.0,
          6.0    at 1e-5,
          6.0    at 2e-5,
          0.0    at 3e-5,
          6.0    at 1.3e-4,
          6.0    at 3.3e-4,
          0.0    at 3.8e-4,    # WL_SEL과 같이 discharge (v9와 동일)
          6.0    at 3.9e-4,
          6.0    at 4.0e-4,
          0.0    at 4.1e-4
      )
    }

    # [v10] DG: SG와 동일하게 discharge 없이 계속 켜둠
    { Name="DG" Voltage=0.0 WorkFunction=4.53
      Voltage=(
          0.0    at 0.0,
          6.0    at 1e-5,
          6.0    at 2e-5,
          0.0    at 3e-5,
          6.0    at 1.3e-4,
          6.0    at 4.0e-4,    # [v10] hold~discharge~post-PGM 스윕까지 6V 유지
          0.0    at 4.1e-4
      )
    }

    # [핵심] WL_SEL: (1) periphery-on 구간 내내 -2V 고정 -> -2->6V 단조증가 스윕
    # (t=0~2e-5) -> 6->0V 복귀(PGM 준비, t=2e-5~3e-5) -> (2) PGM 펄스(0->20V rising
    # 100us, hold 200us, discharge 50us, t=3e-5~3.8e-4) -> (3) periphery-on 구간
    # 내내 -2V 고정 -> -2->6V 단조증가 스윕(t=3.8e-4~4.0e-4) -> 6->0V 복귀(종료,
    # t=4.0e-4~4.1e-4)
    { Name="WL_SEL" Voltage=0.0 WorkFunction=4.53
      Voltage=(
          -2.0    at 0.0,      # periphery-on 구간 내내 -2V(스윕 시작점) 고정
          -2.0    at 1e-5,
          6.0     at 2e-5,     # [1] pre-PGM Id-Vgs 스윕: -2->6V (단조증가만)
          0.0     at 3e-5,     # 스윕 종료, PGM 펄스 준비 위해 0V로 복귀
          20.0    at 1.3e-4,   # [2] PGM Rising: 0->20V (100us)
          20.0    at 3.3e-4,   # PGM Hold: 20V 유지 (200us)
          0.0     at 3.8e-4,   # PGM Discharge: 20->0V (50us)
          -2.0    at 3.9e-4,   # periphery-on 구간 내내 -2V(스윕 시작점) 고정
          6.0     at 4.0e-4,   # [3] post-PGM Id-Vgs 스윕: -2->6V (단조증가만)
          0.0     at 4.1e-4    # 스윕 종료, 0V로 복귀 (별도 구간으로 분리 기록)
      )
    }
}

Physics {
    eBarrierTunneling "NL_Tox"
    hBarrierTunneling "NL_Tox"
}

Physics(Material="PolySi") {
    Recombination(
      SRH
      Band2Band(Model=Hurkx)
    )
    Mobility(DopingDependence)
}

Physics(Material="Si3N4") {
    Mobility(ConstantMobility)

    Traps(
        # Donor 트랩 - 포획 단면적 1e-15/1e-15 (v8/v9와 동일 유지)
        ( Donor Level EnergyMid= 1.1 fromValBand
          Conc= 1.5e19
          eXSection= 1e-15 hXSection= 1e-15
          eBarrierTunneling(NonLocal= "NL_Tox" )
          hBarrierTunneling(NonLocal= "NL_Tox" )
          PooleFrenkel(Electron)
          TrapVolume= 1e-15
       )

        # Acceptor 트랩 - 포획 단면적 1e-15/1e-15 (v8/v9와 동일 유지)
        ( Acceptor Level EnergyMid=1.3 fromCondBand
          Conc=2.5e19
          eXsection=1e-15 hXsection=1e-15
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
}

CurrentPlot {
    eTrappedCharge( Integral( Material="Si3N4" ) )
    hTrappedCharge( Integral( Material="Si3N4" ) )
    eTrappedCharge( Average(  Material="Si3N4" ) )
    SpaceCharge(    Average(  Material="Si3N4" ) )

    # WL_SEL 위치(Sel 서브리전, CTN)만 국소로 분리 추출 - PGM/Erase 밴드 비교의 핵심
    eTrappedCharge( Integrate( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    eTrappedCharge( Average(   Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    hTrappedCharge( Integrate( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    SpaceCharge(    Average(   Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ConductionBandEnergy( Average( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ConductionBandEnergy( Minimum( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ValenceBandEnergy(    Average( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )
    ValenceBandEnergy(    Maximum( Material="Si3N4" Window[(0.038 0.110) (0.043 0.135)] Name="Sel" ) )

    # 채널->Tox 터널링 전류: WL_SEL 위치에서만 (RegionInterface로 정확히 타깃팅)
    eBarrierTunneling( Integral( RegionInterface="R.Channel_Sel/R.TunnelOx_Sel" ) )
    hBarrierTunneling( Integral( RegionInterface="R.Channel_Sel/R.TunnelOx_Sel" ) )

    # WL_Pass1 위치(CTN) 진단 (nand_pgm_EPEP RUN 0003 계열 현상 - v4에서 원인 확정됨)
    eTrappedCharge( Integrate( Material="Si3N4" Window[(0.038 0.065) (0.043 0.090)] Name="Pass1" ) )
    eTrappedCharge( Average(   Material="Si3N4" Window[(0.038 0.065) (0.043 0.090)] Name="Pass1" ) )
    ConductionBandEnergy( Average( Material="Si3N4" Window[(0.038 0.065) (0.043 0.090)] Name="Pass1" ) )
    ConductionBandEnergy( Minimum( Material="Si3N4" Window[(0.038 0.065) (0.043 0.090)] Name="Pass1" ) )

    # 채널(PolySi) 전위 진단 - discharge 순간 채널 전위 오버슈트가 SG/DG 유지로
    # 얼마나 줄어드는지 v9와 비교용
    Potential( Average( Material="PolySi" Window[(0.025 0.110) (0.033 0.135)] Name="SelChannel" ) )
    Potential( Average( Material="PolySi" Window[(0.025 0.065) (0.033 0.090)] Name="Pass1Channel" ) )
}

Math {
    Cylindrical( xAxis=0.0 )

    Method=Pardiso
    -CheckUndefinedModels
    Derivatives
    RelErrControl

    NonLocal "NL_Tox" (
        RegionInterface="R.Channel_Below/R.TunnelOx_Below"
        RegionInterface="R.Channel_Sel/R.TunnelOx_Sel"
        RegionInterface="R.Channel_Above/R.TunnelOx_Above"
        Length= 1e-6
        Digits= 4
        EnergyResolution= 1e-4
    )

    Digits=3
    Number_of_Threads= 4
    Iterations= 25
    Transient= BE
}

Solve {
    Set(TrapFilling=empty)
    Coupled (Iterations=100) { Poisson }
    Coupled (Iterations=100) { Poisson Electron }
    Coupled (Iterations=100 Digits=8) { Poisson Electron Hole }

    Plot ( FilePrefix="n@node@_v10_00_Initial_0V" )

    # -------------------------------------------------------------
    # [1] Pre-PGM Id-Vgs 스윕만 (-2V ~ 6V, 단조증가) - 깨끗한 커브 전용 파일
    # -------------------------------------------------------------
    NewCurrentPrefix = "preIdVg_"
    Transient (
        InitialTime=0.0 FinalTime=2e-5
        InitialStep=1e-9 MaxStep=1e-7 MinStep=1e-10
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (0 2e-5) intervals = 150))

        Plot ( FilePrefix="n@node@_v10_01_PeripheryOn"     Time=( 1e-5 ) )
        Plot ( FilePrefix="n@node@_v10_02_PreIdVg_End"     Time=( 2e-5 ) )
    }

    # -------------------------------------------------------------
    # [1-down] PGM 준비를 위해 6V->0V 복귀 (스윕 데이터 아님, 별도 파일로 격리)
    # -------------------------------------------------------------
    NewCurrentPrefix = "preIdVgDown_"
    Transient (
        InitialTime=2e-5 FinalTime=3e-5
        InitialStep=1e-9 MaxStep=1e-7 MinStep=1e-10
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (2e-5 3e-5) intervals = 50))
    }

    # -------------------------------------------------------------
    # [2] PGM 펄스 - [v10] SG/DG는 discharge 없이 유지, WL_PASS만 WL_SEL과 같이 discharge
    # -------------------------------------------------------------
    Unset(TrapFilling)
    NewCurrentPrefix = "pgm_"
    Transient (
        InitialTime=3e-5 FinalTime=3.8e-4
        InitialStep=1e-12 MaxStep=1e-5 MinStep=1e-15
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (3e-5 3.8e-4) intervals = 500))

        Plot ( FilePrefix="n@node@_v10_03_PGM_0V"        Time=( 3e-5   ) )
        Plot ( FilePrefix="n@node@_v10_04_PGM_10V"       Time=( 8e-5   ) )
        Plot ( FilePrefix="n@node@_v10_05_PGM_20V"       Time=( 1.3e-4 ) )
        Plot ( FilePrefix="n@node@_v10_06_PGM_20V_Hold"  Time=( 3.3e-4 ) )
        Plot ( FilePrefix="n@node@_v10_07_PGM_Discharged" Time=( 3.8e-4 ) )
    }

    # -------------------------------------------------------------
    # [2-repower] post-PGM Id-Vgs 스윕을 위해 WL_PASS를 다시 periphery-on
    # (SG/DG는 이미 켜져 있으므로 그대로)
    # -------------------------------------------------------------
    NewCurrentPrefix = "postPeripheryOn_"
    Transient (
        InitialTime=3.8e-4 FinalTime=3.9e-4
        InitialStep=1e-9 MaxStep=1e-7 MinStep=1e-10
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (3.8e-4 3.9e-4) intervals = 50))

        Plot ( FilePrefix="n@node@_v10_08_PeripheryOn_Post" Time=( 3.9e-4 ) )
    }

    # -------------------------------------------------------------
    # [3] Post-PGM Id-Vgs 스윕만 (-2V ~ 6V, 단조증가) - 깨끗한 커브 전용 파일
    # -------------------------------------------------------------
    Set(TrapFilling=Frozen)
    NewCurrentPrefix = "postIdVg_"
    Transient (
        InitialTime=3.9e-4 FinalTime=4.0e-4
        InitialStep=1e-9 MaxStep=1e-7 MinStep=1e-10
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (3.9e-4 4.0e-4) intervals = 150))

        Plot ( FilePrefix="n@node@_v10_09_PostIdVg_End"     Time=( 4.0e-4 ) )
    }

    # -------------------------------------------------------------
    # [3-down] 종료를 위해 6V->0V 복귀 (스윕 데이터 아님, 별도 파일로 격리)
    # -------------------------------------------------------------
    NewCurrentPrefix = "postIdVgDown_"
    Transient (
        InitialTime=4.0e-4 FinalTime=4.1e-4
        InitialStep=1e-9 MaxStep=1e-7 MinStep=1e-10
    ) {
        Coupled { Poisson Electron Hole }
        CurrentPlot (time = (range = (4.0e-4 4.1e-4) intervals = 50))
    }
}
