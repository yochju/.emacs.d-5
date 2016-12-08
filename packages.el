(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

;; Smart mode line
(use-package smart-mode-line
  :init (smart-mode-line-enable))

(use-package planet-theme
  :init (load-theme 'planet))

;; (use-package atom-one-dark-theme
;;   :init (load-theme 'atom-one-dark))

(use-package diff-hl
  :init (global-diff-hl-mode t))

;; company-mode
(use-package company
  :init (setq
         company-tooltip-align-annotations t
         company-tooltip-minimum-width 30)
  :config (global-company-mode)
  :bind ("M-<tab>" . company-complete))

;; Count matched lines
(use-package anzu
  :init (global-anzu-mode))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package js2-highlight-vars
  :config (add-hook 'js2-mode-hook (lambda () (js2-highlight-vars-mode))))

;; js2-mode
(use-package js2-mode
  :mode "\\.js$"
  :config
  (progn
    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))

    (add-hook 'js2-mode-hook #'tern-mode)

    (setq js2-basic-offset 2
          js2-bounce-indent-p t
          js2-strict-missing-semi-warning nil
          js2-concat-multiline-strings nil
          js2-include-node-externs t
          js2-skip-preprocessor-directives t
          js2-strict-inconsistent-return-warning nil)))

;; JSX
(use-package rjsx-mode
  :mode "\\.jsx$")

;; Tern
(use-package tern
  :init (autoload 'tern-mode "tern" nil t))

(use-package company-tern
  :config (add-to-list 'company-backends 'company-tern))

(use-package coffee-mode
  :config (progn
            (setq coffee-args-compile '("-c" "--bare" "--no-header"))
            (setq coffee-tab-width 2)
            (add-hook 'coffee-mode-hook 'highlight-symbol-mode)))

(use-package highlight-symbol)

;; TypeScript
(use-package tide
  :config (add-hook 'typescript-mode-hook
                    (lambda ()
                      (turn-off-auto-fill)
                      (tide-setup)
                      (flycheck-mode 1)
                      (setq flycheck-check-syntax-automatically '(save mode-enabled))
                      (eldoc-mode 1)
                      (company-mode-on))))

;; Yaml
(use-package yaml-mode)

;; Sass
(use-package sass-mode
  :config (progn
            (load "/Users/katspaugh/.emacs.d/company-sass.el")
            (add-to-list 'company-backends 'company-sass)))

;; Flycheck
(use-package flycheck
  :init (setq
         flycheck-coffeelintrc "coffeelint.json"
         flycheck-checkers
         '(coffee
           coffee-coffeelint
           typescript-tide
           css-csslint
           emacs-lisp
           haml
           javascript-eslint
           json-jsonlint
           yaml-jsyaml))
  :config (global-flycheck-mode))

;; Flyspell
(use-package flyspell
  :init (progn
          (add-hook 'text-mode-hook 'flyspell-mode)
          (add-hook 'markdown-mode-hook 'flyspell-mode)
          (add-hook 'prog-mode-hook 'flyspell-prog-mode)

          (defun flyspell-generic-textmode-verify ()
            "Used for `flyspell-generic-check-word-predicate' in programming modes."
            ;; (point) is next char after the word. Must check one char before.
            (let ((f (get-text-property (- (point) 1) 'face)))
              (not (memq f '(markdown-pre-face markdown-language-keyword-face)))))

          (setq flyspell-generic-check-word-predicate 'flyspell-generic-textmode-verify))

  :config (setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
  :bind ([down-mouse-3] . flyspell-correct-word))

;; Project explorer
(use-package project-explorer
  :bind (("C-c C-p" . project-explorer-open))
  :config (progn
            (add-hook 'project-explorer-mode-hook (lambda ()
                                                    (setq-local left-fringe-width 6)
                                                    (setq-local right-fringe-width 6)))
            (add-hook 'project-explorer-mode-hook 'hl-line-mode))
  :init (setq
         pe/follow-current t
         pe/omit-gitignore t
         pe/width 30))

;; Helm
(use-package helm
  :config
  (progn
    (setq helm-display-header-line nil)
    (setq helm-split-window-in-side-p t)

    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*helm" (* not-newline) "*" eos)
                   (display-buffer-in-side-window)
                   (inhibit-same-window . t)
                   (window-height . 0.4)))

    (bind-key "C-i" 'helm-execute-persistent-action helm-map)
    (bind-key "C-M-i" 'helm-select-action helm-map)))

(use-package helm-git-grep
  :bind ("C-x C-g" . helm-git-grep)
  :config (bind-key "C-x C-g" 'helm-git-grep-from-isearch isearch-mode-map))

;; Ivy
(use-package ivy
  :config (define-key ivy-minibuffer-map (kbd "C-w") 'ivy-yank-word)
  :init (ivy-mode 1))

(use-package smex)

(use-package counsel
  :init (counsel-mode 1)
  :bind (("C-x C-b" . ivy-switch-buffer)
         ("C-x C-d" . counsel-git)))

;; CSS colors
(use-package rainbow-mode
  :config (progn
            (setq rainbow-html-colors nil)
            (add-hook 'css-mode-hook #'rainbow-mode)))

(use-package editorconfig
  :init (editorconfig-mode))


;;; packages.el ends here
