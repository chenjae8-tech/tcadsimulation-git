# TCAD Sentaurus SDEVICE 명령어 작성 프로젝트

이 프로젝트의 목적은 Synopsys Sentaurus **SDEVICE**(소자 물리 시뮬레이터) 커맨드 파일을
작성/수정하는 것이다. 사용자는 여기서 만든 명령을 **다른 터미널에 복사-붙여넣기 해서
직접 실행**한다 (Claude Code가 직접 시뮬레이터를 실행하지 않음). 따라서 문법이 조금만
틀려도 사용자가 시간을 낭비하게 되므로, **매뉴얼에 근거 없는 키워드/파라미터/문법을
추측(환각)해서 쓰지 않는 것**이 이 프로젝트에서 가장 중요한 규칙이다.

## 폴더 구조

- `SDevice User Guide.md` — SDEVICE 원본 매뉴얼(PDF 변환본, 72,550줄). **절대 통째로 읽지 말 것.**
- `SStructure Editor User Guide.pdf` / `.md` — SDE 매뉴얼 원본(약 860페이지, LlamaParse로
  변환, 33,922줄). **절대 통째로 읽지 말 것.**
- `manual/` — 위 두 원본 매뉴얼을 챕터별로 쪼갠 파일들을 문서별로 나눠서 보관하는 폴더.
  하위 폴더로 완전히 분리돼 있으며 각각 자체 `INDEX.md`(챕터 목차/사용법)를 가진다:
  - `manual/sdevice/` — SDEVICE(물리 시뮬레이션) 매뉴얼 챕터 (`manual/sdevice/INDEX.md`).
  - `manual/sde/` — SDE(구조 생성, `sdegeo:`/`sdedr:` 등) 매뉴얼 챕터, 방대한 명령어
    레퍼런스는 `A_Appendix_A_Commands.md`로 별도 분리돼 있음 (`manual/sde/INDEX.md`).
  - 두 폴더 모두 챕터 번호가 00부터 시작해 겹치므로, 인용할 때 항상 `manual/sdevice/`
    또는 `manual/sde/` 경로까지 명시한다.
- `knowledge/PITFALLS.md` — 실제로 틀렸던 문법/환각 사례 누적 기록. **실험(연구 주제)에
  상관없이 전체 공용** — SDEVICE/SDE 문법 실수는 어느 실험을 하든 똑같이 재발할 수 있으므로
  실험 폴더로 나누지 않는다.
- `runs/` — 시뮬레이션 실행 기록. `RUN_LOG.md`(실험을 가로지르는 공용 인덱스)와
  `TEMPLATE.md`는 루트에 두고, 실제 기록 파일은 실험별 하위 폴더
  `runs/<실험명>/000N_짧은설명.md`에 쌓는다.
- `reference/` — 파라미터/물리 모델 선택의 근거가 되는 참고 논문(PDF). 트랩 준위, 단면적,
  이동도 계수처럼 매뉴얼만으로는 "왜 이 값인지" 알 수 없는 물리적 근거를 확인할 때 참고한다
  (사용법은 `reference/README.md`).
- `commands/` — 실제로 사용자에게 건네서 실행한 SDE/SDEVICE 커맨드 파일의 버전별 스냅샷.
  `README.md`(공용 파일명 규칙)는 루트에 두고, 실제 파일은 실험별 하위 폴더
  `commands/<실험명>/`에 저장한다 (`*_sde_v*.scm`은 구조 생성, `*_sdevice_v*.cmd`는
  물리 시뮬레이션). 현재 실험 폴더: `nand_pgm_EPEP` (Erase 여부에 따른 PGM 시 Cell
  밴드 차이 실험).

### 실험(연구 주제) 단위로 세션을 나누는 것에 대해

