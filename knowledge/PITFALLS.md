# SDEVICE 명령어 작성 시 환각/오류 기록 (PITFALLS)

이 파일은 Claude가 SDEVICE 명령을 작성하면서 실제로 틀렸던 것(문법 환각, 존재하지
않는 키워드, 잘못된 섹션 배치, 잘못된 파라미터 이름/단위 등)을 누적 기록하는 곳이다.

**새 세션을 시작할 때, 또는 새 SDEVICE 명령을 작성/수정하기 전에 이 파일 전체를 먼저
읽는다.** 여기 기록된 실수를 반복하지 않는 것이 최우선이다.

## 기록 규칙

- 사용자가 "이거 안 됐어", "이 옵션 에러남", "이 키워드 없대" 같은 식으로 실행 결과를
  알려주면, 그 즉시 아래 형식으로 새 항목을 추가한다 (사용자가 명시적으로 요청하지
  않아도 먼저 기록한다).
- 반드시 어떤 게 틀렸고 무엇이 맞는지, 그리고 근거(매뉴얼 파일/섹션 또는 "매뉴얼에
  없어서 직접 검증 필요")를 남긴다.
- 같은 종류의 실수가 반복되면 기존 항목을 업데이트/보강한다 (중복 항목 만들지 않기).
- 최신 항목이 위로 오도록 역순(최근 날짜가 맨 위)으로 추가한다.

## 항목 템플릿

```
## [YYYY-MM-DD] 짧은 제목

- **틀렸던 표현/가정**: `...`
- **실제 증상**: (시뮬레이터가 뱉은 에러 메시지 또는 관찰된 현상)
- **올바른 표현/원인**: `...`
- **근거**: manual/sdevice/NN_Chapter.md 또는 manual/sde/NN_Chapter.md 의 "섹션명"
  (해당 시), 또는 "사용자 실측 확인"
- **적용 범위**: 이 실수가 다른 어떤 상황에서도 재발할 수 있는지 메모
```

---

<!-- 아래에 실제 항목을 시간 역순으로 추가 -->

## [2026-08-22] `eTrappedCharge`는 Donor+Acceptor 합산이 아니라 Acceptor(+eNeutral) 전용

- **틀렸던 가정**: `eTrappedCharge(Average(...))` 값을 트랩 "점유율(%)"로 환산하면서,
  100% 포화 시 최댓값을 `Donor Conc + Acceptor Conc`(예: 1.5e19+2.5e19=4e19)로
  계산함 - Traps() 안에 정의된 트랩 종류를 전부 더한 것.
- **실제**: `manual/sdevice/17_Traps_and_Fixed_Charges.md` 1195/1197번째 줄에
  명시적으로 나와 있음 - `eTrappedCharge`는 **`eNeutral`과 `Acceptor` 트랩만**의
  전자 점유 전하를 집계하고, `hTrappedCharge`는 **`hNeutral`과 `Donor` 트랩만**의
  정공 점유 전하를 집계한다. Donor 트랩은 "채워짐(전자를 가짐)=중성" 상태라
  전자가 있어도 순전하 기여가 0이라서 `eTrappedCharge`에 안 잡히고, 대신 그
  반대(전자를 잃음=정공을 얻은 것으로 취급)가 `hTrappedCharge`에 잡힌다.
  즉 `eTrappedCharge`의 100% 포화 기준값은 **Acceptor Conc만**(Donor는 빼고)이어야
  한다. 사용자가 "Acceptor Conc로만 계산되는 거 아니냐"고 지적해서 매뉴얼로
  확인 후 정정함(2026-08-22, `runs/nand_pgm_erase_base/0002_discharge_pass_trap_crosstalk.md`).
- **적용 범위**: `eTrappedCharge`/`hTrappedCharge`의 절대량(점유율 등)을 계산할 때는
  항상 Acceptor Conc(전자용)/Donor Conc(정공용)만 따로 분모로 쓸 것 - Traps() 안의
  전체 트랩 농도를 그냥 다 더하지 말 것.

## [2026-08-21] `Set(TrapFilling=...)`의 "가득 채움" 키워드는 `filled`가 아니라 `Full`

- **틀렸던 표현/가정**: nand_pgm_erase_base 실험의 Erase cmd를 작성하면서, "빈 상태"를
  뜻하는 기존 관용구 `Set(TrapFilling=empty)`의 반대말을 그냥 영어 단어 그대로
  `Set(TrapFilling=filled)`라고 추측해서 씀.
- **실제 증상**: 아직 실행 전에 자체 검증 단계(매뉴얼 grep)에서 발견 - 실행했다면
  문법 오류 또는 무시(silently ignored)됐을 가능성이 있음.
- **올바른 표현/원인**: `manual/sdevice/40_Tcl_Interfaces.md` Table 347
  ("TrapFilling= in Set() in Solve {}")과 `manual/sdevice/17_Traps_and_Fixed_Charges.md`
  "Explicit Trap Occupation" 섹션에 따르면, `TrapFilling`에 쓸 수 있는 값은
  `0`(전자/정공 농도 0 기준 평형), `-Degradation`, `Frozen`, `Full`(deprecated, 모든
  트랩을 완전히 채움), `n`/`p`(deprecated) 뿐이다. "완전히 채움"의 정식 키워드는
  대문자 `Full`이며 `filled`라는 키워드는 매뉴얼 어디에도 없음. (참고: `empty`는 이
  테이블에서 라벨이 PDF 변환 과정에서 깨져 안 보이지만, 기존 EPEP/GIDL-HCI cmd에서
  `Set(TrapFilling=empty)`가 이미 문제없이 쓰여온 관용구라 그대로 유지함 - 의심스러운
  건 `filled`였음.)
- **근거**: `manual/sdevice/40_Tcl_Interfaces.md` Table 347(5815~5831번째 줄),
  `manual/sdevice/17_Traps_and_Fixed_Charges.md` "Explicit Trap Occupation" 섹션
  (258~271번째 줄).
- **적용 범위**: `TrapFilling`처럼 "반대말이 있을 법한" 키워드(empty/filled,
  on/off 등)를 쓸 때, 한쪽만 기존 코드에서 검증된 관용구라고 해서 반대쪽도 같은
  패턴(자연스러운 영어 반의어)일 거라고 추측하지 말 것 - SDEVICE 키워드는 대칭적인
  의미라도 이름이 비대칭(`empty`/`Full`)일 수 있으므로 새로 쓰는 쪽은 항상 매뉴얼로
  다시 확인.

## [2026-08-18] `Physics(Material="...")`/`Physics(Region="...")`는 global(default) `Physics`를 override하지 않고 "추가(added to)"됨

- **틀렸던 표현/가정**: v1(nand_erase_GIDL-HCI)부터 계속 "material-specific
  `Physics(Material=X){...}`은 global `Physics{...}`를 완전히 교체(override)한다"고
  가정하고 커맨드를 작성함. 예: global에 `Mobility(DopingDependence HighFieldSaturation
  Enormal)`을 두고, `Physics(Material="Si3N4"){Mobility(ConstantMobility)}`만 있으면
  Nitride엔 `ConstantMobility`만 적용될 거라고 생각함.
- **실제 증상**: 위 구성으로 실행 시 t≈20us(SL≈4V, 필드가 커지는 시점)에
  `Region "R.TrapNi" (Material "Nitride"): UNDEFINED model "DopingDependence(electrons)"` /
  `"DopingDependence(holes)"` 에러로 정지. `Math`에 `-CheckUndefinedModels`가 있었는데도
  막히지 않음(이유는 매뉴얼에서 명시적으로 확인 못 함).
- **올바른 표현/원인**: `manual/sdevice/02_Specifying_Physical_Devices.md` 415~421번째 줄에
  명시: "Physical models defined in the global `Physics` section... are applied in all
  regions"이고, "Physical models defined in a **material-specific** `Physics` section are
  **added to** the default models for all regions containing the specified material" —
  region-specific 도 마찬가지로 "added to the models defined in the default section".
  즉 override가 아니라 **합집합(추가)**. 유일한 예외는 425번째 줄: "region-specific과
  material-specific이 동시에 있으면 region-specific이 material-specific을 완전히
  무시(대체)한다"(이건 진짜 override) — 하지만 material vs global 사이에는 이 규칙이
  적용되지 않음. 결과적으로 global `Physics`에 넣은 모델은 그 role(Semiconductor 등)에
  해당하는 **모든** material에 계속 "추가"로 살아있고, material section에서 다른 걸
  지정해도 지워지지 않음 — 원치 않는 모델을 특정 material에서 빼려면 애초에 그 모델을
  global에 넣지 말고 필요한 material의 `Physics(Material=...)` 쪽으로 옮겨야 함(또는
  `Mobility(-ConstantMobility ...)`처럼 일부 카테고리에 존재하는 `-모델명` negation
  옵션을 쓰되, 이건 카테고리별로 매뉴얼에 명시된 경우에만 검증된 것으로 취급할 것 —
  Ch15 Mobility 50~53번째 줄엔 `-ConstantMobility` 사용례가 있지만 `-HighFieldSaturation`/
  `-Enormal`/`-DopingDependence` 같은 다른 negation은 매뉴얼에서 직접 확인된 바 없음).
- **재해석(과거 기록 정정)**: RUN 0001(nand_erase_GIDL-HCI) 초반에 global
  `Recombination(SRH(DopingDependence) Auger)`가 Nitride에 물려받아져 에러가 났던 걸
  "PolySi Physics 블록의 Recombination override로 해결했다"고 기록했었는데, 실제로는
  override가 작동한 게 아니라 **global 자체에서 그 Recombination을 지워서** 우연히
  해결된 것이었음 — 그때는 이 "추가" 규칙을 몰랐을 뿐, 결과적 수정 방향(global을 비우기)은
  우연히 맞았음.
- **근거**: `manual/sdevice/02_Specifying_Physical_Devices.md` 415~425번째 줄
  ("Physical Models and the Hierarchy of Their Specification"), Table 4(993~1009번째 줄,
  critical model 목록과 checking 조건).
- **적용 범위**: 앞으로 어떤 실험이든 `Physics(Material=...)`나 `Physics(Region=...)`로
  특정 material/region에서 global과 "다른" 모델을 쓰고 싶을 때마다, "material section이
  알아서 global을 대체해줄 것"이라고 가정하지 말고, **global `Physics`에 애초에 그
  material에 원치 않는 모델이 들어있지 않은지 항상 먼저 확인**할 것. 특히 Mobility/
  Recombination처럼 여러 서브모델을 나열하는 카테고리에서, 한 material에만 필요한
  서브모델(예: HighFieldSaturation, Enormal, CarrierTempDrive 계열)은 global에 두지 말고
  처음부터 그 material 전용 `Physics(Material=...)` 블록 안에 넣는 습관을 들일 것.

## [2026-08-18] `FromConductionBand`는 존재하지 않는 키워드 — `fromCondBand`가 맞음

- **틀렸던 표현/가정**: 트랩 에너지 준위를 지정할 때 `Level EnergyMid=2.5
  FromConductionBand`처럼 `FromConductionBand`(대문자 F, "Conduction" 풀스펠링)를
  v1부터 v11까지 계속 사용함. 반대쪽(밸런스밴드 기준)이 필요할 때도 이 방식을
  그대로 쓰려고 했음.
  - **이 실수의 근원**: 사용자가 세션 초반에 준 원본 SDEVICE 커맨드 스니펫에 이미
    이 키워드가 들어있었고, Claude가 그걸 그대로 복사해서 이후 모든 버전에 반복
    사용함 — 즉 사용자가 제공한 원본 코드 자체를 검증 없이 정답으로 가정한 게
    출발점이었음. 사용자가 준 코드라도 매뉴얼에 없는 키워드가 섞여있을 수 있으므로,
    특히 트랩/물리 모델처럼 결과에 직접 영향을 주는 키워드는 처음 등장할 때 한 번은
    grep으로 검증해야 함.
- **실제 증상**: `Grep`으로 매뉴얼 전체를 검색한 결과 `FromConductionBand`는 0건 —
  존재하지 않는 키워드. 그런데도 여러 버전의 시뮬레이션이 에러 없이 실행됐음(SDEVICE가
  인식 못 하는 옵션을 조용히 무시했거나, 대소문자 매칭이 관대했을 가능성 — 확실하지
  않음). 트랩 준위가 의도한 값으로 실제 반영됐는지 불확실한 채로 여러 런이 진행됐을
  수 있음.
- **올바른 표현/원인**: 공식 키워드는 `fromCondBand`(전도대 기준), `fromValBand`
  (가전자대 기준), `fromMidBandGap`(밴드갭 중앙 기준) 세 가지뿐임.
- **근거**: `manual/sdevice/17_Traps_and_Fixed_Charges.md` Eq. 511 (E_trap^0 계산식에
  세 키워드가 명시됨), `manual/sdevice/40_Tcl_Interfaces.md` 5139/5141번째 줄(Tcl
  인터페이스 레퍼런스 테이블).
- **적용 범위**: 트랩/물리 모델 관련 키워드는 "그럴듯하게 들린다"거나 "이전 버전에서
  써왔다"는 이유만으로 신뢰하지 말고, 새 프로젝트나 처음 등장하는 키워드는 반드시
  `Grep`으로 매뉴얼에 실제 존재하는지 확인할 것. 특히 사용자가 제공한 기존 코드를
  베이스로 계속 이어서 작업할 때, 그 코드에 이미 있던 키워드라고 검증을 건너뛰지 말 것.

## [2026-08-17] `Material = "재질" { 파라미터셋 {...} }`은 .cmd가 아니라 .par 파일 문법

- **틀렸던 표현/가정**: SDEVICE 커맨드 파일(.cmd) 최상위에 직접
  `Material = "SiO2" { BarrierTunneling { mt = 0.36, 0.38 } }`를 넣으면 그 재질을
  지나는 모든 NonLocal 메시에 tunneling mass가 적용될 거라고 판단하고 넣음.
- **실제 증상**: `Error in "....cmd" at line N, offending input: Material / syntax
  error!` — .cmd 최상위에는 `File`/`Electrode`/`Physics`/`Plot`/`CurrentPlot`/`Math`/
  `Solve` 같은 정해진 섹션만 올 수 있고, 바깥에 bare `Material = ...` 블록은 문법
  오류.
- **올바른 표현/원인**: `manual/sdevice/24_Tunneling.md`의 `Material = "Oxide" {
  BarrierTunneling { mt = ... } }` 예시는 **파라미터 파일(.par) 문법**이었음.
  `Grep`으로 매뉴얼 전체에서 `Material = "..."` 패턴이 나오는 다른 모든 곳
  (Ch10, Ch11, Ch12, Ch13, Ch16, Ch17)을 확인해보니, 전부 앞에 "...is specified in
  the parameter file", "...parameter file section" 같은 문구가 붙어 있었음 —
  즉 이 패턴은 **항상 .par 파일 안에서만** 쓰는 구문이고 .cmd 파일에는 못 씀.
  같은 목적을 .cmd 파일 안에서 달성하려면 `Physics(Material="...")` 처럼 별도의
  .cmd 전용 문법을 써야 하며, `Material = "재질" { 파라미터셋 { ... } }` 형태의
  "재질별 파라미터 오버라이드"는 .par 파일에만 있는 기능임.
- **근거**: `manual/sdevice/24_Tunneling.md` "Nonlocal Tunneling Parameters" 섹션(356~375번째
  줄) 및 다른 챕터들의 동일 패턴 사용례.
- **적용 범위**: 매뉴얼에서 `Material = "재질명" { ... }` 형태의 코드 블록을 보면,
  주변 문맥에 "parameter file"이라는 언급이 있는지 반드시 확인하고, 있다면 .cmd가
  아니라 .par 파일에 넣어야 한다고 사용자에게 명시할 것. (반대로 `Physics(Material=
  "재질명") { ... }`처럼 `Physics` 키워드가 붙은 형태는 .cmd 파일 문법이 맞음 —
  둘을 혼동하지 말 것.)

## [2026-08-17] `PooleFrenkel`(옵션 없음)은 트랩 타입에 따라 전자/정공 중 한쪽에만 적용됨

- **틀렸던 표현/가정**: `Traps( ( Acceptor ... PooleFrenkel ... ) )`처럼 Acceptor 트랩에
  옵션 없는 `PooleFrenkel`만 넣으면 전자(electron) 캡처/방출이 필드에 따라 강화될
  거라고 가정함.
- **실제 증상**: Acceptor 트랩(전자를 채우는 트랩)에 옵션 없는 `PooleFrenkel`을 썼더니
  전자 쪽 방출(detrapping)이 필드가 커져도 강화되지 않음 — CTN(질화막) 트랩이 한번
  차면 계속 포화된 채 안 빠지는 것처럼 보이는 원인 중 하나였음.
- **올바른 표현/원인**: 옵션 없는 `PooleFrenkel`은 트랩 타입에 따라 기본 적용 대상이
  다름 — Donor/hNeutral 트랩은 전자(σn) 쪽만, **Acceptor/eNeutral 트랩은 정공(σp)
  쪽만** 강화됨. 전자 쪽을 강화하려면 트랩 타입과 무관하게 `PooleFrenkel(Electron)`을
  명시해야 하고, 정공 쪽은 `PooleFrenkel(Hole)`. 둘 다 강화하려면
  `PooleFrenkel(Electron) PooleFrenkel(Hole)`을 같이 씀.
- **근거**: `manual/sdevice/17_Traps_and_Fixed_Charges.md` "Poole-Frenkel Model for Cross
  Sections" 섹션(527~537번째 줄 부근).
- **적용 범위**: 앞으로 Traps()에 `PooleFrenkel`(또는 같은 계열의 `Tunneling(Hurkx)`도
  cross-section을 캐리어별로 다르게 다룰 수 있으니)을 쓸 때마다, 어떤 캐리어의
  capture/emission을 강화하고 싶은지 확인하고 트랩 타입에 의존하는 기본값에 기대지
  말고 `(Electron)`/`(Hole)`을 명시적으로 쓸 것.

## [2026-08-17] Electrode의 static Voltage와 Voltage=(waveform)를 같이 쓸 때, 두 값이 반드시 일치해야 함

- **틀렸던 표현/가정**: `{ Name="WL_Pass1" Voltage=8.0 WorkFunction=4.53 Voltage=( 0.0 at 0.0, ... ) }`
  처럼 static `Voltage=X`와 시간파형 `Voltage=(...)`를 함께 썼는데, X가 파형의 t=0 값과
  다름 (여기서는 static 8.0 vs 파형 시작값 0.0).
- **실제 증상**: `Transient` 시작 전, `Solve` 앞부분의 `Coupled{Poisson}`,
  `Coupled{Poisson Electron}`, `Coupled{Poisson Electron Hole}` 단계에서 해당 전극에
  실제로 static 값(8V)이 인가된 채로 풀림. `Set(TrapFilling=empty)`로 트랩 점유 자체는
  강제로 0이었지만, 그 상태에서 형성된 캐리어/전계 분포가 `Transient`의 초기조건이 되어,
  파형이 곧바로 0V로 떨어져야 하는데도 트랜지언트 극초반에 비정상적으로 큰 터널링
  전류가 발생 → 목표하지 않은 인접 게이트 아래에 트랩이 처음부터 채워진 것처럼 보임.
  사용자가 재실행 후 원인이 맞았다고 확인함.
- **올바른 표현/원인**: static `Voltage=X`는 `Transient` 이전(Coupled/Quasistationary)
  구간에서 실제로 인가되는 값이고, `Voltage=(...)` 파형은 `Transient` 안에서만 유효함
  (매뉴얼에 명시된 정식 동작이지 오타가 아님). 따라서 **전극에 static Voltage와 파형을
  함께 쓸 때는 static 값을 반드시 파형의 t=0(초기) 값과 동일하게 맞춰야 한다** —
  두 값이 의도적으로 다른 게 아니라면(예: quasistationary로 먼저 램프시키고 나서
  transient 파형을 붙이는 의도적 설계가 아니라면) 항상 일치시킬 것.
- **근거**: `manual/sdevice/04_Performing_Numeric_Experiments.md` "Specifying Electrical
  Boundary Conditions" 섹션 (43~49번째 줄 부근): "In addition, you can specify a
  separate *static* voltage... This combination is useful where an initial
  quasistationary command ramps `source` from 0 V to 5 V, before `source` increases
  to 10 V during a subsequent transient analysis."
- **적용 범위**: 앞으로 SDEVICE 전극/파형 명령을 작성할 때마다, 파형이 있는 전극은
  static Voltage 값이 파형의 시작값과 일치하는지 항상 체크리스트로 확인할 것.
  Thermode의 `Power=(...)` 같은 다른 time-dependent 파라미터도 동일한 static/파형
  공존 구조를 쓰므로 같은 규칙이 적용될 수 있음.

- **[2026-08-17 재발]**: "Pass 게이트를 6V로 계속 고정해두고 싶다"는 요구를 파형 없이
  `Voltage=6.0`만 쓰는 식으로 구현했다가 같은 문제가 다시 발생함 — static Voltage는
  `Transient` 이전의 초기 `Set(TrapFilling=empty)` + `Coupled` 단계에서도 그대로
  적용되므로, "쭉 6V 유지"를 원해도 **다른 전극들이 0V에서 출발하는 초기 평형 상태와
  맞추고 싶다면 0V에서 시작해서 목표 전압까지 올라간 뒤 그 값을 유지하는 파형**으로
  써야 한다 (예: `Voltage=( 0.0 at 0.0, 6.0 at 1e-4, 6.0 at <FinalTime> )`), 그냥
  static `Voltage=6.0`으로 두면 안 됨. "일정 전압 유지"라는 요구사항 자체가 static
  Voltage 하나로 해결된다고 착각하지 말 것 — 다른 전극과 같은 초기조건에서 출발해야
  하는 상황이면 항상 파형으로 표현해야 한다.
