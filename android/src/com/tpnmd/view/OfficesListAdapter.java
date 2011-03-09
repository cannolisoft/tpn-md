package com.tpnmd.view;

import java.util.List;

import com.tpnmd.R;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class OfficesListAdapter extends ArrayAdapter<Object> {

	public OfficesListAdapter(Context context, int resource,
			int textViewResourceId, List<Object> objects) {
		super(context, resource, textViewResourceId, objects);
	}

	public OfficesListAdapter(Context context, int resource,
			int textViewResourceId, Object[] objects) {
		super(context, resource, textViewResourceId, objects);
	}

	public OfficesListAdapter(Context context, int resource,
			int textViewResourceId) {
		super(context, resource, textViewResourceId);
	}

	public OfficesListAdapter(Context context, int textViewResourceId,
			List<Object> objects) {
		super(context, textViewResourceId, objects);
	}

	public OfficesListAdapter(Context context, int textViewResourceId,
			Object[] objects) {
		super(context, textViewResourceId, objects);
	}

	public OfficesListAdapter(Context context, int textViewResourceId) {
		super(context, textViewResourceId);
	}

	/**
	 * @see android.widget.BaseAdapter#getView(int, View, ViewGroup)
	 */
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final Object item = this.getItem(position);
		if(isHeaderItem(item)) {
			TextView view = (TextView)convertView;
			if(view == null) {
				Context ctx = this.getContext();
				LayoutInflater li = (LayoutInflater)ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				view = (TextView)li.inflate(R.layout.header, null);
			}
			view.setText(item.toString());
			return view;
		}
		return super.getView(position, convertView, parent);
	}

	/**
	 * @category BaseAdapter
	 * 
	 * @see android.widget.BaseAdapter#areAllItemsEnabled()
	 */
	@Override
	public boolean areAllItemsEnabled() {
		return false;
	}


	/**
	 * @category BaseAdapter
	 *  
	 * @see android.widget.BaseAdapter#isEnabled(int)
	 */
	@Override
	public boolean isEnabled(int position) {
		final Object item = getItem(position);
		return !isHeaderItem(item);
	}

	
	/**
	 * @see android.widget.BaseAdapter#getItemViewType(int)
	 */
	@Override
	public int getItemViewType(int position) {
		final Object item = this.getItem(position);
		if(isHeaderItem(item)){
			return 0;
		}
		return 1;
	}

	/**
	 * @see android.widget.BaseAdapter#getViewTypeCount()
	 */
	@Override
	public int getViewTypeCount() {
		return 2;
	}
	
	
	private boolean isHeaderItem(Object item) {
		if(item instanceof String){
			return true;
		}
		return false;
	}
	
}