사용자가 여러 연구 주제(예: PGM/Erase 밴드 비교, GIDL 관련 Erase 실험 등)를 오갈 때는
**주제별로 별도 세션에서 진행해도 무방하다** — 오히려 권장된다. 이 프로젝트의 파일
구조(`CLAUDE.md` + 실험별 `commands/`, `runs/` 폴더 + 공용 `knowledge/`, `manual/`)
자체가 대화 기록 없이도 새 세션이 콜드 스타트로 맥락을 파악할 수 있도록 설계된 것이라서,
세션을 나눠도 정보 손실이 없다. 새 연구 주제를 시작하면 `commands/<실험명>/`,
`runs/<실험명>/` 폴더를 새로 만들고, 이 문서와 `knowledge/PITFALLS.md`,
`runs/RUN_LOG.md`는 계속 공용으로 사용한다.

다만 `knowledge/PITFALLS.md`, `runs/RUN_LOG.md`, 이 `CLAUDE.md` 처럼 여러 실험이
공유하는 파일을 **서로 다른 세션이 동시에(진짜 병렬로)** 수정하면, 버전 관리(git)가
없는 상태라 마지막에 저장한 쪽이 앞선 수정을 덮어쓸 위험이 있다. 세션을 번갈아
가며(한 세션이 끝난 뒤 다음 세션 시작) 쓰는 것은 문제없지만, 두 세션을 동시에 띄워
같은 파일을 거의 같은 시각에 고치는 상황은 피하는 것이 안전하다.

## 매뉴얼을 찾아볼 때 (토큰 절약 필수)

1. SDEVICE(물리 시뮬레이션) 문법은 `manual/sdevice/INDEX.md`, SDE(구조 생성,
   `sdegeo:`/`sdedr:`) 문법은 `manual/sde/INDEX.md`를 먼저 참고해 어느 챕터가 관련
   있는지 가늠한다. 두 매뉴얼 모두 챕터 번호가 00부터 시작해 겹치므로, 인용할 때 항상
   `manual/sdevice/` 또는 `manual/sde/` 경로까지 명시한다.
2. 정확한 키워드(파라미터명, 함수명, 섹션 키워드, 모델명 등)를 알고 있다면
   `Grep(pattern, path="manual/")`로 (SDEVICE + SDE 챕터 전부, `manual/sde/` 하위 포함)
   검색해서 어느 파일·어느 줄에 있는지 먼저 찾는다. 절대 여러 챕터 파일을 순서대로 다
   읽지 않는다.
3. 대상 챕터를 찾았으면 **그 챕터 파일만** 읽는다. SDEVICE 챕터 39(PMI)/40(Tcl
   Interfaces), SDE `A_Appendix_A_Commands.md`처럼 큰 파일은 필요한 서브섹션 근처만
   offset/limit으로 잘라 읽는다.
4. 매뉴얼에서 근거를 못 찾은 채로 명령을 작성해야 하는 상황이면, 절대 그럴듯하게
   지어내지 말고 사용자에게 "매뉴얼에서 해당 옵션을 확인하지 못했다"고 명시한다.

## SDEVICE 명령을 작성/수정할 때 반드시 지킬 것

1. **작업 시작 전 `knowledge/PITFALLS.md`를 먼저 읽는다.** 과거에 틀렸던 문법/키워드를
   반복하지 않기 위함이다.
2. 새로 넣는 키워드나 파라미터는 가능하면 어느 챕터/섹션 근거인지 답변에 짧게 언급한다
   (예: "Ch15 Mobility의 PhuMob 파라미터 기준").
3. 사용자가 이전에 준 커맨드를 수정하는 상황이면, `runs/RUN_LOG.md`와 관련 `runs/*.md`를
   먼저 확인해서 이미 시도했다가 실패한 방법을 다시 제안하지 않는다.
4. 최종 커맨드를 사용자에게 건넬 때, 필요하면 `commands/`에 스냅샷으로 저장한다
   (`commands/README.md`의 파일명 규칙 사용).
