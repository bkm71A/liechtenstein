package com.incheck.common
{
	[Bindable]
	public class Delivery
	{
		private var _id : int;
		private var _name : String;
		private var _email : String;
		private var _notes : String;
		
		public function Delivery(id : int, name : String, email : String, notes : String) {
			_id = id;
			_name = name;
			_email = email;
			_notes = notes;
		} 
		
		public function set id(value : int) : void {
			_id = value;
		}
		
		public function get id () : int {
			return _id
		}
		
		public function set name(value : String) : void {
			_name = value;
		}
		
		public function get name () : String {
			return _name
		}
		
		public function set email(value : String) : void {
			_email = value;
		}
		
		public function get email () : String {
			return _email
		}

		public function set notes(value : String) : void {
			_notes = value;
		}
		
		public function get notes () : String {
			return _notes
		}
	}
}