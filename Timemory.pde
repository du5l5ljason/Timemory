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
String gpsFilePath = "data/GPSData.csv";
String cameraDataFilePath = "data/CameraGPSData.csv";
String textDataFilePath = "data/TextGPSData.csv";
String splitDaySummaryPath = "data/DaySplitSummary.txt";
String dateStart = "";
String dateEnd = "";

long unixDateStart = 1309884811;
long unixDateOrigin = 1309884811;
long unixDateEnd = 1312441131; 

PFont dataLabel;
PFont titleLabel;
PFont detailsLabel;

int labelTimeX = 800;
int labelTimeY = 40;
int labelCityX = 800;
int labelCityY = 120;
int labelGPSX = 800;
int labelGPSY = 200;
int labelDayX = 800;
int labelDayY = 280;
int labelDistX = 800;
int labelDistY = 360;
int labelPhotosX = 800;
int labelPhotosY = 440;
int labelWordsX = 800;
int labelWordsY = 520;
int dataTimeX = 800;
int dataTimeY = 80;
int dataCityX = 800;
int dataCityY = 160;
int dataGPSX = 800;
int dataGPSY = 240;
int dataDayX = 800;
int dataDayY = 320;
int dataDistX = 800;
int dataDistY = 400;
int dataPhotosX = 800;
int dataPhotosY = 480;
int dataWordsX = 800;
int dataWordsY = 560;
int dayID = 1;
int days = 31;

float[] fDist =  new float[31] ;
int[] nPhotos = new int[31];
int[] nWords = new int[31];
GPSLocation lastDayLoc = new GPSLocation();
GPSLocation curDayLoc = new GPSLocation();

String dataTime = "00-00 00:00:00";
String dataCity = "NONE";
String dataGPS = "( , )";

//Stores the points
//LocationHashMap locMap = new LocationHashMap();
LocationGroup googleTrackLocations = new LocationGroup( );
LocationGroup photoTrackLocations = new LocationGroup();
LocationGroup textTrackLocations = new LocationGroup();

LocationGroup showLocations = new LocationGroup();
LocationGroup showPhotoLocations = new LocationGroup();
LocationGroup showTextLocations = new LocationGroup();
//Time based clustering

void setup()
{
  //setupDateFilters();
  parseGPSFile();
  parseCameraDataFile();
  parseTextDataFile();
  parseSplitDaySummaryFile();
  size(1024, 600, GLConstants.GLGRAPHICS);

  map = new de.fhpotsdam.unfolding.Map(this,0,0,800,600);
  map.zoomAndPanTo(new Location(38.0f, -100.0f), 4);
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  
  dataLabel = createFont("Helvetica",22,true);
  titleLabel = createFont("Helvetica",30,true);
  detailsLabel = createFont("Helvetica",16,true);
}

//Load Files
void parseGPSFile()
{
  String[] lines = loadStrings( gpsFilePath );

  if( lines == null || lines.length < 1)return;
  
  curDayLoc.parseFrom(lines[0]);
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
        String s = g.toString();
       // println(s);
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
        String s = g.toString();
       // println(s);
       }

     
  }

}

