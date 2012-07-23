(require 'org-install)
(require 'org-reprise)

(setq org-export-htmlize-output-type 'css)
(setq org-export-babel-evaluate nil)

(require 'org-publish)

(setq org-publish-project-alist
      '(
	("org-posts"
	 :base-extension "org"
	 :base-directory "~/blog/source"
	 :publishing-directory "~/blog/reprise/assets/"
	 :blog-publishing-directory "~/blog/reprise/"
	 :site-root "http://www.mpdaugherty.com"
	 :recursive t
         :table-of-contents nil
	 :publishing-function org-publish-org-to-html
	 :headline-levels 4
	 :auto-postamble nil
	 :auto-preamble t
	 :exclude-tags ("ol" "noexport")
         :sub-superscript nil ; Don't use _abc and ^abc to indicate super and subscript
         :sub-superscripts nil ; Don't use _abc and ^abc to indicate super and subscript
         :TeX-macros nil ; Testing to see if this helps with the _^ issue...
	 )

	("org-static"
	 :base-directory "~/blog/source"
	 :publishing-directory "~/blog/reprise/assets/media/"
	 :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )

        ("html-files"
         :base-extension "~/blog/source"
         :base-directory "~/org/"
	 :publishing-directory "~/blog/reprise/assets/"
	 :blog-publishing-directory "~/blog/"
	 :site-root "http://www.mpdaugherty.com"
	 :recursive t
         :publishing-function org-publish-attachment
         )

	("blog" :components ("org-notes" "org-static" "html-files"))))


(defun publish-blog ()
  (interactive)
  ; Get rid of any remnants of an unsuccessful build; otherwise python fails
  (shell-command "rm -rf ~/blog/reprise/build")
  (shell-command "rm -rf ~/blog/reprise/source/")
  ; Ensure that this directory exists, even though it may be empty; otherwise python fails
  (shell-command "mkdir ~/blog/reprise/source")
  (shell-command "mkdir ~/blog/reprise/source/static")
  (org-reprise-export-blog "~/blog/source/blog.org")
  (org-publish (assoc "org-static" org-publish-project-alist))
  (org-publish (assoc "html-files" org-publish-project-alist))
  (shell-command "source ~/.virtualenvs/blog/bin/activate && python ~/blog/reprise/reprise.py"))

(provide 'blogging)