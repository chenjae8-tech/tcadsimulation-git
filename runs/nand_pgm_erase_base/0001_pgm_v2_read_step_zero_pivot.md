# RUN 0001 — PGM v2: 펄스는 정상 완료, 뒤에 붙인 Read/Id-Vgs 검증 단계에서 zero-pivot 발산

- **날짜**: 2026-08-22
- **사용된 커맨드 파일**: `commands/nand_pgm_erase_base/20260821_nand5gate_pgm_sdevice_v2.cmd`
  (구조: `commands/nand_pgm_erase_base/20260821_nand5gate_sde_v1.scm`)
- **목적/의도**: WL_SEL PGM 펄스(0→20V rising-hold-discharge)가 정상 동작하는지, 그리고
  뒤에 추가한 Read(SG/WL_PASS/DG pass 전압 + BL read 전압 인가 → WL_SEL Id-Vgs 스윕)
  단계로 Vt 이동을 확인할 수 있는지 검증.
- **상태**: 부분 성공 — PGM 펄스 자체(Transient, discharge까지)는 정상 완료. 그 뒤에
  붙인 Read 단계의 `Quasistationary` 두 개가 모두 완전히 발산(수렴 실패)함.

## 사용자가 제공한 로그/에러 파일

- `commands/nand_pgm_erase_base/log/n2_v2_des.log`
- `commands/nand_pgm_erase_base/log/n2_des.err`

## 관찰된 현상

1. `.err` 파일: `datexcodes.txt`의 재질(Nitride/Si3N4, Oxide/SiO2, PolySi/PolySilicon)이
   "redefined"라는 정보성 경고가 3번 반복(파일이 여러 번 읽힌 것으로 보임, 에러 아님),
   `'TrapFilling=Empty' is deprecated` 경고(기능에는 영향 없음), 그리고
   **`Supernodal had problems (zero pivot) !`가 8번 반복**.
2. `.log` 파일: PGM `Transient`는 `t=3.5e-4`(discharge)까지 각 스텝이 4번 이내 Newton
   반복으로 정상 수렴했고, `n2_v2_05_Discharged_des.tdr`까지 정상 저장됨 (16110~16162줄).
3. 그다음 Read 단계 첫 번째 `Quasistationary`(`Goal{BL=0.5V, DG=6V, WL_PASS=6V, SG=6V}`,
   `Set(TrapFilling=Frozen)` 직후)가 시작되자마자(16192~16368줄), 매 시도마다 Newton
   1번째 반복에서 `Supernodal had problems (zero pivot)` → `Linear system cannot be
   solved.` → 스텝 절반으로 줄여 재시도. `InitialStep=0.02`에서 시작해 `0.02 → 0.01 →
   0.005 → 0.0025 → 0.00125 → 0.000625 → 0.0003125 → 0.00015625`까지 **8번 모두
   동일하게 zero pivot으로 실패**하고, `MinStep=1e-4` 아래로 떨어져
   `Step-size less than MinStep`로 해당 `Quasistationary` 전체가 포기됨(16367~16368줄).
4. 두 번째 `Quasistationary`(`Goal{WL_SEL=6V}`, 16384~16428줄)도 `t=0`(DoZero) 지점에서
   동일한 `Supernodal zero pivot`으로 즉시 실패(`Solve for t=0 does not converge.`).
5. 그럼에도 이후 `Plot(FilePrefix="n2_v2_10_ReadBias_On")`, `Plot(FilePrefix=
   "n2_v2_11_IdVg_End")`는 (수렴 안 된 채로) 그냥 실행돼 `.tdr`가 저장됐다 — **이 두
   스냅샷은 유효한 해가 아니므로 Id-Vgs 분석에 쓰면 안 됨**.
6. 실패 중 한 번(16347~16352줄) 자동 출력된 `C-norm_equation max_error` 진단에서 최대
   오차 위치가: Poisson은 `(0.0225, 0.0230)`(SG/SL접합 경계 y1=0.020 부근 모서리),
   hole은 `(0.033, 0.1225)`(x2=Channel/TunnelOx 경계, WL_SEL 채널 한복판) 근처로 찍힘 —
   재질 경계 모서리/WL_SEL 계면 쪽에 오차가 집중.

## 원인 분석 (가설 — 확정 아님)

- PGM `Transient` 구간은 끝까지 정상 수렴했으므로, **트랩/도핑/구조 자체의 물리적 오류는
  아닐 가능성이 큼**. 문제는 그 뒤에 새로 추가한 `Quasistationary` Read 단계에서만
  발생함.
- `Method`를 지정하지 않으면 기본 direct solver(`Supernodal`/`Super` 계열)가 쓰이는데,
  이번 실패는 스텝 크기를 `MinStep` 아래까지 8단계나 줄여도 **매번 똑같이** zero pivot이
  나서, "스텝이 너무 커서" 못 푸는 것이 아니라 **그 시점의 Jacobian 자체가 이 solver의
  분해(factorization) 방식과 구조적으로 안 맞는 것**으로 보인다 (근거:
  `manual/sdevice/05_Simulation_Results.md` "Linear Solvers" 섹션 — `Method`가 direct
  solver 종류를 결정하며, `PARDISO`이 대안으로 명시돼 있음).
