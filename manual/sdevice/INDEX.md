# Sentaurus Device User Guide — 챕터 인덱스

원본: `../../SDevice User Guide.md` (72,550줄, 약 330만 자)를 `# CHAPTER N` 경계 기준으로
아래 파일들로 분할함. **원본 전체 파일은 절대 통째로 읽지 말 것.** 필요한 챕터 파일만
열거나, 먼저 `Grep`으로 여러 챕터를 동시에 검색해서 어느 챕터에 원하는 키워드/파라미터가
있는지 찾은 뒤 해당 챕터만 읽는다.

이 폴더는 SDEVICE(물리 시뮬레이션) 매뉴얼 전용이다. SDE(구조 생성, `sdegeo:`/`sdedr:` 등)
매뉴얼 챕터는 `../sde/`(`manual/sde/`)에 있으며 서로 다른 문서이므로 혼동하지 않는다.

분할 스크립트/원본 라인 범위는 `_split_manifest.csv` 참고.

## 사용 규칙

1. 특정 키워드(파라미터명, 모델명, 명령어 등)를 찾을 때는 먼저
   `Grep(pattern, path="manual/sdevice/")` 로 전 챕터를 검색해서 어느 파일에 있는지 찾는다.
2. 대상 챕터를 특정했으면 그 챕터 파일만 `Read` 한다. 여러 챕터가 필요해도
   한 번에 2~3개 이하로 제한하고, 꼭 필요한 챕터만 연다.
3. Chapter 39(PMI)와 40(Tcl Interfaces)는 특히 크므로, 그 안에서도 `##`/`###`
   서브섹션 단위로 필요한 부분만 `Read`의 offset/limit으로 잘라 읽는 것을 권장.
4. 매뉴얼에서 답을 찾을 수 없는 내용을 명령어에 넣어야 한다면, 추측(환각)하지 말고
   사용자에게 확인하거나 "매뉴얼에서 확인 안 됨"이라고 명시한다.

## 챕터 목록

| Ch | 제목 | 파일 | 대략 크기 |
|----|------|------|-----------|
| 0  | Front Matter / Table of Contents | `00_Front_Matter_and_Table_of_Contents.md` | 171 KB |
| 1  | Introduction to Sentaurus Device | `01_Introduction_to_Sentaurus_Device.md` | 10 KB |
| 2  | Specifying Physical Devices (구조/메시/도핑 정의) | `02_Specifying_Physical_Devices.md` | 64 KB |
| 3  | Mixed-Mode Simulations (회로 연동) | `03_Mixed_Mode_Simulations.md` | 42 KB |
| 4  | Performing Numeric Experiments (Solve, sweep 등) | `04_Performing_Numeric_Experiments.md` | 98 KB |
| 5  | Simulation Results (출력/플롯 설정) | `05_Simulation_Results.md` | 123 KB |
| 7  | Poisson Equation and Quasi-Fermi Potentials | `07_Poisson_Equation_and_Quasi_Fermi_Potentials.md` | 19 KB |
| 8  | Carrier Transport Equations in Semiconductors | `08_Carrier_Transport_Equations_in_Semiconductors.md` | 14 KB |
| 9  | Lattice and Carrier Temperature Equations | `09_Lattice_and_Carrier_Temperature_Equations.md` | 28 KB |
| 10 | Boundary Conditions | `10_Boundary_Conditions.md` | 72 KB |
| 11 | Transport Equations in Metals, Organic Materials, Disordered Media | `11_Transport_Equations_in_Metals_Organic_Materials_and_Disordered_Media.md` | 29 KB |
| 12 | Semiconductor Band Structure | `12_Semiconductor_Band_Structure.md` | 72 KB |
| 13 | Incomplete Ionization | `13_Incomplete_Ionization.md` | 18 KB |
| 14 | Quantization | `14_Quantization.md` | 91 KB |
| 15 | Mobility | `15_Mobility.md` | 159 KB |
| 16 | Generation-Recombination | `16_Generation_Recombination.md` | 146 KB |
| 17 | Traps and Fixed Charges | `17_Traps_and_Fixed_Charges.md` | 82 KB |
| 18 | Phase and State Transitions | `18_Phase_and_State_Transitions.md` | 32 KB |
| 19 | Degradation | `19_Degradation.md` | 92 KB |
| 20 | Organic Devices | `20_Organic_Devices.md` | 6 KB |
| 21 | Optical Generation | `21_Optical_Generation.md` | 245 KB |
| 22 | Radiation | `22_Radiation.md` | 16 KB |
| 23 | Noise, Fluctuations, and Sensitivity | `23_Noise_Fluctuations_and_Sensitivity.md` | 80 KB |
| 24 | Tunneling | `24_Tunneling.md` | 59 KB |
| 25 | Hot-Carrier Injection | `25_Hot_Carrier_Injection.md` | 56 KB |
| 26 | Heterostructure Device Simulation | `26_Heterostructure_Device_Simulation.md` | 10 KB |
| 27 | Energy-Dependent Parameters | `27_Energy_Dependent_Parameters.md` | 12 KB |
| 28 | Anisotropic Properties | `28_Anisotropic_Properties.md` | 36 KB |
| 29 | Ferroelectric Materials | `29_Ferroelectric_Materials.md` | 37 KB |
| 30 | Ferromagnetism and Spin Transport | `30_Ferromagnetism_and_Spin_Transport.md` | 29 KB |
| 31 | Mechanical Stress | `31_Mechanical_Stress.md` | 172 KB |
| 32 | Galvanic Transport | `32_Galvanic_Transport.md` | 4 KB |
| 33 | Thermal Properties | `33_Thermal_Properties.md` | 37 KB |
| 34 | Light-Emitting Diodes | `34_Light_Emitting_Diodes.md` | 76 KB |
| 35 | Quantum Wells | `35_Quantum_Wells.md` | 49 KB |
| 36 | Kinetic Monte Carlo MIM Transport | `36_Kinetic_Monte_Carlo_MIM_Transport.md` | 142 KB |
| 38 | Numeric Methods (수렴/솔버 설정) | `38_Numeric_Methods.md` | 59 KB |
| 39 | Physical Model Interface (PMI, C 코드 인터페이스) | `39_Physical_Model_Interface.md` | 491 KB |
| 40 | Tcl Interfaces | `40_Tcl_Interfaces.md` | 369 KB |

> 참고: 원본 문서에 Chapter 6과 Chapter 37은 없음(원본 매뉴얼 자체의 챕터 번호 결번).

## 자주 쓰는 챕터 바로가기 (SDEVICE 커맨드 파일 섹션 기준)

- **Electrode/File/Physics/Plot/Math/Solve 섹션 문법 전반** → Ch 2, 4, 5, 38
- **모빌리티 모델 파라미터** → Ch 15
- **재결합(SRH, Auger, Band-to-band 등)** → Ch 16
- **트랩/고정전하** → Ch 17
- **수렴 안 될 때(뉴턴/솔버 옵션)** → Ch 38
- **회로 믹스드모드** → Ch 3
- **광생성/LED/발광** → Ch 21, 34
