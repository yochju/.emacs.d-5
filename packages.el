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
  :init (global-flycheck-mode))

;; Flyspell
(use-package flyspell
  :init (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  :bind ([down-mouse-3] . flyspell-correct-word))

;; nodejs-repl
(use-package dash-at-point
  :ensure t
  :bind ("C-c C-d" . dash-at-point))

;; project-explorer
(use-package project-explorer
  :ensure t
  :bind (("C-c C-p" . project-explorer-open)
         ("C-x p" . project-explorer-helm)))

;; emacs-lisp-mode
(bind-key "M-." 'imenu emacs-lisp-mode-map)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
