;;;;
;;;; Source file that compiles the ipol.gq website. It starts from a theme and
;;;; a bunch of markdown files to bouild up the static webiste.
;;;;
;;;; USAGE:
;;;; Load this file into your lisp interpreter of choice and issue the command
;;;; (make-website)
;;;;
;;;; (c) 2017 Paolo Scaramuzza
;;;;
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;;
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;;

;;; Load required packages. Adjust quicklisp location if needed
(load "~/.quicklisp/setup.lisp")
(ql:quickload "cl-markdown" :silent T)

;;;
;;; Global configuration variables
;;;

;;; Directory where the result is stored
(defparameter *target-dir* "websites/")

;;; Directory containing the pages to be compiled and their extension
(defparameter *pages-dir* "content/pages/*.md")

;;; Drectory containing the articles to be compiled and their extension
(defparameter *articles-dir* "content/articles/*.md")

;;; Character encoding to be used when reading and writing files
(defparameter *char-enc* :utf-8)

;;;
;;; Various functions and code
;;;

;;; Convert a markdown file to html and return the content as a string
(defun render-file (filename)
  (with-open-file (in filename)
  	(let ((data (make-string (file-length in))))
  	  (read-sequence data in)
  	  (cl-markdown:render-to-stream (cl-markdown:markdown data :stream nil)
  	  								:html nil))))

(defun render-header ()
  (with-open-file (in "theme/header.html")
  	(let ((data (make-string (file-length in))))
  	  (read-sequence data in)
  	  data)))

(defun render-footer ()
    (with-open-file (in "theme/footer.html")
          (let ((data (make-string (file-length in))))
          	      (read-sequence data in)
          	            data)))

;;; Scan the sources directories and build a list of paths as strings
(defun get-sources ()
  (append (mapcar #'namestring (directory *pages-dir*))
  		  (mapcar #'namestring (directory *articles-dir*))))

;;; Scan the sources directories and bouild a list of paths for compiled html
;;; targets
(defun get-destinations ()
  (append (mapcar 
  			#'(lambda (p) (concatenate 'string "website/"
  									   (pathname-name p) ".html"))
  			(directory *pages-dir*))
  		  (mapcar
  		  	#'(lambda (p) (concatenate 'string "website/articles/"
  		  							   (pathname-name p) ".html"))
  		  	(directory *articles-dir*))))

;;; Build an association list containing the path of each file and its
;;; destination file where the compiled result will be stored
(defun sources-alist ()
  (pairlis (get-sources) (get-destinations)))

;;; Compile the provided source and put the result in dest
(defun build-file (source dest)
  (let ((ostream (open dest :direction :output
  					   :if-exists :supersede
  					   :if-does-not-exist :create
  					   :external-format *char-enc*)))
  	(format ostream "~a~&~a~&~a" (render-header) (render-file source) (render-footer))
  	(close ostream)))

;;; Make the website using the functions above
(defun make-website ()
  (mapc #'(lambda(fl) (build-file (car fl) (cdr fl))) (sources-alist)))
