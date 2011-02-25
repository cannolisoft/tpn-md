package com.tpnmd.view;

import java.util.ArrayList;

import android.R;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.tpnmd.office.Office;
import com.tpnmd.office.OfficeModel;

public class OfficesListView extends ListActivity {

	@Override
	public void onCreate(Bundle savedInstance) {

		super.onCreate(savedInstance);

		String names[] = getOfficeNames();
		setListAdapter(new ArrayAdapter<String>(this,
				R.layout.simple_list_item_1, names));

		ListView lv = getListView();
		lv.setTextFilterEnabled(true);

		lv.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				OfficeModel.setSelected(position);
				Intent intent = new Intent(view.getContext(), OfficeView.class);
				startActivity(intent);
			}
		});
	}

	private String[] getOfficeNames() {
		ArrayList<String> names = new ArrayList<String>();
		for (Office cur : OfficeModel.getAll()) {
			names.add(cur.getName());
		}
		String[] namesArray = new String[names.size()];
		return names.toArray(namesArray);
	}

}
