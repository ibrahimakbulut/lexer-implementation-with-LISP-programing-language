
(defun gppinterpreter(&optional file)

(setq KEYWORDS '( "and" "or" "not" "equal" "less" "nil" "list" "append" "concat"
"set" "deffun" "for" "if" "exit" "load" "disp" "true" "false") )
(setq OPERATORS '( "+" "-" "/" "*" "(" ")" "**"  ","))
(setq KEYWORDS_TOKENS '( "KW_AND" "KW_OR" "KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" 
"KW_LIST" "KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEFFUN" "KW_FOR" "KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"))
(setq OPERATORS_TOKENS  '("OP_PLUS" "OP_MINUS" "OP_DIV" "OP_MULTIP" "OP_OP" "OP_CP" "OP_DBLEMULTIP" "OP_COMMA" "OP_OC" "OP_CC")        )
(setq result_list '())
(setq temp_list '())

(defun from-list-to-string (listt)  ;;Convert a list to string
    (format nil "~{~A~}" listt))

(defun read_as_list ()   ;;To read from console
	(let (  (line '() )   (characters 0) )

		(loop

			(setq characters (read-char))
			(when (= (char-code characters) 10) (return nil) )

			(push characters line)
		)
		(push (code-char 10) line)
		(setq line (reverse line))
		line
	)
)

(if (equal file nil)       ;if  zero given parameter mean reading from console(from user)
	(progn
	(setq infinite_count 0)
	(loop	
	(setq temp_list (read_as_list) )
	(setq there_is_quatation 0)
	(loop 

(if (or (and (< (char-code (car temp_list)) 123) (> (char-code (car temp_list)) 96) ) (and (< (char-code (car temp_list)) 91) (> (char-code (car temp_list)) 64) ) ) ;if firs char is a letter

	(progn 
		(setq word '())
		(loop 

   			(when  (or (equal  (char-code (car temp_list)) 32)  (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) word)
    		(setq temp_list (cdr temp_list))

		)
		(setq word (reverse word))
		(setq tokenized 1)
		(setq temp_word word)
		(loop 

			(when (null temp_word) (return nil))
			(if  (not (or (and (< (char-code (car temp_word)) 123) (> (char-code (car temp_word)) 96) ) (and (< (char-code (car temp_word)) 91) (> (char-code (car temp_word)) 64) ) (and (< (char-code (car temp_word)) 58) (> (char-code (car temp_word)) 47) )               )  ) 

				(setq tokenized 0)
			

			)
			(setq temp_word (cdr temp_word))

		)

		(if (= tokenized 1)
		
			(progn
		(setq keyword_temp KEYWORDS)
		(setq token_temp KEYWORDS_TOKENS)
		(setq y 0)
		(loop

			(when (or (null  keyword_temp)) (return nil))
			(if (equal (car keyword_temp) (from-list-to-string word))(progn
			(setq result_list  (nconc result_list (list (car token_temp))) ) ;is word a keyword not identifier 
			(print (car token_temp))
			(setq y 1))

			)
			(setq keyword_temp (cdr keyword_temp))
			(setq token_temp (cdr token_temp))
		)	
			(if (equal y 0)
			(progn
			(setq result_list  (nconc result_list (list "IDENTIFIER") ) )
			(print "IDENTIFIER")
			)
			)
		)
			(progn
			(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR " (from-list-to-string word) ) " cannot be tokenized"  ) )) )
			(print (concatenate 'string (concatenate 'string "SYNTAX ERROR " (from-list-to-string word) ) " cannot be tokenized"  ))
			(exit 1)
			)
		)
	)
		
)

(if  (and (< (char-code (car temp_list)) 58) (> (char-code (car temp_list)) 47) ) ;if firs character is digit 
	(progn
		(setq number '())
		(loop 

   			
			(when (or (equal  (char-code (car temp_list)) 32) (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 40) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) number)
    		(setq temp_list (cdr temp_list))

		)

		(setq temp_number number)
		(setq tokenized_number 1)

		(loop 

			(when (null (cdr temp_number) ) (return temp_list))
			(if  (not (and (< (char-code (car temp_number)) 58) (> (char-code (car temp_number)) 47) )  ) 
				(progn
				(setq tokenized_number 0)
				)
			)
			(setq temp_number (cdr temp_number))


		)
		(setq number (reverse number))
		(if (= tokenized_number 1)

		(if (and (=  (char-code (car number)) 48 ) (> (list-length number) 1) )
			(progn
			(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ) )     )     )
			(print (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ))
			(exit 1)
			)
			(progn
			(setq result_list  (append result_list (list "VALUE" ) ) ) ; VALUE added lexer output list
			(print "VALUE")
			)
		)
		(progn
		(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ) )     )     )
		(print (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ))
		(exit 1)
		)
		)
	)
)

(if (and   (not (or (and (< (char-code (car temp_list)) 123) (> (char-code (car temp_list)) 96) ) (and (< (char-code (car temp_list)) 91) (> (char-code (car temp_list)) 64) ) )) (not (equal (char-code (car temp_list)) 10) )  (not (and (< (char-code (car temp_list)) 58) (> (char-code (car temp_list)) 47) )) (not (equal (char-code (car temp_list)) 32)))

	(cond 

			( (and (= (char-code (car temp_list)) 59) (= (char-code (car (cdr temp_list))) 59) )

			(progn
			
			(loop 

				(when  (equal  (char-code (car temp_list)) 10) (equal  (char-code (car temp_list)) 34)(return  temp_list))
    			(setq temp_list (cdr temp_list))
			)
			(setq result_list (append result_list (list "COMMENT")))
			(print "COMMENT")
			)
			)

			(
				(= (char-code (car temp_list)) 34)

				(if (= there_is_quatation 0)
					(progn

						(setq result_list (append result_list (list "OP_OC")))
						(print "OP_OC")
						(setq there_is_quatation 1)
					)
					(progn

					(setq result_list (append result_list (list "OP_CC")))
					(print "OP_CC")
					(setq there_is_quatation 0)
					)


				)
			)

			( (or (= (char-code (car temp_list)) 40) (= (char-code (car temp_list)) 41))

				(if (= (char-code (car temp_list)) 40)
					(progn
					(setq result_list (append result_list (list "OP_OP")))
					(print "OP_OP")
					)
					(progn
					(setq result_list (append result_list (list "OP_CP")))
					(print "OP_CP")
					)
				)

			)


			( t      
			(progn

			(setq operator_temp '())
			(loop 

			(when (or (equal  (char-code (car temp_list)) 32) (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 40) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) operator_temp)
    		(setq temp_list (cdr temp_list))

			)
			(setq operator_temp (reverse operator_temp))

			(if  (or (= (char-code (car temp_list)) 40) (= (char-code (car temp_list)) 41) (= (char-code (car temp_list)) 34)    )

				(push (car temp_list) temp_list)

			)

			(cond
				( 
					(= (list-length operator_temp) 2)

					(if (and (= (char-code (car operator_temp )) 42) (= (char-code (car (cdr operator_temp)) ) 42))
						(progn
							(setq result_list (append result_list (list "OP_DBLEMULTIP")) )
							(print "OP_DBLEMULTIP")
						)
						(progn

							(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) "cannot be tokenized")))))
							(print  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized")))
							(exit 1)
						)

					)

				)

				(  
					(> (list-length operator_temp) 2)

					(progn
					(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) "cannot be tokenized")))))
					(print   (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized")))
					(exit 1)

					)

				)

				( t

			(progn
			(setq token_operator_temp OPERATORS_TOKENS)
			(setq operator_tempp OPERATORS)

			(setq is_operator nil)

			(loop
				(if (equal (car operator_tempp) (from-list-to-string operator_temp))
				(progn
				(setq is_operator t)
				(setq result_list  (nconc result_list (list (car token_operator_temp))) ) ;is word a keyword not identifier 
				(print (car token_operator_temp))
				)
				)
				(when (or (null (cdr operator_tempp) ) (equal (car operator_tempp) (from-list-to-string operator_temp))) (return nil))
				(setq operator_tempp (cdr operator_tempp))
				(setq token_operator_temp (cdr token_operator_temp))
			)
			(if (equal is_operator nil)
				(progn
				(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized") ))))
				(print (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized") ) )
				(exit 1)
				)
			)
			)

			)
			)


			)
			)
			)
	
)


   (when (null  (cdr temp_list) ) (return result_list))
       (setq temp_list (cdr temp_list))

	)
	(terpri)
	(when (= infinite_count 1) (return 0))
	)

	)

