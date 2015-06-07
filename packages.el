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

;; diff
(use-package git-gutter-fringe
  :ensure t
  :init (global-git-gutter-mode))

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
  :config
  (progn
    (helm-mode)

    (setq helm-split-window-in-side-p t)

    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*helm" (* not-newline) "*" eos)
                   (display-buffer-in-side-window)
                   (inhibit-same-window . t)
                   (window-height . 0.4)))

    (bind-key "C-i" 'helm-execute-persistent-action helm-map)
    (bind-key "M-<tab>" 'helm-select-action helm-map)
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

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode "\\.md")

;; js2-mode
(use-package js2-mode
  :ensure t
  ;:mode "\\.js$"
  :config
  (progn
    (setq js2-bounce-indent-p t
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

;; @ -> this
(defun tj/@->this ()
  (interactive)
  (let ((face (get-text-property (point) 'font-lock-face)))
    (if (or
         (eq face 'font-lock-comment-face)
         (eq face 'font-lock-string-face))
        (insert "@")
      (progn
        (delete-char 0)
        (insert "this")))))

;; tj-mode
(use-package tj-mode
  :ensure t
  :mode "\\.js$"
  :config
  (progn
   (add-to-list 'interpreter-mode-alist '("node" . tj-mode))

   (bind-key "@" 'tj/@->this tj-mode-map)

   (add-hook
    'tj-mode-hook
    (lambda ()
      (push '("function" . ?ƒ) prettify-symbols-alist)
      (push '("this" . ?@) prettify-symbols-alist)
      (push '(">=" . ?≥) prettify-symbols-alist)
      (push '("<=" . ?≤) prettify-symbols-alist)))))

;; nodejs-repl
(use-package nodejs-repl
  :ensure t
  :bind ("C-x C-n" . nodejs-repl))

(use-package coffee-mode
  :ensure t
  :config (progn
            (setq coffee-args-compile '("-c" "--bare" "--no-header"))
            (setq coffee-tab-width 2)
            (add-hook 'coffee-mode-hook 'tern-mode)
            (add-hook 'coffee-mode-hook 'highlight-symbol-mode)))

(use-package highlight-symbol
  :ensure t
  :init (setq
         highlight-symbol-foreground-color nil
         highlight-symbol-idle-delay 0.1))

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
           sass
           yaml-jsyaml))
  :config (global-flycheck-mode))

;; Flyspell
;; (use-package flyspell
;;   :init (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;;   :config (setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
;;   :bind ([down-mouse-3] . flyspell-correct-word))

(use-package project-explorer
  :ensure t
  :bind (("C-c C-p" . project-explorer-open)
         ("C-x C-d" . project-explorer-helm))
  :init (setq
         pe/follow-current t
         pe/omit-gitignore t
         pe/side 'left
         pe/width 40))

;; Highlight active window
(use-package hiwin
  :ensure t
  :config (hiwin-mode t))

;;; packages.el ends here

