;; show line numbers (always)
(global-linum-mode 1)

;; show column numbers (always)
(setq column-number-mode t)

;; always display battery mode
(display-battery-mode 1)

;; record timestamp with org-mode done state
(setq org-log-done 'time)

;; copy to clipboard if highlighted with mouse
(setq select-active-regions nil)
(setq mouse-drag-copy-region t)
(global-set-key [mouse-2] 'mouse-yank-at-click)

;; for external packages
(add-to-list 'load-path "~/.emacs.d/")
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))

;; setup multi-term
(add-to-list 'load-path "~/.emacs.d/elpa/multi-term-0.8.8")
(require 'multi-term)

;; setup popup mode (because autocomplete requires it)
(add-to-list 'load-path "~/.emacs.d/elpa/popup-0.5")

;; setup auto-complete
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-1.4/dict")
(ac-config-default)
;;(auto-complete-mode t)

;; setup markdown mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; setup tabbar (to show tabs)
(add-to-list 'load-path "~/.emacs.d/elpa/tabbar-2.0.1")
(require 'tabbar)

(eval-after-load "tabbar"
  (tabbar-mode))

;; keep all tabs in one group
(setq tabbar-buffer-groups-function
      (lambda ()
        (list "All")))

;; add a buffer modification state indicator in the tab label,
;; and place a space around the label to make it looks less crowd
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
	(if (and (buffer-modified-p (tabbar-tab-value tab))
                 (buffer-file-name (tabbar-tab-value tab)))
            (concat " + " (concat ad-return-value " "))
          (concat " " (concat ad-return-value " ")))))

;; called each time the modification state of the buffer changed
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))

;; first-change-hook is called BEFORE the change is made
(defun ztl-on-buffer-modification ()
  (set-buffer-modified-p t)
  (ztl-modification-state-change))

(add-hook 'after-save-hook 'ztl-modification-state-change)

;; this doesn't work for revert, I don't know
;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)

;; setting up the color-theme
(add-to-list 'load-path "~/.emacs.d/elpa/color-theme-6.5.5")
(add-to-list 'load-path "~/.emacs.d/elpa/color-theme-solarized-20120301")
(require 'color-theme)
(setq color-theme-is-global t)
;;(color-theme-arjen)

;; setting up the solarized color-theme
(add-to-list 'load-path "~/.emacs.d/elpa/color-theme-solarized-20120301")
(require 'color-theme-solarized)

;; open emacs in maximized state
(defun x-maximize-frame ()
  "Maximize the current frame (to full screen)"
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))

(defun w32-maximize-frame ()
  "Maximize the current frame (to full screen)"
  (interactive)
  (w32-send-sys-command 61488))

(defun maximize-frame ()
  (if (eq window-system 'w32)
      (w32-maximize-frame)
    (x-maximize-frame)))

(if window-system
    (add-hook 'window-setup-hook 'maximize-frame t))

;; ruby related setup
(add-to-list 'load-path "~/.emacs.d/elpa/inf-ruby-2.2.3")
(add-to-list 'load-path "~/.emacs.d/elpa/ruby-compilation-0.9")
(add-to-list 'load-path "~/.emacs.d/elpa/jump-2.2")
(add-to-list 'load-path "~/.emacs.d/elpa/findr-0.7")
(add-to-list 'load-path "~/.emacs.d/elpa/inflections-1.1")
(add-to-list 'load-path "~/.emacs.d/elpa/ruby-block-0.0.11")
(add-to-list 'load-path "~/.emacs.d/elpa/haml-mode-3.0.14")
(require 'ruby-block)
(ruby-block-mode t)

(add-to-list 'load-path "~/.emacs.d/elpa/ruby-end-0.2.0")
(require 'ruby-end)

(add-to-list 'load-path "~/.emacs.d/elpa/rinari-2.10")
(require 'rinari)

(add-to-list 'load-path "~/.emacs.d/elpa/feature-mode-0.4")
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(add-to-list 'load-path "~/.emacs.d/elpa/yaml-mode-0.0.7")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\.yaml$" . yaml-mode))

(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\.haml$" . haml-mode))

;; add custom keyboard shortcuts
(global-set-key (kbd "C-x g") 'magit-status)

;; always display menubar
(menu-bar-mode 1)
;;(put 'menu-bar-mode 'standard-value '(t))

;; always display toolbar
(tool-bar-mode 1)

;; setup yasnippets
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-0.8.0")
(require 'yasnippet)
(yas/global-mode 1)
(yas--initialize)
(yas/load-directory "~/.emacs.d/elpa/yasnippet-0.8.0/snippets")
