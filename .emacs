(add-to-list 'load-path "~/.emacs.d/")

;;;;;;;;;;;;;;;;;;;;;;;
;; Autocomplete Mode ;;
;;;;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)
(global-auto-complete-mode t)
(setq ac-modes
      '(rst-mode latex-mode python-mode latex-mode tex-mode php-mode js2-mode))

(setq tramp-default-method "ssh")
(setq password-cache-expiry nil)


;;;;;;;;;;;;;;;;;;;;;;;
;; Programming Modes ;;
;;;;;;;;;;;;;;;;;;;;;;;

(require 'python-mode)
(require 'php-mode)
(require 'rst)
(require 'js3-mode)

;;;;;;;;;;;;;;;;;;;;;;;
;; Some Basic Set Up ;;
;;;;;;;;;;;;;;;;;;;;;;;

(setq backup-directory-alist '(("." . "~/emacs-backups")))
(setq make-backup-files nil)
(auto-save-mode)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(transient-mark-mode t) ;; highlighting region


;;;;;;;;;;;;;
;; Flymake ;;
;;;;;;;;;;;;;
;;Fucking Useless

;; (require 'flymake)
;; (add-hook 'php-mode-hook 'flymake-php-load)


;;;;;;;;;;
;; TABS ;;
;;;;;;;;;;

(custom-set-variables
 '(c-basic-offset 4))
(setq tab-width 4)
(add-hook 'php-mode-hook
   (setq tab-width 4))
(setq-default indent-tabs-mode nil)
(add-to-list 'auto-mode-alist '("\\.php5$" . php-mode))


;;;;;;;;;;;
;; Linum ;;
;;;;;;;;;;;

(require 'linum)
(global-linum-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tree Like Strucutre ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'sr-speedbar)
;;(make-face 'speedbar-face)
;;(setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))
;; (setq speedbar-frame-parameters
;;       '((minibuffer)
;; 	(width . 40)
;; 	(border-width . 0)
;; 	(menu-bar-lines . 0)
;; 	(tool-bar-lines . 0)
;; 	(unsplittable . t)
;; 	(left-fringe . 0)))
;; (setq speedbar-hide-button-brackets-flag t)
;; (setq speedbar-show-unknown-files t)
;; (setq speedbar-smart-directory-expand-flag t)
;; (setq speedbar-use-images nil)
;; (setq sr-speedbar-auto-refresh nil)
;; (setq sr-speedbar-max-width 70)
;; (setq sr-speedbar-right-side nil)
;; (setq sr-speedbar-width-console 40)
;; (setq sr-speedbar-skip-other-window-p t)
;; (sr-speedbar-open)


;;;;;;;;;;;;;;;;;;;;;;;
;; Parenthesis, "", () etc
;;;;;;;;;;;;;;;;;;;;;;;

(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers


;; Not Sure Wtf it is
(require 'auto-complete-extension nil t) ;optional
;; (require 'auto-complete-yasnippet nil t) ;optional
(require 'auto-complete-semantic nil t)  ;optional
(require 'auto-complete-gtags nil t)     ;optional
(define-key ac-complete-mode-map [return] 'ac-expand)

(custom-set-variables '(ac-modes
'(emacs-lisp-mode lisp-interaction-mode
                c-mode cc-mode c++-mode java-mode
                perl-mode cperl-mode python-mode ruby-mode
                ecmascript-mode javascript-mode js2-mode js3-mode php-mode css-mode
                makefile-mode sh-mode fortran-mode f90-mode ada-mode
                xml-mode sgml-mode)))

(report-errors "File mode specification error: %s"
  (set-auto-mode))

;;;;;;;;;;;;;;;;;;
;; update Etags ;;
;;;;;;;;;;;;;;;;;;

(require 'etags-update)
(etags-update-mode)
(setq tags-revert-without-query 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Do Things Interactively ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ido)
(ido-mode t)
(ido-toggle-case)

(setq initial-scratch-message nil)
(kill-buffer "*scratch*")
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))


(setq inhibit-default-init t)
(defun my-list-buffers (&optional files-only)
  "Display a list of names of existing buffers.
The list is displayed in a buffer named `*Buffer List*'.
Note that buffers with names starting with spaces are omitted.
Non-null optional arg FILES-ONLY means mention only file buffers.

For more information, see the function `buffer-menu'."
  (interactive "P")
  (switch-to-buffer (list-buffers-noselect files-only)))
(ido-toggle-case)

;;;;;;;;;;;;;;;;;;;;;;;
;; PHP Comment Style ;;
;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'php-mode-hook (lambda () (setq comment-start "//"
                                        comment-end   "")))
(add-hook 'java-mode-hook (lambda () (setq comment-start "//"
                                        comment-end   "")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Multiple Cursors
;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (add-to-list 'load-path "~/.emacs.d/multiple-cursors.el-master")
 (require 'multiple-cursors)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Show WhiteSpace
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default show-trailing-whitespace t)
;;(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; If you wanna remove on save


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Searching in all buffers ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun grep-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete anything with IDO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defvar ido-enable-replace-completing-read t
      "If t, use ido-completing-read instead of completing-read if possible.

    Set it to nil using let in around-advice for functions where the
    original completing-read is required.  For example, if a function
    foo absolutely must use the original completing-read, define some
    advice like this:

    (defadvice foo (around original-completing-read-only activate)
      (let (ido-enable-replace-completing-read) ad-do-it))")

    ;; Replace completing-read wherever possible, unless directed otherwise
    (defadvice completing-read
      (around use-ido-when-possible activate)
      (if (or (not ido-enable-replace-completing-read) ; Manual override disable ido
              (and (boundp 'ido-cur-list)
                   ido-cur-list)) ; Avoid infinite loop from ido calling this
          ad-do-it
        (let ((allcomp (all-completions "" collection predicate)))
          (if allcomp
              (setq ad-return-value
                    (ido-completing-read prompt
                                   allcomp
                                   nil require-match initial-input hist def))
            ad-do-it))))


;; Invoking Bookmarks with IDO
(require 'bookmark)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setup files ending in “.js” to open in js3-mode                ;;
;; Note that auto-complete functions are in .emacs.d/ac/java-mode ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))


(custom-set-variables                                      ;;
  ;; Your init file should contain only one such instance. ;;
  ;; If there is more than one, they won't work right.     ;;
 '(js3-lazy-operators t)                                   ;;
 '(js3-expr-indent-offset 2)                               ;;
 '(js3-paren-indent-offset 2)                              ;;
 '(js3-square-indent-offset 2)                             ;;
 '(js3-curly-indent-offset 2))                             ;;


(setq auto-mode-alist
      (append '(("\\.txt$" . rst-mode)
                ("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Switch to the buffer on split screen ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defadvice split-window (after move-point-to-new-window activate)
  "Moves the point to the newly created window after splitting."
  (other-window 1))

;; (add-to-list 'load-path
;;               "~/.emacs.d/yasnippet")
;; (require 'yasnippet)
;; (yas-global-mode 1)



;;;;;;;;;;;;;;;;;
;; Global Keys ;;
;;;;;;;;;;;;;;;;;

;; (global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c =") 'sr-speedbar-open)
(global-set-key (kbd "C-c -") 'sr-speedbar-close)
(global-set-key (kbd "C-c p") 'sr-speedbar-select-window)
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)
(global-set-key (kbd "C-x m") 'imenu)

(global-set-key (kbd "C-c C-y") 'duplicate-current-line-or-region)
(global-set-key (kbd "C-x C-b") 'my-list-buffers)


(global-set-key (kbd "C-c C-r") 'mc/mark-all-in-region)
(global-set-key (kbd "C-c C-g") 'mc/mark-all-words-like-this)
(global-set-key (kbd "C-c C-j") 'mc/mark-next-word-like-this)

(windmove-default-keybindings)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)

(require 'init-utils)

;;;;;;;;;;;;;;;;
;; Vim Like % ;;
;;;;;;;;;;;;;;;;

(defun my-shell-command-on-current-file (command &optional output-buffer error-buffer)
  "Run a shell command on the current file (or marked dired files).
In the shell command, the file(s) will be substituted wherever a '%' is."
  (interactive (list (read-from-minibuffer "Shell command: "
                                           nil nil nil 'shell-command-history)
                     current-prefix-arg
                     shell-command-default-error-buffer))
  (cond ((buffer-file-name)
         (setq command (replace-regexp-in-string "%" (buffer-file-name) command nil t)))
        ((and (equal major-mode 'dired-mode) (save-excursion (dired-move-to-filename)))
         (setq command (replace-regexp-in-string "%" (mapconcat 'identity (dired-get-marked-files) " ") command nil t))))
  (shell-command command output-buffer error-buffer))

(global-set-key (kbd "M-!") 'my-shell-command-on-current-file)

;;;;;;;;;;;;;;;;;;;;;
;; Ma Git & Mo Git ;;
;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/magit-1.2.0/")
(require 'magit)
(require 'mo-git-blame)

;;;;;;;;;;;;
;; popwin ;;
;;;;;;;;;;;;
(require 'popwin)
(popwin-mode 1)


;;;;;;;;;;;;;;;;;;;
;; Markdown Mode ;;
;;;;;;;;;;;;;;;;;;;

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(setq markdown-css-dir "~/.emacs.d/markdown-css/")
(setq markdown-css-theme "avenir-white")
(setq markdown-command "/usr/local/bin/markdown")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For Shell When the Cursor keeps on moving to center ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(remove-hook 'comint-output-filter-functions
             'comint-postoutput-scroll-to-bottom)

;; Bash autocompletion in Emacs shell-mode
(global-set-key "\M-\r" 'shell-resync-dirs)

;; Ignore Duplicate Commands Emacs Shell
(setq comint-input-ignoredups t)

(custom-set-variables
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output nil) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
 ;; '(comint-completion-autolist t)     ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-completion-addsuffix t)       ; insert space/slash after file completion
 '(comint-buffer-maximum-size 20000)    ; max length of the buffer in lines
 '(comint-prompt-read-only nil)         ; if this is t, it breaks shell-command
 '(comint-get-old-input (lambda () "")) ; what to run when i press enter on a
                                        ; line above the current prompt
 '(comint-input-ring-size 5000)         ; max shell history size
 '(protect-buffer-bury-p nil)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Disable Menu Bar
(menu-bar-mode -1)

;; Bash Completion
(require 'bash-completion)
(bash-completion-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlighting Current Line ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight nil)

(setq lazy-highlight-cleanup nil) ;; Keep Highlighted Unhighlight C-s C-g


;; Desktop Save Mode Enable
;; (desktop-save-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;
;; PHPArray Indentation
;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'php-mode-hook (lambda ()
                           (defun ywb-php-lineup-arglisti-ntro (langelem)
                             (save-excursion
                               (goto-char (cdr langelem))
                               (vector (+ (current-column) c-basic-offset))))
                           (defun ywb-php-lineup-arglist-close (langelem)
                             (save-excursion
                               (goto-char (cdr langelem))
                               (vector (current-column))))
                           (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
                           (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)))

;;;;;;;;;;;;;;
;; yml modee;;
;;;;;;;;;;;;;;

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;;;;;;;;;;;;;;
;; Web  Mode ;;
;;;;;;;;;;;;;;;

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$" . web-mode))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git Gutter If wanna use  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'git-gutter)
;; (global-git-gutter-mode t)
;; (setq git-gutter:modified-sign ".") ;; two space
;; (setq git-gutter:added-sign "+")    ;; multiple character is OK
;; (setq git-gutter:deleted-sign "-")


;;;;;;;;;;;;;;;
;; Ruby Mode ;;
;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/ruby-mode")
(add-to-list 'auto-mode-alist
              '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))


;;;;;;;;;;;;;;;;;
;; Coffee Mode ;;
;;;;;;;;;;;;;;;;;
(require 'coffee-mode)
