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
         ("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x))
  :config
  (progn
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
  :bind ("C-x C-g" . helm-git-grep))

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode "\\.md")

;; JavaScript
(use-package js2-mode
  :ensure t
  ;:mode "\\.js$"
  :config
  (progn
    (setq js2-bounce-indent-p t
          js2-concat-multiline-strings nil
          js2-include-node-externs t
          js2-skip-preprocessor-directives t
          js2-strict-inconsistent-return-warning nil)

    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))

    (add-hook 'js2-mode-hook
              (lambda ()
                (push '("function" . ?ƒ) prettify-symbols-alist)
                (push '("this" . ?@) prettify-symbols-alist)
                (push '(">=" . ?≥) prettify-symbols-alist)
                (push '("<=" . ?≤) prettify-symbols-alist)))))

;; Tern
(use-package tern
  :ensure t
  :init (autoload 'tern-mode "tern" nil t))

(use-package company-tern
  :ensure t
  :config (add-to-list 'company-backends 'company-tern))

;; @ -> this
(defun js-insert-this ()
  (interactive)
  (let ((face (get-text-property (point) 'font-lock-face)))
    (if (or
         (eq face 'font-lock-comment-face)
         (eq face 'font-lock-string-face))
        (insert "@")
      (progn
        (delete-char 0)
        (insert "this")))))

(use-package tj-mode
  :load-path "~/Sites/tj-mode/"
  :mode "\\.js$"
  :config
  (progn
   (bind-key "@" 'js-insert-this tj-mode-map)

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
            (use-package sourcemap :ensure t)

            (add-hook 'coffee-after-compile-hook 'sourcemap-goto-corresponding-point)

            ;; If you want to remove sourcemap file after jumping corresponding point
            (defun my/coffee-after-compile-hook (props)
              (sourcemap-goto-corresponding-point props)
              (delete-file (plist-get props :sourcemap)))

            (add-hook 'coffee-after-compile-hook 'my/coffee-after-compile-hook)
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
         ("C-x C-d" . project-explorer-helm))
  :config (run-with-timer 1 nil #'project-explorer-open))

;; Highlight active window
(use-package hiwin
  :ensure t
  :config (hiwin-mode t))

(use-package indent-guide
  :ensure t
  :config
  (progn
    (add-hook 'coffee-mode-hook 'indent-guide-mode)
    (add-hook 'sass-mode-hook 'indent-guide-mode)
    (add-hook 'sgml-mode-hook 'indent-guide-mode)))

(use-package volatile-highlights
  :ensure t
  :config (volatile-highlights-mode))

;; Smart mode line
;; (use-package smart-mode-line
;;   :ensure t
;;   :config
;;   (progn
;;     (setq sml/theme 'respectful)
;;     (smart-mode-line-enable)
;;     (load-theme 'misterioso)))

;;; packages.el ends here