(              ;a parameter given to function that it is a filename with input
progn
(let ((in (open file :if-does-not-exist nil))) 
  (when in
    (loop for line = (read-char in nil)
         while line do (setq temp_list (push line temp_list))) ;openin file and read chararacter by character
    (close in)))
	(setq temp_list (reverse temp_list)) 

(setq there_is_quatation 0)

(loop 


(if (or (and (< (char-code (car temp_list)) 123) (> (char-code (car temp_list)) 96) ) (and (< (char-code (car temp_list)) 91) (> (char-code (car temp_list)) 64) ) ) ;if firs char is a letter

	(progn 
		(setq word '())
		(loop 


   			(when  (or (equal  (char-code (car temp_list)) 32)  (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) word)
    		(setq temp_list (cdr temp_list))

		)
		(setq word (reverse word))
		(setq tokenized 1)
		(setq temp_word word)
		(loop 


			(when (null temp_word) (return nil))
			(if  (not (or (and (< (char-code (car temp_word)) 123) (> (char-code (car temp_word)) 96) ) (and (< (char-code (car temp_word)) 91) (> (char-code (car temp_word)) 64) ) (and (< (char-code (car temp_word)) 58) (> (char-code (car temp_word)) 47) )               )  ) 

				(setq tokenized 0)
			

			)
			(setq temp_word (cdr temp_word))


		)

		(if (= tokenized 1)
		
			(progn
		(setq keyword_temp KEYWORDS)
		(setq token_temp KEYWORDS_TOKENS)
		(setq y 0)
		(loop

			(when (or (null  keyword_temp)) (return nil))
			(if (equal (car keyword_temp) (from-list-to-string word))(progn
			(setq result_list  (nconc result_list (list (car token_temp))) ) ;is word a keyword not identifier 
			(print (car token_temp))
			(setq y 1))

			)
			(setq keyword_temp (cdr keyword_temp))
			(setq token_temp (cdr token_temp))
		)	
			(if (equal y 0)
			(progn
			(setq result_list  (nconc result_list (list "IDENTIFIER") ) )
			(print "IDENTIFIER")
			)
			)
		)
			(progn
			(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR " (from-list-to-string word) ) " cannot be tokenized"  ) )) )
			(print (concatenate 'string (concatenate 'string "SYNTAX ERROR " (from-list-to-string word) ) " cannot be tokenized"  ))
			(exit 1)
			)
		)
	)
		
)

(if  (and (< (char-code (car temp_list)) 58) (> (char-code (car temp_list)) 47) ) ;if firs character is digit 
	(progn
		(setq number '())
		(loop 

   			
			(when (or (equal  (char-code (car temp_list)) 32) (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 40) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) number)
    		(setq temp_list (cdr temp_list))

		)


		(setq temp_number number)
		(setq tokenized_number 1)

		(loop 


			(when (null (cdr temp_number) ) (return temp_list))
			(if  (not (and (< (char-code (car temp_number)) 58) (> (char-code (car temp_number)) 47) )  ) 
				(progn
				(setq tokenized_number 0)
				)
			)
			(setq temp_number (cdr temp_number))


		)
		(setq number (reverse number))
		(if (= tokenized_number 1)

		(if (and (=  (char-code (car number)) 48 ) (> (list-length number) 1) )
			(progn
			(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ) )     )     )
			(print (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ))
			(exit 1)
			)
			(progn
			(setq result_list  (append result_list (list "VALUE" ) ) ) ; VALUE added lexer output list
			(print "VALUE")
			)
		)
		(progn
		(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ) )     )     )
		(print (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ))
		(exit 1)
		)
		)
	)
)

