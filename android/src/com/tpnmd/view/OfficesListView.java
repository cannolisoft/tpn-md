package com.tpnmd.view;

import java.util.ArrayList;

import com.tpnmd.Office;
import com.tpnmd.OfficeModel;

import android.R;
import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;



public class OfficesListView extends ListActivity {
	
	
	@Override
	public void onCreate( Bundle savedInstance ) {
		
		super.onCreate( savedInstance );

		String names [] = getOfficeNames();
		setListAdapter( new ArrayAdapter<String>(this,R.layout.simple_list_item_1, names ));
		
		ListView lv = getListView();
		lv.setTextFilterEnabled(true);

		lv.setOnItemClickListener(new OnItemClickListener() {
		    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		      // When clicked, show a toast with the TextView text
		      Toast.makeText(getApplicationContext(), ((TextView) view).getText(),
		          Toast.LENGTH_SHORT).show();
		    }
	    });
	}
	
	private String[] getOfficeNames() {
		ArrayList<String> names = new ArrayList<String>();
		for ( Office cur : OfficeModel.getAll() ) {
			names.add( cur.getName() );
		}
		String[] namesArray = new String[names.size()];
		return names.toArray(namesArray);
	}

}
