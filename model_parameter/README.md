# model_parameter/

SDEVICE Material Parameter 파일(`.par`)을 보관하는 폴더.

## 파일 구성

- `models.par` — Synopsys가 기본 제공하는 재질 파라미터 라이브러리 원본
  (약 80개 재질, 38,000줄 이상). **직접 수정하지 않는다.** 커스터마이징이
  기본값에서 얼마나/어떻게 벗어났는지 비교할 기준(baseline)으로만 쓴다.
  이 프로젝트의 어떤 `.cmd`도 `DefaultParametersFromFile`을 켜지 않으므로
  (`manual/sdevice/02_Specifying_Physical_Devices.md` "Default Parameters" 절,
  1050번째 줄 근처), **실행 시 이 파일이 직접 로드되지는 않는다** — 아래
  "Q. models.par의 다른 재질들도 따로 챙겨야 하나?" 참고.
- `models_jh.par` — 실제 시뮬레이션에 쓰는 커스텀 파라미터 파일(라이브 작업본).
  **2026-08-22, 사용자가 SiC 제거 이전 원본 내용으로 직접 되돌림** — 지금은
  Oxide/Nitride/PolySi/**SiC_4H/SiC_6H**/Silicide/Tungsten 7개 재질을 다시 포함한다.
  이 파일은 언제든 사용자가 직접 고칠 수 있으므로, 실제 재질 구성은 아래 스냅샷
  설명을 믿지 말고 매번 `Grep(pattern="^Material = ", path="model_parameter/models_jh.par")`
  로 다시 확인한다.
- `20260822_models_v1.par` — SiC_4H/SiC_6H를 제거해본 버전의 스냅샷. **현재
  `models_jh.par`가 위처럼 원본(SiC 포함)으로 되돌아갔으므로 이 파일은 지금
  라이브 작업본과 내용이 다르다** — "앞으로 쓸 기준본"이 아니라 "한때 시도했던
  SiC 제거안"으로만 취급한다. SiC를 다시 빼기로 하면 이 파일을 그대로 재사용해도
  되지만, 그 전까지는 `models_jh.par`가 사실상의 기준본이다.

## 버전 관리 규칙

`models_jh.par`를 고칠 때는:
1. 고치기 **전에** 현재 내용을 `YYYYMMDD_models_vN.par`로 스냅샷 저장한다
   (새 파일로 저장, 기존 스냅샷은 덮어쓰지 않음. 다음 버전은 v2).
2. `models_jh.par`를 수정한다.
3. 그 변경을 실제로 실행에 쓴 `.cmd` 버전과 함께 `runs/<실험명>/000N_*.md`에 기록한다
   (예: "커맨드 v2 + 모델 파라미터 v3 조합으로 실행").

**중요 — 원격 실행 경로와의 관계**: `.cmd` 파일은 실제 실행 시
`Parameter = "/home/daeyeol05/Original/models_jh.par"`처럼 리눅스 서버의 절대경로
파일을 읽는다. 이 저장소의 `models_jh.par`와 `YYYYMMDD_models_vN.par` 스냅샷은
그 서버 파일의 로컬 기록/버전 관리용 사본이다. 새 버전을 실제로 실행에 반영하려면
서버의 해당 경로 파일도 같은 내용으로 갱신해야 하며, 필요하면 `.cmd`의
`Parameter = "..."` 줄 옆에 주석으로 어느 버전(vN)을 썼는지 남겨서 나중에
"이 결과가 커맨드 vM + 파라미터 vN 조합"임을 추적할 수 있게 한다.

## Q. `models.par`에 있는 다른 재질들도 따로 챙겨야 하나?

**아니다, 지금 NAND 구조에 안 쓰는 재질이면 챙길 필요 없다.** 근거
(`manual/sdevice/02_Specifying_Physical_Devices.md` "Materialwise Parameters"
884~909번째 줄):

1. SDEVICE는 모든 재질에 대해 **컴파일된 내장 기본값(built-in defaults)**을
   갖고 있다. `models.par`는 그 내장 기본값을 사람이 읽을 수 있게 텍스트로 덤프한
   참고용 파일일 뿐이다.
2. 사용자가 `Parameter = "파일.par"`로 지정한 파일(`models_jh.par`)은 여기에
   **재질별로 값을 추가/override**하는 용도다. 이 파일에 어떤 재질의 섹션이
   아예 없으면, 그 재질은 그냥 내장 기본값을 그대로 쓴다 — 에러가 나거나
   시뮬레이션이 막히지 않는다.
3. `DefaultParametersFromFile` 플래그를 쓸 때만 `models.par` 같은 "기본값 파일"이
   추가로 로드되는데, 이 프로젝트의 `.cmd`들은 이 플래그를 켜지 않았다
   (`Grep`으로 확인, 전 커맨드에서 0건). 즉 지금은 `models.par`가 실행 경로에
   전혀 관여하지 않는다.

정리하면: **현재 NAND 구조(Oxide/Nitride/PolySi/Silicide/Tungsten 5개 재질)에
쓰이는 재질만 `models_jh.par`에 있으면 충분**하고, 구조에 없는 재질(GaAs, InP,
Copper, SiC류 등 `models.par`의 나머지 ~75개)은 애초에 SDEVICE가 조회조차 하지
않으므로 `models_jh.par`에 넣을 이유가 없다. `models.par`는 앞으로도 "이
5개 재질의 기본값이 원래 뭐였는지" 비교/확인용 참고 자료로만 남겨두면 된다.

