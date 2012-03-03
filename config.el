; Add this to ~/.emacs
; (load-file "~/.emacs-config/config.el")

; Add more specific folders to the load path
(add-to-list 'load-path (expand-file-name "~/.emacs-config/packages"))
(add-to-list 'load-path (expand-file-name "~/.emacs-config/modes"))

; Add Major modes
;(require 'less-css-mode)
(load-file "~/.emacs-config/modes/less-css-mode.el")

; Use spaces, not tabs
(setq-default indent-tabs-mode nil)

; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

