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
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(transient-mark-mode t)


;;flymake

(require 'flymake)
(add-hook 'php-mode-hook 'flymake-php-load)
;;end flymake

;; TABS
(custom-set-variables
 '(c-basic-offset 4))
(setq tab-width 4)
(add-hook 'php-mode-hook
   (setq tab-width 4))
(setq-default indent-tabs-mode nil)


;;;;;;;;;;;
;; Linum ;;
;;;;;;;;;;;

(require 'linum)
(eval-after-load 'linum
  '(progn
     (defface linum-leading-zero
       `((t :inherit 'linum
            :foreground ,(face-attribute 'linum :background nil t)))
       "Face for displaying leading zeroes for line numbers in display margin."
       :group 'linum)

     (defun linum-format-func (line)
       (let ((w (length
                 (number-to-string (count-lines (point-min) (point-max))))))
         (concat
          (propertize (make-string (- w (length (number-to-string line))) ?0)
                      'face 'linum-leading-zero)
          (propertize (number-to-string line) 'face 'linum))))

     (setq linum-format 'linum-format-func)))
 (global-linum-mode 1)

(require 'sr-speedbar)
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

(require 'auto-complete-extension nil t) ;optional
(require 'auto-complete-yasnippet nil t) ;optional
(require 'auto-complete-semantic nil t)  ;optional
(require 'auto-complete-gtags nil t)     ;optional

(define-key ac-complete-mode-map [return] 'ac-expand)


;;;;;;;;;;;;;;
;; SPEEDBAR ;;
;;;;;;;;;;;;;;

;;(make-face 'speedbar-face)
;;(setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))

(setq speedbar-frame-parameters
      '((minibuffer)
	(width . 40)
	(border-width . 0)
	(menu-bar-lines . 0)
	(tool-bar-lines . 0)
	(unsplittable . t)
	(left-fringe . 0)))
;; (setq speedbar-hide-button-brackets-flag t)
;; (setq speedbar-show-unknown-files t)
;; (setq speedbar-smart-directory-expand-flag t)
;; (setq speedbar-use-images nil)
;; (setq sr-speedbar-auto-refresh nil)
;; (setq sr-speedbar-max-width 70)
;; (setq sr-speedbar-right-side nil)
;; (setq sr-speedbar-width-console 40)
(setq sr-speedbar-skip-other-window-p t)
;; (sr-speedbar-open)

(custom-set-variables '(ac-modes
'(emacs-lisp-mode lisp-interaction-mode
                c-mode cc-mode c++-mode java-mode
                perl-mode cperl-mode python-mode ruby-mode
                ecmascript-mode javascript-mode js2-mode js3-mode php-mode css-mode
                makefile-mode sh-mode fortran-mode f90-mode ada-mode
                xml-mode sgml-mode)))

(report-errors "File mode specification error: %s"
  (set-auto-mode))

(set-face-attribute 'linum nil :background "#222")
(setq linum-format "%4d\u2502")
(add-hook 'speedbar-mode-hook '(lambda () (linum-mode -1)))
(set-face-foreground 'speedbar-directory-face "lightblue3")
;; (setq-default show-trailing-whitespace t)



;;;;;;;;;;;;;;;;;;;;;;;;
;; windows management ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(winner-mode 1)
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)


(defun hide-cscope-buffer ()
  "Turn off the display of cscope buffer"
   (interactive)
   (if (not cscope-display-cscope-buffer)
       (progn
         (set-variable 'cscope-display-cscope-buffer t)
         (message "Turning ON display of cscope results buffer."))
     (set-variable 'cscope-display-cscope-buffer nil)
     (message "Toggling OFF display of cscope results buffer.")))


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
;; This is for multiple  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (add-to-list 'load-path "~/.emacs.d/multiple-cursors.el-master")
 (require 'multiple-cursors)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is for ido-imenu ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;


(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Global Keys

(global-set-key (kbd "C-S-v") 'duplicate-line)
(global-set-key (kbd "C-c =") 'sr-speedbar-open)
(global-set-key (kbd "C-c -") 'sr-speedbar-close)
(global-set-key (kbd "C-c p") 'sr-speedbar-select-window)
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c m") 'imenu)
(global-set-key (kbd "C-c C-v") 'duplicate-current-line-or-region)
(global-set-key (kbd "C-x C-b") 'my-list-buffers)

(global-set-key (kbd "C-c C-r") 'mc/mark-all-in-region)
(global-set-key (kbd "C-c C-w") 'mc/mark-all-words-like-this)


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

(add-to-list 'load-path
              "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)