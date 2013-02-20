class GPSLocation{
  
  // Latitude, Longitude and Altitude of the location
  float lat;
  float lon;
  float alt;
  
  // THe time is in Unix Epoch - time in seconds
  // This is pretty useful for time calculations
  // see: http://en.wikipedia.org/wiki/Unix_time
  long timestamp;
  
  // What device, os etc was it captured with
  float words;
  
  String city;
  String state;
  
  GPSLocation()
  {
    
  }
  
  void parseFrom( String s )
  {
    if( s == null || s.length() < 1 ) return;
    
    String[] parts = s.split( "," );
    
    if( parts.length > 4 )
    {
       lat = Float.valueOf(parts[0].trim()).floatValue() ;
       lon = Float.valueOf(parts[1].trim()).floatValue() ;
       alt = Float.valueOf(parts[2].trim()).floatValue() ;
       timestamp = Long.valueOf(parts[3].trim()).longValue() ;
       words = Float.valueOf(parts[4].trim()).floatValue() ;
       city = parts[5];
       state = parts[6];
       
    }
    
  }
  
  void parseFromGPS( String s1, String s2 )
  {
    if( s1 == null || s1.length() < 24 )return;
    if( s2 == null || s2.length() < 32 )return;
    String[] parts = new String[10];
    //Time
    parts[1] = s1.substring(6,25);


    //lat
    String[] temp = splitTokens(s2, "<gx:coord> /");
    parts[2] = temp[0];
    parts[3] = temp[1];
    parts[4] = temp[2];
    
    timestamp = DateUtils.stringToUnixEpoch( parts[1] );
    lat = Float.valueOf(parts[3].trim()).floatValue();
    lon = Float.valueOf(parts[2].trim()).floatValue();
    alt = Float.valueOf(parts[4].trim()).floatValue();
    
  }
  
  void parseFromCamera( String s )
  {
    String[] temp = splitTokens(s, "DataTimeOriginal");
    temp = splitTokens(temp[0], " :");
    //println(temp);
    String date = temp[0] + "-" + temp[1] + "-" + temp[2] + " " + temp[3] + ":" + temp[4] + ":" + temp[5];
    timestamp = DateUtils.stringToUnixEpoch( date );
  }
  
  void parseFromText( String s)
  {
     String[] temp = split(s,",");

     String date = temp[0] + " " + temp[1];
     timestamp = DateUtils.stringToUnixEpoch( date );
  }
  float distanceTo( GPSLocation g )  
  {
    return GPSUtils.kmDistBetween( this, g );
  }
  
  
  float timeBetween( GPSLocation g )  
  {
    return abs( g.timestamp - timestamp ) ;
  }  
  
  String getLocationID( )
  {
     return "lat:" + lat + "&lon:" + lon;
  }
  
  String toString()
  {
    return "lat:" + lat + ", lon: " + lon + ", alt:" + alt + ", time: " + DateUtils.unixToPrettyDate( timestamp ) + ", " + "words:" + words +  "," + city + "," + state;
  }    
  
  void draw( float x, float y){
    noStroke();
    fill(200,100,100,60);
    float sz = words/10;

    ellipse(x,y, 5, 5);
    //println("point position" + xy[0] + xy[1] );
  }
  
  void drawPhoto( float x, float y, float sz)
  {
    noStroke();
    fill(0,255,0,80);

    ellipse(x,y, sz, sz);
   // println("size is" + sz );
  }
  
  void drawText( float x, float y, float sz)
  {
    noStroke();
    fill(0,0,255,80);
    //println("size is" + sz );
    ellipse(x,y, sz, sz);
    //println("point position" + xy[0] + xy[1] );
  }
}
