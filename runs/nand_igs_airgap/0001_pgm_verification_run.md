# RUN 0001 — NAND_AIR PGM 검증런 성공: 선택 셀 18.9% 포획, 크로스토크 1/985

- **날짜**: 2026-11-03 (실행 시작 2026-10-27)
- **사용된 커맨드 파일**: `NAND_AIR/NAND_AIR_pgm.cmd` (구조: `NAND_AIR/NAND_AIR.scm`)
- **목적/의도**: 새로 만든 평면 NAND 구조(Air Gap 버전)에서 PGM이 실제로 동작하는지,
  단일 펄스(WL2 18V) 1회 + 전후 read로 짧게 확인. ISPP/Erase 없음.
- **상태**: **성공** (NAND_AIR 완료 / NAND_BASE 재실행 중)

## 배경

`nand_pgm_erase_base` 실험의 기준 커맨드(`pecycle_A-ispp-gidl-erase_v5_20261018.txt`)는
원통형(macaroni) 5게이트 구조용이라 이 실험의 평면 구조에 그대로 못 쓴다.
Physics / Traps / Math / 전극 파형 패턴은 그대로 가져오고, 구조 의존적인 부분만 교체했다:

1. `Math`에서 `Cylindrical(xAxis=0.0)` **제거** (평면 2D)
2. 전극 매핑: SL→Source, BL→Drain, SG/DG→SSL/DSL, WL_PASS→WL1/WL3, WL_SEL→WL2
3. `NonLocal "NL_Tox"` 계면을 `region_N_b0/region_N_b1` (N=1~11) 11줄로 교체
4. `CurrentPlot`을 좌표 Window 대신 `Region=`으로 지정
5. Al2O3(Insulator1) 없음
6. 출력 파일명에서 `n@node@` 제거 (터미널 직접 실행)
7. ISPP 15계단 → 단일 펄스 1회

파라미터 파일은 `models_jh.par` 그대로. 기준 커맨드의 `20261017_models_v3.par`와
Oxide/Nitride/PolySi/Tungsten 섹션이 동일함을 diff로 확인했고, 차이는 SiC_4H·SiC_6H
(jh쪽)와 Insulator1=Al2O3(v3쪽)뿐인데 이 구조는 Al2O3를 쓰지 않는다.

## 관찰된 현상

### 1. PGM 펄스 구간 (`NAND_AIR_pgm_pulse_*.plt`, 33~58us)

선택 셀 WL2 아래 질화막(`region_17`)의 `eTrappedCharge` (251행 전 구간 확보):

| t (us) | WL2 (V) | Sel eTrappedCharge (cm^-3) | 점유율 |
|---|---|---|---|
| 33.0 | 0 | 1.66e16 | 0.02% |
| 35.4 | 17.3 | 1.32e18 | 1.32% |
| 36.6 | 18 | 8.46e18 | 8.43% |
| 39.0 | 18 | 1.29e19 | 12.86% |
| 43.8 | 18 | 1.65e19 | 16.46% |
| 49.8 | 18 | 1.88e19 | 18.72% |
| **50.7** | 하강 시작 | **1.8983e19** | **18.93% (최대)** |
| 53.4 | 0 | 1.8968e19 | 18.91% |
| 58.0 | 0 | 1.8963e19 | 18.91% (최종) |

읽어낼 수 있는 것:

1. **아직 포화 전이다.** 18V 도달 직후 8.4%까지 치솟은 뒤, 13us 유지 동안 18.7%로
   두 배가 더 올랐다. 곡선이 평평해지지 않았으므로 펄스를 늘리거나 전압을 올리면
   더 들어간다 — ISPP 확장 여지가 충분하다.
2. **방전 중 전하 손실이 거의 없다.** 최대 18.93% → 최종 18.91%로 0.02%p만 빠졌다.
   게이트 쪽 back-tunneling(NL_Box)을 넣지 않은 구성인데도 역류가 없다
   → 기준 커맨드가 NL_Box를 생략한 판단이 이 구조에서도 유효.
