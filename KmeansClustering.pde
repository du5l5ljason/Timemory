class KMeansClustering{
  
  int numberOfClusters = 0;
  int maxIterations = 100;
  
  boolean hasIterations = true;
  ArrayList clusters = null;
  
  int iterationCount = 0;
  
  boolean inProcess = false;
  
  ArrayList seedLocations = null; 
  
  KMeansClustering( int numClusters )
  {
     numberOfClusters = numClusters;
  }
  
  KMeansClustering( int numClusters, int mxIterations )
  {
     numberOfClusters = numClusters;
     maxIterations = mxIterations;
  }  
  
  
  void cluster( ArrayList locations )
  {
      if( numberOfClusters < 2 )
         return;
    
      if( locations == null || locations.size() < numberOfClusters )
        return;
        
      clusters = null;
      seedLocations = locations;
    
      inProcess = true;
      iterationCount = 0;
  }  


  
  void makeIteration()
  {
      if ( !hasIterations )
        return;

      if( iterationCount > maxIterations )
      {
        finish();
        return;
      }
      
      if( clusters == null )
      {
         initializeClusters(); 
      }

      println( "Initialised" );

      putObjectsIntoClusters();
      
      println( "Objects in Clusters" );
      boolean changed = evalutateCenters();
      
      println( "Changed is " + changed );
      
      if (!changed){
        hasIterations = false;
        finish();
      }else{
        hasIterations = true;
      }
        
      println( "hasIterations " + hasIterations );
        
        
      iterationCount++;
  }

  
  void initializeClusters()
  {
      ArrayList initClusters = new ArrayList();
    
      for (int i = 0; i < numberOfClusters; i++)
      {
         int index = (int) floor( random( 0, seedLocations.size() - 1 )  );
         LocationGroup lg = new LocationGroup( (GPSLocation)seedLocations.get( i ) );
         //lg.addToGroup( (GPSLocation)seedLocations.get( i ) , false );
         
         initClusters.add( lg );
      }
     
      clusters = initClusters;

      println( "initializeClusters() = " + clusters.size() );
     

  }  
  

  
  void putObjectsIntoClusters()
  {
     // First clear the clusters
      for (int i = 0; i < clusters.size() ; i++)
      {
        LocationGroup cluster = ( LocationGroup )clusters.get( i );
        cluster.clear( false );

        // Ensure its non null        
        if( cluster.meanLocation == null )
          cluster.meanLocation = new GPSLocation();
        
      }     
      
      for (int i = 0; i < seedLocations.size(); i++)
      {
          LocationGroup minCluster = null;
          float minDistance = Integer.MAX_VALUE;
          
          GPSLocation geoLoc = ( GPSLocation ) seedLocations.get( i ) ;
          
          for( int j = 0 ; j < clusters.size() ; j ++ )
          {
              LocationGroup locCluster = ( LocationGroup )clusters.get( j );
              
              float distance = geoLoc.distanceTo( locCluster.meanLocation );
              
              if( distance < minDistance )
              {
                  minDistance = distance;
                  minCluster = locCluster;
              }
          }
          // Finally add the cluster to the one wiht minimum distance to it
          minCluster.addToGroup( geoLoc , false );

      }
      
  }
  
  boolean evalutateCenters()
  {
      println( "evalutateCenters()" );
    
      boolean changed = false;
      
      for (int i = 0; i < clusters.size() ; i++)
      {
        LocationGroup cluster = ( LocationGroup )clusters.get( i );
        
        GPSLocation currentCenter = cluster.meanLocation;
        GPSLocation updatedCenter = cluster.getMean( true );
        
        boolean localChanged = ( currentCenter != updatedCenter );
        if (localChanged)
          changed = true;
      }
      
      return changed;    
  }
  
  
  void finish() 
  {
      inProcess = false;      
      hasIterations = true;
  }  
  
}
