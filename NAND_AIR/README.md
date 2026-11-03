# NAND_AIR — IGS Air Gap 구조 (b) IMEC형

게이트 사이 IGS 공간의 **아래쪽 절반(BOX에 접하는 쪽)** 을 공기(ε=1)로 바꾼 구조.
기준 구조는 `../NAND_BASE/`.

## 파일

| 파일 | 리눅스로 올리기 | 설명 |
|---|---|---|
| `NAND_BASE.sat` | ⬆️ **필요** | 구조 원본 — NAND_BASE 폴더와 **똑같은 파일**. AirGap은 이걸 불러와서 얹는다 |
| `NAND_AIR.scm` | ⬆️ **필요** | SDE 스크립트 — 구조 로드 + **Air Gap** + 도핑 + 메시 |
| `NAND_AIR.cmd` | ⬆️ **필요** | SDEVICE 커맨드 — 0V 평형 해석 (구조 점검용) |
| `NAND_AIR_pgm.cmd` | ⬆️ **필요** | SDEVICE 커맨드 — **PGM 검증런**. `NAND_BASE_pgm.cmd` 와 파일 이름 외에는 완전히 동일 |
| `datexcodes.txt` | ⬆️ **필요** | 재질 분류 — **AirGap이 추가된 버전** (NAND_BASE 것과 다름!) |
| `models_jh.par` | ⬆️ **필요** | 물리 파라미터 — **AirGap Epsilon=1.0이 추가된 버전** (NAND_BASE 것과 다름!) |

> ⚠️ `datexcodes.txt`와 `models_jh.par`는 NAND_BASE 폴더 것과 **내용이 다릅니다.**
> 반드시 이 폴더 것을 쓰세요. NAND_BASE 것을 가져다 쓰면 AirGap을 모르는 상태라
> `unknown material`로 실패합니다.

## 실행 순서

리눅스 작업 폴더(NAND_BASE와 **다른 폴더**)에 위 5개 파일을 넣고:

```bash
# 1) 구조 + Air Gap + 도핑 + 메시 생성  ->  NAND_AIR_msh.tdr
sde -l NAND_AIR.scm

# 2) 구조 눈으로 확인 ★ 여기서 Air Gap이 안 보이면 다음으로 넘어가지 말 것
svisual NAND_AIR_msh.tdr &

# 3) 0V 평형 해석
sdevice NAND_AIR.cmd

# 4) 결과 확인
svisual NAND_AIR_des.tdr &
```

**2번에서 확인할 것**: `Material`로 색칠해 보면 게이트 사이 4곳의 **아래쪽 절반**에
AirGap(연보라 `#e6e6fa`)이 보여야 합니다. 위쪽 절반은 산화막 그대로입니다.

## Air Gap 설계값

- **위치**: 게이트 사이 4곳 전부 (x = 0.040~0.055, 0.080~0.095, 0.120~0.135, 0.160~0.175)
  - 양 끝 space 2곳(Source/Drain 바깥쪽)은 제외
- **높이**: y = 0.023 → 0.0365 (13.5nm = 게이트 높이 27nm의 절반, BOX에 접함)
- **재질**: `AirGap` (사용자 정의, group=Insulator, ε=1.0)

## NAND_BASE와 다른 점은 딱 3군데

`NAND_AIR.scm` 안에 `<<< NAND_BASE.scm과 다른 부분` 주석으로 표시해뒀습니다:

1. Air Gap 사각형 4개 생성
2. refinement에 `AirGap` material 추가 — Air Gap 자리는 원래 Oxide라 기준 구조에선
   0.5nm 메시가 들어가던 영역이다. 여기만 성글어지면 **메시 차이가 Air Gap 효과로
   오해될 수 있어서** 반드시 같이 넣는다
3. 출력 이름 (`NAND_BASE` → `NAND_AIR`)

도핑값·메시 크기·`Physics`/`Math`/`Solve`는 글자 하나까지 동일합니다.
비교 실험에서 Air Gap 외의 변수가 섞이면 안 되기 때문입니다.

## 구조 정보

`../NAND_BASE/README.md` 참고 — 적층/배치/전극 이름은 완전히 같습니다.
전극: `Source`, `Drain`, `SSL`, `WL1`, `WL2`, `WL3`, `DSL`
