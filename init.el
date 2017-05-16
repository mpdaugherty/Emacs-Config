;; Load local config (required)
(load-file (expand-file-name "./config.local.el" (file-name-directory load-file-name)))

;; Add the MELPA package archives to my list of packages. MELPA maintains
;; a list of packages backed by git and other source control systems.
;; https://www.emacswiki.org/emacs/MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; So far, MELPA unstable is only used for
;; https://github.com/bbatsov/helm-projectile since the author has not added
;; any stable git tags yet.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(paradox-automatically-star t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; M/ELPA packages are loaded after init.el has run and before 'after-init-hook
;; Therefore, do all customization in a lambda that runs after 'after-init-hook
;; so that (require 'x) statements work correctly
(add-hook
 'after-init-hook
 (lambda ()
   (progn
     ;; Enable projectile globally
     ;; (projectile-global-mode)
     (projectile-global-mode 1)

     ;; Delete trailing whitespace in files when saving
     (add-hook 'before-save-hook 'delete-trailing-whitespace)

     ;; Minor mode for Projectile (project-based features) for Rails projects
     ;; (start along with projectile)
     (add-hook 'projectile-mode-hook 'projectile-rails-on)

     ;; Use helm-projectile for completion
     (setq projectile-completion-system 'helm)
     (add-hook 'projectile-mode-hook 'helm-projectile-on)

     ;; 2 spaces for indentation in coffee mode
     (add-hook 'coffee-mode-hook
	       (lambda ()
		 (set (make-local-variable 'tab-width) 2)))

     ;; Highlight and indent HAML files
     (require 'haml-mode)

     ;; Add a line indicator at 100 columns for programming
     (require 'fill-column-indicator)
     (setq-default fci-rule-column 100)
     (add-hook 'ruby-mode-hook 'fci-mode)
     (add-hook 'haml-mode-hook 'fci-mode)

     ;; Display the current column number while typing
     (column-number-mode 1))))
(put 'upcase-region 'disabled nil)
