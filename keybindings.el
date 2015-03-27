;;; Various keybindings
(global-set-key (kbd "C--") 'undo)
(global-set-key (kbd "C-c C-/") 'comment-region)
(global-set-key (kbd "C-c C-\\") 'uncomment-region)

;; Toggle fullscreen
(global-set-key
 (kbd "C-c f")
 (lambda ()
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
   (toggle-frame-fullscreen)))


(global-set-key
 (kbd "M-w")
 (lambda ()
   (interactive)
   (if (region-active-p)
     (kill-ring-save (region-beginning) (region-end) t)
     (let ((start (line-beginning-position))
           (end (line-end-position)))
       (let ((overlay (make-overlay start end)))
         (overlay-put overlay 'face 'region)
         (run-with-timer 0.2 nil 'delete-overlay overlay))
       (kill-ring-save start end)))))

(global-set-key
 (kbd "C-w")
 (lambda ()
   (interactive)
   (if (region-active-p)
     (kill-region (region-beginning) (region-end) t)
     (kill-whole-line))))

