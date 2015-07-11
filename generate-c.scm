(import (scheme base)
        (scheme file)
        (scheme write))

(with-output-to-file 
  "tmp.c"
  (lambda ()
    (display "
#include \"cyclone.h\"
#include \"runtime.h\"

void do_dispatch(int argc, function_type func, object clo, object *b) {
  switch(argc) {" )

    (define bs "")
    (let loop ((i 0))
        (display "case " )
        (display i )
        (display ":func(" )
        (display i )
        (display ",clo" )
        (display bs )
        (display ");" )

        (set! bs (string-append bs ",*(b+" (number->string i) ")"))
        (if (< i 129)
          (loop (+ i 1))))

    (display "
  default:
  {
   char buf[1024];
   snprintf(buf, 1023, \"Unhandled number of function arguments: %d\\n\", argc); 
   Cyc_rt_raise_msg(buf);
  }
  }
}" )))

