;;; Various keybindings
(global-set-key (kbd "C--") 'undo)
(global-set-key (kbd "C-c C-/") 'comment-region)
(global-set-key (kbd "C-c C-\\") 'uncomment-region)


;; Jump to definition of symbol at point
(defun jump-to-definition ()
  (interactive)
  (imenu (symbol-at-point)))

(bind-key "M-." 'jump-to-definition)


;; Toggle full screen mode
(defun toggle-distraction-free ()
  (interactive)
  (if (eq 'fullboth (frame-parameter nil 'fullscreen))
      (set-fringe-mode '(8 . 8))
    (run-with-timer
     0.7 nil
     (lambda ()
       (set-fringe-mode
        (/ (- (frame-pixel-width)
              (* 120 (frame-char-width)))
           2)))))
  (toggle-frame-fullscreen))

(bind-key "C-c f" 'toggle-frame-fullscreen)


;; Kill/copy region or line
(defun copy-region-or-line ()
  (interactive)
  (unless (region-active-p)
    (set-mark-command (beginning-of-line))
    (move-end-of-line nil))
  (kill-ring-save (region-beginning) (region-end) t))

(defun kill-region-or-line ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end) t)
    (kill-whole-line)))

(bind-key "M-w" 'copy-region-or-line)
(bind-key "C-w" 'kill-region-or-line)