3. `eBarrierTunneling` 적분값: 17.3V에서 음의 피크(채널→질화막 주입 방향),
   유지 구간 동안 약 25배 감소(트랩이 차며 전계 약화), 방전 후 거의 0.
   (이 양의 정확한 단위는 매뉴얼에서 확인하지 않았으므로 부호와 상대 크기만 해석함)

### 2. PGM 후 read 구간 (`NAND_AIR_pgm_s1vt_*.plt`, 58~4812us) — 478행 완전

- `Sel eTrappedCharge = 1.8963e19 cm^-3` 이 **read 내내 완전히 고정**
  → `Set(Traps(Frozen))`이 의도대로 작동. read가 트랩 상태를 바꾸지 않았다.
- 점유율: 1.8963e19 / Tacc 총밀도 1.003e20 = **18.9%**
  (eTrappedCharge는 Acceptor+eNeutral만 집계하므로 분모는 Tacc만 — PITFALLS 2026-08-22)
- `Sel hTrappedCharge = 7.1124e18` → Tdon 6.267e19 대비 11.3%

Id-Vg (Drain TotalCurrent vs WL2), 초기 read(`s0vt`, 461행)와 비교:

| 기준 전류 (A/um) | 초기 Vt (S0) | PGM 후 Vt (S1) | **ΔVt** |
|---|---|---|---|
| 1e-9 | -4.084 | -0.792 | **+3.292** |
| 1e-8 | -3.896 | -0.574 | **+3.322** |
| 1e-7 | **-3.697** | **-0.347** | **+3.350** |
| 1e-6 | -3.484 | -0.100 | **+3.384** |

**ΔVt ≈ +3.35 V**. 네 기준에서 3.29~3.38로 거의 일치 → 곡선이 모양 변화 없이
**평행이동**했다는 뜻(전하가 고르게 잡혔고 계면 열화 등 부작용 없음).

서브스레숄드 스윙 약 260 mV/dec (-1.03V 2.18e-10 → -0.43V 4.34e-8).

초기 `Sel eTrappedCharge = 1.6644e16 (0.017%)` — `Set(Traps("Tacc"=0.0))` 가 그대로 반영됨.

### 기준 구조와의 교차 검증

| | 기준 구조 (원통형, Al2O3 있음) | 이 실험 AIR (평면) |
|---|---|---|
| 초기 Vt | **-4.00 V** | **-4.08 V** (@1e-9) / -3.70 (@1e-7) |
| PGM 후 | +5.60 V (ISPP 15계단 15→22V) | -0.35 V (단일 펄스 18V 1회) |

`Set(Traps("Tdon"=0.139))` 하나로 기준 구조와 거의 같은 소거 상태가 재현됐다.
구조가 꽤 다른데도(평면 vs 원통, 질화막 4nm vs 5nm, Al2O3 없음) 초기점이 맞은 것은
이 값이 트랩 전하량에 지배되기 때문. 물리 이식이 제대로 됐다는 근거.
ΔVt는 기준 +9.6V(15계단) vs 우리 +3.35V(1펄스)로 비율상 타당.

### 3. 크로스토크 — 설계 의도대로 억제됨

펄스 끝(t=58us) 시점:

| 영역 | eTrappedCharge (cm^-3) | Sel 대비 |
|---|---|---|
| Sel (WL2, region_17) | 1.896e19 | 1 |
| Pass_WL3 (region_15) | 1.626e16 | **1/1166** |
| Pass_WL1 (region_19) | 1.625e16 | 1/1167 |
| DSL (region_13) | 1.656e16 | 1/1145 |
| SSL (region_21) | 1.653e16 | 1/1147 |

(t=43us 중간 시점에는 1/985였다. 선택 셀은 계속 차는데 이웃은 멈춰 있어 비율이 벌어진 것)

