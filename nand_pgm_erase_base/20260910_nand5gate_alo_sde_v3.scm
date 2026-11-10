; =====================================================================
; Synopsys Sentaurus Structure Editor (SDE) 스크립트  [v3]
; 대상 소자: Cylindrical(원통형, macaroni) 최소단위 NAND 스트링, x=0 축대칭
; 게이트 스택(하단->상단): SG - WL_PASS(Pass1) - WL_SEL - WL_PASS(Pass2) - DG
;
; ---------------------------------------------------------------------
; [v2 대비 정정 — 알루미나의 형상]
;   v2에서는 Al2O3를 BlockOx 위에 얹은 **연속된 원통 껍질**(y 전 구간)로 만들었으나,
;   이는 잘못이다. 논문 Fig.1(a)를 확대해서 보면 알루미나는 **각 게이트(W)를
;   감싸는 라이너**다 - 게이트와 게이트 사이(spacer 구간)에는 알루미나가 없다.
;   실제 replacement-gate 공정과도 일치한다(희생층 제거 후 게이트 리세스에
;   Al2O3를 컨포멀 증착하고 그 안에 금속을 채움).
;
;   따라서 게이트 하나당 알루미나는 "ㄷ자" 라이너가 된다:
;     - 안쪽면(BlockOx를 마주보는 x5~x5a) : back-tunneling에 직접 관여하는 면
;     - 아래/위면(게이트 상하단, x5a~x6)   : 게이트 모서리를 감싸는 부분
;     - 바깥면(x6)은 덮지 않는다 -> 컨택이 금속에 직접 닿아야 하므로
;
;   [구현 방법] 알루미나 사각형을 게이트보다 talo만큼 크게(사방으로) 먼저 만들고,
;   그 위에 게이트 금속을 덮어씌우면 겹친 부분을 금속이 가져가면서 정확히
;   ㄷ자 라이너만 남는다. (SDE는 나중에 만든 리전이 겹침을 가져간다 - v1에서
;   R.GateIsolation이 게이트 5개에 의해 _lump_1~6으로 쪼개진 것이 그 증거)
;
;   [부수 이득] 알루미나가 게이트별로 분리된 리전이 되므로
;   `Region="R.AlO_Sel"` 처럼 **WL_SEL 위치만 골라서** 전계를 측정할 수 있다.
;   (v2의 연속 껍질에서는 5개 게이트가 한 리전이라 Window로 잘라야 했음)
; ---------------------------------------------------------------------
;
; [v1 대비 변경점 총괄]
;   블록옥사이드와 게이트 사이에 **Al2O3(알루미나) 3nm** 라이너를 추가.
;   근거: reference/2026_IEEE_TED_GIDL_... Table I (t_AlO = 3 nm) 및 Fig.1(a).
;   나머지 치수는 v1이 이미 논문과 완전히 일치한다:
;     Lg 25nm / Ls 20nm / O-N-O 5-5-7nm / tch 8nm / rf 25nm /
;     채널도핑 1e14 / SL-BL도핑 1e20  ... 전부 논문 Table I과 동일
;     Gate metal WF 4.5eV는 SDEVICE .cmd에서 지정
;     WL 개수만 27 -> 5로 의도적 단순화(실행시간)
;
; [재질 이름 주의] Al2O3는 Synopsys 기본 재질 DB에 **존재하지 않는다**
;   (HfO2는 있으나 알루미나는 없음 - models.par 전체 재질 목록으로 확인).
;   그래서 범용 절연체 슬롯 **"Insulator1"** 을 빌려 쓰고 유전율만 9로
;   덮어쓴다(model_parameter/20260910_models_v2.par).
;   => 이 구조를 쓰는 SDEVICE 커맨드는 반드시 20260910_models_v2.par 이상을
;      Parameter로 지정해야 한다. v1 .par로 돌리면 이 층이 그냥 SiO2(3.9)가 된다.
;
; [출력 파일명] v1이 만든 검증된 메시(sde_nand_5wl_msh.tdr)를 덮어쓰지 않도록
;   다른 이름으로 저장한다 -> sde_nand_5wl_alo_msh
;
; Cylindrical 좌표계 활성화는 SDEVICE .cmd의 Math{}에서 `Cylindrical(xAxis=0.0)`.
; 어떤 Contact도 x=0에 걸리지 않는다(SL/BL은 x1~x2, 게이트들은 x6).
; =====================================================================

(sde:clear)
(sde:set-process-up-direction "+y")

; ---------------------------------------------------------------------
; 1. 기하 구조 파라미터 정의 (단위: um)
; ---------------------------------------------------------------------
(define rf 0.025)     ; Filler 반지름 (25nm) - 이 안쪽이 원통 중심축(x=0)
(define tch 0.008)    ; Channel 두께 (8nm)
(define tox 0.005)    ; Tunnel Ox 두께 (5nm)
(define tni 0.005)    ; Trap Nitride 두께 (5nm)
(define tbox 0.007)   ; Block Ox 두께 (7nm)
(define talo 0.003)   ; Al2O3 라이너 두께 (3nm) - 논문 Table I
(define Lg 0.025)     ; Gate Length (25nm)
(define Ls 0.020)     ; Gate Space (20nm)
(define Lj 0.020)     ; Junction Length (20nm)

