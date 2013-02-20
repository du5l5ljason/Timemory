import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import codeanticode.glgraphics.*; 
import de.fhpotsdam.unfolding.*; 
import de.fhpotsdam.unfolding.geo.*; 
import de.fhpotsdam.unfolding.utils.*; 
import de.fhpotsdam.unfolding.providers.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Timemory extends PApplet {







de.fhpotsdam.unfolding.Map map;

//store the points
//LocationGroup locGroup = new LocationGroup( "all" );

//The path of the files we want to analyze
String gpsFilePath = "data/GPSTrackAmtrakTrip.txt";
String cameraDataFilePath = "data/CameraMetadata.txt";
String textDataFilePath = "data/textMetaData.txt";

String dateStart = "";
String dateEnd = "";

float unixDateStart = 0;
float unixDateEnd = 0; 

//Stores the points
//LocationHashMap locMap = new LocationHashMap();
LocationGroup googleTrackLocations = new LocationGroup( );
LocationGroup photoTrackLocations = new LocationGroup();
LocationGroup textTrackLocations = new LocationGroup();

//Time based clustering
TimeBasedClustering tbc = new TimeBasedClustering(  ); 

public void setup()
{
  setupDateFilters();
  parseGPSFile();
  parseCameraDataFile();
  parseTextDataFile();
  
  size(800, 600, GLConstants.GLGRAPHICS);

  map = new de.fhpotsdam.unfolding.Map(this);
  map.zoomAndPanTo(new Location(38.0f, -100.0f), 4);
  MapUtils.createDefaultEventDispatcher(this, map);
}

//Load Files
public void parseGPSFile()
{
  String[] lines = loadStrings( gpsFilePath );

  if( lines == null || lines.length < 1)return;
  for( int i = 0; i< lines.length; i++ )
  {
       //create a new GPSlocation
       GPSLocation g = new GPSLocation();
       
       //parseFrom
       g.parseFrom(lines[i]); 
       if( !isOutsideDateRange( g )  )
       {
         googleTrackLocations.addToGroup( g );
        //tbc.clusterLocation(g);
         //println("add a point"+ g.lat + g.lon);
       }

 
  }

}

public void parseCameraDataFile()
{
  String[] lines = loadStrings( cameraDataFilePath );

  if( lines == null || lines.length < 1)return;
 
  for( int i = 0; i< lines.length; i++ )
  {
       //create a new GPSlocation
       GPSLocation g = new GPSLocation();
       
       //parseFrom
       g.parseFrom(lines[i]); 
       if( !isOutsideDateRange( g )  )
       {
         photoTrackLocations.addToGroup( g );
        //tbc.clusterLocation(g);
        //println("add a point"+ g.lat + g.lon);
       }

  
  }

}

public void parseTextDataFile()
{
  String[] lines = loadStrings( textDataFilePath );

  if( lines == null || lines.length < 1)return;
  for( int i = 0; i< lines.length; i++ )
  {
       //create a new GPSlocation
       GPSLocation g = new GPSLocation();
       
       //parseFrom
       g.parseFrom(lines[i]); 
       if( !isOutsideDateRange( g )  )
       {
         textTrackLocations.addToGroup( g );
        //tbc.clusterLocation(g);
        //println("add a point"+ g.lat + g.lon);
       }

     
  }

}


public boolean isOutsideDateRange( GPSLocation geoLoc )
{
   if( dateStart.length() < 1 && dateEnd.length() < 1 )
   {
      return false;
   } 
   
   if( dateStart.length() > 0 )
   {
       if( geoLoc.timestamp < unixDateStart )
         return true;
   }

   if( dateEnd.length() > 0 )
   {
       if( geoLoc.timestamp > unixDateEnd )
         return true;
   }

   
   return false;
   
}

public boolean isOutsideCoordinatesRange( )
{
  return false;
}



public void setupDateFilters()
{
   if( dateStart.length() > 1  ){
     unixDateStart = DateUtils.stringToUnixEpoch( dateStart );
   }else{
      unixDateStart = 0;
   }
    
   if( dateEnd.length() > 1  ){
     unixDateEnd = DateUtils.stringToUnixEpoch( dateEnd );
   }else{
      unixDateEnd = 0;
   }
   
   println( "Filters set as " + unixDateStart + " " + unixDateEnd );
}


public void draw()
{
  
  //background(0);
  //map.draw();
  
  //noStroke();
  
  //ellipseMode( CENTER );
  // Get a set of the entries 
  //println( "Drawing " + googleTrackLocations.locations.size() + " points " );
  //float lastXY[] = null;
  /*
   for( int i = 0 ; i < googleTrackLocations.locations.size(); i++ )
  {
    
     GPSLocation googleLoc =  (GPSLocation)googleTrackLocations.locations.get( i );
     // Get the screen position
     Location loc = new Location( googleLoc.lat, googleLoc.lon );
     
     float xy[] = map.getScreenPositionFromLocation( loc );
     ellipse( xy[0], xy[1] , 5, 5 );
     
  }
  */

}

static class DateUtils{
  
  /* This converts a String in the format YYYY-MM-DD HH:MM:SS 
     e.g. 2011-12-23 14:34:12
     to a usable date
   */  
  public static Date stringToDate( String str )
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
  
  public static float dateToUnixEpoch( Date date )
  {
     Long longTime = new Long( date.getTime() / 1000 );
     return longTime.floatValue(); 
  }
  
  /* This function wraps the previous two into one 
    So that you can quickly convert a string into a unix timestamp
    */
    
  public static float stringToUnixEpoch( String str )
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
  
  
  public static String unixToPrettyDate( float timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch =(new Float( timestamp) ).longValue()  ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }

  public static String unixToYear( float timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch =(new Float( timestamp) ).longValue()  ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }
 
  public static String unixToMonth( float timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch =(new Float( timestamp) ).longValue()  ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }
  
  public static String unixToDay( float timestamp ) {
     java.util.Date time = new java.util.Date( );

     long epoch =(new Float( timestamp) ).longValue()  ;
     // Multiply by 1000 as java expects date in milliseconds
     time.setTime( epoch*1000 );
     
     SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");     
     
     String dateAsString = formatter.format( time );
     
     return dateAsString;
  }  
  
  
}
class GPSLocation{
  
  // Latitude, Longitude and Altitude of the location
  float lat;
  float lon;
  float alt;
  
  // THe time is in Unix Epoch - time in seconds
  // This is pretty useful for time calculations
  // see: http://en.wikipedia.org/wiki/Unix_time
  float timestamp;
  
  // What device, os etc was it captured with
  int words;
  
  GPSLocation()
  {
    
  }
  
  public void parseFrom( String s )
  {
    if( s == null || s.length() < 1 ) return;
    
    String[] parts = s.split( ", " );
    
    println("The number of parts is" + parts.length);
    if( parts.length > 3 )
    {/*
       lat = Float.valueOf(parts[0].trim()).floatValue() ;
       lon = Float.valueOf(parts[1].trim()).floatValue() ;
       alt = Float.valueOf(parts[2].trim()).floatValue() ;
       timestamp = Float.valueOf( parts[3].trim() ).floatValue() ;
       words = int(parts[4]);
       println(lat + ", " + lon + ", " + alt + ", " + timestamp + "," + words);
       */
    }
    
  }
  
  public void parseFromGPS( String s1, String s2 )
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
  
  public void parseFromCamera( String s )
  {
    String[] temp = splitTokens(s, "DataTimeOriginal");
    temp = splitTokens(temp[0], " :");
    //println(temp);
    String date = temp[0] + "-" + temp[1] + "-" + temp[2] + " " + temp[3] + ":" + temp[4] + ":" + temp[5];
    timestamp = DateUtils.stringToUnixEpoch( date );
  }
  
  public void parseFromText( String s)
  {
     String[] temp = split(s,",");

     String date = temp[0] + " " + temp[1];
     timestamp = DateUtils.stringToUnixEpoch( date );
  }
  public float distanceTo( GPSLocation g )  
  {
    return GPSUtils.kmDistBetween( this, g );
  }
  
  
  public float timeBetween( GPSLocation g )  
  {
    return abs( g.timestamp - timestamp ) ;
  }  
  
  public String getLocationID( )
  {
     return "lat:" + lat + "&lon:" + lon;
  }
  
  public String toString()
  {
    return "lat:" + lat + ", lon: " + lon + ", alt:" + alt + ", time: " + DateUtils.unixToPrettyDate( timestamp );
  }    
  
}
static class GPSUtils{
  
  public static float kmDistBetween( GPSLocation loc1, GPSLocation loc2 ) {
     return kmDistBetween(loc1.lat, loc1.lon, loc2.lat, loc2.lon);
  }

 public static float kmDistBetween(float lat1, float lon1, float lat2, float lon2) {  
     float earthRadiusInKm = 6367;
     return distBetween( lat1, lon1, lat2, lon2 , earthRadiusInKm );
  }

  
  /*
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
  */

  public static float distBetween( GPSLocation loc1, GPSLocation loc2 ) {
     return distBetween(loc1.lat, loc1.lon, loc2.lat, loc2.lon );
  }


  public static float distBetween(float lat1, float lon1, float lat2, float lon2) 
  {
     float earthRadiusInMiles = 3956;
     return distBetween( lat1, lon1, lat2, lon2 , earthRadiusInMiles );
  }

  public static float distBetween(float lat1, float lng1, float lat2, float lng2, float earthRadius ) 
  {
      float dLat = radians(lat2-lat1);
      float dLng = radians(lng2-lng1);
      float a = sin(dLat/2) * sin(dLat/2) +
                 cos( radians(lat1) ) * cos( radians(lat2) ) *
                 sin(dLng/2) * sin(dLng/2);
      float c = 2 * atan2(sqrt(a), sqrt(1-a));
      float distInMiles = earthRadius * c;
      
      return distInMiles;
  }  
 
  
}
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
  
  
  public void cluster( ArrayList locations )
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


  
  public void makeIteration()
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

  
  public void initializeClusters()
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
  

  
  public void putObjectsIntoClusters()
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
  
  public boolean evalutateCenters()
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
  
  
  public void finish() 
  {
      inProcess = false;      
      hasIterations = true;
  }  
  
}
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

  public void clear( boolean clearMean )
  {
      locations.clear();
      
      
      if( clearMean )
      {
         meanLocation = null; 
      }
      //println( "Mean Location is " + meanLocation );
  }
   
  public void addToGroup( GPSLocation location, boolean cleanCentre )
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
  
  public void addToGroup( GPSLocation location )
  {
      if( location == null ) return;
    
      // First clear the mean
      // This forces recalculation after a change
      meanLocation = null;
      
      // Add the location
      locations.add( location );
  }  
  
  public float getDuration()
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
  
  public GPSLocation getMean( boolean force )
  {
     if( force )
       meanLocation = null;
     
     return getMean(  );
  }
  
  public GPSLocation getMean( )
  {
    if( meanLocation == null && locations.size() > 0 )
    {
      // Calculate the mean if needed 
      meanLocation = calculateMean();
      return meanLocation;
    } 
    
    return null;
  }

  public GPSLocation calculateMean()
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
class LocationHashMap
{  
  // Latitude, Longitude and Altitude of the location
  HashMap map = new HashMap();

