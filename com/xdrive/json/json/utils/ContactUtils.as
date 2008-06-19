/*
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
        michael.ritchie@gmail.com
*/
package com.xdrive.json.utils
{
	import com.xdrive.json.XdriveAPIFileTypes;
	import com.xdrive.json.vo.Contact;
	import mx.collections.ArrayCollection;				

	public class ContactUtils
	{
		public function ContactUtils()
		{
		}
		
		/**
		 * Returns list of contacts.
		 * 
		 * @param obj The children of a contact.
		 * 
		 * @return ArrayCollection
		 * */
		public static function createContacts(obj:Object):ArrayCollection
		{
			var temp:ArrayCollection = new ArrayCollection();
			
			for(var i:Object in obj){
				try {
					if(obj[i].type == XdriveAPIFileTypes.CONTACT_OBJECT){
						var contact:Contact = buildContact(obj[i]);
						temp.addItem(contact);
					}
				} catch(e:Error) {trace("Contact creation error: " + e.message)};
			}
			return temp;
		}
		
		/**
		 * Contructs a contact value object from an JSON object.
		 * 
		 * @param obj The returned JSON deserialized object.
		 * 
		 * @return Contact
		 * */
		public static function buildContact(obj:Object):Contact
		{
			var contact:Contact = new Contact();
			
			if(obj.firstname != null) contact.firstname = obj.firstname;
			if(obj.lastname != null) contact.lastname = obj.lastname;
			if(obj.email != null) contact.email = obj.email;
			if(obj.id != null) contact.fileid = obj.id;
			//if(obj.type != null) contact.type = obj.type;
		
			// if we have a private name, then we replace with email
			if(contact.firstname.toLowerCase() == "::private::"){
				contact.firstname = "";
				contact.lastname = "";
			} 
			
			return contact
		}
		
	}
}