static class GPSUtils{
  
  static float kmDistBetween( GPSLocation loc1, GPSLocation loc2 ) {
     return kmDistBetween(loc1.lat, loc1.lon, loc2.lat, loc2.lon);
  }

 static float kmDistBetween(float lat1, float lon1, float lat2, float lon2) {  
     float earthRadiusInKm = 6367;
     return distBetween( lat1, lon1, lat2, lon2 , earthRadiusInKm );
  }

  
  /*
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
  */

  static float distBetween( GPSLocation loc1, GPSLocation loc2 ) {
     return distBetween(loc1.lat, loc1.lon, loc2.lat, loc2.lon );
  }


  static float distBetween(float lat1, float lon1, float lat2, float lon2) 
  {
     float earthRadiusInMiles = 3956;
     return distBetween( lat1, lon1, lat2, lon2 , earthRadiusInMiles );
  }

  static float distBetween(float lat1, float lng1, float lat2, float lng2, float earthRadius ) 
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
