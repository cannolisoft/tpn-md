package com.tpnmd.physician;

import android.net.Uri;

public class Physician {

	public static final String TABLE_NAME = "ZPHYSICIAN";
	public static final String AUTHORITY = "com.tpnmd.physician.Physician";
	
	/**
     * The content:// style URL for this table
     */
    public static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY + "/physician");
    
    /**
     * The MIME type of {@link #CONTENT_URI} providing a directory of notes.
     */
    public static final String CONTENT_TYPE = "vnd.android.cursor.dir/vnd.tpnmd.physician";

    /**
     * The MIME type of a {@link #CONTENT_URI} sub-directory of a single note.
     */
    public static final String CONTENT_ITEM_TYPE = "vnd.android.cursor.item/vnd.tpnmd.physician";

    public static final class Specialty {
        // This class cannot be instantiated
        private Specialty() {} 	
        
        public static final String TABLE_NAME = "ZSPECIALTY";
        
        /**
         * The MIME type of {@link #CONTENT_URI} providing a directory of notes.
         */
        public static final String CONTENT_TYPE = "vnd.android.cursor.dir/vnd.tpnmd.specialty";

    	/**
         * The content:// style URL for this table
         */
        public static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY + "/specialty");
    	
    	public static final class Columns {
            // This class cannot be instantiated
            private Columns() {}
            
            /**
             * The ID of the Specialty
             * <P>Type: INTEGER</P>
             */
            public static final String ID = "_id";
            
            /**
             * The Specialty name
             * <P>Type: TEXT</P>
             */
            public static final String NAME = "ZNAME";
    	}
    }
    
    public static final class SpecialtyTie {
        // This class cannot be instantiated
        private SpecialtyTie() {} 	
        
        public static final String TABLE_NAME = "Z_2SPECIALTY";
    	
    	public static final class Columns {
            // This class cannot be instantiated
            private Columns() {}
            
            /**
             * The ID of the Specialty
             * <P>Type: INTEGER</P>
             */
            public static final String SPECIALTY_ID = "Z_3SPECIALTY";
            
            /**
             * The ID of the Physician
             * <P>Type: INTEGER</P>
             */
            public static final String PHYSICIAN_ID = "Z_2PHYSICIANS";
    	}
    }
	
	public static final class Columns {
        // This class cannot be instantiated
        private Columns() {}
        

        /**
         * The ID of the Physician
         * <P>Type: INTEGER</P>
         */
        public static final String ID = "_id";//"Z_PK";
        
        /**
         * The Physicians name
         * <P>Type: TEXT</P>
         */
        public static final String NAME = "ZNAME";

        /**
         * The Physicians gender
         * <P>Type: TEXT</P>
         */
        public static final String GENDER = "ZGENDER";
        
        /**
         * The Physicians school
         * <P>Type: TEXT</P>
         */
        public static final String SCHOOL = "ZSCHOOL";
        
        /**
         * The Physicians certification
         * <P>Type: TEXT</P>
         */
        public static final String CERTIFICATION = "ZCERTIFICATION";
        
        /**
         * The Physicians residency
         * <P>Type: TEXT</P>
         */
        public static final String RESIDENCY = "ZRESIDENCY";
        
        /**
         * The ID of the Physicians Office 
         * <P>Type: INTEGER</P>
         */
        public static final String OFFICE_ID = "ZOFFICE";
	}
}
