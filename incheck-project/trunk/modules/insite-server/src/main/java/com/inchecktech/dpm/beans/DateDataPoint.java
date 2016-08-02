package com.inchecktech.dpm.beans;

import java.io.Serializable;
import java.util.Date;

public class DateDataPoint implements Serializable{

		private static final long serialVersionUID = 1L;
		public float y;
		public Date x;
		public DateDataPoint(Date x,float y) {
			this.x=x;
			this.y=y;

		}

}
