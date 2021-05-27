;;; init-local.el --- archer's configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;; selectrum
(when (maybe-require-package 'consult)
  ;; The Consult package provides the command consult-line which behaves similarly to Swiper.
  (global-set-key (kbd "M-s /") 'consult-line)
  ;; imenu
  (global-set-key (kbd "M-s i") #'consult-imenu))



;; org
(with-eval-after-load 'org

  ;; epa-file
  (require 'epa-file)
  (epa-file-enable)
  ;; Solve password input problems on Mac
  (setq epa-pinentry-mode 'loopback)

  (maybe-require-package 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

  (when (maybe-require-package 'consult)
    (define-key org-mode-map (kbd "M-s i") 'consult-outline))

  (org-babel-do-load-languages 'org-babel-load-languages
                               (append org-babel-load-languages
                                       '((scheme . t))))

  (setq org-directory "~/org")
  (setq org-default-notes-file (concat org-directory "/inbox.org.gpg"))
  (setq org-agenda-files (list org-default-notes-file
                               (concat org-directory "/work.org.gpg")
                               (concat org-directory "/home.org.gpg")
                               (concat org-directory "/note.org")
                               (concat org-directory "/study.org.gpg")
                               (concat org-directory "/health.org.gpg"))))


;; javascript

;; lsp support
(when (maybe-require-package 'tide)
  (defun setup-tide-mode ()
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    ;; configure javascript-tide checker to run after your default javascript checker
    (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
    (eldoc-mode +1)
    ;; (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (define-key tide-mode-map (kbd "C-.") #'tide-jump-to-implementation)
    (define-key tide-mode-map (kbd "C-,") #'tide-references)
    (when (maybe-require-package 'dumb-jump)
      (setq dumb-jump-selector 'completing-read)
      (setq tide-jump-to-fallback  #'dumb-jump-go))
    (company-mode +1))
  ;; formats the buffer before saving
  ;; (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  (add-hook 'js-mode-hook #'setup-tide-mode))

(provide 'init-local)
;;; init-local.el ends here
