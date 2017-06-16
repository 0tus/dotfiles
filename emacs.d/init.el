(require 'package)

;; Packages
;; ========

(defvar dam-packages
  '(
    ;; auto-complete
    cider
    clj-refactor
    clojure-mode
    company
    emmet-mode
    evil
    exec-path-from-shell
    fill-column-indicator
    flx
    flx-ido
    fuzzy
    ;; git-gutter+
    haskell-mode
    helm
    helm-ag
    helm-git-grep
    highlight-parentheses
    ido-ubiquitous
    ido-vertical-mode
    magit
    markdown-mode
    monokai-theme
    multiple-cursors
    neotree
    paredit
    projectile
    rainbow-delimiters
    ruby-mode
    smex
    ;; smooth-scroll
    smooth-scrolling
    tuareg ;; OCaml mode
    undo-tree
    which-key)
  "Dam packages")

;; Emacs >= 24.4
;; (add-to-list 'package-pinned-packages '(auto-complete . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(clojure-mode . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(evil . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(flx . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(flx-ido . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(fuzzy . "melpa-stable") t)
;; (add-to-list 'package-pinned-packages '(git-gutter+ . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(haskell-mode . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(helm . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(helm-ag . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(helm-git-grep . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(highlight-parentheses . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(ido-ubiquitous . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(ido-vertical-mode . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(multiple-cursors . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(paredit . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(projectile . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(rainbow-delimiters . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(smex . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(tuareg . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(which-key . "melpa-stable") t)

;; On a freshly installed Emacs: `M-x` -> `dam-install-packages`
(defun dam-install-packages ()
  "Installs packages used in this configuration"
  (interactive)
  (condition-case nil
      (progn
        (package-initialize)
        (message "%s" "Refreshing packages")
        (package-refresh-contents)
        (message "%s" " Done")
        (mapc
         (lambda (package)
           (or (package-installed-p package)
               (package-install package)))
         dam-packages))
    (error
     (message "%s" "Error on packages installation"))))


;; Emacs configuration
;; ===================

;; Set up load path
;; (add-to-list 'load-path user-emacs-directory t)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(package-initialize)
;; exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
;; ---
(load custom-file)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please
(setq inhibit-startup-message t)

;; Auto revert (~ reload modified files)
(global-auto-revert-mode t)

;; Display line number
(global-linum-mode t)

;; (setq linum-format "%d")
;; (setq linum-format "%4d \u2502 ")

;; Display line number
;; (setq column-number-mode t)

(load-library "iso-transl")

;; store all backup and autosave files in the tmp dir
;; (setq auto-save-default nil)
;; (setq make-backup-files nil)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Font size
(set-face-attribute 'default nil :height 130)

;; disable ring bell
(setq ring-bell-function 'ignore)

;; UTF-8 default encoding
(prefer-coding-system 'utf-8)

;; Exec Path
;; http://stackoverflow.com/questions/13671839/cant-launch-lein-repl-in-emacs
;; Suggestion:
;; (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
;; (setq exec-path (append exec-path '("/usr/local/bin")))
;; But this simpler option works
(add-to-list 'exec-path "/usr/local/bin")

;; case insensitive sorts
(setq-default sort-fold-case t)

;; General keybindings
;; ===================

;; For Mac OS rebind meta to function key
(when (eq system-type 'darwin)
  ;; (setq mac-function-modifier 'meta)
  ;; (setq mac-option-modifier 'none))
  (setq mac-left-option-modifier 'meta)
  (setq mac-right-option-modifier 'none)
  (setq ns-use-native-fullscreen nil)
  (global-set-key [f9] 'toggle-frame-fullscreen)
  )

;; Linux specific
(when (or (eq system-type 'gnu)
          (eq system-type 'gnu/linux))
  (global-set-key [f11] 'fullscreen-mode-fullscreen-toggle)
  (global-set-key (kbd "<menu>") 'smex))

;; Move cursor easily between windows
(global-set-key (kbd "<M-A-left>") 'windmove-left)
(global-set-key (kbd "<M-A-right>") 'windmove-right)
(global-set-key (kbd "<M-A-up>") 'windmove-up)
(global-set-key (kbd "<M-A-down>") 'windmove-down)

;; Resize windows
(global-set-key (kbd "<C-S-up>") 'shrink-window)
(global-set-key (kbd "<C-S-down>") 'enlarge-window)
(global-set-key (kbd "<C-S-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-S-right>") 'enlarge-window-horizontally)

;; Fill Column
(setq-default fill-column 80)
(setq auto-fill-mode 1)

;; Downcase
(put 'downcase-region 'disabled nil)

;; General installed modes
;; =======================

;; Evil mode
;; ---------

(evil-mode 1)

;; Rainbow delimiters
;; ------------------

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; IDO
;; ---

(require 'ido)
(require 'ido-ubiquitous)
(require 'flx-ido)
(require 'ido-vertical-mode)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)
(ido-mode +1)
(ido-ubiquitous-mode +1)
(ido-vertical-mode +1)

;; SMEX
;; ----

(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Smooth scrolling
;; ----------------

(require 'smooth-scrolling)
;; (setq scroll-step 1)
;; (setq scroll-conservatively 1000)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;; (setq mouse-wheel-progressive-speed nil)
;; (setq mouse-wheel-follow-mouse t)

;; Nice scrolling
(setq
 scroll-margin 0
 scroll-conservatively 100000
 scroll-preserve-screen-position 1)

;; Smooth scroll
;; -------------

;; (require 'smooth-scroll)
;; (smooth-scroll-mode 'toggle)

;; Company mode
;; ------------

(add-hook 'after-init-hook 'global-company-mode)

;; Autocomplete
;; ------------

;; (require 'auto-complete)
;; (ac-flyspell-workaround)
;; (ac-linum-workaround)
;; (global-auto-complete-mode t)

;; Multiple cursors
;; ----------------

(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Dired plus
;; ----------

;; (toggle-diredp-find-file-reuse-dir 1)

;; Ibuffer
;; -------

;; Use Ibuffer instead of Buffer List
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Git gutter plus
;; ---------------

;; (add-hook 'prog-mode-hook 'git-gutter+-mode)
;; (eval-after-load 'git-gutter+
;;   '(require git-gutter-fringe+))

;; Magit
;; -----

(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

;; Neotree
;; -------

(global-set-key [f8] 'neotree-toggle)


;; Fill Column Indicator
;; ---------------------

;; (add-hook 'prog-mode-hook 'fci-mode)


;; Which-key
;; ---------

(require 'which-key)
(which-key-mode)


;; Language modes
;; ==============

;; Emacs Lisp
;; ----------

(add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)


;; Clojure / ClojureScript
;; -----------------------

(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljx\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojurescript-mode))
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))
(add-hook 'clojure-mode-hook 'highlight-parentheses-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)

;; https://github.com/bhauman/lein-figwheel/wiki/Using-the-Figwheel-REPL-within-NRepl#integration-with-emacscider
;; (require 'cider)
;; (setq cider-cljs-lein-repl
;;       "(do (require 'figwheel-sidecar.repl-api)
;;            (figwheel-sidecar.repl-api/start-figwheel!)
;;            (figwheel-sidecar.repl-api/cljs-repl))")

(require 'clj-refactor)
(defun my-clojure-mode-hook ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1) ; for adding require/use/import statements
    ;; This choice of keybinding leaves cider-macroexpand-1 unbound
    (cljr-add-keybindings-with-prefix "C-c C-m"))
(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(require 'cider)
(setq cider-repl-use-pretty-printing t)
(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

;; Haskell
;; -------

;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;; (custom-set-variables
;;   '(haskell-process-suggest-remove-import-lines t)
;;   '(haskell-process-auto-import-loaded-modules t)
;;   '(haskell-process-log t))

;; Haskell bindings
;; (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
;; (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
;; (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
;; (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
;; (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
;; (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
;; (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
;; (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)

;; Cabal bindings
;; (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
;; (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
;; (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
;; (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)

;; Ruby
;; ----

(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))

;; Javascript
;; ----------

;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)


;; HTML and templates
;; ------------------

(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)

(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
;; (setq web-mode-engines-alist '(("underscore" . "\\.tpl\\'")) )


;; Elixir - Alchemist
;; ------------------

(setq alchemist-goto-erlang-source-dir "~/code/github-non-dam/otp-OTP-19.3")
(setq alchemist-goto-elixir-source-dir "~/code/github-non-dam/elixir-1.4.2")
;; (setq alchemist-mix-command "/usr/local/bin/mix")
;; (setq alchemist-iex-program-name "/usr/local/bin/iex")
;; (setq alchemist-execute-command "/usr/local/bin/elixir")
;; (setq alchemist-compile-command "/usr/local/bin/elixirc")


;; ELM
;; ---

;; (add-hook 'elm-mode-hook 'auto-complete-mode)


;; LaTeX - AucTeX
;; --------------

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(setq TeX-PDF-mode t)
