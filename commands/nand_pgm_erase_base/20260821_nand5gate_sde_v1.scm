; =====================================================================
; Synopsys Sentaurus Structure Editor (SDE) 스크립트
; 대상 소자: Cylindrical(원통형, macaroni) 최소단위 NAND 스트링, x=0 축대칭
; 게이트 스택(하단->상단): SG(Source Gate) - WL_PASS - WL_SEL - WL_PASS - DG(Drain Gate)
; 접합: 최하단 SL, 최상단 BL. WL_PASS는 두 물리적 게이트(Pass1/Pass2)를 하나의
;   컨택 이름으로 묶음 (같은 전압으로 동시 인가) - nand_erase_GIDL-HCI의 SGDW/SGUP
;   컨택 그룹핑과 동일한 방식.
;
; 기하 파라미터(rf/tch/tox/tni/tbox/Lg/Ls/Lj)와 도핑 농도(Boron 1e14 채널,
; Arsenic 1e20 SL/BL 접합)는 nand_pgm_EPEP, nand_erase_GIDL-HCI 두 기존 실험과
; 동일한 값을 재사용함 (사용자 요청: "도핑 농도는 다른 파일과 동일하게").
;
; Cylindrical 좌표계 활성화는 SDE가 아니라 SDEVICE .cmd의 Math{} 섹션에서
; `Cylindrical(xAxis=0.0)`으로 함 (manual/sdevice/01_Introduction_to_Sentaurus_Device.md
; "Cylindrical Coordinate System" 섹션). 이 구조의 x0=0.0(R.Filler 안쪽 시작점)이
; 그 축 위치와 일치하도록 기하를 잡았고, 어떤 Contact도 x=0에 걸리지 않음
; (SL/BL은 x1~x2 부근, 게이트들은 x6) - 매뉴얼의 "No contacts should be aligned
; to the cylindrical z-axis" 경고에 위배되지 않음.
; =====================================================================

(sde:clear)
(sde:set-process-up-direction "+y")

; ---------------------------------------------------------------------
; 1. 기하 구조 파라미터 정의 (기존 실험과 동일 값, 단위: um)
; ---------------------------------------------------------------------
(define rf 0.025)     ; Filler 반지름 (25nm) - 이 안쪽이 원통 중심축(x=0)
(define tch 0.008)    ; Channel 두께 (8nm)
(define tox 0.005)    ; Tunnel Ox 두께 (5nm)
(define tni 0.005)    ; Trap Nitride 두께 (5nm)
(define tbox 0.007)   ; Block Ox 두께 (7nm)
(define Lg 0.025)     ; Gate Length (25nm)
(define Ls 0.020)     ; Gate Space (20nm)
(define Lj 0.020)     ; Junction Length (20nm)

; X 축 좌표 (반지름 방향, x0=0이 원통 중심축)
(define x0 0.0)
(define x1 rf)                   ; 0.025 (Filler/Channel 경계)
(define x2 (+ x1 tch))           ; 0.033 (Channel/TunnelOx 경계)
(define x3 (+ x2 tox))           ; 0.038 (TunnelOx/TrapNi 경계)
(define x4 (+ x3 tni))           ; 0.043 (TrapNi/BlockOx 경계)
(define x5 (+ x4 tbox))          ; 0.050 (BlockOx/GateIsolation 경계)
(define x6 (+ x5 0.010))         ; 0.060 (게이트 전극 바깥쪽 끝)

; Y 축 좌표 (채널 길이 방향, 하단->상단): SL - SG - Pass1 - SEL - Pass2 - DG - BL
(define y0  0.0)                 ; SL 접합 시작
(define y1  (+ y0  Lj))          ; 0.020  SL 접합 끝 / SG 시작
(define y2  (+ y1  Lg))          ; 0.045  SG 끝
(define y3  (+ y2  Ls))          ; 0.065  Space / WL_Pass1 시작
(define y4  (+ y3  Lg))          ; 0.090  WL_Pass1 끝
(define y5  (+ y4  Ls))          ; 0.110  Space / WL_SEL 시작
(define y6  (+ y5  Lg))          ; 0.135  WL_SEL 끝
(define y7  (+ y6  Ls))          ; 0.155  Space / WL_Pass2 시작
(define y8  (+ y7  Lg))          ; 0.180  WL_Pass2 끝
(define y9  (+ y8  Ls))          ; 0.200  Space / DG 시작
(define y10 (+ y9  Lg))          ; 0.225  DG 끝
(define y11 (+ y10 Lj))          ; 0.245  BL 접합 끝
(define y_top y11)

