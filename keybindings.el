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

(bind-key "C-c f" 'toggle-distraction-free)


;; Kill/copy region or line
(defun flash-region (start end &optional timeout)
  (let ((overlay (make-overlay start end)))
    (overlay-put overlay 'face 'region)
    (run-with-timer (or timeout 0.2) nil 'delete-overlay overlay)))

(defun copy-region-or-line ()
  "Copy region or a single line."
  (interactive)
  (if (region-active-p)
      (copy-region-as-kill (region-beginning) (region-end) t)
    (let ((start (line-beginning-position))
          (end (line-end-position)))
      (copy-region-as-kill start end)
      (flash-region start end))))

(defun kill-region-or-line ()
  "Kill region or a single line."
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end) t)
    (kill-whole-line)))

(bind-key "M-w" 'copy-region-or-line)
(bind-key "C-w" 'kill-region-or-line)


(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(bind-key "M-<backspace>" 'backward-delete-word minibuffer-local-map)
