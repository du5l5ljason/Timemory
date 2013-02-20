static class DateUtils{
  
  /* This converts a String in the format YYYY-MM-DD HH:MM:SS 
     e.g. 2011-12-23 14:34:12
     to a usable date
   */  
  static Date stringToDate( String str )
  {
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");     
     try{
     Date dte = (Date)formatter.parse( str ); 
     return dte; 
     }catch( Exception e )
     {
     }
     return null;
  }
  
  /* This takes a date object and converts it to Unix time
     Unix time is the seconds elapsed since sometime in 1970 
     */
  
  static long dateToUnixEpoch( Date date )
  {
     Long longTime = new Long( date.getTime() / 1000 );
     return longTime; 
  }
  
  /* This function wraps the previous two into one 
    So that you can quickly convert a string into a unix timestamp
    */
    
  static long stringToUnixEpoch( String str )
  {
     Date date = stringToDate( str );
     return dateToUnixEpoch( date );
  }
  
  /* THe function below convert the Unix Timestamp 
     Into a formatted String
     
     - to Pretty Date -> 2012-11-06 09:53:12
     - to Year -> 2012
     - to Month -> 2012-11
     - to day -> 2012-11-06
     */
  
  
  static String unixToPrettyDate( long timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch =timestamp  ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }

  static String unixToYear( long timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch = timestamp ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }
 
  static String unixToMonth( long timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch = timestamp ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }
  
  static String unixToDay( long timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch = timestamp ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }  
  
  
}