; X 축 좌표 (반지름 방향, x0=0이 원통 중심축)
(define x0 0.0)
(define x1 rf)                   ; 0.025 (Filler/Channel 경계)
(define x2 (+ x1 tch))           ; 0.033 (Channel/TunnelOx 경계)
(define x3 (+ x2 tox))           ; 0.038 (TunnelOx/TrapNi 경계)
(define x4 (+ x3 tni))           ; 0.043 (TrapNi/BlockOx 경계)
(define x5 (+ x4 tbox))          ; 0.050 (BlockOx/AlO라이너 경계)
(define x5a (+ x5 talo))         ; 0.053 (AlO라이너/게이트금속 경계)
(define x6 (+ x5a 0.010))        ; 0.063 (게이트 전극 바깥쪽 끝, 컨택 위치)

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

; 게이트 사이 간격(Ls=20nm)이 알루미나 두께(3nm)의 2배보다 충분히 크므로
; 이웃 게이트의 라이너끼리 붙지 않는다 (20 - 3 - 3 = 14nm의 절연막이 남음).

; ---------------------------------------------------------------------
; 2. 소자 영역(Region) 및 물질(Material) 생성
;    생성 순서가 중요: 나중에 만든 리전이 겹친 부분을 가져간다.
;    GateIsolation(전체) -> AlO(게이트보다 크게) -> 게이트 금속  순서로 덮어씀.
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

; 질화막(CTN)과 블록옥사이드는 채널홀에 컨포멀 증착되므로 y 전 구간 연속 - v1과 동일
(sdegeo:create-rectangle (position x3 y0 0) (position x4 y_top 0) "Si3N4" "R.TrapNi")
(sdegeo:create-rectangle (position x4 y0 0) (position x5 y_top 0) "SiO2"  "R.BlockOx")

; 게이트 바깥 영역을 우선 절연막으로 전부 채운다 (이후 AlO/금속이 덮어씀)
(sdegeo:create-rectangle (position x5 y0 0) (position x6 y_top 0) "SiO2" "R.GateIsolation")

; --- Al2O3 라이너: 게이트보다 사방으로 talo만큼 큰 사각형으로 먼저 깔고 ---
; (다음 단계에서 게이트 금속이 안쪽을 가져가면 ㄷ자 라이너만 남는다)
(sdegeo:create-rectangle (position x5 (- y1 talo) 0)  (position x6 (+ y2 talo) 0)  "Insulator1" "R.AlO_SG")
(sdegeo:create-rectangle (position x5 (- y3 talo) 0)  (position x6 (+ y4 talo) 0)  "Insulator1" "R.AlO_Pass1")
(sdegeo:create-rectangle (position x5 (- y5 talo) 0)  (position x6 (+ y6 talo) 0)  "Insulator1" "R.AlO_Sel")
(sdegeo:create-rectangle (position x5 (- y7 talo) 0)  (position x6 (+ y8 talo) 0)  "Insulator1" "R.AlO_Pass2")
(sdegeo:create-rectangle (position x5 (- y9 talo) 0)  (position x6 (+ y10 talo) 0) "Insulator1" "R.AlO_DG")

; --- 게이트 금속 5단: 라이너 안쪽(x5a부터)을 채운다. 바깥면(x6)은 컨택용으로 노출 ---
(sdegeo:create-rectangle (position x5a y1 0) (position x6 y2 0)  "Tungsten" "R.SG")
(sdegeo:create-rectangle (position x5a y3 0) (position x6 y4 0)  "Tungsten" "R.WL_Pass1")
(sdegeo:create-rectangle (position x5a y5 0) (position x6 y6 0)  "Tungsten" "R.WL_Sel")
(sdegeo:create-rectangle (position x5a y7 0) (position x6 y8 0)  "Tungsten" "R.WL_Pass2")
(sdegeo:create-rectangle (position x5a y9 0) (position x6 y10 0) "Tungsten" "R.DG")

; ---------------------------------------------------------------------
; 3. 전극(Contact) 정의 및 안전 할당
;    컨택은 x6(게이트 바깥면)에 붙는다. 위에서 금속이 x6까지 채워져 있고
;    알루미나는 바깥면을 덮지 않으므로, 컨택이 금속에 직접 닿는다.
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

; Contact 활성화 (마지막에 한 번 더 재확인)
(sdegeo:set-current-contact-set "SL")
(sdegeo:set-current-contact-set "BL")
(sdegeo:set-current-contact-set "SG")
(sdegeo:set-current-contact-set "WL_PASS")
(sdegeo:set-current-contact-set "WL_SEL")
(sdegeo:set-current-contact-set "DG")

