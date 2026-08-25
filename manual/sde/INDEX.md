# Sentaurus Structure Editor User Guide — 챕터 인덱스

원본: `../../SStructure Editor User Guide.md` (33,922줄)를 `# CHAPTER N` 경계 기준으로
아래 파일들로 분할함. **원본 전체 파일은 절대 통째로 읽지 말 것.** 필요한 챕터 파일만
열거나, 먼저 `Grep`으로 여러 챕터를 동시에 검색해서 어느 챕터에 원하는 키워드/명령어가
있는지 찾은 뒤 해당 챕터만 읽는다.

이 폴더는 SDE(구조 생성, `sdegeo:`/`sdedr:` 등) 매뉴얼 전용이다. SDEVICE(물리 시뮬레이션)
매뉴얼 챕터는 `../sdevice/`(`manual/sdevice/`)에 있으며 서로 다른 문서이므로 혼동하지 않는다.

분할 라인 범위는 `_split_manifest.csv` 참고.

## 사용 규칙

1. 특정 명령어(`sdegeo:`, `sdedr:`, `sde:` 등 함수명)를 찾을 때는 먼저
   `Grep(pattern, path="manual/sde/")` 로 전 챕터를 검색해서 어느 파일에 있는지 찾는다.
2. 대상 챕터를 특정했으면 그 챕터 파일만 `Read` 한다.
3. **`A_Appendix_A_Commands.md`(383 KB, 18,205줄)는 특히 크다.** 이 파일은 모든 Scheme
   명령어/함수를 알파벳순으로 나열한 레퍼런스이므로, 통째로 읽지 말고 반드시 `Grep`으로
   원하는 함수명(`^# 함수명` 형태로 각 함수 항목이 시작함)의 줄 번호를 먼저 찾은 뒤
   `Read`의 offset/limit으로 그 부분만 잘라 읽는다.
   - 대략적 위치: 범용 함수(`afm-smooth-layers`~) → `sde:` 접두사(~줄 6232부터) →
     `sdedr:` 접두사(~줄 11835부터) → `sdegeo:` 접두사(~줄 15322부터) → 기타. 단, 정확한
     위치는 항상 Grep으로 재확인할 것 (버전 갱신 등으로 라인이 밀릴 수 있음).
4. 매뉴얼에서 답을 찾을 수 없는 내용을 명령어에 넣어야 한다면, 추측(환각)하지 말고
   사용자에게 확인하거나 "매뉴얼에서 확인 안 됨"이라고 명시한다.

## 챕터 목록

| Ch | 제목 | 파일 | 대략 크기 |
|----|------|------|-----------|
| 0  | Front Matter / Table of Contents | `00_Front_Matter_and_Table_of_Contents.md` | 120 KB |
| 1  | Introduction to Sentaurus Structure Editor | `01_Introduction_to_Sentaurus_Structure_Editor.md` | 17 KB |
| 2  | Graphical User Interface | `02_Graphical_User_Interface.md` | 39 KB |
| 3  | Controlling Views | `03_Controlling_Views.md` | 17 KB |
| 4  | Generating Geometric Structures (2D/3D 도형 생성) | `04_Generating_Geometric_Structures.md` | 145 KB |
| 5  | Structure Generation Using Etching and Deposition | `05_Structure_Generation_Using_Etching_and_Deposition.md` | 101 KB |
| 6  | Electrical and Thermal Contacts | `06_Electrical_and_Thermal_Contacts.md` | 19 KB |
| 7  | Generating Mesh and Doping Profiles (메시/도핑 정의 — `sdedr:`) | `07_Generating_Mesh_and_Doping_Profiles.md` | 83 KB |
| 8  | Creating Planar Layer Stacks | `08_Creating_Planar_Layer_Stacks.md` | 48 KB |
| 9  | Working With Scheme and Scheme Extensions | `09_Working_With_Scheme_and_Scheme_Extensions.md` | 20 KB |
| 10 | Geometric Query Functions | `10_Geometric_Query_Functions.md` | 29 KB |
| 11 | Miscellaneous Utilities | `11_Miscellaneous_Utilities.md` | 10 KB |
| A  | Appendix A: Commands (전체 Scheme 함수 레퍼런스, 알파벳순) | `A_Appendix_A_Commands.md` | 383 KB |

> 참고: 원본 문서에서 Chapter 3, 9의 제목은 PDF 변환 시 `#` 헤딩이 아니라 일반 텍스트로
> 남아 있었음(PDF 원본의 챕터 표지 스타일 차이로 추정). 분할 시 수동으로 경계를 확인해
> 보정함.

## 자주 쓰는 챕터 바로가기

- **도형/구조 생성 (`sdegeo:` 계열 함수 사용법)** → Ch 4, 5, Appendix A(`sdegeo:` 섹션)
- **메시/refinement/도핑 프로파일 (`sdedr:` 계열)** → Ch 7, Appendix A(`sdedr:` 섹션)
- **전극/컨택 정의** → Ch 6
- **Scheme 스크립팅 기초, 사용자 정의 변수** → Ch 9, 11
- **특정 함수의 정확한 인자/옵션** → 항상 Appendix A를 Grep으로 검색
