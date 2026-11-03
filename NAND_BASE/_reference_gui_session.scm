
;; Defined Parameters:

;; Contact Sets:
(sdegeo:define-contact-set "Drain" 4 (color:rgb 0 0 1 )"##" )
(sdegeo:define-contact-set "Source" 4 (color:rgb 1 0 0 )"##" )
(sdegeo:define-contact-set "DSL" 4 (color:rgb 0 0 1 )"##" )
(sdegeo:define-contact-set "WL3" 4 (color:rgb 0.5 0.5 0.5 )"##" )
(sdegeo:define-contact-set "WL2" 4 (color:rgb 0 1 0 )"##" )
(sdegeo:define-contact-set "WL1" 4 (color:rgb 0 1 1 )"##" )
(sdegeo:define-contact-set "SSL" 4 (color:rgb 1 0 0 )"##" )

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)

;; Restore GUI session parameters:
(sde:set-window-position 0 28)
(sde:set-window-size 1920 780)
(sde:set-window-style "Windows")
(sde:set-background-color 0 127 178 204 204 204)
(sde:scmwin-set-prefs "Liberation Sans" "Normal" 8 124 )