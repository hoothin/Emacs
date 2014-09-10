(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tango-dark)))
 '(global-linum-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "YaHei Consolas Hybrid" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

;;改变默认路径
;;(setenv "HOME" "")
;;(setenv "PATH" "")
;;(load-file "\\.emacs")

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
(setq default-directory "D:/Workspace/org-mode/" )

;;外观设置   
;;去掉工具栏   
(tool-bar-mode 0)

;;去掉菜单栏
;(menu-bar-mode 0)

;;不要滚动栏，现在都用滚轴鼠标了，可以不用滚动栏了   
(scroll-bar-mode 1)

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
;;显示默认的文档的宽度，看起来比较舒服？   
(setq default-fill-column 60)

;;在minibuffer里启用自动补全函数和变量   
(icomplete-mode 1)

;; 不要问yes or no, 用y/n代替
(fset 'yes-or-no-p 'y-or-n-p)

;;设置代理
;;(setq url-proxy-services '(("http" . "127.0.0.1:8087")))

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

;;包管理增加来源
(require 'package)
(add-to-list 'package-archives'
  ("elpa" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives' 
  ("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives'
  ("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;org-mode
(setq org-publish-project-alist
      '(("note-org"	;;将所有org文件发布为html
         :base-directory "D:/Workspace/org-mode/org.src/"
         :recursive t
         :base-extension "org"
         :publishing-directory "D:/Workspace/org-mode/org.html/"
         :publishing-function org-html-publish-to-html
         :auto-sitemap t                ; Generate sitemap.org automagically...
		 :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
		 :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
         :auto-preamble t	;;html开头目录
         :makeindex t)	;;生成跳转到#+index: XXX标记的链接的汇总文件
        ("note-static"	;;发布附件
         :base-directory "D:/Workspace/org-mode/org.src/"
         :publishing-directory "D:/Workspace/org-mode/org.html/"
         :recursive t
         :base-extension "css//|js//|png//|jpg//|gif//|pdf//|mp3//|swf//|zip//|gz//|txt//|el"
         :publishing-function org-publish-attachment)
        ("note"	;;将html与附件一起发布
         :components ("note-org" "note-static"))))

;; org2blog
(require 'org2blog-autoloads)
(setq org2blog/wp-buffer-template
	"#+DATE: %s
	#+OPTIONS: toc:nil num:nil todo:nil pri:nil tags:nil ^:nil TeX:nil
	#+CATEGORY: Heart
	#+TAGS:
	#+PERMALINK:
	#+TITLE:
	\n")
;;(setq org2blog/wp-blog-alist
;;      `(("Hoothin's Blog"
;;         :url "http://.com/xmlrpc.php"
;;         :username ""
;;         :password ""
;;         :keep-new-lines t
;;         :confirm t
;;         :wp-code nil
;;         :tags-as-categories nil)
;;        ))

;;org日历视图
(setq org-agenda-files (list "D:/Workspace/org-mode/todo.org"))
(global-set-key "\C-ca" 'org-agenda)

;;yasnippet 智能填充模板
(require 'yasnippet)
(yas/global-mode 1)
(yas/minor-mode-on)

;;auto-complete 自动补全
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-modes
	(append ac-modes '(org-mode objc-mode jde-mode sql-mode
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

;;打开文件和切换buffer增强，win下不能切换盘符
;;(require 'ido)
;;(ido-mode t)

;;撤销删除
(require 'redo+)
(setq undo-no-redo t)	;;不要撤销撤销操作本身
(global-set-key (kbd "C-.") 'redo)	;;重做增强，能重做多次

;;记录和恢复屏幕
(load "desktop") 
(desktop-load-default) 
;(desktop-read)
(desktop-save-mode 1)

;;保存全局变量 (kill-ring，命令记录……)，局部变量，寄存器，打开的文件，修改过的文件和最后修改的位置等
(require 'session) 
(add-hook 'after-init-hook 'session-initialize) 