(require 'package)

;; MELPA
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(require 'bind-key)

;; diff-hl
(use-package diff-hl
  :ensure t
  :init (global-diff-hl-mode))

;; company-mode
(use-package company
  :ensure t
  :config (global-company-mode)
  :bind ("M-<tab>" . company-complete))

;; Helm
(use-package helm
  :ensure t
  :bind (("C-x C-b" . helm-mini)
         ("C-M-s" . swiper-helm)
         ("M-x" . helm-M-x))
  :config
  (progn
    (use-package swiper-helm :ensure t)
    (bind-key "C-i" 'helm-execute-persistent-action helm-map)
    (bind-key "M-<tab>" 'helm-select-action helm-map)
    (bind-key "C-M-i" 'helm-select-action helm-map)))

(use-package helm-git-grep
  :ensure t
  :bind ("C-x C-g" . helm-git-grep))

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode "\\.md")

;; js2-mode
(defun js2-insert-this ()
  (interactive)
  (let ((node (js2-node-at-point)))
    (if (or (js2-comment-node-p node) (js2-string-node-p node))
        (insert "@")
      (progn
        (delete-char 0)
        (insert "this")))))

(use-package js2-mode
  :ensure t
  :mode "\\.js$"
  :config
  (progn
    (setq js2-bounce-indent-p t
          js2-concat-multiline-strings nil
          js2-include-node-externs t
          js2-skip-preprocessor-directives t
          js2-strict-inconsistent-return-warning nil)

    (bind-key "@" 'js2-insert-this js2-mode-map)

    (add-hook 'js2-mode-hook
              (lambda ()
                (push '("function" . ?ƒ) prettify-symbols-alist)
                (push '("this" . ?@) prettify-symbols-alist)
                (push '(">=" . ?≥) prettify-symbols-alist)
                (push '("<=" . ?≤) prettify-symbols-alist)))

    (add-hook 'js2-mode-hook 'tern-mode)))

;; Tern
(use-package tern
  :ensure t
  :init (autoload 'tern-mode "tern" nil t))

(use-package company-tern
  :ensure t)

;; nodejs-repl
(use-package nodejs-repl
  :ensure t
  :bind ("C-x C-n" . nodejs-repl))

(use-package coffee-mode
  :ensure t
  :config (progn
            (add-hook 'coffee-mode-hook 'tern-mode)
            (add-hook 'coffee-mode-hook 'highlight-symbol-mode)))

(use-package highlight-symbol
  :ensure t)

;; Yaml
(use-package yaml-mode
  :ensure t)

;; Sass
(use-package sass-mode
  :ensure t)

;; Flycheck
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode))

;; Flyspell
(use-package flyspell
  :init (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  :config (setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
  :bind ([down-mouse-3] . flyspell-correct-word))

(use-package project-explorer
  :ensure t
  :bind (("C-c C-p" . project-explorer-open)
         ("C-x C-d" . project-explorer-helm)))

;; Highlight active window
(use-package hiwin
  :ensure t
  :config (hiwin-mode t))

;; Smart mode line
(use-package smart-mode-line
  :ensure t
  :config (smart-mode-line-enable))

(use-package sml-modeline
  :ensure t
  :config (sml-modeline-mode t))

;; Display the number of isearch occurrences
(use-package anzu
  :ensure t
  :config (anzu-mode))

