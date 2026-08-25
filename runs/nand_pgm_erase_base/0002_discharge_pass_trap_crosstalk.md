# RUN 0002 — Discharge 구간에 WL_PASS 쪽도 같이 PGM되는 것처럼 보이는 현상 (기존 미해결 이슈 재발)

- **날짜**: 2026-08-22
- **사용된 커맨드 파일**: `commands/nand_pgm_erase_base/20260821_nand5gate_pgm_sdevice_v2.cmd`
  (사용자가 SVisual TDR 스냅샷 6장 `n2_v2_00_Initial_0V` ~ `n2_v2_05_Discharged`와
  `.plt` 시간 그래프를 제공)
- **목적/의도**: v2의 PGM Transient(discharge까지는 정상 완료했던 부분) 결과를 SVisual로
  확인.
- **상태**: 현상 확인, 원인은 기존 실험(`nand_pgm_EPEP` RUN 0003)에서 이미 관찰됐던
  것과 동일하며 그쪽도 인과관계 미확정 상태였음. 마침 이번 v3 재설계가 그 실험의
  미완료 격리 테스트 조건을 우연히 충족하므로, v3 실행 결과로 answer 가능.

## 관찰된 현상

1. **TDR 스냅샷**: `n2_v2_02_10V` 부터 CTN(Si3N4) 층에 색(트랩/전하 관련 물리량으로 추정)이
   나타나기 시작해 `03_20V`/`04_20V_Hold`/`05_Discharged`로 갈수록 강해짐. 사용자 관찰에
   따르면 이 색이 WL_SEL 위치뿐 아니라 **WL_PASS 위치 아래에도** 나타남 — "discharge 할 때
   vpass 쪽에도 같이 pgm 되는 현상".
2. **`.plt` 시간 그래프**: `eBarrierTunneling_Integral(RegionInterface="R.Channel_Sel/
   R.TunnelOx_Sel")`(WL_SEL 위치, cyan 곡선)이 rising~hold 구간에 상승/포화하다가,
   **discharge 구간(WL_SEL·WL_PASS 전압이 함께 20V→0V, 6V→0V로 떨어지는 t≈3e-4~3.5e-4)에서
   급격히 떨어졌다가(로그 스케일에서 여러 자릿수 dip) 다시 올라오는 비단조(非單調) 패턴**을
   보임. 전압이 계속 감소하는데 터널링 전류(크기)가 다시 증가하는 것은 직관적이지 않음.

## 원인 분석 (가설 — `nand_pgm_EPEP` RUN 0003과 동일 계열)

- **동일 현상 선례**: `runs/nand_pgm_EPEP/0003_pass1_discharge_trap_runaway.md`에서
  거의 동일한 증상을 이미 관찰함 — "WL_Target 방전 구간에 WL_Pass1 CTN 트랩량이 discharge
  중반부터 폭증, 심지어 두 전극이 완전히 0V가 된 뒤에도 계속 상승". 그 기록의 핵심 단서:
  전압이 이미 0V인데도 트랩량이 190us 넘게 계속 오른다는 것은 **전압에 순간적으로 반응하는
  계산 아티팩트가 아니라, 방전 중 채널/터널옥사이드에 과도하게 실린 캐리어가 서서히
  트랩으로 빨려들어가며 완화(relax)되는 실제 물리적 전이 과정일 가능성이 크다**는 것.
- **구조적 이유(우리 구조에서 새로 확인)**: SDE 구조(`20260821_nand5gate_sde_v1.scm`)에서
  `R.Channel`/`R.TunnelOx`는 Below/Sel/Above 3구간으로 쪼갰지만, **`R.TrapNi`(CTN)와
  `R.BlockOx`는 여전히 y0~y_top 전체를 잇는 하나의 연속된 리전**이다. 즉 물리적으로 하나로
  이어진 질화막이라, WL_SEL 바로 아래에 강하게 트랩된 전하가 옆(WL_PASS 아래 위치)으로
  횡방향 확산/재분배되는 것은 인위적 버그가 아니라 **연속된 재질에서 기대되는 실제
  거동**일 수 있음 (다만 이게 물리적으로 타당한 "정도"인지, 과도한 것인지는 별도 검증 필요).
