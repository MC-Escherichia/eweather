 ;;; test-helper.el --- Setting up helper functions for eweather test                              -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Matthew Conway

;; Author: Matthew Conway <matthew.f.conway@gmail.com>
;; Keywords:

;;; Commentary:

;;; Code:


(require 'el-mock)
(require 'f)
(require 'json)
(eval-when-compile
  (require 'cl))
(require 'eweather (f-expand "eweather.el" (f-parent (f-parent (f-this-file)))))
(require 'eweather-icons (f-expand "eweather-icons.el" (f-parent (f-parent (f-this-file)))))

(defvar eweather-test/small-json "{\"a\": 1, \"b\": {\"bb\": 2,\"bc\": 3}}")
;; redefine eweather-APIKEY for testing purposes
(setq eweather-APIKEY "123abc")
(write-region "123abc" nil "test-apikey.txt")

(provide 'test-helper)


