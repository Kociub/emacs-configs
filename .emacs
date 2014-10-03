;; hide the tool bar
(tool-bar-mode -1)

;; use cua mode (ctrl-c, ctrl-v, etc.) by default
(cua-mode t)

;; allows to change window with alt+arrow
(require 'windmove)
(windmove-default-keybindings 'meta)

;; set theme to wombat
(custom-set-variables
'(custom-enabled-themes (quote (wombat))))
(custom-set-faces)

;; use C-c k to rename the current buffer and file
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(global-set-key (kbd "C-c r")  'rename-file-and-buffer)

;; while saving file creates directories if they don't exists
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))
