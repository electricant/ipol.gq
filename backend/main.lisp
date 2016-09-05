; Load required packages
(ql:quickload "cl-markdown")
(ql:quickload "hunchentoot")
(ql:quickload "flexi-streams")

; Load configuration file (beware to run this script from the folder it is
; located into)
(load "config.lisp")

;;-------------;;
;;  Functions  ;;
;;-------------;;
(defun render-file (filename)
    (with-open-file (in filename)
		(let ((data (make-string (file-length in))))
			(read-sequence data in)
			(cl-markdown:render-to-stream
				(cl-markdown:markdown data :stream nil)
				:html nil))))

;; Strip the provided path for the specified amount of directories
;; Parameters;
;;  path - path to strip
;;  num  - number of directores to remove
(defun strip-path (path num)
	(cond
		((eql num 0) path)
		(t (strip-path (subseq path (1+ (position #\/ path))) (1- num)))))

;;
;; Comparison function used to sort files from the most to the least recent
;;
(defun by-date-descending (file1 file2)
	(> (with-open-file (s file1) (file-write-date s))
	   (with-open-file (s file2) (file-write-date s))))

;;
;; Return a list containing all the articles
;;
(defun articles-list ()
	(directory (concatenate 'string *content-dir* *articles-dir* "*.md")))

;;
;; Return the title of the artile by reading the first line of the file.
;; This routine assumes that the first line is the title of the article which
;; is in the form '# Title'
;;
(defun article-title (filename)
	(with-open-file (stream filename)
		(subseq (read-line stream nil) 2)))

;;
;; Return the URL of the corresponding article or page filename
;;
(defun article-URL (filename)
	(let ((filename-str (namestring filename)))
		(subseq filename-str (length *content-dir*) (- (length
		filename-str) 3))))

;;---------------;;
;;  Actual code  ;;
;;---------------;;
(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 8000))

; List all the files within a directory. Useful to build a list of articles
; or stuff like that. The titles are sorted by date.
(hunchentoot:define-easy-handler (list-content :uri
	(concatenate 'string *URL-root* "/recent")) ()
	(setf (hunchentoot:content-type*) "text/plain")
	(format nil "~{~{~a#~^~}~%~^~}"
		(mapcar #'(lambda (name) (list (article-title name) (article-URL name)))
			(sort (articles-list) #'by-date-descending))))

; Global index page
(hunchentoot:define-easy-handler (main :uri *URL-root*) ()
	(setf (hunchentoot:content-type*) "text/html")
	(render-file (concatenate 'string *content-dir* "index.md")))

; All other pages are sent through a 404 handler
(defmethod hunchentoot:acceptor-status-message
	(acceptor (http-status-code (eql 404)) &key)
	(let ((uri (strip-path (hunchentoot:request-uri hunchentoot:*request*)
		*strip-level*))
	     (content ()))
		; If the request is a directory serve its index file, otherwhise
		; serve the corresponding markdown file
		(if (eq (position #\/ uri :from-end t) (1- (length uri)))
			(setf content (render-file
				(concatenate 'string *content-dir* uri "index.md")))
			(setf content (render-file
				(concatenate 'string *content-dir* uri ".md"))))
		; Content is now ready. Time to send it out
		(setf (hunchentoot:return-code*) 200)
		(setf (hunchentoot:content-length*)
			(length (sb-ext:string-to-octets content)))
		(setf (hunchentoot:content-type*) "text/html; charset=utf-8")
		(princ content (flexi-streams:make-flexi-stream
			(hunchentoot:send-headers)
			:external-format (flexi-streams:make-external-format :utf-8)))))