(if (and   (not (or (and (< (char-code (car temp_list)) 123) (> (char-code (car temp_list)) 96) ) (and (< (char-code (car temp_list)) 91) (> (char-code (car temp_list)) 64) ) )) (not (equal (char-code (car temp_list)) 10) )  (not (and (< (char-code (car temp_list)) 58) (> (char-code (car temp_list)) 47) )) (not (equal (char-code (car temp_list)) 32)))

	(cond 

			( (and (= (char-code (car temp_list)) 59) (= (char-code (car (cdr temp_list))) 59) )

			(progn
			
			(loop 

				(when  (equal  (char-code (car temp_list)) 10) (equal  (char-code (car temp_list)) 34)(return  temp_list))
    			(setq temp_list (cdr temp_list))
			)
			(setq result_list (append result_list (list "COMMENT")))
			(print "COMMENT")
			)
			)


			(
				(= (char-code (car temp_list)) 34)

				(if (= there_is_quatation 0)
					(progn

						(setq result_list (append result_list (list "OP_OC")))
						(print "OP_OC")
						(setq there_is_quatation 1)
					)
					(progn

					(setq result_list (append result_list (list "OP_CC")))
					(print "OP_CC")
					(setq there_is_quatation 0)
					)


				)
			)

			( (or (= (char-code (car temp_list)) 40) (= (char-code (car temp_list)) 41))

				(if (= (char-code (car temp_list)) 40)
					(progn
					(setq result_list (append result_list (list "OP_OP")))
					(print "OP_OP")
					)
					(progn
					(setq result_list (append result_list (list "OP_CP")))
					(print "OP_CP")
					)
				)

			)


			( t      
			(progn

			(setq operator_temp '())
			(loop 

   			
			(when (or (equal  (char-code (car temp_list)) 32) (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 40) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) operator_temp)
    		(setq temp_list (cdr temp_list))

			)
			(setq operator_temp (reverse operator_temp))

			(if  (or (= (char-code (car temp_list)) 40) (= (char-code (car temp_list)) 41) (= (char-code (car temp_list)) 34)    )

				(push (car temp_list) temp_list)


			)

			(cond
				( 
					(= (list-length operator_temp) 2)

					(if (and (= (char-code (car operator_temp )) 42) (= (char-code (car (cdr operator_temp)) ) 42))
						(progn
							(setq result_list (append result_list (list "OP_DBLEMULTIP")) )
							(print "OP_DBLEMULTIP")
						)
						(progn

							(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) "cannot be tokenized")))))
							(print  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized")))
							(exit 1)
						)


					)

				)


				(  
					(> (list-length operator_temp) 2)


					(progn
					(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) "cannot be tokenized")))))
					(print   (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized")))
					(exit 1)

					)


				)


				( t

			(progn
			(setq token_operator_temp OPERATORS_TOKENS)
			(setq operator_tempp OPERATORS)

			(setq is_operator nil)

			(loop
				(if (equal (car operator_tempp) (from-list-to-string operator_temp))
				(progn
				(setq is_operator t)
				(setq result_list  (nconc result_list (list (car token_operator_temp))) ) ;is word a keyword not identifier 
				(print (car token_operator_temp))
				)
				)
				(when (or (null (cdr operator_tempp) ) (equal (car operator_tempp) (from-list-to-string operator_temp))) (return nil))
				(setq operator_tempp (cdr operator_tempp))
				(setq token_operator_temp (cdr token_operator_temp))
			)
			(if (equal is_operator nil)
				(progn
				(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized") ))))
				(print (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized") ) )
				(exit 1)
				)
			)
			)

			)
			)


			)
			)


			)
	
)

   (when (null  (cdr temp_list) ) (return result_list))
       (setq temp_list (cdr temp_list))

	)
	)
 	)

) ;not 600 lines :)