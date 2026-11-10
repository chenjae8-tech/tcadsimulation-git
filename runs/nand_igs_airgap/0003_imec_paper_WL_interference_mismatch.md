# RUN 0003 — IMEC 논문 리뷰: "WL-WL interference" 지표가 지금까지의 테스트와 다름 (중요, 방향 수정)

- **날짜**: 2026-11-10
- **참고 논문**: `reference/논문/Hole-Side_Airgap_Integration_as_Enabler_for_3D_NAND_Flash_Z-Pitch_Scaling.pdf`
  (S. Rachidi et al., imec, IMW 2025)

## 배경

사용자가 2026-11-03 세션(미기록)에서 "C2C 개선 효과가 없다"고 들었고, 이 논문을 근거로
"수정이 필요하다"는 얘기를 들었다고 함. 오늘 세션에서 RUN 0002(BASE vs AIR PGM 펄스
비교)로 이웃 셀 크로스토크를 쟀을 때도 BASE·AIR 간 차이가 거의 없었음 — 사용자가
"PGM을 잘못한 거 아니냐"고 의심해서 재검증(펄스 전/후 변화량 비교로 버그 아님을 확인,
0002 참고). 그 뒤 "논문의 WL간 간섭 50% 개선과 비교해보자"는 요청으로 논문을 직접 읽음.

## 핵심 발견 — 논문의 "WL-WL interference"는 우리가 잰 지표와 다른 물리량

**논문(Fig. 3~5) 측정 방법**: CG(=이 실험의 Sel=WL2)에 read Id-Vg 스윕을 걸되, **이웃 게이트
Vpass를 3~7V로 바꿔가며 반복 측정**. 비교 지표는 "Vpass가 바뀔 때 CG 자신의 read Vt가
얼마나 흔들리는지"(논문 표현: "VT shift analogous to short channel effect"). AG 없음은
Vpass 3→7V에서 Vt가 크게 이동(Fig.5(a), 그래프 눈대중 약 -2V→-8V), AG 있음은 훨씬
덜 움직이고 고전압에서 saturate(Fig.5(b), 약 -1V→-2~-3V). **본문에 "50%"라는 숫자가
명시돼 있지는 않음** — Fig.4/5 그래프로만 제시됨. 정확한 메커니즘(본문 설명): AG가
이웃 게이트→채널 간 정전용량 결합(fringing field)을 줄여서, Vpass 레벨 자체가 Sel 채널
포텐셜에 미치는 영향을 줄이는 것.

**지금까지(RUN 0001/0002) 우리가 잰 것**: WL1/WL3(Pass)를 **처음부터 끝까지 고정 6V**로
두고, WL2에 18V PGM 펄스 1회를 줬을 때 "**이웃 셀에 전하가 얼마나 트랩되는지**"(크로스토크,
전하량 기준). PGM(프로그램) 상태 기준이고, Vpass를 변수로 다룬 적이 없음.

**결론**: 두 테스트는 완전히 다른 물리 현상이다.
- 논문: READ 시 이웃 게이트 **DC 전압 레벨**이 Sel 채널에 주는 **정전용량 결합** 영향
- 우리: PGM 시 Sel에 주입된 전하가 **이웃 셀 자체의 전하 트랩량**에 주는 영향

지금까지 돌린 커맨드는 WL1/WL3가 한 값(6V)으로 고정돼 있어 Vpass 의존성을 볼 수 있는
구조가 아니다. 즉 "C2C 개선 효과 없음"이라는 이전 결론은 AirGap이 실제로 효과가 없어서가
아니라, **논문이 측정한 효과 자체를 우리가 테스트한 적이 없었기 때문**일 가능성이 높다.

## 다음 액션

- [ ] 논문 Fig.4/5와 동일한 비교를 위한 새 테스트 설계: WL2(Sel) read Id-Vg 스윕을
      WL1/WL3 Vpass = 4V/5V/6V/7V 각각 고정해서 반복 (BASE·AIR 각 4회, 총 8런)
- [ ] 각 Vpass에서 WL2 read Vt 추출 → Vt vs Vpass 커브를 BASE/AIR로 비교
      (ΔVt_total = Vt(Vpass=7V) - Vt(Vpass=4V) 를 두 구조에서 비교하는 게 논문 재현에 해당)
- [ ] 기존 `NAND_BASE_pgm.cmd`/`NAND_AIR_pgm.cmd`의 S0 read 구간(10~33us, WL2 -7→12V 스윕)
      구조를 재활용하되 WL1/WL3 전압을 파라미터화한 새 커맨드 작성 필요 — 아직 작성 전