  // Total Locations
  int totalLocations = 0;

  // Total Unique Locations
  int uniqueLocations = 0;
  
  // Max per Group
  int maxGroupSize = 1;
  

  LocationHashMap()
  {
    
  }
  
  public void add( GPSLocation location )
  {
     if( location == null ) return;

     // First see if it exists in the map
     LocationGroup locGroup;
     if( hasLocation( location ) )
     {
       // Get the group and add the new location
       locGroup = getLocationGroupFor( location );
       locGroup.addToGroup( location );
       
       if( locGroup.locations.size() > maxGroupSize )
       {
         maxGroupSize = locGroup.locations.size();
       }
       
     }else{
       String grpKey = location.getLocationID( );
       
       // Create a new group
       locGroup = new LocationGroup( grpKey );
       locGroup.addToGroup( location );
       
       map.put( grpKey, locGroup );
       
       // Incrememt unique locations
       uniqueLocations++;
     }
     
     // Finally increment the total
     totalLocations++;    
    
  }
 
  public boolean hasLocation( GPSLocation location )
  {
       if( location == null ) return false;
       
       if( map.containsKey( location.getLocationID( ) ) ) 
       {
         return true;
       }
       return false;
   }

   public LocationGroup getLocationGroupFor( GPSLocation location )
   {
     if( location == null ) return null;
    
      return getLocationGroupFor( location.getLocationID( ) ); 
   }

   public LocationGroup getLocationGroupFor( String locUID )
   {
       if( !map.containsKey( locUID ) )
       {
         return null;
       }
       
       LocationGroup locGroup = (LocationGroup)map.get( locUID );
       
       return locGroup;
   }  
   

}
class TimeBasedClustering{
  
  // Init Distance  to 50 meters or 0.05 KM
  float distanceThreshold = 0.05f;
  
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
  
  
  public void reset()
  {
    placeClusters = new ArrayList();
    currentCluster = null;
    pendingLocation = null;
    
  }
  
  public void clusterLocation( GPSLocation location )
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
  
  public float duration( LocationGroup cluster )
  {
        if( cluster == null ) return 0;
			
        return cluster.getDuration();
  }
  
  
  public void finish()
  {
      
    
  }
  
  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "Timemory" });
  }
}