; ---------------------------------------------------------------------
; 4. 도핑 프로파일 (Doping Profile) - v1과 동일, 논문 Table I과도 일치
; ---------------------------------------------------------------------
(sdedr:define-constant-profile "Prof.Channel" "BoronActiveConcentration" 1e14)
(sdedr:define-constant-profile-region "Place.Channel.Below" "Prof.Channel" "R.Channel_Below")
(sdedr:define-constant-profile-region "Place.Channel.Sel"   "Prof.Channel" "R.Channel_Sel")
(sdedr:define-constant-profile-region "Place.Channel.Above" "Prof.Channel" "R.Channel_Above")

(sdedr:define-refeval-window "Win.SL" "Rectangle" (position x1 y0 0) (position x2 y1 0))
(sdedr:define-constant-profile "Prof.Junction.SL" "ArsenicActiveConcentration" 1e20)
(sdedr:define-constant-profile-placement "Place.SL" "Prof.Junction.SL" "Win.SL")

(sdedr:define-refeval-window "Win.BL" "Rectangle" (position x1 y10 0) (position x2 y11 0))
(sdedr:define-constant-profile "Prof.Junction.BL" "ArsenicActiveConcentration" 1e20)
(sdedr:define-constant-profile-placement "Place.BL" "Prof.Junction.BL" "Win.BL")

; ---------------------------------------------------------------------
; 5. 매쉬 제어 (Mesh Refinement) - v1과 동일 전략 + 블로킹 스택/라이너 정밀화
; ---------------------------------------------------------------------
; 전체 채널 기본 메쉬
(sdedr:define-refinement-size "Ref.Global" 0.005 0.010 0.002 0.004)
(sdedr:define-refinement-region "Place.GlobalChannel.Below" "Ref.Global" "R.Channel_Below")
(sdedr:define-refinement-region "Place.GlobalChannel.Sel"   "Ref.Global" "R.Channel_Sel")
(sdedr:define-refinement-region "Place.GlobalChannel.Above" "Ref.Global" "R.Channel_Above")

; WL_SEL 주변 집중 메쉬 - 새로 생긴 라이너 안쪽면(x5a)까지 포함
(sdedr:define-refeval-window "Win.SelFocus" "Rectangle" (position x1 y4 0) (position x5a y7 0))
(sdedr:define-refinement-size "Ref.SelFocus" 0.0005 0.002 0.0003 0.001)
(sdedr:define-refinement-placement "Place.SelFocus" "Ref.SelFocus" "Win.SelFocus")

; 채널/TunnelOx 계면(x2) 주변 - WL_SEL 구간만 국한
(sdedr:define-refeval-window "Win.ChannelSurfaceSel" "Rectangle"
  (position (- x2 0.002) y4 0) (position (+ x2 0.002) y7 0))
(sdedr:define-refinement-size "Ref.ChannelSurfaceSel" 0.001 0.002 0.0005 0.001)
(sdedr:define-refinement-placement "Place.ChannelSurfaceSel" "Ref.ChannelSurfaceSel" "Win.ChannelSurfaceSel")

; TrapNi(질화막) - WL_SEL 구간만 국소 정밀화
(sdedr:define-refeval-window "Win.TrapNiFocus" "Rectangle" (position x3 y4 0) (position x4 y7 0))
(sdedr:define-refinement-size "Ref.TrapNiFocus" 0.001 0.010 0.0005 0.002)
(sdedr:define-refinement-placement "Place.TrapNiFocus" "Ref.TrapNiFocus" "Win.TrapNiFocus")

; BlockOx(7nm) 정밀화 - 게이트쪽 전계를 보는 것이 이 구조 변경의 목적
(sdedr:define-refeval-window "Win.BlockOxFocus" "Rectangle" (position x4 y4 0) (position x5 y7 0))
(sdedr:define-refinement-size "Ref.BlockOxFocus" 0.001 0.010 0.0005 0.002)
(sdedr:define-refinement-placement "Place.BlockOxFocus" "Ref.BlockOxFocus" "Win.BlockOxFocus")

; **WL_SEL의 알루미나 라이너 전체(ㄷ자 포함)** - 3nm로 얇고 모서리를 감싸므로
; 반지름 방향 메쉬를 충분히. x6까지 잡아야 위/아래 라이너 부분도 풀린다.
(sdedr:define-refeval-window "Win.AloSelFocus" "Rectangle"
  (position x5 (- y5 talo) 0) (position x6 (+ y6 talo) 0))
(sdedr:define-refinement-size "Ref.AloSelFocus" 0.001 0.005 0.0005 0.001)
(sdedr:define-refinement-placement "Place.AloSelFocus" "Ref.AloSelFocus" "Win.AloSelFocus")

; ---------------------------------------------------------------------
; 6. TDR/메쉬 생성
;    SDEVICE .cmd의 Grid = "sde_nand_5wl_alo_msh.tdr" 로 맞출 것.
; ---------------------------------------------------------------------
(sde:build-mesh "sde_nand_5wl_alo_msh")
