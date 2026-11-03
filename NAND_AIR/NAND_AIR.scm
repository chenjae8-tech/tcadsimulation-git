; =====================================================================
; SDE 스크립트 - NAND_AIR (IMEC형 IGS Air Gap 구조)
; 작성: 2026-10-27
;
; 역할: NAND_BASE.sat(기준 구조)을 로드해서 게이트 사이에 Air Gap을 넣고,
;       NAND_BASE와 "완전히 동일한" 도핑/메시를 입혀 NAND_AIR_msh.tdr을 만든다.
;
; NAND_BASE.scm과 다른 점은 딱 두 군데뿐이다:
;   (1) 아래 "1. IGS Air Gap 생성" 블록 4줄
;   (2) refinement에 AirGap material 한 줄 추가
;   (3) 출력 이름 NAND_BASE -> NAND_AIR
; 그 외 도핑값/메시크기는 글자 하나까지 같게 맞췄다. (a) vs (b) 비교에서
; Air Gap 외의 변수가 섞이면 안 되기 때문이다.
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
;     0.040~0.055 IGS1 <- Air Gap            0.055~0.080 게이트2 = WL3
;     0.080~0.095 IGS2 <- Air Gap            0.095~0.120 게이트3 = WL2 (가운데)
;     0.120~0.135 IGS3 <- Air Gap            0.135~0.160 게이트4 = WL1
;     0.160~0.175 IGS4 <- Air Gap            0.175~0.200 게이트5 = SSL
;     0.200~0.215 Source (region_11_b0, N+)
;   (2026-10-27 .sat의 2d-contact 속성을 edge 단위로 추적해 확정)
;
;   전극(.sat에 저장돼 있음): Source, Drain, SSL, WL1, WL2, WL3, DSL
;
; [Air Gap 설계값]
;   위치 : 게이트 사이 4곳 전부 (양 끝 space 2곳은 제외)
;   형상 : IGS 공간의 BOX 쪽(아래쪽) 절반 13.5nm만 공기로 치환,
;          위쪽 절반은 산화막 유지 -> IMEC IGS AG 단면 개념도와 동일한 배치
;
; [선행 조건 - 반드시 먼저]
;   같은 폴더의 datexcodes.txt에 "AirGap"이 group=Insulator로 선언돼 있어야 한다
;   (manual/sdevice/02_Specifying_Physical_Devices.md "User-Defined Materials").
;   이 폴더의 datexcodes.txt에는 이미 넣어뒀다. 없으면 unknown material로 실패.
;
; [실행] 이 폴더의 파일을 전부 리눅스 작업 폴더에 넣고:
;          sde -l NAND_AIR.scm
;        결과: NAND_AIR_msh.tdr
; =====================================================================

(sde:clear)

; "ABA" = new replaces old (manual/sde/A_Appendix_A_Commands.md 5780번째 줄).
; 나중에 그린 AirGap이 그 자리의 IGS 산화막을 치환하게 하려면 .sat 로드 "전에"
; 켜져 있어야 한다.
(sdegeo:set-default-boolean "ABA")

; 기준 구조 로드 (NAND_BASE와 똑같은 .sat을 쓴다)
(sde:load-sat "NAND_BASE.sat")

; ---------------------------------------------------------------------
; 1. IGS Air Gap 생성  <<< NAND_BASE.scm과 다른 부분 (1/3)
;    게이트 사이 4곳, BOX에 접하는 아래쪽 절반
; ---------------------------------------------------------------------
(define y_gl 0.023)                           ; 게이트 층 바닥 (= BOX 상단)
(define y_gt 0.050)                           ; 게이트 층 천장
(define y_ag (+ y_gl (/ (- y_gt y_gl) 2)))    ; 0.0365 - Air Gap 상단 (높이 13.5nm)

(sdegeo:create-rectangle (position 0.040 y_gl 0) (position 0.055 y_ag 0) "AirGap" "R.AirGap1")
(sdegeo:create-rectangle (position 0.080 y_gl 0) (position 0.095 y_ag 0) "AirGap" "R.AirGap2")
(sdegeo:create-rectangle (position 0.120 y_gl 0) (position 0.135 y_ag 0) "AirGap" "R.AirGap3")
(sdegeo:create-rectangle (position 0.160 y_gl 0) (position 0.175 y_ag 0) "AirGap" "R.AirGap4")

; 기하만 먼저 눈으로 확인하고 싶을 때 쓰는 중간 산출물.
; 원본 NAND_BASE.sat은 건드리지 않는다.
(part:save "NAND_AIR.sat")

; ---------------------------------------------------------------------
; 2. 도핑 프로파일 - NAND_BASE.scm과 완전히 동일
; ---------------------------------------------------------------------
; Source/Drain: Phosphorus 1e20 (N+), 채널: Boron 1e17 (P)
(sdedr:define-constant-profile "ConstantProfileDefinition_sd" "PhosphorusActiveConcentration" 1e20)
(sdedr:define-constant-profile "ConstantProfileDefinition_ch" "BoronActiveConcentration"      1e17)

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
; 3. 메시 refinement - NAND_BASE.scm과 동일 + AirGap 한 줄 추가
; ---------------------------------------------------------------------
(sdedr:define-refinement-size "RefinementDefinition_1" 0.0005 0.0005 0.0001 0.0001)

(sdedr:define-refinement-material "RefinementPlacement_1" "RefinementDefinition_1" "Oxide")
(sdedr:define-refinement-material "RefinementPlacement_2" "RefinementDefinition_1" "Si3N4")

; <<< NAND_BASE.scm과 다른 부분 (2/3)
; AirGap 자리는 원래 Oxide라서 NAND_BASE에서는 0.5nm 메시가 들어가던 영역이다.
; 여기만 성글어지면 (a)/(b) 비교에서 메시 차이가 결과 차이로 오해될 수 있으므로
; 반드시 같은 refinement로 묶는다.
(sdedr:define-refinement-material "RefinementPlacement_3" "RefinementDefinition_1" "AirGap")

; ---------------------------------------------------------------------
; 4. 메시 생성  <<< NAND_BASE.scm과 다른 부분 (3/3) - 출력 이름만 다름
; ---------------------------------------------------------------------
; 최종 메시: NAND_AIR_msh.tdr
(sde:build-mesh "NAND_AIR")
