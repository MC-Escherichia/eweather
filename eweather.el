;;; eweather.el --- A pop up weather app for emacs   -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Matthew Conway

;; Author: Matthew Conway <matthew.f.conway@gmail.com>
;; Keywords: calendar, convenience, comm,
;; Version: 0.1.0

;;; Commentary:


;;; Code:

(require 'request)

;; Load api key from apikey.txt

(defun get-string-from-file (filePath)
  "Return FILEPATH's file content as a string.  H/T ergoemacs.org."
  (with-temp-buffer
	(insert-file-contents filePath)
	(buffer-string)))

(defvar eweather-APIKEY
  (replace-regexp-in-string
   "\n\\'" ""
   (condition-case err
	   (get-string-from-file "./apikey.txt")
	 (error ""))))


;; make request for weather data given zipcode

(defun strip-headers-url-retrieve (url)
  "Return body of url request given URL."
  (with-current-buffer (url-retrieve-synchronously url)
	(goto-char (point-min))
	;; find a blank line
	(re-search-forward "^$")
	(delete-region (point) (point-min))
	(buffer-string)))

(defun nested-hash-lookup (key-list table)
  "Recursive lookup of successive keys in KEY-LIST starting to look in TABLE."
  (let ((lookup (gethash (car key-list) table)))
	(cond ((null (cdr key-list)) lookup)
		  ((not (hash-table-p lookup)) (error (concat "Bad Key: " (car key-list))))
		  (t (nested-hash-lookup (cdr key-list) lookup)))))

(defun json-to-hash-map (json)
  "Read JSON string into a hash-table."
  (let ((json-object-type 'hash-table))
	(json-read-from-string json)))

(defun retrieve-zip-from-ip ()
  "Return zip code as deduced from IP Address."
  (string-to-number
   (nested-hash-lookup
	'("location" "zip")
	(let ((iplookup-url (concat "http://api.wunderground.com/api/"
								eweather-APIKEY
								"/geolookup/q/autoip.json")))
	  (json-to-hash-map
	   (strip-headers-url-retrieve iplookup-url))))))


(defun url-from-zip (zip)
  "Return the request url for the nearest forecast given ZIP."
  (let ((url (concat "http://api.wunderground.com/api/"
					 eweather-APIKEY
					 "/geolookup/q/"
					 (int-to-string zip)
					 ".json")))
	(nested-hash-lookup
	 '("location" "requesturl")
	 (json-to-hash-map
	  (strip-headers-url-retrieve url)))))

(defun retrieve-forecast (zip)
  "Return a hash table representing forecast for area represented by ZIP."
  (let ((url (concat "http://api.wunderground.com/api/"
					 eweather-APIKEY
					 "/forecast/q/"
					 (replace-regexp-in-string "html" "json" (url-from-zip zip)))))
	(json-to-hash-map
	 (strip-headers-url-retrieve url))))







;; format response

;; interactive pop-up


(provide 'eweather)
;;; eweather.el ends here
