(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Backup and autosave files in temporary directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; y-or-no-p
(defalias 'yes-or-no-p 'y-or-n-p)


(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; Set tabs to 4 spaces
(setq-default indent-tabs-mode nil)
(setq standard-indent 4)
(setq tab-width 4)

;; Electric
(electric-indent-mode -1)
(electric-pair-mode -1)

;; Save command history across sessions
(savehist-mode t)
(setq history-length 1000)

;; whitespace-mode
(global-whitespace-mode t)
(setq-default whitespace-style
              '(face tab trailing space-before-tab space-after-tab))

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)

;; Save desktop
(desktop-save-mode)

;; Prettify programming languages keywords
(global-prettify-symbols-mode)

;; Load packages
(load "~/.emacs.d/packages.el")

;; Keybindings
(load "~/.emacs.d/keybindings.el")

(server-start)
