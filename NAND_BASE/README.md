# NAND_BASE — 기준 구조 (a) Air Gap 없음

게이트 사이가 전부 산화막(IGS 산화막)으로 채워진 원래 구조.
Air Gap 구조(`../NAND_AIR/`)와 비교할 때의 **기준선**이 된다.

## 파일

| 파일 | 리눅스로 올리기 | 설명 |
|---|---|---|
| `NAND_BASE.sat` | ⬆️ **필요** | 구조 원본 (SDE GUI로 그린 것, 55개 영역) |
| `NAND_BASE.scm` | ⬆️ **필요** | SDE 스크립트 — 구조 로드 + 도핑 + 메시 |
| `NAND_BASE.cmd` | ⬆️ **필요** | SDEVICE 커맨드 — 0V 평형 해석 (구조 점검용) |
| `NAND_BASE_pgm.cmd` | ⬆️ **필요** | SDEVICE 커맨드 — **PGM 검증런** (단일 펄스 + 전후 read) |
| `datexcodes.txt` | ⬆️ **필요** | 재질 분류 정의 (SDE/SDEVICE 둘 다 읽음) |
| `models_jh.par` | ⬆️ **필요** | 물리 모델 파라미터 |
| `_reference_msh.cmd` | ❌ 안 올림 | GUI가 만들었던 원본 메시 커맨드 (참고용) |
| `_reference_gui_session.scm` | ❌ 안 올림 | GUI 세션 저장 파일, 기하 정보 없음 (참고용) |

`_reference_`로 시작하는 파일은 **올리지 마세요.** 기록용이고, 내용은 이미
`NAND_BASE.scm` 안에 반영돼 있습니다.

## 실행 순서

리눅스 작업 폴더에 위 5개 파일을 넣고:

```bash
# 1) 구조 + 도핑 + 메시 생성  ->  NAND_BASE_msh.tdr
sde -l NAND_BASE.scm

# 2) 구조 눈으로 확인 (게이트 사이가 전부 산화막이어야 함)
svisual NAND_BASE_msh.tdr &

# 3) 0V 평형 해석 (구조/도핑이 제대로 들어갔는지 빠르게 점검)
sdevice NAND_BASE.cmd

# 4) 결과 확인
svisual NAND_BASE_des.tdr &

# 5) PGM 검증런 (단일 펄스 18V + 전후 read)
sdevice NAND_BASE_pgm.cmd

# 6) 판정 — .plt 의 Sel eTrappedCharge 가 PGM 구간(33~58us)에 올라갔는지
inspect NAND_BASE_pgm_des.plt &
```

PGM 검증런 판정 기준은 `NAND_BASE_pgm.cmd` 헤더 주석 참고.
점유율 분모: `eTrappedCharge` → Tacc 1.003e20 cm⁻³, `hTrappedCharge` → Tdon 6.267e19 cm⁻³.

## 구조 정보 (NAND_BASE.sat에서 직접 읽어낸 값, 단위 µm)

세로 적층 (아래 → 위):

| y 범위 | 두께 | 재질 | 역할 |
|---|---|---|---|
| 0.023 – 0.050 | 27nm | Tungsten / Oxide | 게이트(WL) / IGS 산화막 |
| 0.016 – 0.023 | 7nm | Oxide | BOX (블록 산화막) |
| 0.012 – 0.016 | 4nm | Si3N4 | CT (트랩 질화막) |
| 0.007 – 0.012 | 5nm | Oxide | TOX (터널 산화막) |
| 0.000 – 0.007 | 7nm | PolySi | 채널 |

가로 배치 (게이트 25nm / 간격 15nm), **드레인이 왼쪽**:

| x 범위 | 내용 |
|---|---|
| 0.000 – 0.015 | **Drain** (N+ 1e20) |
| 0.015 – 0.040 | 게이트1 = **DSL** |
| 0.040 – 0.055 | IGS 1 |
| 0.055 – 0.080 | 게이트2 = **WL3** |
| 0.080 – 0.095 | IGS 2 |
| 0.095 – 0.120 | 게이트3 = **WL2** (가운데 — 선택 셀로 쓰기 좋음) |
| 0.120 – 0.135 | IGS 3 |
| 0.135 – 0.160 | 게이트4 = **WL1** |
| 0.160 – 0.175 | IGS 4 |
| 0.175 – 0.200 | 게이트5 = **SSL** |
| 0.200 – 0.215 | **Source** (N+ 1e20) |

도핑: 양 끝 = Phosphorus 1e20 (N+), 채널 = Boron 1e17
메시: Oxide / Si3N4 에 Max 0.5nm · Min 0.1nm

**전극 이름**: `Source`, `Drain`, `SSL`, `WL1`, `WL2`, `WL3`, `DSL`
→ SDEVICE `.cmd`의 Electrode 이름은 반드시 이것과 같아야 합니다.

> 위 배치는 `.sat`의 `2d-contact` 속성이 어느 edge에 붙어 있는지 직접 추적해서 확인한
> 값입니다 (2026-10-27). 주의: SDE GUI가 도핑 placement에 붙인 이름
> (`ConstantProfilePlacement_source` → `region_1_b0`, 즉 **왼쪽**)은 전극 이름과
> **반대**입니다. 양 끝 모두 같은 N+ 1e20이라 도핑에는 영향이 없지만, 전극 이름을
> 볼 때는 placement 이름이 아니라 위 표를 기준으로 삼을 것.

**region 이름 → 위치 대응** (PGM/Erase 커맨드에서 Region/RegionInterface를 쓸 때 필요):

| 층 | region 이름 |
|---|---|
| 채널 (y 0~0.007) | `region_1_b0` ~ `region_11_b0` (왼→오) |
| TOX (y 0.007~0.012) | `region_1_b1` ~ `region_11_b1` (왼→오) |
| CT Si3N4 (y 0.012~0.016) | `region_12` ~ `region_22` (왼→오) |
| BOX (y 0.016~0.023) | `region_23` ~ `region_33` (왼→오) |
| 게이트층 산화막 | `region_34`(왼끝), `region_35`~`region_38`(IGS 1~4), `region_39`(오른끝) |
| 게이트 Tungsten | `region_40`(DSL), `41`(WL3), `42`(WL2), `43`(WL1), `44`(SSL) |

각 행의 11개 region은 x 구간 11개(0~0.015, 0.015~0.040, …, 0.200~0.215)와 같은 순서로
왼쪽부터 대응합니다. 예: WL2(가운데 게이트, x 0.095~0.120) 아래 질화막 = `region_17`,
그 아래 TOX = `region_6_b1`, 채널 = `region_6_b0`.
