(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes '(modus-vivendi))
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(global-font-lock-mode t)
 '(inhibit-startup-screen t)
 '(line-number-mode nil)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(company-coq proof-general lsp-mode company rustic ivy-posframe which-key projectile mini-frame ivy general doom-modeline))
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "FiraCode Nerd Font" :foundry "CTDB" :slant normal :weight regular :height 98 :width normal)))))

(dolist (package '(which-key general))
  (unless (package-installed-p package)
    (package-install package)))

;(unless (package-installed-p 'mini-frame)
;  (package-install 'mini-frame))

;(require 'mini-frame)
;(mini-frame-mode 1)
;(setq mini-frame-detach-on-hide nil)

;; backup settings
(setq
  backup-by-copying t
  backup-directory-alist
	`((".*" . ,temporary-file-directory))
  auto-save-file-name-transforms
  	`((".*" ,temporary-file-directory t))
  delete-old-version t
  kept-new-version2 6
  kept-old-versions 2
  version-control t)

(require 'which-key)
(which-key-mode)

(require 'general)
(general-create-definer my-leader-def
  :states '(normal visual insert emacs)
  :prefix "M-SPC"
  :non-normal-prefix "M-SPC")

(my-leader-def
  "p"  '(:ignore t :which-key "projects")
  "pf" 'projectile-find-file)

(setq which-key-idle-delay 0.5) ;; default 0.5

;; Doom modeline
(unless (package-installed-p 'doom-modeline)
  (package-install 'doom-modeline))

(require 'doom-modeline)
(doom-modeline-mode 1)


(unless (package-installed-p 'projectile)
  (package-install 'projectile))

(require 'projectile)
(projectile-mode +1)
(setq projectile-switch-project-action 'projectile-dired)
(setq projectile-indexing-method 'alien)
(setq projectile-completion-system 'ivy)

;;; Create a function to display recent projects on startup
(defun display-projectile-list-on-startup ()
  (let ((buf (get-buffer-create "*Projectile Projects*")))
    (with-current-buffer buf
      (erase-buffer)
      (dolist (project (projectile-relevant-known-projects))
        (insert project "\n")))
    (switch-to-buffer buf)))



(unless (package-installed-p 'mini-frame)
  (package-install 'mini-frame))

(unless (package-installed-p 'ivy)
  (package-install 'ivy))


(require 'ivy)
(ivy-mode 1)


;; Rust
(unless (package-installed-p 'rustic)
  (package-install 'rustic))

(require 'rustic)

;; use rust-analyzer as the LSP server
(setq rustic-lsp-server 'rust-analyzer) 

;;; Company
(unless (package-installed-p 'company)
  (package-install 'company))

(require 'company)
;; Enable company mode in all buffers
(add-hook 'after-init-hook 'global-company-mode)
;; Set company backends for lsp-mode
(push 'company-capf company-backends)

;;; lsp-mode
(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))

(require 'lsp-mode)
;; Enable lsp-mode in rustic-mode
(add-hook 'rustic-mode-hook #'lsp)
;; Use company-capf as the completion provider
(add-hook 'lsp-mode-hook (lambda () (set (make-local-variable 'company-backends) '(company-capf))))

;; Enable rustfmt on save
(setq rustic-format-on-save t)

;; Enable inlay hints
(setq lsp-rust-analyzer-display-inlay-hints t)
(setq lsp-inlay-hints-mode t)

;;; Speedbar for Rust
(my-leader-def
  :states '(normal visual emacs)
  :keymaps 'override
  "l" '(:ignore t :which-key "Language")
  "r" '(:ignore t :which-key "Rust"))

(my-leader-def
  :states '(normal visual emacs)
  :keymaps 'override
  "l r b" '(rustic-cargo-build :which-key "Build")
  "l r r" '(rustic-cargo-run :which-key "Run")
  "l r t" '(rustic-cargo-test :which-key "Test")
  "l r f" '(rustic-cargo-fmt :which-key "Format")
  "l r c" '(rustic-cargo-check :which-key "Check")
  "l r p" '(rustic-cargo-clippy :which-key "Clippy"))


(unless (package-installed-p 'proof-general)
  (package-install 'proof-general))

(unless (package-installed-p 'company-coq)
  (package-install 'company-coq))

(add-hook 'coq-mode-hook #'company-coq-mode)
