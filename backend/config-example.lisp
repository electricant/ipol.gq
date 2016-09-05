;;
;; This file contains the global configuration variables for ipol.gq backend.
;; This is just an example, edit it to suit your needs and rename it as
;; 'config.lisp'.
;;

; Directory where the content is stored, with trailing /
(defparameter *content-dir* "/my/websites/directory/ipol.gq/content/")

; Number of components to strip from the path when a request is received
(defparameter *strip-level* 2)

; Put a value different from "/" here if this program acceopts requests within a
; sub path of the domain
(defparameter *URL-root* "/artsrv")

; Subdirectory within *content-dir* where the articles are stored.
; Used to build a list with the most recent articles
(defparameter *articles-dir* "articles/")
