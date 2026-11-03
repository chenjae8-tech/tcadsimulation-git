; =====================================================================
; SDE 스크립트 - NAND_BASE (기준 구조, Air Gap 없음)
; 작성: 2026-10-27
;
; 역할: NAND_BASE.sat(GUI로 그린 구조)을 로드해서 도핑 + 메시를 입히고
;       NAND_BASE_msh.tdr을 만든다. 기하는 전혀 건드리지 않는다.
;
; 왜 이 스크립트가 필요한가:
;   원래는 GUI에서 도핑/메시를 직접 찍어 넣으셨는데, 그러면 Air Gap 구조
;   (NAND_AIR)와 "똑같은 조건"인지 보장할 수 없다. 두 구조를 같은 스크립트
;   계열로 만들어야 (a) vs (b) 비교에서 도핑/메시 차이가 결과 차이로
;   오해되지 않는다. 도핑값과 refinement는 원본 GUI가 만든
;   _reference_msh.cmd에서 그대로 가져왔다.
;
; [구조 - NAND_BASE.sat에서 직접 읽어낸 값, 11 x 5 = 55 region, 단위 um]
;   y 0.023~0.050 (27nm) : Tungsten(게이트 5개) / Oxide(IGS 공간 6개)
;   y 0.016~0.023 ( 7nm) : Oxide   - BOX (블록 산화막)
;   y 0.012~0.016 ( 4nm) : Si3N4   - CT  (트랩 질화막)
;   y 0.007~0.012 ( 5nm) : Oxide   - TOX (터널 산화막)
;   y 0.000~0.007 ( 7nm) : PolySi  - 채널 (region_1_b0 ~ region_11_b0)
;
;   x 배치 (게이트 25nm / 간격 15nm), 드레인이 왼쪽:
;     0.000~0.015 Drain (region_1_b0, N+)    0.015~0.040 게이트1 = DSL
;     0.040~0.055 IGS1                       0.055~0.080 게이트2 = WL3
;     0.080~0.095 IGS2                       0.095~0.120 게이트3 = WL2 (가운데)
;     0.120~0.135 IGS3                       0.135~0.160 게이트4 = WL1
;     0.160~0.175 IGS4                       0.175~0.200 게이트5 = SSL
;     0.200~0.215 Source (region_11_b0, N+)
;
;   전극(.sat에 저장돼 있음): Source, Drain, SSL, WL1, WL2, WL3, DSL
;   (2026-10-27 .sat의 2d-contact 속성을 edge 단위로 추적해 확정. SDE GUI가 도핑
;    placement에 붙인 이름 "..._source"는 왼쪽 region_1_b0을 가리키지만, 실제
;    Source 전극은 오른쪽 끝(x=0.215)이다. 양 끝 모두 N+ 1e20이라 도핑은 무관.)
;
; [실행] 이 폴더의 파일을 전부 리눅스 작업 폴더에 넣고:
;          sde -l NAND_BASE.scm
;        결과: NAND_BASE_msh.tdr
; =====================================================================

(sde:clear)

; "ABA" = new replaces old (manual/sde/A_Appendix_A_Commands.md 5780번째 줄)
(sdegeo:set-default-boolean "ABA")

; 구조 로드. part:load와 달리 sde:load-sat은 Boolean 설정에 따라 겹침을
; 올바르게 처리함 (같은 매뉴얼 8232번째 줄).
; 재질 / region 이름 / 전극은 .sat에 들어있어 그대로 따라온다 (도핑은 없음).
(sde:load-sat "NAND_BASE.sat")

; ---------------------------------------------------------------------
; 1. 도핑 프로파일 - _reference_msh.cmd와 완전히 동일한 값/배치
; ---------------------------------------------------------------------
; Source/Drain: Phosphorus 1e20 (N+), 채널: Boron 1e17 (P)
(sdedr:define-constant-profile "ConstantProfileDefinition_sd" "PhosphorusActiveConcentration" 1e20)
(sdedr:define-constant-profile "ConstantProfileDefinition_ch" "BoronActiveConcentration"      1e17)

; 채널 층 11개 region 중 양 끝이 S/D, 가운데 9개가 채널
(sdedr:define-constant-profile-region "ConstantProfilePlacement_source" "ConstantProfileDefinition_sd" "region_1_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_drain"  "ConstantProfileDefinition_sd" "region_11_b0")

(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch1" "ConstantProfileDefinition_ch" "region_2_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch2" "ConstantProfileDefinition_ch" "region_3_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch3" "ConstantProfileDefinition_ch" "region_4_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch4" "ConstantProfileDefinition_ch" "region_5_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch5" "ConstantProfileDefinition_ch" "region_6_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch6" "ConstantProfileDefinition_ch" "region_7_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch7" "ConstantProfileDefinition_ch" "region_8_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch8" "ConstantProfileDefinition_ch" "region_9_b0")
(sdedr:define-constant-profile-region "ConstantProfilePlacement_ch9" "ConstantProfileDefinition_ch" "region_10_b0")

; ---------------------------------------------------------------------
; 2. 메시 refinement - _reference_msh.cmd와 동일
; ---------------------------------------------------------------------
; 원본 RefinementDefinition_1: Max (0.0005 0.0005) / Min (0.0001 0.0001)
; 인자 순서는 (definition-name max-x max-y [max-z] min-x min-y [min-z]) -
; 2D라서 z를 생략한 4개 값 (매뉴얼 13613번째 줄).
(sdedr:define-refinement-size "RefinementDefinition_1" 0.0005 0.0005 0.0001 0.0001)

; 원본은 하나의 placement 안에 RefineWindow를 material Oxide / Si3N4 두 줄로
; 넣었는데, Scheme의 sdedr:define-refinement-material은 placement당 material이
; 하나라서(매뉴얼 13447번째 줄) 나눠서 선언한다. 효과는 동일.
(sdedr:define-refinement-material "RefinementPlacement_1" "RefinementDefinition_1" "Oxide")
(sdedr:define-refinement-material "RefinementPlacement_2" "RefinementDefinition_1" "Si3N4")

; ---------------------------------------------------------------------
; 3. 메시 생성
; ---------------------------------------------------------------------
; (sde:build-mesh file-basename) -> file-basename_bnd.tdr + file-basename_msh.cmd
; 를 만들고 Sentaurus Mesh를 호출 (매뉴얼 6150/6175번째 줄).
; 최종 메시: NAND_BASE_msh.tdr
(sde:build-mesh "NAND_BASE")
