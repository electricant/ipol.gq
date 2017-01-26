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

;;;
;;; Various functions and code
;;;


;;; Make the website using the functions above
(defun make-website ()
  nil)
