;;; packages
(setq custom-file "~/.emacs.d/custom.el")  ; I have no intention of using it for now
(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(global-auto-revert-mode 1)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; open buffer in the same window
(global-set-key "\C-x\C-b" 'buffer-menu)
;; backspace instead of help
(global-set-key "\C-h" 'delete-backward-char)
;; visualize matching brackets
(show-paren-mode 1)
;; highlight current line
(global-hl-line-mode 1)
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(global-set-key (kbd "s-r") 'revert-buffer) ; GUI Emacs
;; Terminal Emacs: WezTerm Cmd+r sends \e[250~; decode to f19, then bind f19
(defun my-setup-terminal-keys ()
  (define-key input-decode-map "\e[250~" [f19]))
(add-hook 'tty-setup-hook #'my-setup-terminal-keys)
(when (not (display-graphic-p)) (my-setup-terminal-keys))
(global-set-key [f19] 'revert-buffer)
(set-display-table-slot standard-display-table 'wrap ?↩)
(set-face-attribute 'default nil :height 120)
(global-display-line-numbers-mode t)
(column-number-mode t)
(xterm-mouse-mode 1)

;; let the frame occupy the right half of the screen
(defun position-frame (position-x position-y width height)
  "Set frame of size WIDTH and HEIGHT at position (POSITION-X, POSITION-Y)."
  (set-frame-position (selected-frame) position-x position-y)
  (set-frame-size (selected-frame) width height t))
(defun position-frame-half-screen (position-x)
  "Resize the frame to half width of the screen and position at POSITION-X."
  (let ((width (- (floor (/ (display-pixel-width) 2)) 33))
        (height (display-pixel-height)))
    (position-frame position-x 0 width height)))
(defun position-frame-right ()
  "Position frame to the right half of the screen."
  (interactive)
  (position-frame-half-screen (/ (display-pixel-width) 2)))
(defun position-frame-left ()
  "Position frame to the left half of the screen."
  (interactive)
  (position-frame-half-screen 0))
(global-set-key (kbd "<C-M-right>") 'position-frame-right)
(global-set-key (kbd "<C-M-left>") 'position-frame-left)

;;; editor defaults
(global-auto-revert-mode 1)

;;; window navigation
(when (>= (frame-width) 160)        ; split vertically only if wide enough
  (split-window-right))
(setq split-width-threshold 160)    ; prevent auto horizontal splits when narrow
(setq split-height-threshold 500)   ; prevent commands from splitting vertically
(windmove-default-keybindings)      ; move to other window by S-right etc.
(winner-mode)
(global-set-key (kbd "C-c p") 'winner-undo)
(global-set-key (kbd "C-c n") 'winner-redo)
(use-package buffer-move
  :config
  (global-set-key (kbd "<C-S-left>")   'buf-move-left)
  (global-set-key (kbd "<C-S-right>")  'buf-move-right)
  (global-set-key (kbd "<C-S-up>")  'buf-move-up)
  (global-set-key (kbd "<C-S-down>")  'buf-move-down)
  (setq buffer-move-behavior 'move))

(savehist-mode 1)
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-magic-tilde nil)
  (setq ivy-use-virtual-buffers t))
(use-package swiper
  :config
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "C-r") 'swiper-backward))

;;; git
(use-package magit
  :config
  (global-set-key (kbd "C-x m") 'magit-status)
  (global-set-key (kbd "M-a") 'magit-blame-addition)
  (define-key magit-file-section-map (kbd "RET") 'magit-diff-visit-worktree-file)
  (define-key magit-hunk-section-map (kbd "RET") 'magit-diff-visit-file-other-window)
  (setq magit-commit-show-diff nil)
  (setq magit-display-buffer-function
        (lambda (buffer)
          (if (>= (frame-width) 160)
              (magit-display-buffer-traditional buffer)
            (display-buffer buffer '(display-buffer-same-window))))))

(add-hook 'emacs-startup-hook
          (lambda ()
            (when (and (magit-toplevel)
                       (not (member "-Q" command-line-args)))
              (magit-status))))

;;; org mode - override org-mode default to favor general window switching
(use-package org
  :config
  (define-key org-mode-map (kbd "<C-S-left>") nil)
  (define-key org-mode-map (kbd "<C-S-right>") nil)
  (define-key org-mode-map (kbd "<C-S-up>") nil)
  (define-key org-mode-map (kbd "<C-S-down>") nil)
  (define-key org-mode-map (kbd "<S-up>") nil)
  (define-key org-mode-map (kbd "<S-down>") nil)
  (define-key org-mode-map (kbd "<S-left>") nil)
  (define-key org-mode-map (kbd "<S-right>") nil)
  (define-key org-mode-map (kbd "C-c a") 'org-agenda))
(setq org-log-done t)
(setq org-adapt-indentation nil)
(setq org-src-tab-acts-natively nil)

;;; whitespaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package whitespace
  :config
  (setq whitespace-style `(face trailing tabs))
  (global-whitespace-mode 1))

;;; Python
(defun insert-pdb-set-trace ()
  "Insert pdb."
  (interactive)
  (insert "import pdb; pdb.set_trace()"))
(use-package python
  :config
  (define-key python-mode-map (kbd "C-x p") 'insert-pdb-set-trace))

;;; Ruby
(use-package enh-ruby-mode
  :config
  (add-to-list 'auto-mode-alist
               '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode)))

;;; Lua
(use-package lua-mode)

;;; TypeScript
(use-package prettier-js
  :config
  (add-hook 'typescript-mode-hook 'prettier-js-mode))
(use-package typescript-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))
  (add-hook 'typescript-mode-hook (lambda () (flycheck-add-next-checker 'lsp 'javascript-eslint))))

;;; flycheck
(use-package flycheck
  :config
  (global-flycheck-mode)
  (global-set-key (kbd "s-n") 'flycheck-next-error)
  (global-set-key (kbd "s-p") 'flycheck-previous-error)
  (global-set-key (kbd "s-l") 'flycheck-list-errors))
(use-package flycheck-pos-tip
  :after (flycheck)
  :config
  (flycheck-pos-tip-mode))  ; show error/warning message at tooltip

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (define-key company-mode-map (kbd "C-c SPC") 'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
  (define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)
  (define-key company-active-map (kbd "M-h") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "C-h") nil))

(use-package lsp-mode
  :hook ((typescript-mode . lsp))
  :commands lsp
  :config
  (define-key lsp-mode-map (kbd "C-c SPC") 'completion-at-point))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;;; treemacs
;; Don't auto-launch at startup; it blocks TRAMP's SSH process handling.
;; Use C-c t to open on demand.
(defun my-treemacs-open ()
  "Open treemacs for the current directory or repo root.
Finds the matching workspace and navigates to the file at point."
  (interactive)
  (let* ((root (expand-file-name (or (vc-root-dir) (magit-toplevel) default-directory)))
         (target (or (and (derived-mode-p 'magit-mode)
                          (magit-file-at-point t)
                          (expand-file-name (magit-file-at-point t) root))
                     buffer-file-name
                     root))
         (ws (treemacs-find-workspace-by-path root)))
    (when (and ws (not (eq ws (treemacs-current-workspace))))
      (treemacs-do-switch-workspace ws))
    (treemacs)
    (ignore-errors (treemacs-goto-node target))))
(use-package treemacs
  :config
  (global-set-key (kbd "C-c t") 'my-treemacs-open)
  (global-set-key (kbd "C-c f") 'treemacs-find-file)
  (global-set-key (kbd "M-0") #'treemacs-select-window)
  (treemacs-follow-mode -1)
  (treemacs-filewatch-mode -1)
  (define-key treemacs-mode-map (kbd "j") #'treemacs-next-line)
  (define-key treemacs-mode-map (kbd "k") #'treemacs-previous-line)
  (define-key treemacs-mode-map (kbd "M-p")
    (lambda () (interactive)
      (let ((state (treemacs-button-get (treemacs-current-button) :state)))
        (unless (memq state '(dir-node-open dir-node-closed))
          (treemacs-goto-parent-node))
        (treemacs-previous-neighbour))))
  (define-key treemacs-mode-map (kbd "M-n")
    (lambda () (interactive)
      (let ((state (treemacs-button-get (treemacs-current-button) :state)))
        (unless (memq state '(dir-node-open dir-node-closed))
          (treemacs-goto-parent-node))
        (treemacs-next-neighbour)))))

;;; theme
(use-package color-theme-sanityinc-tomorrow
  :config
  (load-theme 'sanityinc-tomorrow-bright t)
  (defun theme-dark ()
    "Switch to my selected dark theme."
    (interactive)
    (load-theme 'sanityinc-tomorrow-bright t))
  (defun theme-light ()
    "Switch to my selected light theme."
    (interactive)
    (load-theme 'sanityinc-tomorrow-day t)))

;; Enable mouse in terminal (click to position cursor, select, etc.)
(xterm-mouse-mode 1)
;; Bind scroll wheel to line-based scrolling
(global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down 3)))
(global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up 3)))
