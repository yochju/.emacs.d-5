(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(coffee-args-compile (quote ("-c" "--bare")))
 '(coffee-tab-width 2)
 '(company-backends
   (quote
    (company-tern company-nxml company-css company-capf company-dabbrev-code company-abbrev)))
 '(company-tooltip-align-annotations t)
 '(company-tooltip-minimum-width 24)
 '(cursor-type (quote bar))
 '(custom-enabled-themes (quote (misterioso)))
 '(desktop-buffers-not-to-save ".")
 '(desktop-files-not-to-save ".")
 '(flycheck-coffeelintrc "~/.emacs.d/flycheck-config/coffeelint.json")
 '(flycheck-eslintrc "~/.emacs.d/flycheck-config/eslint.json")
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(global-hl-line-mode t)
 '(global-whitespace-mode t)
 '(highlight-symbol-foreground-color nil)
 '(highlight-symbol-idle-delay 0.1)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(ns-pop-up-frames nil)
 '(ns-right-alternate-modifier (quote none))
 '(ns-use-native-fullscreen nil)
 '(pe/omit-gitignore t)
 '(pe/side (quote right))
 '(pe/width 30)
 '(scroll-bar-mode nil)
 '(scroll-margin 3)
 '(scroll-step 5)
 '(sgml-basic-offset 2)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 140 :family "Menlo"))))
 '(cursor ((t (:background "red"))))
 '(helm-source-header ((t (:background "gray35" :foreground "white" :weight bold :height 1.1 :family "Sans Serif"))))
 '(highlight-symbol-face ((t (:underline t))))
 '(hl-line ((t (:background "selectedKnobColor"))))
 '(pe/directory-face ((t (:inherit dired-directory :height 120))))
 '(pe/file-face ((t (:inherit default :height 140)))))
