;;; company-sass.el --- company-mode completion backend for sass-mode  -*- lexical-binding: t -*-

;; Copyright (C) 2016  Free Software Foundation, Inc.

;; Author: katspaugh

;;; Commentary:

;;; Code:

(require 'company)
(require 'company-css)
(require 'css-mode)
(require 'cl-lib)

;;; values
(defconst company-sass-property-value-regexp
  "\\_<\\([[:alpha:]-]+\\):[[:space:]]*\\([[:alpha:]]*\\_>\\|\\)\\="
  "A regular expression matching CSS property values.")

;;;###autoload
(defun company-sass (command &optional arg &rest ignored)
  "`company-mode' completion backend for `sass-mode'."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-sass))
    (prefix (and (derived-mode-p 'sass-mode)
                 (company-grab-symbol)))
    (candidates
     (cond
      ((company-grab company-sass-property-value-regexp 2)
       (all-completions arg
                        (company-css-property-values
                         (company-grab company-sass-property-value-regexp 1))))
      ((company-grab-symbol)
       (all-completions arg css-property-ids))))
    (sorted t)))

(provide 'company-sass)
;;; company-sass.el ends here
