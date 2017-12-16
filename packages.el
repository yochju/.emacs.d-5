;;; -*- lexical-binding: t -*-

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

(use-package atom-one-dark-theme
  :init (load-theme 'atom-one-dark))

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

(defun setup-tide-mode ()
  (interactive)
  (run-with-idle-timer
   0.5 nil
   (lambda () (progn
                (tide-setup)
                (tide-hl-identifier-mode +1)))))

;; TypeScript
(use-package tide
  :config
  (progn
    (add-hook 'typescript-mode-hook #'setup-tide-mode)
    (add-hook 'js2-mode-hook #'setup-tide-mode)
    (add-hook 'rjsx-mode-hook #'setup-tide-mode)))

(defun tide-annotate-completions (completions prefix file-location)
  (-map
   (lambda (completion)
     (let ((name (plist-get completion :name)))
       (put-text-property 0 1 'file-location file-location name)
       (put-text-property 0 1 'completion completion name)
       name))
   (-sort
    'tide-compare-completions
    (-filter
     (let ((member-p (tide-member-completion-p prefix)))
       (lambda (completion)
         (and (string-prefix-p prefix (plist-get completion :name))
              (or (not member-p)
                  (member (plist-get completion :kind) '("warning" "export" "method" "property" "getter" "setter"))))))
     completions))))


(add-to-list 'auto-mode-alist '("\\.json\\'" . fundamental-mode))


;; js2-mode
(use-package js2-mode
  :defer 1
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode))
  :config
  (progn
    ;;
    ;; Override the js-mode indentation function for multiline vars
    ;;
    (defun js--multi-line-declaration-indentation ()
      "Helper function for `js--proper-indentation'.
Return the proper indentation of the current line if it belongs to a declaration
statement spanning multiple lines; otherwise, return nil."
      (let (at-opening-bracket)
        (save-excursion
          (back-to-indentation)
          (when (not (looking-at js--declaration-keyword-re))
            (when (looking-at js--indent-operator-re)
              (goto-char (+ (- js-indent-level 1) (match-beginning 0))))
            (while (and (not at-opening-bracket)
                        (not (bobp))
                        (let ((pos (point)))
                          (save-excursion
                            (js--backward-syntactic-ws)
                            (or (eq (char-before) ?,)
                                (and (not (eq (char-before) ?\;))
                                     (prog2
                                         (skip-syntax-backward ".")
                                         (looking-at js--indent-operator-re)
                                       (js--backward-syntactic-ws))
                                     (not (eq (char-before) ?\;)))
                                (js--same-line pos)))))
              (condition-case nil
                  (backward-sexp)
                (scan-error (setq at-opening-bracket t))))
            (when (looking-at js--declaration-keyword-re)
              (goto-char (+ (- js-indent-level 1) (match-beginning 0)))
              (1+ (current-column)))))))

    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))

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

;; Yaml
(use-package yaml-mode
  :defer 1)

;; Flycheck
(use-package flycheck
  :defer 1
  :init (setq
         flycheck-checkers
         '(typescript-tide
           javascript-tide
           jsx-tide
           javascript-eslint
           css-csslint
           emacs-lisp
           haml
           json-jsonlint
           yaml-jsyaml))
  :config (global-flycheck-mode))

;; Flyspell
;; (use-package flyspell
;;   :defer 1
;;   :init (progn
;;           (add-hook 'text-mode-hook 'flyspell-mode)
;;           (add-hook 'markdown-mode-hook 'flyspell-mode)
;;           (add-hook 'prog-mode-hook 'flyspell-prog-mode)

;;           (defun flyspell-generic-textmode-verify ()
;;             "Used for `flyspell-generic-check-word-predicate' in programming modes."
;;             (let ((f (get-text-property (- (point) 1) 'face)))
;;               (not (memq f '(markdown-pre-face markdown-language-keyword-face)))))

;;           (setq flyspell-generic-check-word-predicate 'flyspell-generic-textmode-verify))

;;   :config (setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))
;;   :bind ([down-mouse-3] . flyspell-correct-word))

;; Project explorer
(use-package project-explorer
  :bind (("C-c C-p" . project-explorer-open))
  :config (progn
            (add-hook 'project-explorer-mode-hook (lambda ()
                                                    (setq-local left-fringe-width 4)
                                                    (setq-local right-fringe-width 4)))
            (add-hook 'project-explorer-mode-hook 'hl-line-mode)

            (defun highlight-file-line (&rest args) (hl-line-highlight))
            (advice-add 'pe/goto-file :after 'highlight-file-line))
  :init (setq
         pe/follow-current t
         pe/omit-gitignore t
         pe/width 30))

;; Ivy
(use-package ivy
  :config (define-key ivy-minibuffer-map (kbd "C-w") 'ivy-yank-word)
  :bind (("C-x C-f" . find-file))
  :init (ivy-mode 1))

(use-package smex)
(use-package flx)

;; Recent files
(recentf-mode)

(use-package counsel
  :init (counsel-mode 1)
  :bind (("C-x C-b" . ivy-switch-buffer)
         ("C-x C-d" . counsel-git)
         ("C-x C-a" . counsel-ag)
         ("C-x C-r" . counsel-recentf)))

;; CSS colors
(use-package rainbow-mode
  :defer 1
  :config (progn
            (setq rainbow-html-colors nil)
            (add-hook 'css-mode-hook #'rainbow-mode)))

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

;;; packages.el ends here
