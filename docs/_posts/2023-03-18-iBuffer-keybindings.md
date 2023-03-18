layout: post
title: "Remapping iBuffer keybindings in Doom Emacs"
date: 2023-03-18 
categories: emacs keybindings

- [The Problem](#orgcad55d5)
- [The Solution](#org12f51d2)



<a id="orgcad55d5"></a>

# The Problem

I use DOOM Emacs as my configuration frame work, and it uses IBUFFER to manage the buffers. The keybindings that are used in IBUFFER are the same as the standard Text manipulation keys. So J and K are up and down like normal but L and H just move you from side to side in the buffer. So now this brings me to my problem, I wanted to make it so that when I press L it will enter the buffer. When I tried to google this I found no documentation. so I went to the DOOM Emacs discord and asked for help, and the lead maintainer of DOOM spent around 10 minutes replying. So as discords are black holes for information I am putting this on my blog in an attempt to preserve it.


<a id="org12f51d2"></a>

# The Solution

Keybindings in Emacs can be a bit complicated, but here&rsquo;s my attempt to lay out the steps to binding a key:

1.  Identify what (major or minor) mode you want to associate your new keybind with. C-h m can give you information about currently active modes in the current buffer. Or you can look up the value of the major-mode variable: C-h v major-mode. This should tell you ibuffer-mode.
2.  Identify the keymap variable associated with ibuffer-mode is (conventionally, that&rsquo;s {mode-name}-map, but sometimes it&rsquo;s {mode-name}-keymap). You can search variables with C-h v ^ibuffer-mode. You&rsquo;ll eventually find ibuffer-mode-map.
3.  Identify the package that this keymap variable is defined in. C-h v ibuffer-mode-map will tell you it&rsquo;s defined in a ibuffer.el file, and the package name is often just the name of the file minus the extension: ibuffer.
4.  Identify what command you want to execute when you press l. One may already exist; like C-h v, you can use C-h x to search all known commands. Or even better: since you already know the enter key does what you want, type C-h k then press enter key. This gives you documentation about the command bound to enter: ibuffer-visit-buffer.
5.  Finally, bind the new key on the keymap variable (#2) to the command (#4), after the package (#3) is loaded. Doom provides the map! macro to do all this in one go:

```emacs-lisp
;; in Doom
(map! :after ibuffer
      :map ibuffer-mode-map
      "l" #'ibuffer-visit-buffer)
```

However, there may be cases where this won&rsquo;t work. Use C-h k to debug that. In this case, it&rsquo;ll tell you that this key is bound to evil-forward-char, not ibuffer-visit-buffer. That&rsquo;s because evil (vim-emulated) keybinds have precedence over non-evil ones. The quick fix: make your keybinding an evil keybind:

```emacs-lisp
 ;; in Doom
 (map! :after ibuffer
       :map ibuffer-mode-map
-      "l" #'ibuffer-visit-buffer)
+      :n "l" #'ibuffer-visit-buffer)
```

The :n binds it to normal mode on ibuffer-mode-map.

These precedence rules aren&rsquo;t very obvious, and there&rsquo;s a lot of detective work involved for more complex cases, but that should roughly outline the kind of issues you&rsquo;re going to run into most.

Hope that helps!