5. **커맨드를 작성/수정하기 전에 `commands/datexcodes.txt`의 현재 내용을 확인한다.**
   SDEVICE는 실행을 시작할 때 이 파일을 읽어서 재질(material)의 `group`
   (Semiconductor/Conductor/Insulator/All) 분류를 정하고, 이 분류가
   Auger/DopingDependence/Scharfetter/ConstantMobility 같은 critical model의 파라미터
   존재 여부 체크에 직접 영향을 준다 (자세한 메커니즘과 배경은 아래 "소자/시뮬레이션
   관련 고정 정보 > `datexcodes.txt`" 참고). 이 파일은 사용자가 언제든 고칠 수 있는
   평문 파일이라 과거 세션에서 기록해둔 내용을 그대로 믿지 말고, 커맨드를 작성할 때마다
   `Read`로 실제 현재 내용을 다시 확인한다.
6. **새 SDEVICE 커맨드를 작성하거나 `Parameter = "..."` 줄을 새로 쓰는 상황이면,
   어느 모델 파라미터 파일을 쓸지 먼저 사용자에게 물어본다.** `model_parameter/`
   폴더에는 라이브 작업본(`models_jh.par`)과 시점별 버전 스냅샷
   (`model_parameter/YYYYMMDD_models_vN.par`, 버전 규칙은 `model_parameter/README.md`
   참고)이 같이 있으므로, 사용자가 특별히 말하지 않았다면 어느 쪽(최신 작업본인지,
   특정 버전 고정인지)을 쓸지 임의로 정하지 말고 확인한다.
7. **최종 커맨드를 사용자에게 건넨 뒤에는, 그 커맨드를 실제로 실행할 폴더(평가
   폴더)에 `datexcodes.txt`도 같이 들어가 있는지 확인했는지 주의사항으로
   상기시킨다.** SDEVICE는 실행 디렉터리의 로컬 `datexcodes.txt`를 `$STROOT_LIB`/
   `$HOME` 기본값보다 최우선으로 읽으므로 (위 5번, 아래 "`datexcodes.txt`" 절 참고),
   이 파일이 실행 폴더에 빠져 있으면 의도한 `group` 분류가 적용되지 않아 critical
   model 파라미터 체크 결과가 달라질 수 있다. 사용자가 자주 잊어버리는 부분이므로
   커맨드를 건넬 때마다 매번 짧게 되짚어준다.

## 사용자가 시뮬레이션 결과/현상을 알려줄 때

사용자가 "이번엔 이런 현상이 나왔어", "이 옵션에서 에러났어", "수렴이 안 돼" 등을
알려주면, 다음을 사용자가 요청하지 않아도 먼저 수행한다:

1. `runs/RUN_LOG.md`에서 관련된 이전 런이 있는지 확인한다. 있으면 이어서 갱신,
   없으면 `runs/TEMPLATE.md`를 복사해 해당 실험 폴더에
   `runs/<실험명>/000N_짧은설명.md`로 새로 만든다.
2. 현상, 원인 분석(매뉴얼 근거 포함), 적용한 수정, 결과를 그 파일에 기록한다.
3. `RUN_LOG.md` 인덱스 표에 한 줄 추가/갱신한다.
4. 만약 원인이 "내가(Claude) 매뉴얼에 없는 문법을 지어내서" 였다면,
   `knowledge/PITFALLS.md`에도 반드시 새 항목을 추가한다 — 이게 이 프로젝트에서
   가장 중요한 피드백 루프다.

## 알려진 PDF 변환 잔재 (주의)

원본이 PDF → md 변환본이라 페이지마다 반복되던 푸터("Sentaurus(TM) Device User Guide",
버전 문자열, `<page_number>` 태그)는 스크립트로 제거했다. 다만 일부 챕터에는 아직도
문장 중간에 `NN: 챕터명` 한 줄 + 그다음 줄에 그 페이지의 섹션명이 끼어들어 있는 경우가
남아 있다(예: `15: Mobility` / `Doping-Dependent Mobility Degradation`). 이건 실제
내용이 아니라 PDF 쪽 페이지 러닝헤더 잔재이므로, 명령/파라미터를 인용할 때 이런 끼어든
줄을 실제 키워드나 문장의 일부로 착각하지 않도록 주의한다. 이런 잔재 때문에 실제로
잘못된 정보를 뽑아낸 사례가 생기면 `knowledge/PITFALLS.md`에 기록한다.

## 소자/시뮬레이션 관련 고정 정보

### `commands/datexcodes.txt`

이 프로젝트에서는 `commands/datexcodes.txt` 경로에 `datexcodes.txt` 파일을 두고 있다.
**SDEVICE는 실행을 시작할 때 이 파일을 읽는다** — 즉 커맨드(.cmd)를 작성/수정할 때는
항상 이 파일의 존재와 현재 내용을 함께 고려해야 한다. 이건 Synopsys TCAD 전체 도구가
공유하는 **재질(material)/변수(variable) 설정 데이터베이스**로, 물리적 파라미터 값은
담지 않고 이름·색상·라벨·분류(`group`) 같은 표시/설정용 메타데이터만 담는다 (근거:
`Utilities User Guide.pdf` Chapter 1 "The File datexcodes.txt").

- **파일 구조**: header(4줄) + `Materials { ... }` 섹션 + `Variables { ... }` 섹션.
- **Materials 필드**: `label`(표시 이름), `color`, `alter1`/`alter2`(SUPREM-4 변환용 별칭),
  그리고 **`group`**(재질 분류: `Semiconductor` / `Conductor` / `Insulator` / `All`,
  기본값 `All`).
- **탐색 우선순위**: `$STROOT_LIB/datexcodes.txt`(최저) → `$HOME/datexcodes.txt`(중간)
  → 실행 디렉터리의 로컬 `datexcodes.txt`(최고, 앞선 정의를 override/추가). SDEVICE를
  실제로 실행하는 디렉터리가 이 프로젝트의 `commands/` 하위라면, `commands/datexcodes.txt`가
  Synopsys 기본값보다 우선 적용된다.

**중요 — `group` 설정이 SDEVICE 물리 모델 체크에 직접 영향을 준다**: SDEVICE User
Guide(`manual/sdevice/02_Specifying_Physical_Devices.md` Table 4, "Undefined Physical
Models")에 따르면 `Auger`/`DopingDependence`/`Scharfetter`/`ConstantMobility` 같은
critical model은 **`group`이 Semiconductor인 재질에서만** 파라미터 정의 여부를 체크한다.
과거(2026-08-17, `runs/nand_erase_GIDL-HCI/0001_gidl_hci_no_trapping.md` 참고) 이 로컬
`datexcodes.txt`가 `Nitride, Si3N4`을 `group = Semiconductor`로, `Oxide, SiO2`를
`group = Insulator`로 명시하고 있어서 Si3N4 관련 `UNDEFINED model` 에러의 원인이 된 적이
있다.

**단, `datexcodes.txt`는 사용자가 언제든 고쳐 쓸 수 있는 평문 파일이다.** 2026-08-22
한 시점에는 `commands/datexcodes.txt`가 비어 있었다가(0바이트), 같은 날 사용자가 다시
채워 넣어 지금은 아래 내용으로 확인됨 (2026-08-22 기준):

```
Materials {
    Nitride, Si3N4 { group = Semiconductor ... }
    Oxide, SiO2    { group = Insulator ... }
    PolySi, PolySilicon { group = Semiconductor ... }
}
```

즉 위 "Nitride=Semiconductor / Oxide=Insulator" 서술과 지금 일치하고, PolySi(채널
material)도 Semiconductor로 명시돼 있다. 다만 이 파일은 언제든 다시 바뀔 수 있으므로,
커맨드에서 Si3N4/SiO2/PolySi 등 특정 material에 Recombination/Mobility 모델을(global이든
material-specific이든) 지정하기 전에는 이 기록을 그대로 믿지 말고 매번 `Read`로
`commands/datexcodes.txt`의 실제 현재 내용을 먼저 확인한다 — 비어 있다면 로컬 override가
없다는 뜻이므로 `$STROOT_LIB`/`$HOME` 기본값의 `group` 분류가 그대로 적용된다.
