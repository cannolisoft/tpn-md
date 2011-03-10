package com.tpnmd.view;

import android.R;
import android.app.Activity;
import android.app.ExpandableListActivity;
import android.database.Cursor;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ExpandableListAdapter;
import android.widget.SimpleCursorTreeAdapter;

import com.tpnmd.physician.Physician;
import com.tpnmd.physician.PhysicianDatabase;

public class PhysicianList extends ExpandableListActivity {

    private static final String[] groupFrom = new String[]{Physician.Columns.NAME};
    private static final int[] groupTo = new int[]{android.R.id.text1};
	
    private static final String[] itemFrom = new String[]{Physician.Columns.NAME, Physician.Columns.GENDER};
    private static final int[] itemTo = new int[]{android.R.id.text1, android.R.id.text2};
	
	private final PhysicianDatabase database;
	
	public PhysicianList() {
		super();

		database = new PhysicianDatabase(this);
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setListAdapter(buildListTreeAdapter()); 
	}
	
	private ExpandableListAdapter buildListTreeAdapter() {
        Cursor c = database.getSpecialties(Physician.Specialty.Columns.NAME);
        startManagingCursor(c);
        
        PhysicianTreeAdapter physicians = 
    	    new PhysicianTreeAdapter(this, c, 
    	    		R.layout.simple_expandable_list_item_1, groupFrom, groupTo,
    	    		R.layout.simple_expandable_list_item_2, itemFrom, itemTo);
        
        return physicians;
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreateOptionsMenu(android.view.Menu)
	 */
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return super.onCreateOptionsMenu(menu);
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onOptionsItemSelected(android.view.MenuItem)
	 */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		return super.onOptionsItemSelected(item);
	}


	public class PhysicianTreeAdapter extends SimpleCursorTreeAdapter {

		public PhysicianTreeAdapter(Activity context, Cursor cursor,
				int collapsedGroupLayout, int expandedGroupLayout,
				String[] groupFrom, int[] groupTo, int childLayout,
				int lastChildLayout, String[] childFrom, int[] childTo) {
			super(context, cursor, collapsedGroupLayout, expandedGroupLayout, groupFrom,
					groupTo, childLayout, lastChildLayout, childFrom, childTo);
		}

		public PhysicianTreeAdapter(Activity context, Cursor cursor,
				int collapsedGroupLayout, int expandedGroupLayout,
				String[] groupFrom, int[] groupTo, int childLayout,
				String[] childFrom, int[] childTo) {
			super(context, cursor, collapsedGroupLayout, expandedGroupLayout, groupFrom,
					groupTo, childLayout, childFrom, childTo);
		}

		public PhysicianTreeAdapter(Activity context, Cursor cursor,
				int groupLayout, String[] groupFrom, int[] groupTo,
				int childLayout, String[] childFrom, int[] childTo) {
			super(context, cursor, groupLayout, groupFrom, groupTo, childLayout, childFrom,
					childTo);
		}

		@Override
		protected Cursor getChildrenCursor(Cursor groupCursor) {
			int columnIndex = groupCursor.getColumnIndex(Physician.Specialty.Columns.ID);
			String specialtyId = groupCursor.getString(columnIndex);

			Cursor cursor = database.getPhysiciansWithSpecialty(
					specialtyId, itemFrom, Physician.Columns.NAME);
			startManagingCursor(cursor);
			
			return cursor;
		}

	}
}
