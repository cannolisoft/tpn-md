package com.tpnmd.view;

import java.util.ArrayList;
import java.util.List;

import android.R;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.tpnmd.office.Office;
import com.tpnmd.office.OfficeModel;

public class OfficesListView extends ListActivity {

	@Override
	public void onCreate(Bundle savedInstance) {

		super.onCreate(savedInstance);

		List<Object> items = getListItems();
		setListAdapter(new OfficesListAdapter(this, R.layout.simple_list_item_1, items));

		ListView lv = getListView();
		lv.setTextFilterEnabled(true);

		lv.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Office office = (Office) getListAdapter().getItem(position);
				
				Intent intent = new Intent(view.getContext(), OfficeView.class);
				intent.putExtra(Office.class.getName(), office);
				startActivity(intent);
			}
		});
	}
	
	private List<Object> getListItems() {
		ArrayList<Object> names = new ArrayList<Object>();

		names.add("Urgent Care");
		names.addAll(OfficeModel.getUrgentCare());

		names.add("Practices");
		names.addAll(OfficeModel.getPractices());

		return names;
	}


}
