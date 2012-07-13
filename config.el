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
(setq load-path (cons "~/.emacs-config/modes/org-mode/lisp/" load-path))
(require 'org-install)
(require 'org-mobile)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

; Mobile
(setq org-mobile-directory "~/org/mobile")

; Add FlySpell (http://www-sop.inria.fr/members/Manuel.Serrano/flyspell/flyspell.html)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t)


; Org mode custom views
(setq org-agenda-custom-commands
      '(("g" "Goals and current tasks"
         ((tags-todo "+week+goal"
           ((org-agenda-overriding-header " Week Goals: ")))
          (tags-todo "+month+goal"
           ((org-agenda-overriding-header " Month Goals: ")))
          (tags-todo "+year+goal"
           ((org-agenda-overriding-header " Year Goals: ")))
          (agenda "")))  ; TODO I can set filters, custom view settings, etc. in the next argument after this list.
        ("n" "Next tasks" tags-todo "+next")))

; Add all files in the ~/org/ directory and most recent reviews to my agenda
; Also, make this into an interactive command so I can reload it when I create
; a new review
(defun org-reload-agenda-files ()
  (interactive)
  (setq org-agenda-files (append
                          (file-expand-wildcards "~/org/*.org")
                          (file-expand-wildcards "~/Dropbox/LifePhilosophy/*.org")
                          (delq nil ; this gets us a list of the most recent year, month, and week reviews
                                (mapcar
                                 (lambda (folder)
                                   (car (last (sort
                                               (file-expand-wildcards (concatenate 'string folder "/*.org")) `string-lessp))))
                                 (file-expand-wildcards "~/Dropbox/LifePhilosophy/*Reviews"))))))
(org-reload-agenda-files)

; Add SLIME
(load-file "~/.emacs-config/modes/slime/slime.el")

; Set up my review commands
(defun create-weekly-review ()
  (interactive)
  (with-current-buffer
   (find-file-noselect "~/Dropbox/LifePhilosophy/WeeklyReviews/abc.org")
   (org-element-parse-buffer)))


;; Add org2blog
;; Which requires xml-rpx
(setq load-path (cons "~/.emacs-config/xml-rpc/" (cons "~/.emacs-config/org2blog/" load-path)))
(require 'xml-rpc)
(require 'org2blog-autoloads)
(setq org2blog/wp-blog-alist
      '(("mpd.com"
         :url "http://www.mpdaugherty.com/xmlrpc.php"
         :username "mike")))

;; Add yasnippets
(add-to-list 'load-path
              "~/.emacs-config/yasnippet")
(setq yas/snippet-dirs "~/.emacs-config/snippets")
(require 'yasnippet)
(yas/global-mode 1)

;; Add django-mode
(add-to-list 'load-path (expand-file-name "~/.emacs-config/modes/django-mode"))
(require 'django-html-mode)
(require 'django-mode)
(yas/load-directory "~/.emacs-config/modes/django-mode/snippets")
(add-to-list 'auto-mode-alist '("\\.dhtml$" . django-html-mode))
(add-to-list 'auto-mode-alist '("\\.django$" . django-html-mode))