이웃 셀·선택 게이트는 초기값에서 거의 움직이지 않았다(미세하게 감소).
기준 커맨드의 두 가지 설계 — (a) WL_PASS를 WL_SEL과 같은 기울기로 올리고 같은 시각에
방전, (b) PGM 중 SG/DG를 6V가 아닌 1.9V로 유지 — 가 이 구조에서도 그대로 유효했다.
기준 커맨드의 검증값("Pass1이 Sel 대비 1/1000, 2e16 vs 4e19")과 같은 수준이다.

## 원인 분석 / 해석

문제가 아니라 정상 동작이므로 원인 분석은 불필요. 다만 확인된 것:

- **region 이름 기반 지정이 전부 맞았다.** `NonLocal`의 `region_N_b0/region_N_b1` 11개
  계면과 `CurrentPlot`의 `Region="region_17"` 등이 에러 없이 인식됐다. GUI가 자동
  생성한 region 이름(`.sat`의 `region` 속성에서 읽어낸 것)을 그대로 쓸 수 있다.
- **Cylindrical 제거가 맞았다.** 평면 구조에서 기준 커맨드의 `Cylindrical(xAxis=0.0)`을
  그대로 뒀다면 x를 반지름으로 해석해 전혀 다른 소자가 됐을 것이다.
- **시간 스텝 우려는 기우였다.** 실행 초반 `Stepsize: 1.6e-11`로 시작해 걱정했으나
  (0~10us 구간에 62만 스텝이 필요한 속도), 실제로는 스텝이 정상적으로 커져 완주했다.

## 운영상 교훈 (문법 오류 아님 — PITFALLS 대상 아님)

1. **`nohup` 없이 돌린 런은 원격 세션이 끊기면 같이 죽는다.** NAND_BASE는
   `sdevice NAND_BASE_pgm.cmd`로, NAND_AIR는 `nohup sdevice ... &`로 돌렸는데,
   Xmanager 연결이 끊긴 뒤 NAND_AIR만 살아남아 완주했다. 긴 런은 반드시 nohup.
2. **리눅스→윈도우 클립보드 복사는 큰 파일에서 조용히 잘린다.** 1455행 .plt를 한 번에
   복사하면 0바이트 또는 부분 파일이 된다(과거 `NAND_BASE.sat`이 962바이트 빈 파일로
   들어왔던 것도 같은 원인). 나눠서 복사하면 되지만, 윈도우에 OpenSSH가 있으므로
   `scp chenjae8@ngsd:<경로> <윈도우경로>` 가 정답.
3. 라이선스 feature 이름은 `sdevice`가 아니라 **`sdevice_all`** (11개). `lmstat -f sdevice`로는
   조회되지 않는다. 우리 커맨드는 `sdevice_all` 외에 `sdevice-traps_all`,
   `sdevicemonosemicond_all`, `sdevice-parallel_all`(Number_of_Threads=4)도 함께 점유한다.

## 결과 / 다음 액션

- [x] NAND_AIR PGM 검증런 완료 — PGM 동작 확인
- [ ] **NAND_BASE 재실행 중** (2026-11-03 `nohup`으로 재시작). 완료되면 동일 항목 추출
- [ ] `NAND_AIR_pgm_s0vt_*.plt`(초기 read) 확보 → ΔVt 계산
      (현재는 PGM 후 Vt만 있어 PGM으로 몇 V 이동했는지 모름)
- [ ] BASE vs AIR 비교 — 이번 실험의 본 목적
      - 같은 18V 펄스에서 포획량 차이
      - Vt 차이
      - Air Gap(ε=1)이 IGS 산화막(ε=3.9) 대비 이웃 WL 간섭을 얼마나 줄이는지

### 비교 시 주의

BASE와 AIR는 `.cmd`가 파일 이름 외에 글자 하나까지 동일하고(diff로 검증),
메시 refinement도 AirGap을 Oxide/Si3N4와 같은 등급(Max 0.5nm/Min 0.1nm)으로 묶어
놓았으므로, 두 결과의 차이는 Air Gap 유무에서만 온다고 볼 수 있다.
