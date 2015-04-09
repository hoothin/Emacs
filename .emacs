(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-linum-mode t)
 '(mu-worlds (quote (["BookSword" "202.100.210.107" 6666 "Hoothin" "guest"])))
 '(truncate-partial-width-windows nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "YaHei Consolas Hybrid" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
 (set-default-font "YaHei Consolas Hybrid")

;; Chinese Font 配置中文字体
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
                    charset
                    (font-spec :family "YaHei Consolas Hybrid" :size 16)))

;;改变默认路径
;;(setenv "HOME" "")
;;(setenv "PATH" "")
;;(load-file "\\.emacs")
; 如果想在emacs的SHELL中调用某个程序，要把它的路径加入 "PATH"，此处必须是完整路径 
; 如果想在 elisp 中调用某个程序，要把它的路径加入 exec-path
(setq exec-path (append exec-path '("~/support")))

;;包管理增加来源
(require 'package)
; (add-to-list 'package-archives'
  ; ("elpa" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives'
  ("tromey" . "http://tromey.com/elpa/") t)
; (add-to-list 'package-archives' 
;  ("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives'
  ("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(load-theme 'monokai t)

;;全屏启动
(defun jbr-init () 
"Called from term-setup-hook after the default
terminal setup is
done or directly from startup if term-setup-hook not
used.  The value
0xF030 is the command for maximizing a window." 
  (interactive)
  (w32-send-sys-command #xf030)
  ;(calendar)
)
(setq term-setup-hook 'jbr-init)
(setq window-setup-hook 'jbr-init)

;;设置c-x c-f打开的默认路径
(setq default-directory "~" )

;;设置默认编码
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;外观设置   
;;去掉工具栏   
(tool-bar-mode 0)

;;去掉菜单栏
;(menu-bar-mode 0)

;;不要滚动栏
(scroll-bar-mode 0)

;;指针不要闪 
;(blink-cursor-mode -1)

;;当指针到一个括号时，自动显示所匹配的另一个括号   
(show-paren-mode 1)
;;去掉烦人的警告铃声   
(setq visible-bell 0)

;;去掉Emacs和gnus启动时的引导界面   
(setq inhibit-startup-message t)   
(setq gnus-inhibit-startup-message t)

;;在minibuffer上面可以显示列号   
(column-number-mode t)   
;;显示默认的文档的宽度
(setq default-fill-column 60)

;;在minibuffer里启用自动补全函数和变量   
(icomplete-mode 1)

;; 不要问yes or no, 用y/n代替
(fset 'yes-or-no-p 'y-or-n-p)

;;设置代理
;;(setq url-proxy-services '(("http" . "127.0.0.1:8087")))
;;(setenv "http_proxy" "http://127.0.0.1:8087")

;;自动显示图片
(auto-image-file-mode)

;;{{{ 如果你正在编辑一个东西（在位置A），突然想到别的某处（位置B）要修改或查看
;;或别的，总之你要过去看看，你可以用C-'来在当前位置做个标记，然后去你想去的
;;地方B，看了一会你觉的我可以回A去了，用C-,就回到刚才做标记的地方A，再用C-,又会回到B
;;这个由王垠创作
(global-set-key (kbd "C-'") 'ska-point-to-register)
(global-set-key (kbd "C-;") 'ska-jump-to-register)
(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
  Use ska-jump-to-register to jump back to the stored
  position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and position
  that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))

;;smex "M-x"快捷键增强
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;helm 递增式补全和缩小选择范围功能
(add-to-list 'load-path "~/.emacs.d/lisp/helm")
(require 'helm-config)
(helm-mode 1)

;; 换行
(global-set-key [f9] 'toggle-truncate-lines)

;;org-mode
(setq org-publish-project-alist
      '(("note-org"	;;将所有org文件发布为html
         :base-directory "~/note/org.src/"
         :recursive t
         :base-extension "org"
         :publishing-directory "~/note/org.html/"
         :publishing-function org-html-publish-to-html
         :auto-sitemap t                ; Generate sitemap.org automagically...
         :sitemap-filename "!sitemap.org"  ; ... call it sitemap.org (it's the default)...
         :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
         :auto-preamble t	;;html开头目录
         :makeindex t)	;;生成跳转到#+index: XXX标记的链接的汇总文件
        ("note-static"	;;发布附件
         :base-directory "~/note/org.src/"
         :publishing-directory "~/note/org.html/"
         :recursive t
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-function org-publish-attachment)
        ("note"	;;将html与附件一起发布
         :components ("note-org" "note-static"))))
;; org2blog
(require 'org2blog-autoloads)
(setq org2blog/wp-blog-alist
      `(("Hoothin's Blog"
         :url "http://hoothin.com/xmlrpc.php"
         :username "admin")
        ))
(setq org2blog/wp-buffer-template
    "#+DATE: %s
#+CATEGORY: 
#+TAGS:
#+TITLE:
\n")

;;org日历视图
(setq org-agenda-files (list "~/note/"
"~/note/org.src/"))
(global-set-key "\C-ca" 'org-agenda)

(require 'ps-ccrypt)

(appt-activate 1) 

;;org-remember改名org-capture
(setq org-default-notes-file "~/.notes")
(define-key global-map [f12] 'org-capture)
;(setq org-capture-templates
;      '(("TODO" ?d "* TODO %?\n %x\n %a" "~/org-mode/todo.org" "Task List")
;    ("IDEA" ?i "* IDEA %?\n %i\n %a" "~/org-mode/todo.org" "Idea List")
;    ))
(setq org-capture-templates
'(("t" "Todo" entry (file+headline "~/note/todo.org" "Task")
       "* TODO %?\n  %i\n  DEADLINE: <%<%Y-%m-%d %a>>  SCHEDULED: <%<%Y-%m-%d %a>>\n")
  ("i" "Idea" entry (file+headline "~/note/todo.org" "Tickler")
       "* %?\n  %i\n  %a")
  ("d" "Diary" entry (file+datetree (concat "~/note/journal/" (concat (format-time-string "%Y-%m") ".org.cpt")) "")
   "* null %?\nEntered on %U\n  %i")))
(setq org-log-done 'time)

;; Dangerous!!!  This might remove entries added by `appt-add' manually.在 Org Mode 的 Agenda View 下，按 r 或者 g，就可以把有具体时间的任务添加到appt的任务提醒列表里面。需要注意的是，手工使用 appt-add 添加的提醒将被清除，无法恢复。
(org-agenda-to-appt t "TODO")
(defadvice  org-agenda-redo (after org-agenda-redo-add-appts)
  "Pressing `r' on the agenda will also add appointments."
  (progn
    (let ((config (current-window-configuration)))
      (appt-check t)
      (set-window-configuration config))
    (org-agenda-to-appt)))
(ad-activate 'org-agenda-redo)

;;启用图文混排
(add-hook 'org-mode-hook 'iimage-mode)
(iimage-mode t)

;;yasnippet 智能填充模板
(require 'yasnippet)
(yas/global-mode 1)
(yas/minor-mode-on)

;;auto-complete 自动补全
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-modes
	(append ac-modes '(haxe-mode org-mode objc-mode jde-mode sql-mode
		change-log-mode text-mode
		makefile-gmake-mode makefile-bsdmake-mo
		autoconf-mode makefile-automake-mode)))
(ac-config-default)
(setq ac-dwim t)
(defun ac-cmake-mode-setup ()
  (setq ac-sources (append '(ac-source-yasnippet  ac-source-dictionary) ac-sources)))
(add-hook 'cmake-mode-hook 'ac-cmake-mode-setup)
(defun ac-org-mode-setup ()
  (setq ac-sources (append '(ac-source-yasnippet  ac-source-dictionary) ac-sources)))
(add-hook 'org-mode-hook 'ac-org-mode-setup)
(defun ac-haxe-mode-setup ()
  (setq ac-sources (append '(ac-source-yasnippet  ac-source-dictionary) ac-sources)))
(add-hook 'haxe-mode-hook 'ac-haxe-mode-setup)

;;打开文件和切换buffer增强，win下不能切换盘符
;;(require 'ido)
;;(ido-mode t)

;;撤销删除
(require 'redo+)
(setq undo-no-redo t)	;;不要撤销撤销操作本身

;;记录和恢复屏幕
(load "desktop") 
(desktop-load-default) 
;(desktop-read)
(desktop-save-mode 1)

;;保存全局变量 (kill-ring，命令记录……)，局部变量，寄存器，打开的文件，修改过的文件和最后修改的位置等
(require 'session) 
(add-hook 'after-init-hook 'session-initialize) 
(add-hook 'after-init-hook 'resume)
(add-hook 'kill-emacs-hook 'save-current-configuration)

;;mush与mud支持
(autoload 'mu-open "mu" "Play on MUSHes and MUDs" t)
(add-hook 'mu-connection-mode-hook 'ansi-color-for-comint-mode-on)

;; w3m
(require 'w3m)
;;设置w3m为emacs的默认浏览器,使用新tabs打开由browser-usr函数输入的url
(setq browse-url-browser-function 'w3m-browse-url browse-url-new-window-flag t)
;; enable cookies
(setq w3m-use-cookies t)
;;设置代理
;;(setq w3m-command-arguments
;;      (nconc w3m-command-arguments
;;             '("-o" "http_proxy=http://.com:8000/")))
(setq w3m-home-page "http://dict.youdao.com/")
(setq w3m-default-display-inline-images t)

;;多光标
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-=") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

;;快速跳转 C-f1 跳单词 C-u C-f1 跳字母 C-u C-u C-f1 跳行
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(global-set-key [C-f1] 'ace-jump-mode)

;;窗口快速跳转
(global-set-key [C-f2]  'ace-window)

;;撤销重做窗口操作C-c left C-c right
(winner-mode 1)

(global-set-key [C-f3] 'windresize)

;C-f4关闭当前buffer 
(global-set-key [C-f4] 'kill-this-buffer)

;;如果没有激活区域就注释当前行
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))
  (comment-dwim arg)))
(global-set-key "\M-;" 'comment-dwim-line)

;; 如果没有激活区域就复制当前一整行
(defadvice kill-line (before check-position activate)
  (if (member major-mode
        '(emacs-lisp-mode scheme-mode lisp-mode
                c-mode c++-mode objc-mode js-mode
                latex-mode plain-tex-mode))
    (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
         (just-one-space 0)
         (backward-char 1)))))
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end))
         (message "Copied line")
         (list (line-beginning-position)
             (line-beginning-position 2)))))
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
   (list (line-beginning-position)
       (line-beginning-position 2)))))
(defun modified-copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (point)
          (line-end-position))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key (kbd "M-k") 'modified-copy-line)

(require 'haxe-mode)
(defconst my-haxe-style
  '("java" (c-offsets-alist . ((case-label . +)
                               (arglist-intro . +)
                               (arglist-cont-nonempty . 0)
                               (arglist-close . 0)
                               (cpp-macro . 0))))
  "My Haxe Programming Style")
(add-hook 'haxe-mode-hook
  (function (lambda () (c-add-style "haxe" my-haxe-style t))))
(add-hook 'haxe-mode-hook
          (function
           (lambda ()
             (setq tab-width 4)
             (setq indent-tabs-mode t)
             (setq fill-column 80)
             (local-set-key [(return)] 'newline-and-indent))))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(global-set-key (kbd "C-x w <up>")     'buf-move-up)
(global-set-key (kbd "C-x w <down>")   'buf-move-down)
(global-set-key (kbd "C-x w <left>")   'buf-move-left)
(global-set-key (kbd "C-x w <right>")  'buf-move-right)

;; markdown-mode
(require 'markdown-mode)
; (setq markdown-command "\"markdown.exe\"")
(autoload 'markdown-mode "markdown-mode"
"Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.txt\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;C-z切换
(require 'evil)
(evil-mode 1)

(require 'emmet-mode)
   (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
   (add-hook 'html-mode-hook 'emmet-mode)
   (add-hook 'css-mode-hook  'emmet-mode)
   (add-hook 'web-mode-hook  'emmet-mode)

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

(setq org-ditaa-jar-path "~/support/ditaa/ditaa0_9.jar")
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (C . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (sh . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))

(require 'cal-china-x)
    (setq mark-holidays-in-calendar t)
    (setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
    ; (setq calendar-holidays cal-china-x-important-holidays)

(setq my-holidays
    '(;;纪念日
      (holiday-fixed 4 18 "一一生日")
      (holiday-fixed 3 13 "老婆生日")
      (holiday-fixed 10 17 "我的生日")
      (holiday-fixed 2 14 "情人节")
      (holiday-fixed 4 1 "愚人节")
      (holiday-fixed 12 25 "圣诞节")
      (holiday-float 5 0 2 "母亲节")
      (holiday-float 6 0 3 "父亲节")
))
;;除去基督徒的节日、希伯来人的节日和伊斯兰教的节日。
; (setq christian-holidays nil
; hebrew-holidays nil
; islamic-holidays nil
; solar-holidays nil
; bahai-holidays nil
; )
(setq calendar-holidays (append cal-china-x-important-holidays my-holidays))

;;设置所在地的经纬度和地名，calendar中按S,可以根据这些信息告知你每天的
;;日出和日落的时间。
(setq calendar-longitude +121.48)
(setq calendar-latitude +31.22)
(setq calendar-location-name "Shanghai")

(setq appt-issue-message t)

(add-to-list 'load-path "~/config")
(require 'appt-config)

(add-hook 'diary-hook 'appt-make-list)

(defun bing-dict ()
 "Search current word in bing dictionary."
 (interactive)
 (save-restriction
 (let (start end)
 (skip-chars-backward "A-Za-z0–9") (setq start (point))
 (skip-chars-forward "A-Za-z0–9") (setq end (point))
 (setq current-word (buffer-substring start end))
 (eww (concat "http://cn.bing.com/dict/search?q=" current-word))
 (if (not (string= (buffer-name) "*eww*"))
 (switch-to-buffer-other-window "*eww*"))
 (hl-line-mode "*eww*")
 ;wait for 2 second, because the buffer will refresh soon and it go back to top line.
 (sit-for 2)
 (search-forward current-word nil t 2)
 ;mark the word for 1 second 
 (end-of-line)
 (set-mark (line-beginning-position))
 (sit-for 1)
 (deactivate-mark)
 ))
)
(global-set-key (kbd "C-c s") 'bing-dict)