- **eBarrierTunneling dip-then-rise 해석**: 로그 스케일 그래프에서 여러 자릿수가 꺼졌다가
  다시 오르는 모양은, 전형적으로 **부호가 반전되는 지점(net 0 통과)** 을 지날 때 나타나는
  모양과 일치한다 — 방금 트랩된 전자가 만드는 국소 고정전하(음전하)가 게이트 전압이
  빠르게 낮아지는 동안 상대적으로 우세해지면서, 채널→CTN 방향이던 순 터널링 방향이
  CTN→채널(detrapping, 전자가 도로 빠져나감) 방향으로 역전됐을 가능성. Charge-trap
  플래시에서 "프로그램 직후 급격한 방전이 유발하는 detrapping/retention loss"는 알려진
  현상이라 이 자체가 버그라고 단정할 근거는 아직 없음.

## 남아있는 핵심 질문 (nand_pgm_EPEP RUN 0003과 동일)

`nand_pgm_EPEP` RUN 0003은 이 현상이 (a) WL_Target(=우리 WL_SEL)의 급격한 전계 붕괴가
유발한 인접 게이트 크로스토크(실제 물리 현상)인지, (b) WL_Pass 자신의 **동시 방전** 때문에
생기는 현상인지 구분하기 위해 "Pass를 방전시키지 않고 일정 전압으로 고정한 채 Target만
방전"하는 격리 실험(v5→v7)을 제안했으나, **실행 결과 확인이 안 된 채 미해결로 남아있었다**
(`runs/nand_pgm_EPEP/0003_pass1_discharge_trap_runaway.md` "결과/다음 액션" 체크리스트
참고).

## 우연히 충족된 격리 조건 (v3)

Zero-pivot 문제 대응으로 이미 재작성한 `20260822_nand5gate_pgm_sdevice_v3.cmd`의 전극
파형을 다시 보면, **WL_PASS는 t=1e-5(6V 도달)부터 t=4.0e-4까지 쭉 6V로 고정**돼 있고,
WL_SEL의 PGM discharge(t=3.3e-4~3.8e-4)와 **동시에 방전하지 않는다** (WL_PASS는 그보다
훨씬 뒤인 t=4.0e-4~4.1e-4에 가서야, 그것도 post-PGM Id-Vgs 스윕이 다 끝난 뒤에 방전됨).
즉 v3는 nand_pgm_EPEP RUN 0003이 제안했던 "Pass 고정, Target만 방전" 격리 조건을 그대로
만족한다 — 이는 원래 v3 설계 의도(zero-pivot 회피)와는 무관하게 생긴 부수 효과.

**해석 기준**: v3 실행 후에도 WL_SEL discharge(t=3.3e-4~3.8e-4) 구간에 WL_Pass1 위치의
트랩량이 여전히 폭증/dip-rise 패턴을 보이면 → (a) WL_SEL 유발 크로스토크(진짜 물리 현상).
그 구간에 잠잠하다가 v3 자체의 discharge(t=4.0~4.1e-4)에서만 비슷한 패턴이 나타나면 →
(b) Pass 자신의 방전이 원인.

## 적용한 수정

`20260822_nand5gate_pgm_sdevice_v3.cmd`의 `CurrentPlot`에 WL_Pass1 위치(TrapNi
x범위 0.038~0.043, y범위 0.065~0.090) 전용 진단 항목 추가:
- `eTrappedCharge(Integrate(...) Name="Pass1")`
- `ConductionBandEnergy(Average/Minimum(...) Name="Pass1")`

`nand_pgm_EPEP` RUN 0003이 폭주 여부 확인에 실제로 쓴 것과 동일한 조합
(전도대-트랩 에너지차가 트랩 캡처율에 지수적으로 영향 — `manual/sdevice/
17_Traps_and_Fixed_Charges.md` "Electron Capture Rate..." Eq. 545/546 근거).

## 결과 / 다음 액션

- [x] v4 실행(Extrapolate 제거 후 PGM이 실제로 진행됨) 결과 확인: `ConductionBandEnergy_
      AvePass1`이 WL_SEL discharge 구간(대략 t=3.3e-4~3.8e-4 부근)에서 급격히 위로
      튀는 것을 확인함(-0.85 부근에서 거의 0 근처까지). **이 시점에 WL_PASS는 여전히
      static 6V 그대로 유지 중**(t=4.0e-4까지 discharge 안 함) - 즉 WL_PASS 자신은
      전혀 방전하지 않고 있는데도 Pass1 위치 밴드가 크게 반응함.

