(require 'package)

;; MELPA
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

(use-package diff-hl
  :ensure t
  :init (global-diff-hl-mode t))

;; company-mode
(use-package company
  :ensure t
  :init (setq
         company-tooltip-align-annotations t
         company-tooltip-minimum-width 30)
  :config (global-company-mode)
  :bind ("M-<tab>" . company-complete))

;; Helm
(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x C-b" . helm-mini)
         ("C-x C-o" . helm-occur-from-isearch))
  :init (helm-mode)
  :config
  (progn
    (setq helm-display-header-line nil)

    (set-face-attribute 'helm-source-header nil :height 130)

    ;; (setq helm-echo-input-in-header-line t)
    ;; (defun helm-hide-minibuffer-maybe ()
    ;;   (when (with-helm-buffer helm-echo-input-in-header-line)
    ;;     (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
    ;;       (overlay-put ov 'window (selected-window))
    ;;       (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
    ;;                               `(:background ,bg-color :foreground ,bg-color)))
    ;;       (setq-local cursor-type nil))))
    ;; (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

    (add-to-list 'helm-completing-read-handlers-alist
                 '(find-file . nil))

    (setq helm-split-window-in-side-p t)

    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*helm" (* not-newline) "*" eos)
                   (display-buffer-in-side-window)
                   (inhibit-same-window . t)
                   (window-height . 0.4)))

    (bind-key "C-i" 'helm-execute-persistent-action helm-map)
    (bind-key "C-M-i" 'helm-select-action helm-map)))

(use-package helm-git-grep
  :ensure t
  :bind ("C-x C-g" . helm-git-grep)
  :config
  (progn
    (bind-key "C-x C-g" 'helm-git-grep-from-isearch isearch-mode-map)

    (defvar helm-search-history nil "History of helm git-grep input")

    (defun helm-git-grep-1 (&optional input)
      "Execute helm git grep.
Optional argument INPUT is initial input."
      (helm :sources '(helm-source-git-grep
                       helm-source-git-submodule-grep)
            :buffer (if helm-git-grep-ignore-case "*helm git grep [i]*" "*helm git grep*")
            :input input
            :keymap helm-git-grep-map
            :history 'helm-search-history ;; Separate history
            :candidate-number-limit helm-git-grep-candidate-number-limit))))

;; Count matched lines
(use-package anzu
  :ensure t
  :init (global-anzu-mode))

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode "\\.md")

;; js2-mode
(use-package js2-mode
  :ensure t
  :mode "\\.js$"
  :config
  (progn
    (defun js2-insert-this ()
      (interactive)
      (let ((node (js2-node-at-point)))
        (if (or (js2-comment-node-p node) (js2-string-node-p node))
            (insert "@")
          (progn
            (delete-char 0)
            (insert "this.")))))

    (bind-key "@" 'js2-insert-this js2-mode-map)

    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))

    (add-hook
     'js2-mode-hook
     (lambda ()
       (tern-mode)

       (push '("function" . ?ƒ) prettify-symbols-alist)
       (push '("=>" . ?⟹) prettify-symbols-alist)
       (push '("this." . ?@) prettify-symbols-alist)
       (push '(">=" . ?≥) prettify-symbols-alist)
       (push '("<=" . ?≤) prettify-symbols-alist)))

    (setq js2-bounce-indent-p t
          js2-strict-missing-semi-warning nil
          js2-concat-multiline-strings nil
          js2-include-node-externs t
          js2-skip-preprocessor-directives t
          js2-strict-inconsistent-return-warning nil)))

;; Tern
(use-package tern
  :ensure t
  :init (autoload 'tern-mode "tern" nil t))

(use-package company-tern
  :ensure t
  :config (add-to-list 'company-backends 'company-tern))

;; nodejs-repl
(use-package nodejs-repl
  :ensure t
  :bind ("C-x C-n" . nodejs-repl))

(use-package coffee-mode
  :ensure t
  :config (progn
            (setq coffee-args-compile '("-c" "--bare" "--no-header"))
            (setq coffee-tab-width 2)
            (add-hook 'coffee-mode-hook 'highlight-symbol-mode)))

(use-package highlight-symbol
  :ensure t
  :init (setq
         highlight-symbol-foreground-color nil
         highlight-symbol-idle-delay 0.1))

;; JSON
(use-package json-mode
  :ensure t
  :mode "\\.json")

;; Yaml
(use-package yaml-mode
  :ensure t)

;; Sass
(use-package sass-mode
  :ensure t)

;; Flycheck
(use-package flycheck
  :ensure t
  :init (setq
         flycheck-coffeelintrc "coffeelint.json"
         flycheck-eslintrc "eslint.json"
         flycheck-checkers
         '(coffee
           coffee-coffeelint
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
          (add-hook 'markdown-mode-hook 'flyspell-mode))
  :config (setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
  :bind ([down-mouse-3] . flyspell-correct-word))

;; Project explorer
(use-package project-explorer
  :ensure t
  :bind (("C-c C-p" . project-explorer-open)
         ("C-x C-d" . project-explorer-helm))
  :config (progn
            (add-hook 'project-explorer-mode-hook (lambda () (setq-local left-fringe-width 6)))
            (add-hook 'project-explorer-mode-hook 'hl-line-mode))
  :init (setq
         pe/follow-current t
         pe/omit-gitignore t
         pe/width 35))

;; CSS colors
(use-package rainbow-mode
  :ensure t
  :config (progn
            (setq rainbow-html-colors nil)
            (add-hook 'css-mode-hook #'rainbow-mode)))

(use-package smart-mode-line
  :ensure t
  :init (smart-mode-line-enable))

(use-package atom-one-dark-theme
  :ensure t
  :init (load-theme 'atom-one-dark))

;;; packages.el ends here
