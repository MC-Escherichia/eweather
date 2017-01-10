;;; eweather-icons.el ---                            -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Matthew Conway

;; Author: Matthew Conway <matthew.f.conway@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


(defvar eweather-icon-map
  '(("chanceflurries" . ("chanceflurries" "chancesnow" "flurries" "snow" "nt_chanceflurries nt_chancesnow nt_flurries nt_snow"))
	("chancerain" . ("chancerain" "rain" "nt_chancerain" "nt_rain"))
	("chancesleet" . ("chancesleet" "sleet" "nt_chancesleet" "nt_sleet"))
	("chancetstorms" . ("chancetstorms" "tstorms" "nt_chancetstorms" "nt_tstorms"))
	("clear" . ("clear" "sunny"))
	("fog" . ("fog" "hazy" "nt_fog" "nt_hazy"))
	("cloudy" . ("cloudy" "nt_cloudy"))
	("mostlycloudy" . ("mostlycloudy" "partlycloudy"))
	("mostlysunny" . ("mostlysunny" "partlysunny"))
	("nt_clear" . ("nt_clear" "nt_sunny"))
	("nt_mostlycloudy" . ("nt_mostlycloudy" "nt_partlycloudy" "nt_mostlysunny" "nt_partlysunny"))))


(defvar eweather-invert-icon-map
  (let  ((keys (mapcar (lambda (x) (car x)) eweather-icon-map)))
	(cl-reduce
	 #'append
	 (mapcar (lambda (k)
			   (mapcar (lambda (el) (list el k))
					   (cdr (assoc k eweather-icon-map))))
			 keys))))

(defun eweather-get-icon (weather-type)
  "Return ascii icon corresponding to WEATHER-TYPE."
  (let ((icon-name (cadr (assoc weather-type eweather-invert-icon-map))))
	(if icon-name
		(with-temp-buffer
		  (insert-file-contents (concat "icons/" icon-name ".txt"))
		  (buffer-string))
	  (error "Weather Type not in database"))))


(provide 'eweather-icons)
;;; eweather-icons.el ends here
