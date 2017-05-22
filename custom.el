(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(company-backends
   (quote
    (company-tide company-nxml company-css company-capf company-files)))
 '(css-indent-offset 2)
 '(cursor-type (quote (bar . 2)))
 '(custom-enabled-themes (quote (atom-dark-one-theme)))
 '(custom-safe-themes
   (quote
    ("a56a6bf2ecb2ce4fa79ba636d0a5cf81ad9320a988ec4e55441a16d66b0c10e0" "08b8807d23c290c840bbb14614a83878529359eaba1805618b3be7d61b0b0a32" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(dabbrev-case-distinction nil)
 '(dabbrev-case-replace nil)
 '(desktop-buffers-not-to-save ".")
 '(desktop-files-not-to-save ".")
 '(diff-hl-side (quote right))
 '(fci-rule-color "#3E4451")
 '(fill-column 200)
 '(flycheck-check-syntax-automatically (quote (save mode-enabled)))
 '(flycheck-checkers
   (quote
    (tsx-tide typescript-tide javascript-tide emacs-lisp haml javascript-eslint json-jsonlint yaml-jsyaml jsx-tide scss-stylelint css-stylelint)))
 '(flycheck-idle-change-delay 5.0)
 '(highlight-symbol-foreground-color nil)
 '(highlight-symbol-idle-delay 0.1)
 '(inhibit-startup-screen t)
 '(ivy-count-format "")
 '(ivy-fixed-height-minibuffer t)
 '(ivy-height 10)
 '(ivy-use-virtual-buffers t)
 '(ivy-wrap t)
 '(js-switch-indent-offset 4)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(ns-function-modifier (quote alt))
 '(ns-pop-up-frames nil)
 '(ns-right-alternate-modifier (quote none))
 '(package-selected-packages
   (quote
    (fundamental-mode js2-refactor wgrep tj-mode web-mode ag yaml-mode which-key use-package tide smex smart-mode-line-powerline-theme sass-mode rjsx-mode rainbow-mode project-explorer planet-theme markdown-mode js2-highlight-vars highlight-symbol helm-git-grep helm flycheck-title editorconfig diff-hl counsel company-tern coffee-mode atom-one-dark-theme anzu)))
 '(pe/omit-gitignore t)
 '(pe/side (quote left))
 '(pe/width 35)
 '(recentf-menu-filter (quote recentf-arrange-by-dir))
 '(safe-local-variable-values (quote ((sgml-basic-offset . 2) (standard-indent . 2))))
 '(scroll-margin 3)
 '(scroll-step 5)
 '(sml/theme (quote respectful))
 '(typescript-indent-level 2)
 '(use-package-always-ensure t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 140 :family "Menlo"))))
 '(cursor ((t (:background "red3"))))
 '(flycheck-error ((t (:foreground "DarkOrange" :underline (:color "Red1" :style wave)))))
 '(flycheck-warning ((t (:foreground "DarkOrange" :underline (:color "DarkOrange" :style wave)))))
 '(helm-source-header ((t (:height 150))))
 '(hl-line ((t (:background "#3E4450"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.3 :weight bold))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.2 :weight bold))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.1 :weight bold))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.0 :weight bold))))
 '(minibuffer-prompt ((t (:background "#3E4450" :foreground "#FFFFFF"))))
 '(mode-line ((t (:family "Helvetica"))))
 '(pe/directory-face ((t (:inherit dired-directory :height 110 :family "Menlo"))))
 '(pe/file-face ((t (:inherit default :height 110 :family "Menlo")))))
