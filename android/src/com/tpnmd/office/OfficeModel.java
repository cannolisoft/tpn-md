package com.tpnmd.office;

import java.util.ArrayList;
import java.util.List;

public class OfficeModel {

   private static ArrayList<Office> all = null;
   private static ArrayList<Office> urgentCare = null;
   private static ArrayList<Office> practices = null;
   
   // Prevent construction
   private OfficeModel() {};
   
   public static List<Office> getAll() {
	   if ( all == null ) {
		   all = new ArrayList<Office>();
		   all.addAll(getPractices());
		   all.addAll(getUrgentCare());
	   }
	   return all;
   }

   public static List<Office> getUrgentCare() {
	   
     if ( urgentCare == null ) {
	   
    	 urgentCare = new ArrayList<Office>();
	     urgentCare.add( new Office( "Urgent Care", "Rex Urgent Care of Cary",
	                                 "1515 Southwest Cary Parkway, Suite 130",
	                                 "Cary, NC 27511", "919-387-3180",
	                                 "default.jpg", "cary",
	                                 35.755050,-78.809045));
	     urgentCare.add( new Office( "Urgent Care", "Rex Urgent Care of Wakefield",
	                                 "4420 Lake Boone Trail", "Raleigh, NC 27607",
	                                 "919-784-3419", "default.jpg", "wakefield",
	                                  35.815467, -78.704067 ));
     }

     return urgentCare;
   }

   public static List<Office> getPractices() {
     if ( practices == null ) {
	     practices = new ArrayList<Office>();
	     practices.add( new Office( "", "Chapel Hill North Medical Center",
	                                "1838 Martin Luther King, Jr. Blvd.","Chapel Hill, NC 27514",
	                                "919-960-7461", "default.jpg", "",
	                                 35.964467, -79.058385 ));
	
	     practices.add( new Office( "","Chatham Crossing",
	                                "11312 US 15-501N, Suite 308", "Chapel Hill, NC 27517",
	                                "919-960-6094", "default.jpg", "",
	                                 35.84619, -79.09073 ));
	
	     practices.add( new Office( "","Chatham Primary Care",
	                                "311 N. Fir Avenue", "Siler City, NC 27344",
	                                "919-742-6032", "default.jpg", "",
	                                 35.722466, -79.470778 ));
	
	     practices.add( new Office( "", "Executive Health (The Carolina Clinic)",
	                                "315 Meadowmont Village Circle", "Chapel Hill, NC 27517",
	                                "919-962-2862", "default.jpg", "",
	                                 35.904847, -79.010439 ));
	
	     practices.add( new Office( "", "Highgate Family Medical Center",
	                                "5317 Highgate Drive, Suite 117", "Durham, NC 27713",
	                                "919-361-2644", "default.jpg", "",
	                                 35.910117 , -78.941535 ));
	
	     practices.add( new Office( "", "Pittsboro Family Medicine",
	                                "855 East Street", "Pittsboro, NC 27312",
	                                "919-545-0911", "default.jpg", "",
	                                 35.719903 , -79.162602 ));
	
	     practices.add( new Office( "","Sanford Hematology Oncology",
	                                "1212 Central Drive, Suite 201", "Sanford, NC 27330",
	                                "919-775-8183", "default.jpg", "",
	                                 35.467442 , -79.186845 ));
	
	     practices.add( new Office( "","Sanford Specialty Clinics",
	                                "1301 Central Drive", "Sanford, NC 27330",	
	                                "919-718-9512", "default.jpg", "",
	                                 35.466466 , -79.185844 ));
	
	     practices.add( new Office( "","UNC Family Medicine at Hillsborough",
	                                "2201 Old N.C. Highway 86", "Hillsborough, NC 27278",
	                                "919-732-2909", "default.jpg", "",
	                                 36.053007, -79.103842 ));
	
	     practices.add( new Office( "","University Pediatrics at Highgate",
	                                "5322 Highgate Dr., Suite 144", "Durham, NC 27713",
	                                "919-806-3335", "default.jpg","",
	                                 35.909862 , -78.941376 ));
	
	     practices.add( new Office( "","Rex Family Practice of Knightdale",
	                                "6602 Knightdale Blvd., Suite 202", "Knightdale, NC 27545",
	                                "919-747-5270", "knightdale.jpg", "",
	                                 35.795562, -78.510993 ));
	
	     practices.add( new Office( "", "Rex Family Practice of Wakefield",
	                                "11200 Governor Manly Way, Suite 205", "Raleigh, NC 27614",
	                                "919-570-7700", "wakefield.jpg", "",
	                                 35.942431, -78.599759 ));
	
	     practices.add( new Office( "","Rex Primary Care of Holly Springs",
	                                "208 Village Walk Drive", "Holly Springs, NC 27540",
	                                "919-552-8911", "default.jpg", "",
	                                 35.639555, -78.833773 ));
	
	     practices.add( new Office( "","Rex Senior Health Center",
	                                "512 E. Davie Street", "Raleigh, NC 27601",
	                                "919-832-2400", "default.jpg", "",
	                                 35.775227, -78.631606 ));
	
	     practices.add( new Office( "", "Rex/UNC Family Practice of Panther Creek ",
	                                "10030 Green Level Church Road, Suite 808",
	                                "Cary, NC 27519", "919-481-4997", "default.jpg", "",
	                                 35.819609, -78.902204 ));
	
	     practices.add( new Office( "", "Boylan Healthcare (Browning Place)",
	                                "3900 Browning Place, Suite 101", "Raleigh, NC 27609",
	                                "919-781-9650", "default.jpg", "",
	                                 35.830793, -78.633088 ));
	
	     practices.add( new Office( "","Boylan Healthcare (Health Park)",
	                                "8300 Health Park, Suite 309", "Raleigh, NC 27615",
	                                "default.jpg", "919-781-9650", "",
	                                 35.894875, -78.659756 ));
     }

     return practices;
   }
   
}
