;; The toolbar is useless

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(tool-bar-mode -1)

;; Hide scrollbars
(scroll-bar-mode -1)

;; Custom file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Save desktop
(desktop-save-mode)

;; Backup and autosave files in temporary directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Set system PATH
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; y-or-no-p
(defalias 'yes-or-no-p 'y-or-n-p)

;; Set tabs to 2 spaces
(setq-default
 indent-tabs-mode nil
 js-indent-level 2
 standard-indent 2
 tab-width 2
 sgml-basic-offset 2)

;; Electric
(electric-indent-mode -1)
(electric-pair-mode -1)

;; Save command history across sessions
;(savehist-mode)

;; Don't blink cursor
(blink-cursor-mode -1)

;; Highlight matching parentheses
(show-paren-mode t)

;; Fringes
(setq-default left-fringe-width 18
              right-fringe-width 6)

;; Display tabs and trailing spaces
(global-whitespace-mode t)
(setq-default whitespace-style '(face tab trailing))

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)

;; Auto-revert buffer on file change
(global-auto-revert-mode)

;; Display column number
(column-number-mode)

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

;; Mute bell
(setq ring-bell-function #'ignore)

;; Allow upcase-region
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Display file path in the title bar
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Make the minibuffer prompt's font bigger
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup)
(defun my-minibuffer-setup ()
  (set (make-local-variable 'face-remapping-alist)
       '((default :height 200 :foreground "white" :family "Menlo"))))

;; Load packages
(run-with-idle-timer 0 nil #'load "~/.emacs.d/packages.el")

;; Keybindings
(run-with-idle-timer 0 nil #'load "~/.emacs.d/keybindings.el")

;; Start the Emacs server
(run-with-idle-timer 1 nil #'server-start)