void parseSplitDaySummaryFile()
{
  String[] lines = loadStrings( splitDaySummaryPath );

  if( lines == null || lines.length < 1)return;
  println(lines.length);
  for( int i = 0; i< lines.length; i++ )
  {
      if( lines[i] != null && lines[i].length() >= 1 ) 
      {
        String[] parts = splitTokens(lines[i],",");
        
        if(parts.length > 3)
        {
            fDist[i] = Float.valueOf(parts[1].trim()).floatValue() ;
            nPhotos[i] = int(parts[2]);
            nWords[i] = int(parts[3]);
        }
        println("dist is " + fDist[i] + ", " + nPhotos[i] + "," + nWords[i]);
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

GPSLocation findMatchGPS( Location loc)
{
  int nlength = googleTrackLocations.locations.size();
  if( nlength<1)return null;
  
  float minDist = 100000.0f;
  int minID = 0;
  for(int i = 0; i < nlength; i++)
  {
    GPSLocation location = (GPSLocation)googleTrackLocations.locations.get(i);
    if(GPSUtils.distBetween(location.lat, location.lon, loc.x, loc.y) < minDist)
    {
      minDist = GPSUtils.distBetween(location.lat, location.lon, loc.x, loc.y);
      minID = i;
    }
  }
  GPSLocation g = new GPSLocation();
  g = (GPSLocation)googleTrackLocations.locations.get(minID);
  return g;
}
////////////////////////////////////////////////////////////////////
//DRAWING MODULE
//
//
///////////////////////////////////////////////////////////////////
public void draw()
{
  
  background(255);
  map.draw();
  drawPoints();
  drawGUI();
  drawData();
}

void drawPoints()
{  
  for( int i = 0 ; i< googleTrackLocations.locations.size() ; i++)
  {
    GPSLocation loc = (GPSLocation)googleTrackLocations.locations.get(i);

    if( 0 <= unixDateStart - loc.timestamp && unixDateStart - loc.timestamp <= 400 )
    {
      showLocations.addToGroup( loc );
     
    }
  }
  
  for( int i = 0 ; i< photoTrackLocations.locations.size() ; i++)
  {
    GPSLocation loc = (GPSLocation)photoTrackLocations.locations.get(i);

    if( 0 <= unixDateStart - loc.timestamp && unixDateStart - loc.timestamp <= 400 )
    {
      showPhotoLocations.addToGroup( loc );
     
    }
  }
  
  for( int i = 0 ; i< textTrackLocations.locations.size() ; i++)
  {
    GPSLocation loc = (GPSLocation)textTrackLocations.locations.get(i);

    if( 0 <= unixDateStart - loc.timestamp && unixDateStart - loc.timestamp <= 400 )
    {
      showTextLocations.addToGroup( loc );
     
    }
  }
  
  unixDateStart +=400;
  
  for (int i = 0 ; i< showLocations.locations.size() ; i++)
  {
    GPSLocation loc = (GPSLocation)showLocations.locations.get(i);
    Location geoloc = new Location( loc.lat, loc.lon );
    float xy[] = map.getScreenPositionFromLocation( geoloc );
    loc.draw(xy[0], xy[1]);
  }
  
  for (int i = 0 ; i< showPhotoLocations.locations.size() ; i++)
  {
    GPSLocation loc = (GPSLocation)showPhotoLocations.locations.get(i);
    Location geoloc = new Location( loc.lat, loc.lon );
    float xy[] = map.getScreenPositionFromLocation( geoloc );
    float sz = loc.words/5.0f;
    loc.drawPhoto(xy[0], xy[1], sz);
  }

   for (int i = 0 ; i< showTextLocations.locations.size() ; i++)
  {
    GPSLocation loc = (GPSLocation)showTextLocations.locations.get(i);
    Location geoloc = new Location( loc.lat, loc.lon );
    float xy[] = map.getScreenPositionFromLocation( geoloc );
    float sz =loc.words/20.0f;
    loc.drawText(xy[0], xy[1], sz);
  }

}

void drawGUI()
{
  textFont(titleLabel);
  
  fill(0,0,0);
  
  text("TIME", labelTimeX,labelTimeY);
  text("PLACE", labelCityX,labelCityY); 
  text("LOCATION", labelGPSX, labelGPSY);
  text("DAY", labelDayX, labelDayY);
  text("DISTANCE", labelDistX, labelDistY);
  text("PHOTOS", labelPhotosX, labelPhotosY);
  text("WORDS", labelWordsX, labelWordsY);
}

void drawData()
{
  textFont(dataLabel);
  
  fill(100,200,50);
  Location loc = map.getLocationFromScreenPosition(mouseX, mouseY);
  GPSLocation location = findMatchGPS(loc);
  dataTime = DateUtils.unixToPrettyDate( location.timestamp );
  dataCity = location.city;
  dataGPS = "(" + location.lat + ", " + location.lon + ")";
  text(dataTime, dataTimeX, dataTimeY);
  text(dataCity, dataCityX, dataCityY);
  text(dataGPS, dataGPSX, dataGPSY);
  text(dayID, dataDayX, dataDayY);
  text(fDist[dayID-1], dataDistX,dataDistY);
  text(nPhotos[dayID-1], dataPhotosX, dataPhotosY);
  text(nWords[dayID-1], dataWordsX, dataWordsY);
  
  if((unixDateStart-unixDateOrigin)%86400 == 0)
  {
    dayID += 1 ;
  }
}

