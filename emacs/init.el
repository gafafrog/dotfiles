;;; init.el — entry point

(let ((dir (file-name-directory (file-truename load-file-name))))
  (load (expand-file-name "me.el" dir)))
