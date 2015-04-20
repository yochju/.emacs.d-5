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

;; git-gutter-fringe
(use-package git-gutter-fringe
  :ensure t
  :init (global-git-gutter-mode 1))

;; company-mode
(use-package company
  :ensure t
  :config (global-company-mode)
  :bind ("M-<tab>" . company-complete))

;; Helm
(use-package helm
  :ensure t
  :bind (("C-x C-b" . helm-mini)
         ("M-x" . helm-M-x))
  :config (bind-key "C-i" 'helm-execute-persistent-action helm-map))

(use-package helm-git-grep
  :ensure t
  :bind ("C-x C-p" . helm-git-grep))

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
  :init (global-flycheck-mode))

;; Flyspell
(use-package flyspell
  :init (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  :bind ([down-mouse-3] . flyspell-correct-word))


;; project-explorer
(defvar pe/update-timer nil)

(defun pe/update-other-window ()
  (when (pe/get-current-project-explorer-buffer)
    (let ((win (selected-window)))
      (project-explorer-open)
      (select-window win))))

(defun pe/update ()
  (interactive)
  (when pe/update-timer (cancel-timer pe/update-timer))
  (setq pe/update-timer (run-with-timer 0.1 nil #'pe/update-other-window)))

(use-package project-explorer
  :ensure t
  :bind (("C-c C-p" . project-explorer-open)
         ("C-x C-d" . project-explorer-helm))
  :config (add-hook 'post-command-hook #'pe/update))

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

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