; ---------------------------------------------------------------------
; 2. 소자 영역(Region) 및 물질(Material) 생성
; ---------------------------------------------------------------------
(sdegeo:set-default-boolean "ABA")

; 중심 Filler (원통 중심축 포함, 절연물로 채움)
(sdegeo:create-rectangle (position x0 y0 0) (position x1 y_top 0) "SiO2" "R.Filler")

; --- R.Channel, R.TunnelOx: WL_SEL 구간(y5~y6)만 따로 분리 (트랩/터널링 국소 추출용) ---
(sdegeo:create-rectangle (position x1 y0 0) (position x2 y5 0)    "PolySi" "R.Channel_Below")
(sdegeo:create-rectangle (position x1 y5 0) (position x2 y6 0)    "PolySi" "R.Channel_Sel")
(sdegeo:create-rectangle (position x1 y6 0) (position x2 y_top 0) "PolySi" "R.Channel_Above")

(sdegeo:create-rectangle (position x2 y0 0) (position x3 y5 0)    "SiO2" "R.TunnelOx_Below")
(sdegeo:create-rectangle (position x2 y5 0) (position x3 y6 0)    "SiO2" "R.TunnelOx_Sel")
(sdegeo:create-rectangle (position x2 y6 0) (position x3 y_top 0) "SiO2" "R.TunnelOx_Above")

(sdegeo:create-rectangle (position x3 y0 0) (position x4 y_top 0) "Si3N4" "R.TrapNi")
(sdegeo:create-rectangle (position x4 y0 0) (position x5 y_top 0) "SiO2" "R.BlockOx")

; 게이트 분리 절연막 (Outer Isolation)
(sdegeo:create-rectangle (position x5 y0 0) (position x6 y_top 0) "SiO2" "R.GateIsolation")

; 게이트 전극 5단: SG - WL_Pass1 - WL_Sel - WL_Pass2 - DG
(sdegeo:create-rectangle (position x5 y1 0) (position x6 y2 0) "Tungsten" "R.SG")
(sdegeo:create-rectangle (position x5 y3 0) (position x6 y4 0) "Tungsten" "R.WL_Pass1")
(sdegeo:create-rectangle (position x5 y5 0) (position x6 y6 0) "Tungsten" "R.WL_Sel")
(sdegeo:create-rectangle (position x5 y7 0) (position x6 y8 0) "Tungsten" "R.WL_Pass2")
(sdegeo:create-rectangle (position x5 y9 0) (position x6 y10 0) "Tungsten" "R.DG")

; ---------------------------------------------------------------------
; 3. 전극(Contact) 정의 및 안전 할당
; ---------------------------------------------------------------------
; SL Contact (하단 접합)
(sdegeo:define-contact-set "SL" 4 (color:rgb 1 0 0) "##")
(sdegeo:set-current-contact-set "SL")
(sdegeo:set-contact-edges (find-edge-id (position (/ (+ x1 x2) 2) y0 0)) "SL")