## [2026-08-22] 판정 완료: (a) WL_SEL 유발 크로스토크로 확정

v4에서 WL_PASS를 WL_SEL discharge와 완전히 분리(WL_PASS는 flat 6V 유지, discharge는
그보다 6e-5초 뒤인 t=4.0e-4~4.1e-4에만 발생)해뒀는데도 Pass1 위치 밴드/트랩 반응이
WL_SEL 자신의 discharge 구간에 그대로 나타났다. 이는 `nand_pgm_EPEP` RUN 0003이
제기했던 (a) vs (b) 질문에 대해:

**(a) WL_SEL(=Target)의 급격한 전계 붕괴가 유발하는 인접 게이트 크로스토크가 맞다** —
Pass 게이트 자신의 동시 방전((b) 가설)은 원인이 아니다. WL_PASS가 방전하지 않는데도
같은 현상이 재현됐으므로 이 실험으로 최종 판정 가능.

물리적으로는 `R.TrapNi`가 WL_SEL과 WL_Pass1 아래로 하나로 이어진 연속 리전이라는
구조적 사실과 일치한다 — WL_SEL 아래에 급격히 형성/붕괴하는 전하·전계가 옆으로
이어진 질화막을 통해 Pass1 위치의 밴드에도 실제로 영향을 주는 것으로 보인다.

- [x] 판정 완료 - 이 파일과 `runs/nand_pgm_EPEP/0003_pass1_discharge_trap_runaway.md`
      양쪽에 (a) 확정으로 갱신함.

## [2026-08-22 추가] 별개 발견: Pass1 트랩이 discharge 크로스토크 이전에도 이미 상당함

v4의 `eTrappedCharge_IntegrPass1` vs `eTrappedCharge_IntegrSel` 시계열을 직접 비교한
결과, Pass1 트랩은 **WL_SEL이 20V로 올라가기도 전, WL_PASS가 6V에 도달하자마자 이미
거의 평평(포화)한 레벨**로 가 있음을 확인함 (그 뒤 discharge 구간에 소폭 더 튀는 것은
위에서 확정한 (a) 크로스토크). 즉 Pass1 트랩량의 대부분은 discharge 크로스토크가 아니라
**WL_PASS 자신의 6V 바이어스만으로 생기는 "pass-disturb"**로 보임 - 실제 칩에서도 알려진
현상이지만, 이 정도로 짧은 시간(수백 us)에 거의 포화까지 가는 건 6V가 이 ONO 두께
(Tox 5nm/CTN 5nm/BOX 7nm)에 과하게 센 값이거나, 트랩/PooleFrenkel 파라미터가 낮은
필드에도 과민하게 반응하는 것일 가능성이 있음.

## 결과 / 다음 액션 (추가)

- [ ] Vpass(SG/WL_PASS/DG)를 6V보다 낮춰서(예: 4V) 같은 진단을 재실행 - Pass1 베이스라인이
      비례해서 낮아지면 "필드 크기에 민감한 실제 현상", 거의 안 바뀌면 파라미터 이슈로 판단.

## [2026-08-22 추가] v6: WL_PASS에 PGM Rising Time 추가

사용자가 v6의 PGM 구간 전압 그래프(WL_PASS vs WL_SEL vs time)를 보고, WL_PASS가 PGM
Rising 시작 시점(t=3e-5)에 이미 6V로 켜진 채 그대로 유지되고 있어서(WL_SEL이 아직
낮은 전압일 때부터 Pass가 이미 다 켜진 상태로 노출) 이게 "Pass1 트랩이 처음부터 다
찬 것처럼 보이는" 원인일 수 있다고 지적함. `20260822_nand5gate_pgm_sdevice_v6.cmd`의
SG/WL_PASS/DG 파형을 수정: PGM 시작 전(t=3e-5) 일단 0V로 내렸다가, WL_SEL의 PGM
Rising과 동일한 100us(t=3e-5~1.3e-4) 동안 같이 0->6V로 rising하도록 변경(기존
nand_pgm_EPEP의 Pass 파형 관례와 동일). PGM Hold/Discharge/post 스윕 구간은 그대로
6V 유지해서, RUN 0002 위쪽에서 확정한 "WL_PASS는 WL_SEL discharge와 동시에 방전하지
않는다"는 격리 조건은 그대로 보존함.

