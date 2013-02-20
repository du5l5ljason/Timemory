class LocationGroup{
  
  // Latitude, Longitude and Altitude of the location
  ArrayList locations = new ArrayList();

  // The mean position
  GPSLocation meanLocation = null;


  // A label or key for the group. Useful when working with hashmaps to index the group
  String label = "";  
  
  LocationGroup()
  {
    
  }
  
  LocationGroup( String lbl )
  {
    label = lbl;
  }  
  
  LocationGroup( GPSLocation loc )
  {
    locations.add( loc );
    meanLocation = loc;
  }    

  void clear( boolean clearMean )
  {
      locations.clear();
      
      
      if( clearMean )
      {
         meanLocation = null; 
      }
      //println( "Mean Location is " + meanLocation );
  }
   
  void addToGroup( GPSLocation location, boolean cleanCentre )
  {
      if( location == null ) return;
    
      if( cleanCentre )
      {
        // First clear the mean
        // This forces recalculation after a change
        meanLocation = null;
      }
      
      // Add the location
      locations.add( location );
  }   
  
  void addToGroup( GPSLocation location )
  {
      if( location == null ) return;
    
      // First clear the mean
      // This forces recalculation after a change
      meanLocation = null;
      
      // Add the location
      locations.add( location );
  }  
  
  float getDuration()
  {
     float minTime = -1.0f;
     float maxTime = 0;
    
     for( int i = 0 ; i < locations.size(); i++ )
     {
       GPSLocation g = (GPSLocation)locations.get( i );
       
       if( g.timestamp > maxTime )
       {  
         maxTime = g.timestamp;
       }
       
       if( minTime == -1.0f || g.timestamp < minTime )
       {  
         minTime = g.timestamp;
       }
       
     }
     
     return abs( maxTime - minTime ) ; 
    
  }  
  
  GPSLocation getMean( boolean force )
  {
     if( force )
       meanLocation = null;
     
     return getMean(  );
  }
  
  GPSLocation getMean( )
  {
    if( meanLocation == null && locations.size() > 0 )
    {
      // Calculate the mean if needed 
      meanLocation = calculateMean();
      return meanLocation;
    } 
    
    return null;
  }

  GPSLocation calculateMean()
  {
     float x = 0.0f;
     float y = 0.0f;
     float z = 0.0f;     
     
     for( int i = 0 ; i < locations.size(); i++ )
     {
       GPSLocation g = (GPSLocation)locations.get( i );
       
       float dLat = radians( g.lat );
       float dLng = radians( g.lon );
       
       x += ( cos( dLat ) * cos( dLng ) ); 
       y += (cos( dLat ) * sin( dLng ) ); 
       z += sin( dLat ); 
     } 

     float x_avg = x / locations.size();
     float y_avg = y / locations.size();
     float z_avg = z / locations.size();

     GPSLocation avg = new GPSLocation();
     
     float sqr = (x_avg * x_avg) + (y_avg * y_avg );
     float sqroot = sqrt( sqr );
     
     avg.lat = degrees( atan( z_avg / sqroot ) );
     avg.lon = degrees( atan( y_avg / x_avg ) );     
     
     return avg; 
  }

  
}
