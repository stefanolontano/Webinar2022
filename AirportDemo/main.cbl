      ******************************************************************
      *
      * (C) Copyright 1984-2013 Micro Focus or one of its affiliates.
      *
      * The only warranties for products and services of Micro Focus and
      * its affiliates and licensors ("Micro Focus") are set forth in the
      * express warranty statements accompanying such products and services.
      * Nothing herein should be construed as constituting an additional
      * warranty.  Micro Focus shall not be liable for technical or editorial
      * errors or omissions contained herein.  The information contained
      * herein is subject to change without notice.
      *
      * This sample code is supplied for demonstration purposes only
      * on an "as is" basis and is for use at your own risk.
      *
      ******************************************************************

       program-id main.

       working-storage section.
       01  user-input      pic x(80).

       local-storage section.
       copy "airparams.cpy" replacing ==(ap-prefix)== by ==ls==.
       01 ls-rec.
       copy "airrec.cpy" replacing ==(prefix)== by ==ap==.

       procedure division.

           set open-file to true
           perform call-aircode-program

           perform until exit
               display "Enter an airport code, or two codes " &
                       "separated by space, or no code to exit:"
               accept user-input
               unstring user-input delimited by space
                   into ls-airport1, ls-airport2

               if ls-airport1 = spaces
                   exit perform
               end-if

               if ls-airport2 not = spaces
                   set get-distance to true
                   perform call-aircode-program
                   display "Distance: " distance-km "kms"
                           distance-miles  "miles"
               else
                   move " " to ap-code of ls-rec
                   set get-details to true
                   perform call-aircode-program

                   if ap-code OF ls-rec <> " "
                   then
                       set display-record to true
                       perform call-aircode-program
                   end-if
               end-if
           end-perform

           set close-file to true
           perform call-aircode-program
       .

       call-aircode-program section.
           call "aircode" using
                           by value ls-function
                           by value ls-airport1
                           by value ls-airport2
                           by value ls-prefix-text
                           by reference ls-rec
                           by reference ls-distance-result
                           by reference ls-matched-codes-array
       .

       end program.
