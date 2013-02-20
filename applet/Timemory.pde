import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
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

void setup()
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
void parseGPSFile()
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

void parseCameraDataFile()
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

void parseTextDataFile()
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


boolean isOutsideDateRange( GPSLocation geoLoc )
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

boolean isOutsideCoordinatesRange( )
{
  return false;
}



void setupDateFilters()
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


void draw()
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

