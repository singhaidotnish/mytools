;; -------------------------------
;; 🧠 ADHD-Friendly Emacs Config
;; -------------------------------

;; Minimal UI
(menu-bar-mode 1)
(tool-bar-mode 1)
(scroll-bar-mode 1)
(transient-mark-mode 1)
(setq inhibit-startup-screen t)
(setq package-check-signature nil)
;; Line numbers
(global-display-line-numbers-mode 1)

;; Line wrapping for readability
(global-visual-line-mode 1)

;; Theme: Wombat (dark, low strain)
(load-theme 'wombat t)

;; initialize package.el, add MELPA and GNU ELPA
(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; install use-package if it’s missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; now load use-package
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Bind C-a to select the entire buffer
(global-set-key (kbd "C-a") 'mark-whole-buffer)
;; ---------------------
(use-package web-mode
  :ensure t)

;; ---------------------
;; 🐍 Python: Elpy Setup
;; ---------------------
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")

;; Auto-pair brackets
(electric-pair-mode 1)

;; Auto-format with black (optional)
(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode))

;; ----------------------
;; 📝 Org Mode Friendly
;; ----------------------
(setq org-startup-indented t)

;; ----------------------
;; ⏩ Faster startup
;; ----------------------
(setq gc-cons-threshold 100000000)
;; ---------------------
;; indents spaces
;; ---------------------
(setq-default indent-tabs-mode nil) ; use spaces
(setq-default tab-width 4)          ; set tab width

;; ----------------------
;; ✅ Helpful Reminders
;; ----------------------
(defun emacs-welcome-message ()
  (message "✅ Use C-x C-f to open files, C-c C-c to run Python!"))

(add-hook 'emacs-startup-hook #'emacs-welcome-message)

(defun copy-buffer-file-path ()
  "Copy the full path to the current file to the kill ring."
  (interactive)
  (if buffer-file-name
      (progn
        (kill-new buffer-file-name)
        (message "Copied buffer file path: %s" buffer-file-name))
    (message "Buffer not visiting a file")))
(global-set-key (kbd "C-c p") 'copy-buffer-file-path)
;; ----------------------
;; indents
;; ----------------------
(defun toggle-indent-width (&optional width)
  "Set indent width to WIDTH (2, 4, or 8). If not given, toggle between 2 and 4.
If current buffer is a .tsx file, switch to web-mode before indenting."
  (interactive
   (list
    (read-number "Enter indent width (or leave blank to toggle): " nil)))

  ;; 🔄 Ensure web-mode is available before calling it
  (require 'web-mode)
  
  ;; 🧠 Force web-mode for .tsx if needed
  (when (and buffer-file-name
             (string-match-p "\\.tsx\\'" buffer-file-name)
             (not (eq major-mode 'web-mode)))
    (web-mode)
    (message "🔁 Switched to web-mode for TSX indentation"))

  ;; 🧠 Set the indent width
  (let* ((current-indent (cond
                          ((boundp 'web-mode-code-indent-offset) web-mode-code-indent-offset)
                          ((boundp 'js-indent-level) js-indent-level)
                          ((boundp 'typescript-indent-level) typescript-indent-level)
                          (t 2)))
         (target-indent (or width
                            (if (= current-indent 2) 4 2))))

    ;; Apply indent settings
    (when (boundp 'web-mode-code-indent-offset)
      (setq web-mode-code-indent-offset target-indent)
      (setq web-mode-markup-indent-offset target-indent)
      (setq web-mode-css-indent-offset target-indent))
    (when (boundp 'js-indent-level)
      (setq js-indent-level target-indent))
    (when (boundp 'typescript-indent-level)
      (setq typescript-indent-level target-indent))

    ;; Reindent if mode is supported
    (when (memq major-mode '(js-mode js2-mode typescript-mode typescript-ts-mode web-mode))
      (save-excursion
        (indent-region (point-min) (point-max)))
      (message "✅ Indent set to %d and buffer reindented" target-indent))

    (unless (memq major-mode '(js-mode js2-mode typescript-mode typescript-ts-mode web-mode))
      (message "✅ Indent set to %d — buffer NOT reindented (unsupported mode)" target-indent))))
;;========================
;; Reload config quickly
;;========================
(defun reload-init-file ()
  (interactive)
  (load-file user-init-file)
  (message "🚀 Emacs config reloaded!"))

(global-set-key (kbd "C-c r") 'reload-init-file)
;;========================
;; open init.el
;;========================
(defun open-my-config ()
  "Open my Emacs config file."
  (interactive)
  (find-file user-init-file))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ispell-dictionary nil)
 '(package-selected-packages '(web-mode use-package elpy blacken)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, the;; ===========================
;; Store backups & autosaves elsewhere
;; ===========================

;; Create a central backups dir if it doesn't exist
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

;; Put auto-saves in the same central place
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save-list/" user-emacs-directory) t)))

;; Keep auto-save-list dir clean
(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" user-emacs-directory))

;; Optional: don't make lockfiles (".#filename")
(setq create-lockfiles nil)
y won't work right.
 )
