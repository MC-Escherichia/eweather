;;; eweather-test.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Matthew Conway

;; Author: Matthew Conway <matthew.f.conway@gmail.com>
;; Keywords: abbrev, abbrev, abbrev

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

(ert-deftest eweather-test/read-apikey ()
  (should (equal "123abc" (get-string-from-file "./test-apikey.txt"))))

(ert-deftest eweather-test/strip-headers-url-retrieve ()
  (with-mock
	(mock (url-retrieve-synchronously "http://time.gov")
		  => (find-file "test/time.gov.txt"))
	(should (equal
			 (strip-headers-url-retrieve "http://time.gov")
			 (get-string-from-file "test/noheader_time.gov.txt")))))

(ert-deftest eweather-test/nested-hash-lookup ()
  (let ((map (json-to-hash-map eweather-test/small-json)))
	(should (equal
			 (nested-hash-lookup '("a") map)
			 (gethash "a" map)))
	(should (equal
			 (nested-hash-lookup '("a") map)
			 1))
	(should (equal
			 (nested-hash-lookup '("b" "bb") map)
			 2))
	(should-error (nested-hash-lookup '("c" "ca") map))
	(should (not (nested-hash-lookup '("b" "ba") map)))))

(ert-deftest eweather-test/retrieve-zip-from-ip ()
  (with-mock
	(mock (url-retrieve-synchronously *)
		  => (find-file "test/autoip.json"))
	(should (equal 10001 (retrieve-zip-from-ip)))))

(ert-deftest eweather-test/url-from-zip ()
  (with-mock
	(mock (strip-headers-url-retrieve *)
		  => (get-string-from-file "test/geolookup.json"))
	(should (equal "US/NY/Bronx.html" (url-from-zip 10463)))))

(ert-deftest eweather/retrieve-forecast ()
  (let ((eweather-APIKEY "123abc"))
	(with-mock
	  (mock (url-from-zip 10463)
			=> "US/NY/Bronx.html")
	  (mock (strip-headers-url-retrieve
			 "http://api.wunderground.com/api/123abc/forecast/q/US/NY/Bronx.json")
			=> (get-string-from-file "test/forecast.json") :times 1)
	  (should (retrieve-forecast 10463)))))

(ert-deftest eweather-test/eweather-get-icon ()
  (let ((nt_sunny_icon (get-string-from-file "icons/nt_clear.txt")))
	(should-error (eweather-get-icon "nt_happy"))
	(should (equal nt_sunny_icon (eweather-get-icon "nt_sunny")))
	(should (equal nt_sunny_icon (eweather-get-icon "nt_clear")))))

(provide 'eweather-test)
;;; eweather-test.el ends here
