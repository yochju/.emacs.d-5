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
         ("M-x" . helm-M-x)
         ("M-S-x" . execute-extended-command)))

(use-package helm-git-grep
  :ensure t
  :bind ("C-x C-g" . helm-git-grep))

(use-package helm-projectile
  :ensure t
  :bind ("C-x C-d" . helm-projectile))

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
                (push '("<=" . ?≤) prettify-symbols-alist)))))

;; Coffee
(use-package coffee-mode
  :ensure t
  :mode "\\.coffee")

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; emacs-lisp-mode
(bind-key "M-." 'imenu emacs-lisp-mode-map)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