- [ ] v6(WL_PASS rising time 추가판) 실행 후 Pass1 트랩 베이스라인이 이전보다 줄어드는지
      확인 - 줄어들면 "노출 시간"이 원인의 일부였다는 뜻, 안 줄어들면 여전히 필드
      크기(Vpass=6V 자체) 문제로 좁혀짐.

## [2026-08-22 추가] 문헌 확인: "z-interference"/"neighboring WL program disturb"로 알려진 실제 현상

웹 검색 결과, 인접 워드라인의 높은 프로그램 전압이 만드는 fringing field가 옆 셀의
charge trap layer로 전자를 주입하고, SiN층에 갇힌 전하가 그 층을 따라 실제로
마이그레이션(migrate)한다는 것이 3D NAND 업계에서 **"z-interference"** 또는
**"neighboring word line program disturb"**라는 이름으로 이미 연구된 현상임을 확인함.
즉 이 프로젝트에서 관찰한 WL_SEL -> Pass1 크로스토크는 시뮬레이션 버그가 아니라
실측 근거가 있는 실제 물리에 해당함.

문헌에 나온 완화 기법 2가지:
1. **인접 워드라인 사이 airgap** - 물리적 구조 변경(현재 구조에는 없음, 향후 별도
   실험 주제).
2. **인접 셀 pass voltage를 낮춰서 트랩 전자 밀도 감소** - 지금 진행 중인 Vpass
   민감도 테스트(위 항목)와 정확히 일치.

우리 구조가 이 두 완화책을 전혀 적용하지 않은 단순화된 형태라서, 크로스토크가 실제
양산 칩보다 두드러지게 보이는 것으로 판단됨 - "버그를 고친다"기보다 "완화되지 않은
단순 구조의 예상된 결과"로 해석하는 것이 맞음.