**단, 구조에 쓰이는 재질인데 `models_jh.par`에 섹션 자체가 없다면** 그건
내장 기본값이 그대로 적용된다는 뜻이라 문제는 아니지만, 만약 그 재질에
의도적으로 오버라이드를 걸고 싶다면(예: 지금처럼 `BarrierTunneling`의 `mt`
같은 값) 그때 섹션을 추가하면 된다.

## (보류됨) SiC 제거 스냅샷 — 2026-08-22

`20260822_models_v1.par` = 그 시점 `models_jh.par` 내용. 원래 있던 `SiC_4H`/
`SiC_6H` 재질 블록은 **현재 구조에서 쓰지 않아 삭제**했다 (내용 자체도 광학
`ComplexRefractiveIndex` n=1 고정값뿐인 빈 블록이었음). 이제 `models_jh.par`는
Oxide/Nitride/PolySi/Silicide/Tungsten 5개 재질만 포함한다.

Synopsys 기본값(`models.par`)과 비교한 나머지 5개 재질의 커스터마이징 내역은
다음과 같다 (모두 기본값 대부분을 그대로 보존한 채 일부 블록만 추가하는 패턴).

### Oxide (터널 산화막)
기본값과 100% 동일 + 다음 블록만 추가:
- `BarrierTunneling { mt = 0.36, 0.38 }` — 전자/정공 터널링 유효질량. FN/Direct
  터널링 배리어 재질이라 필요 (근거: `runs/nand_pgm_EPEP/0005_detrapping_model_gaps.md`
  "v7 실행 에러" 절 — `NonLocal` 메시가 걸린 재질은 이 값이 없으면 실행 자체가
  에러로 멈춤).

### Nitride (CTN, 전하 트랩층)
기본값과 100% 동일 + 다음 블록 추가:
- `BarrierTunneling { mt = 0.36, 0.38 }`
- `ConstantMobility` / `ConstantMobility_aniso` — mumax=1e-5, 1e-5 cm²/(Vs);
  Exponent=2.5, 2.2; mutunnel=0.01(aniso는 0.05), 0.01. 부도체인 질화막에
  사실상 이동하지 않는 수준의 낮은 상수 이동도만 부여.
- `Traps` — 재질 차원의 트랩 공통 물리상수. `XsecFormula = 4, 4`(Poole-Frenkel
  필드 강화 모델 선택), `Vth = 2.042e7, 1.56e7 cm/s`(전자/정공 열속도),
  `HuangRhys = 0`, `PhononEnergy = 0`(포논 보조 방출 비활성). **개별 트랩 종류
  (Acceptor/Donor)의 농도·에너지 준위·기본 단면적(Xsec)은 이 `.par`가 아니라
  `.cmd`의 `Physics { Traps(...) }`에서 정의**되며, 최신 값과 문헌 근거는
  `runs/nand_pgm_EPEP/0006_trap_parameter_literature_values.md`에 있음.
- `PooleFrenkel { epsPF = 7.5, 7.5; a_power = 1, 1 }` — 위 `Traps`의
  `XsecFormula=4`가 참조하는 필드 강화 계수.

### PolySi (채널)
기본값과 100% 동일 + `BarrierTunneling { mt = 0.36, 0.38 }` 블록만 추가.
(Mobility/DopingDependence/Scharfetter/PooleFrenkel 등은 원래 기본값에도 있던
것이라 새로 추가된 게 아님 — PolySi 기본 PooleFrenkel의 `epsPF=11.7`은 손대지
않고 그대로 둠.)

### Silicide
기본값과 100% 동일 (변경 없음, `ComplexRefractiveIndex` n=1 고정값만 존재).

### Tungsten (게이트 금속)
Synopsys 기본값은 광학 `ComplexRefractiveIndex`(파장 의존 n/k 테이블, 약 240행)
만 가진 재질인데, 이 파일에는 그 테이블이 전혀 없고 `BarrierTunneling
{ mt = 0.36, 0.38 }` 블록 하나만 정의돼 있음. 근거:
`runs/nand_pgm_EPEP/0005_detrapping_model_gaps.md` — `NL_Box`(BlockOx-Tungsten
계면 비국소 터널링) 활성화 시 "Tunneling mass for interface ... is not specified!"
에러가 발생해서, Tungsten 재질에 `mt` 값을 추가해 실험적으로 해결한 이력이 있음
(매뉴얼상 WKB 모델은 이론적으로 contact 쪽 mt가 불필요해야 한다는 서술과 배치되지만
실제로는 필요했음 — 원인은 미확정, 실험적으로만 해결됨). 광학 테이블이 없는 것은
현재 전기적 시뮬레이션에서 광학 물성을 쓰지 않기 때문으로 보이나, 향후 Optics 관련
물리를 켤 계획이 있다면 기본값 테이블을 다시 가져와야 함.

### 공통 패턴
`mt = 0.36, 0.38` 터널링 유효질량은 Oxide/Nitride/PolySi/Tungsten 4개 재질 모두
동일한 값으로 맞춰져 있다 — `NL_Tox`(채널-Oxide-Nitride)와 `NL_Box`
(Nitride-BlockOx-Tungsten) 두 비국소 터널링 경로에 걸리는 모든 재질에 같은
유효질량을 쓰겠다는 의도로 보인다.
