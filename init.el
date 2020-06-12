;;; init.el --- Initialization file for Emacs
;;; Commentary: Emacs Startup File --- initialization for Emacs

;; Load local config (required)
(load-file (expand-file-name "./config.local.el" (file-name-directory load-file-name)))

;; Add the MELPA package archives to my list of packages. MELPA maintains
;; a list of packages backed by git and other source control systems.
;; https://www.emacswiki.org/emacs/MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
(package-initialize)

;; On OSX, ensure that the PATH available in Emacs is the same as the current path in the shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Enable paradox package manager by default
(require 'paradox)
(paradox-enable)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (dash projectile yaml-mode emmet-mode exec-path-from-shell add-node-modules-path flycheck web-mode scss-mode sass-mode projectile-rails paradox origami markdown-mode helm-projectile fill-column-indicator coffee-mode)))
 '(paradox-automatically-star t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Turn off tab mode & set standard indentation unless overridden to 2 spaces
(setq-default indent-tabs-mode nil)
(setq standard-indent 2)

;; M/ELPA packages are loaded after init.el has run and before 'after-init-hook
;; Therefore, do all customization in a lambda that runs after 'after-init-hook
;; so that (require 'x) statements work correctly
(add-hook
 'after-init-hook
 (lambda ()
   (progn
     ;; Enable projectile globally
     (projectile-mode 1)

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
     (column-number-mode 1)

     ;; Org-mode config
     (setq org-log-done 'time) ; Log when items are marked DONE
     )))
(put 'upcase-region 'disabled nil)

;; Enable origami code folding for *.js, *.svelte, *.rb files
(add-hook 'find-file-hook
          (lambda ()
            (when (or (string= (file-name-extension buffer-file-name) "js")
                      (string= (file-name-extension buffer-file-name) "svelte")
                      (string= (file-name-extension buffer-file-name) "rb"))
              (origami-mode +1))))

;; Set up origami-mode keybindings
(add-hook 'origami-mode-hook
          (lambda ()
            (message "Setting keymap")
            (define-key origami-mode-map (kbd "C-'")
              'origami-toggle-node)))

;; Enable Web Mode automatically for JS & JSX files (for React) & Svelte files
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.svelte?$" . web-mode))
;; And add syntax highlighting
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
;; 2-space indentation default
(defun web-mode-init-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-js-indent-offset 2)
  (setq js-indent-level 2))
(add-hook 'web-mode-hook  'web-mode-init-hook)

;; Add Emmet Mode for fast HTML coding
(add-hook 'web-mode-hook  'emmet-mode)

;; Add flycheck for in-line error checking
(require 'flycheck)

;; Enable flycheck globally
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'flycheck-mode-hook 'add-node-modules-path)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  ;; disable json-jsonlist checking for json files
  (setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers '(json-jsonlist)))
  ;; disable jshint since we prefer eslint checking
  (setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers '(javascript-jshint)))
  ;; use eslint with web-mode for jsx files
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;; Monkey-patch eslint config exists since the default implementation calls "eslint --print-config ."
  ;; when the "." isn't supported anymore and it needs to be "eslint --print-config filename.js"
  (defun flycheck-eslint-config-exists-p ()
    "Whether there is a valid eslint config for the current buffer."
    (let* ((executable (flycheck-find-checker-executable 'javascript-eslint))
           (exitcode (and executable (call-process executable nil nil nil
                                                   "--print-config" (buffer-file-name)))))
                                        ;    (message executable)
                                        ;    (message (buffer-file-name))
                                        ;    (call-process executable
                                        ;                  nil
                                        ;                  "*scratch*"
                                        ;                  t
                                        ;                  "--print-config" (buffer-file-name))
      (eq exitcode 0)))
  )
