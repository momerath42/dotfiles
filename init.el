
;;; my init.el
;;; Code:

;; NOTE: this file obviously belongs in ~/.emacs.d/ - this is a copy for the
;; sake of sharing my dotfiles in one repo with its .git in ~/.config

(setq user-full-name "M. Quinn Warnock")
(setq user-mail-address "quinn@noodle.software")

(setq-default
 fill-column 80
 sentence-end-double-space nil
 indent-tabs-mode nil  ; Use spaces instead of tabs
 tab-width 4)

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(defvar savefile-dir (expand-file-name "savefile" user-emacs-directory)
  "This folder stores all the automatically generated save/history-files.")

(menu-bar-mode -1)
(tool-bar-mode -1)

(server-start)

(ido-mode t)

;; (setq org-clock-persist 'history)
;; (org-clock-persistence-insinuate)
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "WAIT(w@/!)" "IN-PROGRESS(i!)" "|" "DONE(d!)" "CANCELED(c@)")))
;; (setq org-log-into-drawer t)

(global-set-key (kbd "C-M-l") 'goto-line)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
;; makes :ensure unnecessary:
(setq straight-use-package-by-default t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package diminish)
(use-package bind-key)

(use-package treemacs)
(use-package diff-hl)
(use-package magit
  :config
  (global-set-key (kbd "C-c g") 'magit-file-dispatch)
  )

;; fk/ stuff borrowed from https://github.com/KaratasFurkan/.emacs.d
;; (defconst fk/default-font-family "RobotoMono Nerd Font")
(defconst fk/default-font-size 120)
(defconst fk/default-icon-size 15)
;; for TV use:
;;(defconst fk/default-font-size 180)
;;(defconst fk/default-icon-size 26)

;; (defconst fk/variable-pitch-font-family "Noto Serif")

;; (custom-set-faces
;;  `(default ((t (:family ,fk/default-font-family :height ,fk/default-font-size))))
;;  `(variable-pitch ((t (:family ,fk/variable-pitch-font-family :height 1.0))))
;;  ;; Characters with fixed pitch face do not shown when height is 90.
;;  `(fixed-pitch-serif ((t (:height 1.2)))))

(defun fk/adjust-font-size (height)
  "Adjust font size by given HEIGHT. If height is '0', reset font size. This function also handles icons and modeline font sizes."
  (interactive "nHeight ('0' to reset): ")
  (let ((new-height (if (zerop height)
                        fk/default-font-size
                      (+ height (face-attribute 'default :height)))))
    (set-face-attribute 'default nil :height new-height)
    (set-face-attribute 'mode-line nil :height new-height)
    (set-face-attribute 'mode-line-inactive nil :height new-height)
    (message "Font size: %s" new-height))
  (let ((new-size (if (zerop height)
                      fk/default-icon-size
                    (+ (/ height 5) treemacs--icon-size))))
    (when (fboundp 'treemacs-resize-icons)
      (treemacs-resize-icons new-size))
    (when (fboundp 'company-box-icons-resize)
      (company-box-icons-resize new-size)))
  (when diff-hl-mode
    (diff-hl-maybe-redefine-bitmaps)))

(defun fk/increase-font-size ()
  "Increase font size by 0.5 (5 in height)."
  (interactive)
  (fk/adjust-font-size 5))

(defun fk/decrease-font-size ()
  "Decrease font size by 0.5 (5 in height)."
  (interactive)
  (fk/adjust-font-size -5))

(defun fk/reset-font-size ()
  "Reset font size according to the `fk/default-font-size'."
  (interactive)
  (fk/adjust-font-size 0))

(global-set-key (kbd "C-=") 'fk/increase-font-size)
(global-set-key (kbd "C--") 'fk/decrease-font-size)
(global-set-key (kbd "C-0") 'fk/reset-font-size)


(use-package paredit
  :hook (;;(prog-mode . enable-paredit-mode)
         (clojure-mode . enable-paredit-mode)
         (cider-mode . enable-paredit-mode)
         ;;(python-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (emacs-lisp-mode . enable-paredit-mode)
         ))

(use-package org-appear
  :hook (org-mode . org-appear-mode))
;; makes org-mode tables align better
(use-package valign
  :straight (:host github :repo "casouri/valign")
  :commands valign-mode
  :custom
  (valign-fancy-bar t))

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)
         (cider-mode . rainbow-delimiters-mode)
         (python-mode . rainbow-delimiters-mode))
  :delight)

;; colorizes color-names / color-describing strings (like #aabbcc)
(use-package rainbow-mode
  :hook ((prog-mode . rainbow-mode)
         (clojure-mode . rainbow-mode)
         (python-mode . rainbow-mode)
         (js2-mode . rainbow-mode)
         (html-mode . rainbow-mode))
  :delight)

;; (use-package melancholy-theme
;;   :init (load-theme 'melancholy t))
 (use-package zenburn-theme
   :init (load-theme 'zenburn t))

(use-package atomic-chrome
  :ensure t
  :init (atomic-chrome-start-server))

;; (use-package eaf
;;   :load-path "~/.emacs.d/site-lisp/emacs-application-framework"
;;   :custom
;;   ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
;;   (eaf-browser-continue-where-left-off t)
;;   (eaf-browser-enable-adblocker t)
;;   (browse-url-browser-function 'eaf-open-browser)
;;   (eaf-python-command "/usr/bin/python")  ; don't use venv python
;;   :config
;;   (require 'eaf-browser)
;;   (require 'eaf-music-player)
;;   (require 'eaf-mindmap)
;;   (require 'eaf-terminal)
;;   (require 'eaf-video-player)
;;   (require 'eaf-file-manager)
;;   ;;(require 'eaf-org-previewer)
;;   (require 'eaf-image-viewer)
;;   (require 'eaf-airshare)
;;   (require 'eaf-jupyter)
;;   (require 'eaf-camera)
;;   (require 'eaf-pdf-viewer)
;;   (require 'eaf-file-sender)
;;   (require 'eaf-rss-reader)
;;   (require 'eaf-markdown-previewer)
;;   (defalias 'browse-web #'eaf-open-browser)
;;   (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;   (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki

(use-package undo-tree
  :init
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t)
  (global-undo-tree-mode)
  :diminish undo-tree-mode)

(use-package browse-kill-ring)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package company)

(use-package flycheck)

;; eglot config borrowed from: https://www.adventuresinwhy.com/post/eglot/
;;  they needed this; we'll see if I do:
;; Fix path
;; (use-package exec-path-from-shell
;;   :ensure t
;;   :config
;;   (when (memq window-system '(mac ns x))
;;     (exec-path-from-shell-initialize)))

;; Open python files in tree-sitter mode.
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

(use-package eglot
  :defer t
  :bind (:map eglot-mode-map
              ("C-c C-d" . eldoc)
              ("C-c C-e" . eglot-rename)
              ("C-c C-o" . python-sort-imports)
              ("C-c C-f" . eglot-format-buffer))
  :hook ((python-ts-mode . eglot-ensure)
         (python-ts-mode . flyspell-prog-mode)
         (python-ts-mode . superword-mode)
         (python-ts-mode . hs-minor-mode)
         (python-ts-mode . (lambda () (set-fill-column 88))))
  :config
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["flake8"]
                             :plugins (
                                       :pycodestyle (:enabled :json-false)
                                       :mccabe (:enabled :json-false)
                                       :pyflakes (:enabled :json-false)
                                       :flake8 (:enabled :json-false
                                                :maxLineLength 88)
                                       :ruff (:enabled t
                                              :lineLength 88)
                                       :pydocstyle (:enabled t
                                                    :convention "numpy")
                                       :yapf (:enabled :json-false)
                                       :autopep8 (:enabled :json-false)
                                       :black (:enabled t
                                               :line_length 88
                                               :cache_config t)))))))
;; end borrowing

;;(use-package eglot)

(use-package cider)

(use-package flycheck-clj-kondo
  :after clojure-mode
  :hook clojure-mode
  )

(use-package dartclojure
  :straight (:host github :repo "burinc/dartclojure.el")
  :config
  (setq dartclojure-bin "dartclojure"
        dartclojure-opts "-m \"m\" -f \"f\""))


(defun clerk-show ()
  (interactive)
  (when-let
      ((filename
        (buffer-file-name)))
    (save-buffer)
    (cider-interactive-eval
     (concat "(nextjournal.clerk/show! \"" filename "\")"))))

(define-key clojure-mode-map (kbd "<M-return>") 'clerk-show)


;; borrowed from https://manueluberti.eu/2023/03/25/clojure-lsp.html
;;(setq-default cider-eldoc-display-for-symbol-at-point nil)

;; (defun mu-cider-disable-eldoc ()
;;   "Let LSP handle ElDoc instead of CIDER."
;;   (remove-hook 'eldoc-documentation-functions #'cider-eldoc t))

;;(add-hook 'cider-mode-hook #'mu-cider-disable-eldoc)

;; (defun mu-cider-disable-completion ()
;;   "Let LSP handle completion instead of CIDER."
;;   (remove-hook 'completion-at-point-functions #'cider-complete-at-point t))

;; (add-hook 'cider-mode-hook #'mu-cider-disable-completion)
;; end borrowing

;; TODO: use pyright (or something)
;; (use-package python
;;   :straight (:type built-in)
;;   :init
;;   (add-to-list 'all-the-icons-icon-alist
;;                '("\\.py$" all-the-icons-alltheicon "python" :height 1.1 :face all-the-icons-dblue))
;;   :custom
;;   (python-shell-interpreter "ipython")
;;   (python-shell-interpreter-args "-i --simple-prompt")
;;   (python-indent-guess-indent-offset-verbose nil)
;;   :bind
;;   ( :map python-mode-map
;;     ("C-c r" . python-indent-shift-right)
;;     ("C-c l" . python-indent-shift-left))
;;   :hook
;;   ;; With pyls:
;;   ;; pip install python-language-server flake8 pyls-black(optional) pyls-isort(optional)
;;   ;; With pyright
;;   ;; sudo npm install -g pyright && pip install flake8 black(optional)
;;   ;; NOTE: these hooks runs in reverse order
;;   ;;(python-mode . (lambda () (setq-local company-prescient-sort-length-enable nil)))
;;   ;;(python-mode . (lambda () (unless (and buffer-file-name (file-in-directory-p buffer-file-name "~/.virtualenvs/")) (flycheck-mode))))
;;   ;; (python-mode . lsp-deferred)
;;   ;;(python-mode . (lambda () (fk/add-local-hook 'before-save-hook 'eglot-format-buffer)))
;;   (python-mode . eglot-ensure)
;;   ;; importmagic runs ~100mb ipython process per python file, and it does not
;;   ;; always find imports, 60%-70% maybe. I stop using this, but still want to keep.
;;   ;; (python-mode . importmagic-mode)
;;   ;;(python-mode . fk/activate-pyvenv)
;;   ;; (python-mode . (lambda ()
;;   ;;                  (when (and (buffer-file-name)
;;   ;;                             (string=
;;   ;;                              (car (last (f-split (f-parent (buffer-file-name)))))
;;   ;;                              "tests"))
;;   ;;                    (fk/hide-second-level-blocks))))
;;   ;;(python-mode . fk/tree-sitter-hl-mode)
;;   (python-mode . (lambda () (setq-local fill-column 88)))
;;   :config
;;   (defvar python-walrus-operator-regexp ":=")

;;   ;; Make walrus operator ":=" more visible
;;   (font-lock-add-keywords
;;    'python-mode
;;    `((,python-walrus-operator-regexp 0 'escape-glyph t))
;;    'set))

;; (use-package lsp-pyright
;;     ;; :quelpa
;;     ;; (lsp-pyright
;;     ;;     :fetcher git
;;     ;;     :url "https://github.com/emacs-lsp/lsp-pyright")
;;     :hook (python-mode . (lambda () (require 'lsp-pyright)))
;;     :init (when (executable-find "python3")
;;               (setq lsp-pyright-python-executable-cmd "python3")))

(use-package pyvenv
  :init
  (setenv "WORKON_HOME" "/home/momerath/python-venvs/")
  (pyvenv-mode 1)
  (pyvenv-tracking-mode 1))

(use-package vterm)

(use-package emacs-everywhere)

;; TODO: figure out why this broken; it says it failed to define clj-refactor (or
;; something like that)
;; (use-package clj-refactor
;;   :init
;;   (clj-refactor-mode 1)
;;   (yas-minor-mode 1)
;;   (cljr-add-keybindings-with-prefix "C-c C-m")
;;   :after clojure-mode
;;   :hook clojure-mode)

(use-package docker
  :commands docker)

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package docker-compose-mode
  :mode "docker-compose\\'")

;; TODO either install/config lsp or figure out how to use eglot for c++ and js
(use-package cc-mode
  ;; TODO: fk/c-run isn't defined in https://github.com/KaratasFurkan/.emacs.d#custom-functions - write my own
  ;; :bind
  ;; ( :map c-mode-base-map
  ;;   ("C-c C-c" . fk/c-run))
  ;;:hook
  ;;(c-mode . lsp-deferred)
  ;;(c++-mode . lsp-deferred)
  )

(use-package clang-format
  :commands clang-format-buffer clang-format-region
  :hook
  (c-mode . (lambda () (fk/add-local-hook 'before-save-hook 'clang-format-buffer)))
  (c++-mode . (lambda () (fk/add-local-hook 'before-save-hook 'clang-format-buffer))))

(use-package js2-mode
  :mode "\\.js\\'"
  :custom
  (js-indent-level 4)
  :hook
  (js2-mode . flycheck-mode)
  ;;(js2-mode . (lambda () (require 'tree-sitter-langs) (tree-sitter-hl-mode)))
  ;(js2-mode . lsp-deferred)
  )

(use-package tide)
;; TODO use-package-ify this copy-pasta
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(add-hook 'typescript-ts-mode-hook #'setup-tide-mode)
(add-hook 'js2-mode-hook #'setup-tide-mode)
(flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(use-package web-mode)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript - tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(if (fboundp 'global-flycheck-mode)
    (global-flycheck-mode +1)
  (add-hook 'prog-mode-hook 'flycheck-mode))

(use-package super-save
  :config
  (super-save-mode +1))

(use-package which-func
  :config
  (which-function-mode 1))

(use-package hl-todo
  :config
  (global-hl-todo-mode 1))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(connection-local-criteria-alist
   '(((:application eshell)
      eshell-connection-default-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((eshell-connection-default-profile
      (eshell-path-env-list))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(custom-enabled-themes '(zenburn))
 '(custom-safe-themes
   '("28a34dd458a554d34de989e251dc965e3dc72bace7d096cdc29249d60f395a82" default))
 '(safe-local-variable-values '((pyvenv-workon . needler)))
 '(typescript-ts-mode-indent-offset 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#3F3F3F" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 118 :width normal :foundry "1ASC" :family "JetBrainsMono Nerd Font"))))
 '(mode-line ((t (:height 120 :box (:line-width (1 . -1) :style released-button) :foreground "#8FB28F" :background "#2B2B2B")))))
