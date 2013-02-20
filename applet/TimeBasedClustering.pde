class TimeBasedClustering{
  
  // Init Distance  to 50 meters or 0.05 KM
  float distanceThreshold = 0.05;
  
  // Init time threshold to 600 seconds or 10 minutes
  float timeThreshold = 600;
  
  
  ArrayList placeClusters;
  LocationGroup currentCluster;
  GPSLocation pendingLocation;
  
  TimeBasedClustering()
  {
      reset();
  }
  
  
  TimeBasedClustering( float dist, float time )
  {
      distanceThreshold = dist;
      timeThreshold = time;
      reset();
  }  
  
  
  void reset()
  {
    placeClusters = new ArrayList();
    currentCluster = null;
    pendingLocation = null;
    
  }
  
  void clusterLocation( GPSLocation location )
  {
      //println( "Clustering " + location );
      // if there is a current cluster
      // And if the next location exceeds the distance threshold
      // Create a new place.
      
      //println( "currentCluster = " + currentCluster );
      
      if( currentCluster != null  )
      {
          //println( "currentCluster Mean = " + currentCluster.getMean() );   
          GPSLocation mean = currentCluster.getMean( true );
          
          if( mean != null && location.distanceTo( mean ) <  distanceThreshold )
          {
            currentCluster.addToGroup( location );
            pendingLocation = null;
            return;
          }
      }
      
      //println( "\t CurrentCluster " );      
      
      // Otherwise
      // if there's a pending location
      if( pendingLocation != null )
      {
          // Check if the current cluster's time 
          // Is greater than the time threshold
          // If so, add it to the place clusters
          if( duration( currentCluster ) > timeThreshold )
               placeClusters.add( currentCluster );
        
          //Once added... clear the cluster
          // And add the previous
          currentCluster = new LocationGroup();
          currentCluster.addToGroup( pendingLocation );
          
          if( location.distanceTo( pendingLocation ) < distanceThreshold )
          {
              currentCluster.addToGroup( location );
              pendingLocation = null;
          }else{
              pendingLocation = location;
          }
      
      }else{
        // Else set the current location to the pending location
        pendingLocation = location;	
      }      

    
  }
  
  float duration( LocationGroup cluster )
  {
        if( cluster == null ) return 0;
			
        return cluster.getDuration();
  }
  
  
  void finish()
  {
      
    
  }
  
  
}
