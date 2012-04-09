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

(add-to-list 'auto-mode-alist '("\\.ejs$" . html-mode))

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

; Add FlySpell (http://www-sop.inria.fr/members/Manuel.Serrano/flyspell/flyspell.html)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t)


; Org mode custom views
(setq org-agenda-custom-commands
      '(("g" "Goals and current tasks"
         ((tags "+goal")
          (tags-todo "+today")
          (agenda ""))))) ; TODO I can set filters, custom view settings, etc. in the next argument after this list.

; Add all files in the ~/org/ directory to my agenda
(setq org-agenda-files (append
                        (file-expand-wildcards "~/org/*.org")
                        (file-expand-wildcards "~/Dropbox/LifePhilosophy/*.org")
                        (file-expand-wildcards "~/Dropbox/LifePhilosophy/*Reviews/*.org")))

; Add SLIME
(load-file "~/.emacs-config/modes/slime/slime.el")