- 이 프로젝트의 `nand_erase_GIDL-HCI`/`nand_pgm_EPEP` 최신 버전들은 모두 `Math`에
  `Method=Pardiso`를 명시해서 쓰고 있는데, 이번 PGM v2의 `Math`에는 `Method`가
  누락되어 있었다 (Erase v2에는 이미 `Method=Pardiso`가 들어가 있음) — 즉 이 프로젝트
  전체에서 유일하게 이 PGM cmd만 기본 solver를 쓰고 있었다는 뜻.
- `Set(TrapFilling=Frozen)`이나 4개 전극(SG/WL_PASS/DG/BL)을 동시에 ramp하는 것 자체가
  근본 원인일 가능성도 배제할 수는 없지만, 스텝을 극단적으로 줄여도 실패가 반복된
  정황상 solver 선택 쪽이 1차 용의선.

## 적용한 수정

`commands/nand_pgm_erase_base/20260822_nand5gate_pgm_sdevice_v3.cmd` 작성:
1. `Math`에 `Method=Pardiso`, `-CheckUndefinedModels`, `Extrapolate`, `Derivatives`,
   `RelErrControl` 추가 (Erase v2에서 이미 쓰고 있던 강건성 옵션 세트와 통일).
2. PGM 펄스(Transient) 자체는 변경 없음 — 이미 정상 동작했으므로 그대로 유지.
3. Read 단계 구조는 유지하되, 이번 수정으로도 재발하면 다음으로 시도할 것:
   (a) 4개 전극 동시 ramp를 SG/WL_PASS/DG 먼저 → BL 별도로 순차 분리,
   (b) `n2_v2_des_min_des.tdr`(발산 직전 상태, 이미 로그에 저장돼 있음)를 SVisual로
   열어서 실제로 어느 vertex/영역에서 physically 이상한 값(예: 국소적으로 튀는 캐리어
   농도)이 있는지 직접 확인.

## 결과 / 다음 액션

v3 실행 결과 대기. Pardiso로도 동일하게 발산하면, 위 "다음 시도" 항목(전극 순차 ramp
분리, min-state 파일 직접 검사)으로 넘어갈 것.

### [2026-08-22 추가] v3 재설계 - Quasistationary/Goal을 아예 제거

사용자가 다른 곳(구조가 다른 3WL+SSL/DSL NAND, Source/Drain/SSL/DSL/WL1~3 명명)에서
쓰던 pre-PGM/post-PGM IDVG 커맨드 2개를 참고자료로 제공. 그 커맨드는 Vgs 스윕을
Quasistationary+Goal이 아니라 **스윕 게이트(WL2) 자체에 Voltage=(-4 at 0, 7 at 10e-6)
파형을 직접 걸어 Transient 안에서 그리는 방식**이었음 - 우리가 zero-pivot으로 발산한
Quasistationary+Goal 자체를 아예 쓰지 않는 구조.

`20260822_nand5gate_pgm_sdevice_v3.cmd`를 이 방식으로 전면 재작성함:
- pre-PGM Id-Vgs 스윕 -> PGM 펄스 -> post-PGM Id-Vgs 스윕을 **하나의 연속된 시간축**
  위에서 전극 파형(Voltage=(...))만으로 이어붙임 (Quasistationary/Goal 완전히 제거).
- `Set(TrapFilling=empty)`(pre-PGM 스윕 동안 유지) -> `Unset`(PGM 펄스) ->
  `Set(TrapFilling=Frozen)`(post-PGM 스윕)로 트랩 상태 제어.