Sources:
- [Neighboring word line program disturb countermeasure for charge-trapping memory](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/9552251)
- [A Novel Program Scheme for Z-Interference Improvement in 3D NAND Flash Memory](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10144150/)
- [Study of pass-gate voltage (VPASS) interference in sub-30nm charge-trapping (CT) NAND flash devices](https://www.researchgate.net/publication/238520787_Study_of_pass-gate_voltage_V_PASS_interference_in_sub-30nm_charge-trapping_CT_NAND_flash_devices)

## [2026-08-22 추가] eTrappedCharge(Integrate) 단위 확인 실패 + post-PGM Id-Vgs에 "어깨(shoulder)" 관찰

사용자가 v6 결과의 eTrappedCharge_IntegrPass1/IntegrSel 값을 직접 읽어보니(discharge
직전 baseline ~10^17.5, discharge 후 ~10^21.8, Sel은 계속 ~10^22.1) 이전에 필자가
`IntegrationUnit=um` 가정으로 계산한 이론적 최댓값(5×10^15, um²·cm⁻³ 가정)과 자릿수가
전혀 안 맞음이 확인됨 - **이전 턴의 "0.0002%" 계산은 틀렸던 것으로 정정**. `Integrate`가
`Cylindrical` 모드에서 정확히 어떤 단위/부피 관례를 쓰는지 매뉴얼만으로는 확정할 수
없었음.

이를 우회하기 위해 `20260822_nand5gate_pgm_sdevice_v7.cmd`에 `eTrappedCharge(
Average(...))`를 Sel/Pass1 Window에 추가함 - `Average`는 항상 밀도(cm⁻³)라서 우리가
직접 지정한 트랩 총 농도(4×10^19 cm⁻³)로 나누면 적분 단위 문제와 무관하게 정확한
점유율(%)을 구할 수 있음.

**추가 관찰**: post-PGM Id-Vgs 커브(WL_SEL 스윕)에서 Vgs≈2~3V 부근에 "어깨" 모양의
정체 구간이 나타남 (pre-PGM 커브에는 없음). SG/WL_PASS/DG 자신도 disturb로 자체 Vt가
살짝 올라가 있다면, 6V read 바이어스에서의 오버드라이브가 줄어 SL-BL 직렬 경로에서
병목이 될 수 있다는 가설 - Pass1 disturb 크기가 확인되면 이 어깨 현상의 타당성도
같이 판단 가능.

## 결과 / 다음 액션 (추가)

- [ ] v7 실행 후 `eTrappedCharge_AveSel`/`AvePass1`을 4e19로 나눠 실제 점유율(%) 확인
- [ ] 그 점유율이 현실적인 수준인지(과도하게 크지 않은지) 판단
- [ ] post-PGM Id-Vgs의 어깨 현상이 Pass1 disturb 크기와 상관관계가 있는지 확인

## [2026-08-22 추가] discharge를 300us로 늘려 rate-dependence 검증 (v7에 통합)

사용자가 "discharge 구간에 Pass1이 트랩되는 원인부터 먼저 해결하자"고 우선순위를 정함.
가장 직접적인 검증: 처음엔 별도 v8로 만들었으나, 사용자 요청으로 v7 하나로 통합함 -
`20260822_nand5gate_pgm_sdevice_v7.cmd`에 eTrappedCharge(Average) 점유율 진단과
discharge 연장이 함께 들어있음. PGM Discharge 시간을 50us -> **300us(6배)**로 늘림
(WL_SEL 20V->0V 하강 시간만 늘리고, 나머지 파형/물리는 그대로 - post-PGM 스윕 등
이후 구간은 전부 +2.5e-4 밀림). discharge 중간 지점 스냅샷(`06b_Discharging_Mid`,
t=4.8e-4)도 추가해서 300us 동안의 진행 추이를 볼 수 있게 함.

**해석 기준**: discharge를 6배 늘렸을 때
- Pass1의 discharge-jump 크기가 비례해서 작아지면 -> 빠른 dV/dt(전계 붕괴 속도)에
  비례하는 rate-dependent 현상 -> 실제 칩처럼 discharge를 더 천천히 하거나(또는
  수치적으로 더 안정적인 스텝을 쓰거나) 하는 방향으로 완화 가능.
- 거의 안 줄어들면 -> discharge 속도와 무관하게 "WL_SEL이 결국 0V로 돌아간다"는
  전위차 자체가 원인 -> 트랩 파라미터(cross-section 등) 재검토나 구조적 격리
  (다음 우선순위)로 넘어가야 함.

- [x] v7 실행 결과: discharge를 300us로 늘려도 Pass1 최종 포화 레벨은 50us 때와
      동일 -> **rate-dependence 가설 기각.** discharge 속도는 원인이 아님.
- [x] v7의 eTrappedCharge_AveSel/AvePass1 실측값으로 점유율 계산 (최초 계산):
      Sel=2.5e19/4e19=62.5%, Pass1=7.36e18/4e19=18.4% - **이후 정정됨, 아래 참고**.

### [2026-08-22 정정] eTrappedCharge의 100% 포화 기준값은 Acceptor Conc만(4e19 아님)

사용자가 "Acceptor Conc(2.5e19)로만 계산되는 거 아니냐"고 지적 - 확인 결과 맞았음.
`manual/sdevice/17_Traps_and_Fixed_Charges.md` 1195/1197번째 줄: `eTrappedCharge`는
`eNeutral`+`Acceptor` 트랩만의 전자 점유를 집계하고 Donor는 `hTrappedCharge` 쪽으로
잡힘(Donor의 "채워짐=중성" 상태는 순전하 0이라 eTrappedCharge에 기여 안 함).
`knowledge/PITFALLS.md` [2026-08-22] 항목에 기록함.

**정정된 점유율**: Max = Acceptor Conc만 = 2.5e19.
- Sel: 2.5e19/2.5e19 = **100%** (완전 포화)
- Pass1: 7.36e18/2.5e19 = **29.4%**

Pass1/Sel 비율(약 29%, 분모가 뭐든 동일하게 나옴)이라는 핵심 결론은 안 바뀌지만,
Sel 자체는 62.5%가 아니라 **100% 포화**였다는 게 정확한 해석. 100%면 이미 최대치라서
포획 단면적을 더 낮춰도(v8: 1e-15/1e-15) Sel 신호가 크게 줄어들 여지(headroom)가
있다는 뜻이기도 함.

## [2026-08-22 추가] v8: 포획 단면적을 보수적인 대칭값(1e-15/1e-15)으로 낮춤 + discharge 원복

Rate-dependence가 기각됐으므로 다음 용의선은 트랩 포획 단면적(eXSection/hXSection)
자체. 기존 nand_pgm_EPEP RUN 0006 값(Donor 1e-12/1e-13, Acceptor 1e-13/1e-12)은
쿨롱 인력이 강한 특정 결함 모델에 맞춘 비대칭값인데, 사용자가 다른 문헌 예시에서 본
훨씬 보수적인 대칭값(중성 트랩 범위, ~1e-14~1e-16 cm²)인 **1e-15/1e-15**로 Donor/
Acceptor 둘 다 통일해서 `20260822_nand5gate_pgm_sdevice_v8.cmd`를 작성함. discharge도
v7의 300us(검증 완료, 더 이상 필요 없음)에서 원래 값인 **50us로 복귀**(실제 칩
discharge는 30us도 안 걸리는 게 보통이라, 비현실적으로 늘렸던 값을 유지할 이유 없음).

**해석 기준**: 단면적을 4자릿수 가까이 낮췄을 때
- Pass1 점유율이 크게 줄고 Sel은 여전히 쓸 만한 수준(수십 % 대)을 유지하면 -> 단면적이
  원인이었다는 게 확정, 이 값을 새 기준으로 채택.
- Sel도 같이 너무 낮아지면(예: 한 자릿수 %) -> PGM 펄스를 더 세게/길게 보완하는 방향
  검토 필요.

- [x] v8 실행 후 점유율 재확인: **Sel 100%(불변) / Pass1 28.5%(v7의 29.4%에서 거의
      불변)** - 단면적 1000배 낮췄는데도 결과가 거의 안 바뀜. 300us hold가 단면적과
      무관하게 평형 점유율까지 도달할 만큼 충분히 길어서, 단면적 튜닝 자체가
      틀린 지렛대였던 것으로 결론.
- [x] eBarrierTunneling이 eTrappedCharge_AvePass1과 같은 시점(WL_SEL≈11.2V)에 같이
      튀는 것 확인 - FN/WKB 터널링의 정상적인 비선형 turn-on, 버그 아님.

## [2026-08-22 추가] 웹 문헌: "채널 전위 변화"가 인접 WL disturb의 intrinsic cause

웹 검색 결과, 3D NAND TCAD 연구에서 인접 워드라인 disturb의 근본 원인을 **"channel
potential changes under victim cells"**(피해 셀 아래 채널의 전위 변화)로 지목함 -
CTN(질화막)을 통한 횡방향 확산이 아니라, **하나로 이어진 채널(PolySi)을 통해 전위
요동이 전파되는 것**이 핵심 메커니즘이라는 것.

Sources:
- [Enhanced programming efficiency in vertical NAND flash using self-boosting hot carrier injection](https://www.nature.com/articles/s41598-025-19858-y)
- [Adaptive Bitline Voltage Countermeasure for Neighbor Wordline Interference in 3D NAND Flash Memory-Based Sensors](https://pmc.ncbi.nlm.nih.gov/articles/PMC10051062/)
- [Compact Modeling of Trap-Assisted Tunneling Current in 3-D NAND Flash Memory](https://www.researchgate.net/publication/389162636_Compact_Modeling_of_Trap-Assisted_Tunneling_Current_in_3-D_nand_Flash_Memory)

**사용자가 06(hold)/07(discharge 후) Potential 스냅샷을 직접 비교**해서 이를 눈으로
확인함: discharge 순간 채널 코어(X~0)에서부터 음전위(~-2V)로 오버슈트되는 "깔때기"
모양이 WL_SEL 위치를 중심으로 옆으로 퍼지는 게 보임 - 20V hold 동안 축적됐던 채널
전하가 게이트 급강하 시 재분배되며 생기는 과도 현상으로 추정.

**사용자 가설**: 이 채널 전위 하강이 (그동안 6V로 고정해뒀던) WL_PASS까지 전파되면,
Channel-WL_PASS 전위차가 순간적으로 (예: 6-(-2)=8V로) 벌어져서 Pass1 터널링을
유발한다는 것 - 물리적으로 타당함.

## [2026-08-22 추가] v9: 채널 전위 정량 진단 + 완화 실험(WL_PASS도 같이 discharge)

`20260822_nand5gate_pgm_sdevice_v9.cmd` 작성:
1. `Potential(Average(Material="PolySi" Window=...))`를 Sel/Pass1 **채널** 위치에
   추가 - discharge 순간 Pass1 채널 전위가 실제로 얼마나 떨어지는지, 그 타이밍이
   eTrappedCharge_AvePass1 점프와 일치하는지 정량 확인.
2. **완화 실험**: 기존(v6~v8)에는 원인 격리를 위해 SG/WL_PASS/DG를 discharge 구간
   내내 6V로 고정해뒀었음(RUN 0002/0003에서 (a) Sel 유발 확정에 사용) - 원인이 이미
   확정됐으므로 격리를 풀고, **SG/WL_PASS/DG를 WL_SEL과 같은 타이밍에 같이
   discharge**시킴(실제 칩처럼 미선택 WL도 결국 비슷한 시점에 꺼지는 상황과 유사).
   Channel-WL_PASS 전위차 스파이크가 줄어 Pass1 disturb가 완화되는지 확인. post-PGM
   Id-Vgs 스윕을 위해 discharge 직후 다시 6V로 재인가.

**해석 기준**: v9의 Pass1 disturb(점유율)가 v8(28.5%) 대비 줄어들면 -> 완화 성공,
Channel-WL 전위차가 핵심 메커니즘이었다는 것 확정. 안 줄어들면 -> 다른 메커니즘
(순수 CTN 횡방향 확산 등) 재검토 필요.

- [x] v9 실행 결과: Pass1 점유율 = 6.71e18/2.5e19 = **26.8%** (v8의 28.5% 대비 약간
      감소, 상대 6%). Channel-WL_PASS 전위차를 8V->2V로 줄였는데 개선이 미미함.
- [x] v9의 Potential_SelChannel/Pass1Channel 그래프 확인: hold 구간에는 거의 같이
      평평(0.7V 부근)하다가 discharge 순간 둘 다 거의 동시에 -2V까지 오버슈트 -
      채널이 하나로 이어진 도체라 Sel/Pass1 위치 구분 없이 거의 균일하게 흔들림
      확인.
- [x] **[정정, 중요] Pass1 hold 구간 baseline 재확인**: 사용자가 hold 구간
      `eTrappedCharge_AvePass1` 값을 직접 읽어보니 **8.85e11** (2.5e19 대비
      0.0000035%, 사실상 0). 최종값(6.71e18, 26.8%)과 비교하면 discharge 한 번에
      약 760만 배 증가 - **Pass1 disturb의 사실상 전부가 discharge 이벤트 자체에서
      나옴**. 이전 턴(이 파일 상단)에서 "baseline(Vpass=6V 자체)이 dominant
      contributor"라고 결론 내렸던 건 **로그축 그래프를 눈대중으로 읽은 오독**이었음
      (앞서 eTrappedCharge_IntegrSel을 ~1e22로 오독했던 것과 동일 패턴) - 정정함.
      Vpass 크기를 낮추는 실험은 이제 근거가 약해져서 보류.

## [2026-08-22 추가] v10: SG/DG를 discharge시키지 않고 채널-SL/BL 통로를 열어둠

Channel-WL_PASS 전위차를 크게 줄였는데도(v9) 개선이 6%뿐이었던 이유를 재검토:
**SG(SL쪽)/DG(BL쪽) select gate까지 WL_PASS와 함께 discharge시킨 게 역효과**였을
가능성. SG/DG는 채널을 SL/BL(0V 고정)에 연결하는 통로인데, 채널이 가장 흔들리는
순간(discharge)에 이 통로 자체를 닫아버리면 SL/BL의 "붙잡는 힘"이 채널 중간까지
전달되지 못함.

`20260822_nand5gate_pgm_sdevice_v10.cmd`: WL_PASS는 v9처럼 계속 discharge, **SG/DG만
discharge 없이 6V로 계속 켜둠**(v8 방식으로 되돌림)으로써 채널-SL/BL 통로를 discharge
내내 열어둠. Potential_SelChannel/Pass1Channel 진단도 유지해서 오버슈트가 실제로
줄어드는지 확인.

**해석 기준**: v10의 discharge 순간 채널 Potential 오버슈트(-2V)가 v9보다 작아지고,
Pass1 점유율도 v9(26.8%)보다 확실히 줄어들면 -> "SG/DG로 채널을 붙잡는 것"이 유효한
완화 방법으로 확정.

- [ ] v10 실행 후 Potential 오버슈트 크기와 Pass1 점유율을 v9와 비교
