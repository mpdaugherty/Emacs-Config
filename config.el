; Add this to ~/.emacs
; (load-file "~/.emacs-config/config.el")

; Add more specific folders to the load path
(add-to-list 'load-path (expand-file-name "~/.emacs-config/packages"))
(add-to-list 'load-path (expand-file-name "~/.emacs-config/modes"))
(add-to-list 'load-path (expand-file-name "~/.emacs-config/slime"))

; When in JS Mode, always run jshint
(require 'flymake-node-jshint)
;;; (setq flymake-node-jshint-config "~/.jshintrc-node.json") ; can add config later
(add-hook 'js-mode-hook (lambda () (flymake-mode 1)))

; enhancements for displaying flymake errors with no mouse
(require 'flymake-cursor)

; Add Major modes
;(require 'less-css-mode)
(load-file "~/.emacs-config/modes/less-css-mode.el")

; Use spaces, not tabs
(setq-default indent-tabs-mode nil)

; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

; Add Org Mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

; Add all files in the ~/org/ directory to my agenda
(setq org-agenda-files (list "~/org/todo.org")) ; TODO: Make this list all *.org files in directory, then create one per project

; Add SLIME for emacs lisp files
(load-file "~/.emacs-config/modes/slime/slime.el")
(add-to-list 'auto-mode-alist '("\\.el$" . slime-mode))
(add-to-list 'auto-mode-alist '("\\.lisp$" . slime-mode))