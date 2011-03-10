package com.tpnmd.physician;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteQueryBuilder;
import android.util.Log;

public class PhysicianDatabase {
	private static final String TAG = "PhysicianDatabase";
	
	private static final Map<String, String> mPhysicianProjectionMap = buildPhysicianProjectionMap();
	private static final Map<String, String> mSpecialtyProjectionMap = buildSpecialtyProjectionMap();
	
	private final DatabaseHelper mOpenHelper;
	
	public PhysicianDatabase(Context context){
		mOpenHelper = new DatabaseHelper(context);
	}

	public Cursor getPhysicians(String[] columns, String sortOrder) {
		String[] newColumns = appendSelectionArgs(columns,
				new String[]{Physician.Columns.ID}
				);
        return queryPhysicans(newColumns, null, null, sortOrder);	
	}
	
	public Cursor getPhysician(String physicianId, String[] columns, String sortOrder) {
        String selection = Physician.Columns.ID + " = ?";
        String[] selectionArgs = new String[] {physicianId};
		String[] newColumns = appendSelectionArgs(columns,
				new String[]{Physician.Columns.ID}
				);
        return queryPhysicans(newColumns, selection, selectionArgs, sortOrder);
	}

	public Cursor getSpecialties(String sortOrder) {
		String[] columns = new String[]{
				Physician.Specialty.Columns.ID,
				Physician.Specialty.Columns.NAME};
		return querySpecialty(columns, null, null, sortOrder);
	}
	
	public Cursor getPhysiciansWithSpecialty(String specialtyId, String[] columns, String sortOrder) {
		String[] newColumns = appendSelectionArgs(columns,
				new String[]{Physician.Columns.ID}
				);
        return queryPhysicansAndSpecialty(specialtyId, newColumns, null, null, sortOrder);	
	}
	
	private Cursor queryPhysicans(String[] columns, String selection, String[] selectionArgs, String sortOrder) {
		final SQLiteQueryBuilder qb = new SQLiteQueryBuilder();
		qb.setTables(Physician.TABLE_NAME);
		qb.setProjectionMap(mPhysicianProjectionMap);
		
		final SQLiteDatabase db = mOpenHelper.getReadableDatabase();
		final Cursor cursor = qb.query(db, columns, selection, selectionArgs, null, null, sortOrder);
		
        if (cursor == null) {
            return null;
        } else if (!cursor.moveToFirst()) {
            cursor.close();
            return null;
        }
        return cursor;
	}
	
	private Cursor querySpecialty(String[] columns, String selection, String[] selectionArgs, String sortOrder) {
		final SQLiteQueryBuilder qb = new SQLiteQueryBuilder();
		qb.setTables(Physician.Specialty.TABLE_NAME);
		qb.setProjectionMap(mSpecialtyProjectionMap);
		
		final SQLiteDatabase db = mOpenHelper.getReadableDatabase();
		final Cursor cursor = qb.query(db, columns, selection, selectionArgs, null, null, sortOrder);
		
        if (cursor == null) {
            return null;
        } else if (!cursor.moveToFirst()) {
            cursor.close();
            return null;
        }
        return cursor;
	}
	
	private Cursor queryPhysicansAndSpecialty(String specialtyId, String[] columns,
			String selection, String[] selectionArgs, String sortOrder) {
		final SQLiteQueryBuilder qb = new SQLiteQueryBuilder();
		qb.setProjectionMap(mPhysicianProjectionMap);
		qb.setTables(
				String.format(
					"%1$s LEFT OUTER JOIN %2$s ON (%3$s = %2$s.%4$s)",
					Physician.TABLE_NAME, Physician.SpecialtyTie.TABLE_NAME,
					Physician.Columns.ID, Physician.SpecialtyTie.Columns.PHYSICIAN_ID));
		
		qb.appendWhere(
				String.format(
						"%1$s.%2$s = %3$s",
						Physician.SpecialtyTie.TABLE_NAME, Physician.SpecialtyTie.Columns.SPECIALTY_ID,
						specialtyId));
		
		final SQLiteDatabase db = mOpenHelper.getReadableDatabase();
		final Cursor cursor = qb.query(db, columns, selection, selectionArgs, null, null, sortOrder);
		
        if (cursor == null) {
            return null;
        } else if (!cursor.moveToFirst()) {
            cursor.close();
            return null;
        }
        return cursor;
	}
	
	private static Map<String, String> buildPhysicianProjectionMap() {
		Map<String, String> map = new HashMap<String, String>();
		//we need to alias the PK field to _id for android's pleasure
		map.put(Physician.Columns.ID, "Z_PK as _id");
		map.put(Physician.Columns.NAME, Physician.Columns.NAME);
		map.put(Physician.Columns.GENDER, Physician.Columns.GENDER);
		return map;
	}
	
	private static Map<String, String> buildSpecialtyProjectionMap() {
		Map<String, String> map = new HashMap<String, String>();
		//we need to alias the PK field to _id for android's pleasure
		map.put(Physician.Specialty.Columns.ID, "Z_PK as _id");
		map.put(Physician.Specialty.Columns.NAME, Physician.Specialty.Columns.NAME);
		return map;
	}
	
	private static String[] appendSelectionArgs(String[] originalValues, String[] newValues){
		String[] result = new String[originalValues.length + newValues.length];
		int originalLength = originalValues.length;
		System.arraycopy(originalValues, 0, result, 0, originalLength);
		System.arraycopy(newValues, 0, result, originalLength, newValues.length);
		return result;
	}
	
    /**
     * This class helps open, create, and upgrade the database file.
     */
    private static class DatabaseHelper extends SQLiteOpenHelper {

    	private Context context;
    	
    	private static final String DATABASE_NAME = "tpnmd.sqlite";
		private static final int DATABASE_VERSION = 1;

		public DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
            this.context = context;
        }

        @Override
        public void onCreate(SQLiteDatabase db) {            
        	Log.w(TAG, "Created database");

        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            Log.w(TAG, "Upgrading database from version " + oldVersion + " to "
                    + newVersion + ", which will destroy all old data");
        }
        
		@Override
		public synchronized SQLiteDatabase getReadableDatabase() {
			if(!isDBInPlace()){
				copyDBIntoPlace();
			}
			return super.getReadableDatabase();
		}

		@Override
		public synchronized SQLiteDatabase getWritableDatabase() {
			if(!isDBInPlace()){
				copyDBIntoPlace();
			}
			return super.getWritableDatabase();
		}

		private boolean isDBInPlace(){
        	File toFile = this.context.getDatabasePath(DATABASE_NAME);
        	if(toFile.exists()){
        		return true;
        	}
        	return false;
        }
        
        private void copyDBIntoPlace(){
        	File toFile = this.context.getDatabasePath(DATABASE_NAME);
        	
        	try {
            	InputStream fromStream = 
            		this.context.getAssets().open(DATABASE_NAME);
            	
            	toFile.createNewFile();
            	FileUtils.copyInputStreamToFile(fromStream, toFile);
			} catch (IOException e) {
				Log.e(TAG, "Failed copying database into place", e);
			}
        }
    }
}