; BL Contact (상단 접합)
(sdegeo:define-contact-set "BL" 4 (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "BL")
(sdegeo:set-contact-edges (find-edge-id (position (/ (+ x1 x2) 2) y_top 0)) "BL")

; SG (Source Gate) Contact
(sdegeo:define-contact-set "SG" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-current-contact-set "SG")
(sdegeo:set-contact-edges (find-edge-id (position x6 (/ (+ y1 y2) 2) 0)) "SG")

; WL_PASS Contact (Pass1 + Pass2 두 물리 게이트를 하나의 컨택으로 묶음)
(sdegeo:define-contact-set "WL_PASS" 4 (color:rgb 0 1 1) "##")
(sdegeo:set-current-contact-set "WL_PASS")
(sdegeo:set-contact-edges (find-edge-id (position x6 (/ (+ y3 y4) 2) 0)) "WL_PASS")
(sdegeo:set-contact-edges (find-edge-id (position x6 (/ (+ y7 y8) 2) 0)) "WL_PASS")

; WL_SEL Contact (PGM/Erase 인가 전극)
(sdegeo:define-contact-set "WL_SEL" 4 (color:rgb 1 1 0) "##")
(sdegeo:set-current-contact-set "WL_SEL")
(sdegeo:set-contact-edges (find-edge-id (position x6 (/ (+ y5 y6) 2) 0)) "WL_SEL")

; DG (Drain Gate) Contact
(sdegeo:define-contact-set "DG" 4 (color:rgb 0.5 0.5 0.5) "##")
(sdegeo:set-current-contact-set "DG")
(sdegeo:set-contact-edges (find-edge-id (position x6 (/ (+ y9 y10) 2) 0)) "DG")

; Contact 활성화 (nand35tier 관례와 동일하게 마지막에 한 번 더 재확인)
(sdegeo:set-current-contact-set "SL")
(sdegeo:set-current-contact-set "BL")
(sdegeo:set-current-contact-set "SG")
(sdegeo:set-current-contact-set "WL_PASS")
(sdegeo:set-current-contact-set "WL_SEL")
(sdegeo:set-current-contact-set "DG")

; ---------------------------------------------------------------------
; 4. 도핑 프로파일 (Doping Profile) - 기존 실험과 동일 농도
; ---------------------------------------------------------------------
; 채널 기본 P-type 도핑 (Boron 1e14) - Channel이 3구간으로 나뉘어 각각 적용
(sdedr:define-constant-profile "Prof.Channel" "BoronActiveConcentration" 1e14)
(sdedr:define-constant-profile-region "Place.Channel.Below" "Prof.Channel" "R.Channel_Below")
(sdedr:define-constant-profile-region "Place.Channel.Sel"   "Prof.Channel" "R.Channel_Sel")
(sdedr:define-constant-profile-region "Place.Channel.Above" "Prof.Channel" "R.Channel_Above")

; SL Junction N+ 고농도 도핑 (Arsenic 1e20, y0~y1)
(sdedr:define-refeval-window "Win.SL" "Rectangle" (position x1 y0 0) (position x2 y1 0))
(sdedr:define-constant-profile "Prof.Junction.SL" "ArsenicActiveConcentration" 1e20)
(sdedr:define-constant-profile-placement "Place.SL" "Prof.Junction.SL" "Win.SL")

; BL Junction N+ 고농도 도핑 (Arsenic 1e20, y10~y11)
(sdedr:define-refeval-window "Win.BL" "Rectangle" (position x1 y10 0) (position x2 y11 0))
(sdedr:define-constant-profile "Prof.Junction.BL" "ArsenicActiveConcentration" 1e20)
(sdedr:define-constant-profile-placement "Place.BL" "Prof.Junction.BL" "Win.BL")

; ---------------------------------------------------------------------
; 5. 매쉬 제어 (Mesh Refinement) - WL_SEL 주변만 밀도 있게, 전체는 가볍게
; ---------------------------------------------------------------------
; 전체 채널 기본 메쉬 (가벼운 값 - nand_pgm_EPEP v3에서 실행시간 문제로 완화된 값과 동일)
(sdedr:define-refinement-size "Ref.Global" 0.005 0.010 0.002 0.004)
(sdedr:define-refinement-region "Place.GlobalChannel.Below" "Ref.Global" "R.Channel_Below")
(sdedr:define-refinement-region "Place.GlobalChannel.Sel"   "Ref.Global" "R.Channel_Sel")
(sdedr:define-refinement-region "Place.GlobalChannel.Above" "Ref.Global" "R.Channel_Above")

; WL_SEL 주변(이전 게이트 끝 y4 ~ 다음 게이트 시작 y7) 집중 메쉬 - PGM/Erase 비교의 핵심 구간
(sdedr:define-refeval-window "Win.SelFocus" "Rectangle" (position x1 y4 0) (position x5 y7 0))
(sdedr:define-refinement-size "Ref.SelFocus" 0.0005 0.002 0.0003 0.001)
(sdedr:define-refinement-placement "Place.SelFocus" "Ref.SelFocus" "Win.SelFocus")

; 채널/TunnelOx 계면(x2) 주변 - WL_SEL 구간만 국한해서 표면 메쉬 추가 정밀화
(sdedr:define-refeval-window "Win.ChannelSurfaceSel" "Rectangle"
  (position (- x2 0.002) y4 0) (position (+ x2 0.002) y7 0))
(sdedr:define-refinement-size "Ref.ChannelSurfaceSel" 0.001 0.002 0.0005 0.001)
(sdedr:define-refinement-placement "Place.ChannelSurfaceSel" "Ref.ChannelSurfaceSel" "Win.ChannelSurfaceSel")

; TrapNi(질화막) - WL_SEL 구간만 국소 정밀화 (트랩 분포 비교의 핵심 데이터)
(sdedr:define-refeval-window "Win.TrapNiFocus" "Rectangle" (position x3 y4 0) (position x4 y7 0))
(sdedr:define-refinement-size "Ref.TrapNiFocus" 0.001 0.010 0.0005 0.002)
(sdedr:define-refinement-placement "Place.TrapNiFocus" "Ref.TrapNiFocus" "Win.TrapNiFocus")

; ---------------------------------------------------------------------
; 6. TDR/메쉬 생성
; ---------------------------------------------------------------------
(sde:build-mesh "nand5gate_msh")
