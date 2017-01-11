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
  :defer 1
  :init (global-diff-hl-mode t))

;; company-mode
(use-package company
  :defer 1
  :init (setq
         company-tooltip-align-annotations t
         company-tooltip-minimum-width 30)
  :config (global-company-mode)
  :bind ("M-<tab>" . company-complete))

;; Count matched lines
(use-package anzu
  :defer 1
  :init (global-anzu-mode))

;; Markdown
(use-package markdown-mode
  :defer 1
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; js2-mode
(use-package js2-mode
  :defer 1
  :mode "\\.js$"
  :config
  (progn
    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))

    (add-hook 'js2-mode-hook #'tern-mode)

    ;; Don't indent multi-line declarations (var, let, const) in any special way.
    (advice-add 'js--multi-line-declaration-indentation :around (lambda (orig-fun &rest args) nil))

    (setq js2-basic-offset 2
          js2-bounce-indent-p t
          js2-strict-missing-semi-warning nil
          js2-concat-multiline-strings nil
          js2-include-node-externs t
          js2-skip-preprocessor-directives t
          js2-strict-inconsistent-return-warning nil)))

;; JSX
(use-package rjsx-mode
  :defer 1
  :mode "\\.jsx$")

;; Tern
(use-package tern
  :defer 1
  :init (autoload 'tern-mode "tern" nil t))

(use-package company-tern
  :defer 1
  :config (add-to-list 'company-backends 'company-tern))

(use-package coffee-mode
  :defer 1
  :config (progn
            (setq coffee-args-compile '("-c" "--bare" "--no-header"))
            (setq coffee-tab-width 2)
            (add-hook 'coffee-mode-hook 'highlight-symbol-mode)))

(use-package highlight-symbol
  :defer 1)

;; TypeScript
(use-package tide
  :defer 1
  :config (add-hook 'typescript-mode-hook
                    (lambda ()
                      (turn-off-auto-fill)
                      (tide-setup)
                      (flycheck-mode 1)
                      (setq flycheck-check-syntax-automatically '(save mode-enabled))
                      (eldoc-mode 1)
                      (company-mode-on))))

;; Yaml
(use-package yaml-mode
  :defer 1)

;; Sass
(use-package sass-mode
  :defer 1
  :config (progn
            (load "/Users/katspaugh/.emacs.d/company-sass.el")
            (add-to-list 'company-backends 'company-sass)))

;; Flycheck
(use-package flycheck
  :defer 1
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
  :defer 1
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
  :defer 2
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
  :defer 2
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
  :defer 1
  :config (progn
            (setq rainbow-html-colors nil)
            (add-hook 'css-mode-hook #'rainbow-mode)))

;; Editorconfig
(use-package editorconfig
  :init (editorconfig-mode))


;;; packages.el ends here
