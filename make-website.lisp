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

;;; Load required packages
(ql:quickload "cl-markdown")
(ql:quickload "flexi-streams")

;;;
;;; Global configuration variables
;;;

;;; Directory where the result is stored
(defparameter *target-dir* "websites/")

;;; Directory containing the pages to be compiled
(defparameter *pages-dir* "content/pages/")

;;; Drectory containing the articles to be compiled
(defparameter *articles-dir* "content/articles/")

;;; Character encoding to be used (has to be an external-format object)
(defparameter *char-enc* (flexi-streams:make-external-format :utf-8))

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

;;; Return a new stream with the encoding set by *char-enc*
(defun set-encoding (strm)
  (flexi-streams:make-flexi-stream strm	:external-format *char-enc*))

;;; Strip the provided path for the specified amount of directories
;;; Parameters;
;;;  path - path to strip
;;;  num  - number of directores to remove
(defun strip-path (path num)
  (cond
  	((eql num 0) path)
  	(t (strip-path (subseq path (1+ (position #\/ path))) (1- num)))))

;;; Returns the list of markdown files to be compiled
(defun get-sources ()
  (append (directory (concatenate 'string *pages-dir* "*.md"))
          (directory (concatenate 'string *articles-dir* "*.md"))))

;;; Build an association list containing the path of each file and its
;;; destination file where the compiled result will be stored

;;; for each element e of get-sources
;;;	   append to a new list ((namestring e) ("website/[articles/]"
;;;	   									     (pathname-name e) ".html")

;;; Make the website using the functions above
(defun make-website ()
  nil)
