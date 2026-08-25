# commands/

여기에는 실제로 다른 터미널에 복사해서 돌린 SDE/SDEVICE 커맨드 파일의 스냅샷을
버전별로 저장한다. 대화창에 붙여넣는 코드 블록은 시간이 지나면 찾기 어려워지므로,
사용자에게 새 커맨드를 제안할 때마다 그 최종본을 파일로도 저장해 둔다.

## 실험별 하위 폴더

실험(연구 주제) 단위로 하위 폴더를 만든다. 예: `commands/nand_pgm_EPEP/`
(Erase 여부에 따른 PGM 시 밴드 차이 실험), 나중에 GIDL 관련 실험을 시작하면
`commands/nand_gidl_erase/` 처럼 새 폴더를 만든다. 이 README와 파일명 규칙은
모든 실험 폴더에 공통으로 적용된다.

## 파일명 규칙

`YYYYMMDD_짧은설명_vN.cmd` (SDEVICE) / `YYYYMMDD_짧은설명_vN.scm` (SDE)
(예: `20260817_pmos_idvg_v1.cmd`)

버전을 올릴 때는 새 파일로 저장하고(덮어쓰지 않음), `runs/<실험명>/` 아래 해당 실행
기록에서 어떤 버전 파일을 썼는지 링크한다. 이렇게 하면 "v1에서 이 현상이 나서 v2에서
무엇을 바꿨는지"를 나중에 그대로 추적할 수 있다.

## SDEVICE cmd 파일: 시뮬레이터 출력 파일명에도 버전 태그 넣기

`.cmd` 파일 자체의 스냅샷 파일명(`YYYYMMDD_..._vN.cmd`)과 별개로, 그 cmd를 돌렸을 때
**시뮬레이터가 실제로 생성하는 결과 파일**(`.tdr`/`.plt`/`.log`, snapshot plot 파일들)도
어느 버전으로 만들어졌는지 파일명만 보고 구분할 수 있어야 한다. `File{}` 섹션의
`Plot`/`Current`/`Output`과 `Solve` 안의 모든 `FilePrefix`에 `n@node@` 뒤에
`_vN_`(버전 번호)을 끼워넣는다. 예:

```
File {
  Plot    = "n@node@_v11_des.tdr"
  Current = "n@node@_v11_des.plt"
  Output  = "n@node@_v11_des.log"
}
...
plot ( FilePrefix="n@node@_v11_snap_10us_2V" ... )
```

노드 번호(`@node@`)는 Sentaurus Workbench가 실행마다 자동 부여하는 값이라 그것만으로는
어느 cmd 버전의 결과인지 알 수 없다 — 버전을 올릴 때마다 이 태그도 같이 올릴 것.
