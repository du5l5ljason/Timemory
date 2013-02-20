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
  
  void add( GPSLocation location )
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
 
  boolean hasLocation( GPSLocation location )
  {
       if( location == null ) return false;
       
       if( map.containsKey( location.getLocationID( ) ) ) 
       {
         return true;
       }
       return false;
   }

   LocationGroup getLocationGroupFor( GPSLocation location )
   {
     if( location == null ) return null;
    
      return getLocationGroupFor( location.getLocationID( ) ); 
   }

   LocationGroup getLocationGroupFor( String locUID )
   {
       if( !map.containsKey( locUID ) )
       {
         return null;
       }
       
       LocationGroup locGroup = (LocationGroup)map.get( locUID );
       
       return locGroup;
   }  
   

}
