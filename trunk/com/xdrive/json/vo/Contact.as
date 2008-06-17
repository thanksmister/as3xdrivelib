/*
Copyright (C) 2008 AOL Xdrive

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Author: Michael Ritchie, Senior Flex Architect
        michael.ritchie@corp.aol.com
        
@ignore
*/

package com.xdrive.json.vo
{
	import com.xdrive.json.XdriveAPIFileTypes;
	
	/**
	 * Collection is a value object representing the XdriveAPIFileType.ContactObject type.  
	 */
	 [Bindable]
	public class Contact
	{
		private var _firstname:String = "";
		private var _lastname:String = "";
		private var _nickname:String = "";
		private var _fileid:String = "";
		private var _type:String = XdriveAPIFileTypes.CONTACT_OBJECT;
		private var _email:String = "";

		public function Contact()
		{
		}
		
		/**
	 	 * Clones the VO object to break binding.
	 	 * 
	 	 * @return Share
	 	 */
		public function clone() : Contact
		{
			var clone:Contact = new Contact();
				clone.fileid = this.fileid;
				clone.firstname = this.firstname;
				clone.lastname = this.lastname;
				clone.type = this.type;
				clone.nickname = this.nickname;
				clone.email = this.email;
			return clone;
		}	
		
		/**
	 	 * Convert collection object to string for tracing
	 	 * 
	 	 * @return String
	 	 */
		public function toString() : String
		{
			var str:String = "\nFirst Name: " + this.firstname;
			str += "Last Name: " + this.lastname + "\n";
			str += "Email: " + this.email + "\n";
			str += "ID: " + this.fileid + "\n";
			return str;
		}	
		
		/**
		 * Gets first name of the contact.
		 * */
		public function get firstname() : String 
		{
			return _firstname;
		}
		
		/**
		* @private
		*/
		public function set firstname(name : String) : void 
		{
			_firstname = name;
		}
		
		/**
		 * Gets last name of the contact.
		 * */
		public function get lastname() : String 
		{
			return _lastname;
		}
		
		/**
		* @private
		*/
		public function set lastname(name : String) : void 
		{
			_lastname = name;
		}
		
		/**
		 * Gets id of the contact.
		 * */
		public function get fileid() : String 
		{
			return _fileid;
		}
		
		/**
		* @private
		*/
		public function set fileid(id : String) : void 
		{
			_fileid = id;
		}
		
		/**
		 * Gets type for the contact contact.
		 * */
		public function get type() : String 
		{
			return _type;
		}
		
		/**
		* @private
		*/
		public function set type(t :  String) : void 
		{
			_type = t;
		}
		
		/**
		 * Gets nickname of the contact.
		 * */
		public function get nickname() : String 
		{
			return _nickname;
		}
		
		/**
		* @private
		*/
		public function set nickname(name : String) : void 
		{
			_nickname = name;
		}
		
		/**
		 * Gets email address of the contact.
		 * */
		public function get email() : String 
		{
			return _email;
		}
		
		/**
		* @private
		*/
		public function set email(address : String) : void 
		{
			_email = address;
		}
	}
}