- 세 구간을 `NewCurrentPrefix`(manual/sdevice/05_Simulation_Results.md "NewCurrentPrefix
  Statement")로 나눠서 `.plt`를 분리 - 사용자가 준 참고 커맨드는 `NewCurrentFile=`을
  썼는데, manual 전체 검색 결과 이 키워드는 Ch36(Kinetic Monte Carlo/MIM Transport)
  예제에만 등장하고 일반 Solve 레퍼런스(Ch05/Ch40 등 5개 챕터)는 전부
  `NewCurrentPrefix`만 문서화하고 있어 `NewCurrentPrefix`로 대체함.
- `Physics(Material="PolySi")`에 `Mobility(DopingDependence)` 추가 (참고 커맨드에서
  채택 - `model_parameter/README.md` 확인 결과 `models_jh.par`가 PolySi 기본
  DopingDependence 파라미터를 보존 중이라 안전).
- 참고 커맨드의 `FromConductionBand`(대문자, 존재하지 않는 키워드 - 위
  `knowledge/PITFALLS.md` [2026-08-18] 항목과 동일한 실수)와 옵션 없는 `PooleFrenkel`
  ([2026-08-17] 항목)은 **채택하지 않음** - 이미 우리 트랩 값은 올바른 키워드를 씀.
- `Method=Pardiso` + 강건성 옵션은 그대로 유지(belt-and-suspenders).

Method=Pardiso가 원인이었는지, 애초에 Quasistationary+Goal 자체가 문제였는지는 이번
재설계로는 더 이상 구분할 수 없게 됐지만(Quasistationary를 아예 안 쓰므로), 실용적으로는
문제 재발 위험이 가장 낮은 구조로 판단해 이 방향으로 확정. 실행 결과 대기.

### [2026-08-22 추가] v3 실행 결과: zero-pivot은 해결됐으나 새로운 발산(Extrapolate 의심) 발견

v3 실행 로그(`runs/nand_pgm_erase_base/log/n2_v3_des.log`) 확인 결과:

- **WL_PASS는 문제 없음**: 로그의 매 스텝 "contact voltage" 표에서 PGM Transient
  내내 `WL_PASS 6.000E+00`으로 정상 인가돼 있었음. 사용자가 Inspect에서 본 "WL_PASS가
  0으로 평평한" 그래프는 실제 값이 아니라 표시상 문제(다른 dataset/범위를 보고 있었을
  가능성)로 판단.
- **진짜 문제**: [2] PGM 펄스 Transient가 `Unset(TrapFilling)` 직후(t=3.0000e-05+)
  시작하자마자 `|RHS| is greater than maximum allowed 1.0000E+15`로 반복 발산 →
  스텝을 계속 줄여도(1e-7 -> ... -> 1e-9대) 회복 못 하고 `Step-size is too small`로
  그 Transient 전체가 포기됨(로그 10764~11577줄 부근). 즉 **20V PGM 펄스 자체가
  실질적으로 실행되지 않은 채** [3] post-PGM 단계로 넘어가버림 - 04~07(PGM_10V/20V/
  Hold/Discharged) 스냅샷이 아예 안 만들어졌고, 08/09가 00~03과 큰 차이 없어 보였던
  이유.
- **원인 가설**: v3에서 새로 추가한 `Math`의 `Extrapolate`가, [1] Pre-PGM 스윕에서
  WL_SEL이 6V->0V로 내려가던(음의 기울기) 마지막 추세를 그대로 이어받아 [2] PGM
  Transient의 "0V->20V로 올라가는(양의 기울기)" 첫 스텝 초기 추정값을 만드는 과정에서,
  마침 그 경계에서 `Unset(TrapFilling)`으로 트랩 방정식도 동시에 재활성화되는 시점과
  겹쳐 초기 추정값이 크게 어긋났을 가능성 (manual/sdevice/04_Performing_Numeric_
  Experiments.md "Extrapolation" 섹션 - 기본값은 `-Extrapolate`). v2(Extrapolate
  없음)의 PGM Transient는 같은 위상 구간에서 문제없이 수렴했었다는 사실과도 부합.
- **적용한 수정**: `commands/nand_pgm_erase_base/20260822_nand5gate_pgm_sdevice_v4.cmd`
  - `Math`에서 `Extrapolate` 제거(기본값 `-Extrapolate`로 복귀). 나머지(Method=Pardiso,
    -CheckUndefinedModels, Derivatives, RelErrControl, Mobility(DopingDependence),
    전극 파형 구조, WL_Pass1 진단)는 v3와 동일 유지.

v4 실행 결과 대기. 여전히 같은 지점에서 발산하면 Extrapolate가 원인이 아니었다는 뜻이므로,
다음으로는 Mobility(DopingDependence) 제거 또는 pre-PGM/PGM 경계의 InitialStep을 더
작게 주는 방향을 시도할 것.

### [2026-08-22 추가] v4 성공 확인 + v5: Id-Vgs 스윕 범위를 음(-) 전압까지 확장

v4 실행 결과 PGM 펄스가 정상적으로 진행됨을 확인(04~09 스냅샷 정상 생성, CTN에 트랩이
실제로 차오르는 것 확인). Extrapolate가 원인이었다는 가설이 맞았던 것으로 판단.

이후 Id-Vgs 커브 확인 중 WL_SEL=0V에서 이미 BL 전류가 ~1e-10A로 잡혀있어 Vt가 0V
근처이거나 그보다 낮을 가능성 확인 → `20260822_nand5gate_pgm_sdevice_v5.cmd`에서
WL_SEL의 pre-PGM/post-PGM 스윕 시작점을 0.0V -> -2.0V로 변경(스윕 범위 -2~6V). 나머지는
v4와 동일. 또한 Inspect에서 Id-Vgs 곡선에 "두 줄"이 보이는 이유(스윕 구간 안에서
올라가는 트레이스+PGM 준비를 위해 다시 내려가는 트레이스가 겹쳐 보이는 것 - 실제
히스테리시스 아님)를 설명함.
