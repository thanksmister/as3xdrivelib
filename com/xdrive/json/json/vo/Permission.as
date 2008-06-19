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

package com.xdrive.json.vo
{
	import com.xdrive.json.XdriveAPIFileTypes;
	
	/**
	 * Permission is a value object representing the XdriveAPIFileType.SharePermissionObject type.  
	 */
	 [Bindable]
	public class Permission
	{
		private var _fileid:String = "";
		private var _type:String = XdriveAPIFileTypes.SHARE_PERMISSION_OBJECT;
		private var _grantor:Contact = new Contact();
		private var _grantee:Contact = new Contact();
		private var _grantdate:Date = new Date();
		private var _read:Boolean = false;
		private var _write:Boolean = false;
		private var _create:Boolean = false;
		private var _modify:Boolean = false;
		private var _delete:Boolean = false;
		private var _share:Boolean = false;

		public function Permission()
		{
		}
		
		/**
	 	 * Clones the VO object to break binding.
	 	 * 
	 	 * @return Folder
	 	 */
		public function clone() : Permission
		{
			var clone:Permission = new Permission();
				clone.fileid = this.fileid;
				clone.type = this.type;
				clone.grantor = this.grantor;
				clone.grantee = this.grantee;
				clone.grantdate = this.grantdate;
				clone.read = this.read;
				clone.write = this.write;
				clone.create = this.create;
				clone.modify = this.modify;
				clone.share = this.share;
				clone.deletion = this.deletion;
			return clone;
		}	
		
		/**
		 * The file name.
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
		 * The type for the folder.
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
		 * The <code>Contact</code> who is giving permission.
		 * */
		public function get grantor() : Contact 
		{
			return _grantor;
		}
		
		/**
		* @private
		*/
		public function set grantor(co : Contact) : void 
		{
			_grantor = co;
		}
		
		/**
		 * The <code>Contact</code> who being given permission.
		 * */
		public function get grantee() : Contact 
		{
			return _grantee;
		}
		
		/**
		* @private
		*/
		public function set grantee(co : Contact) : void 
		{
			_grantee = co;
		}
		
		/**
		 * The date the asset was granted permission.
		 * */
		public function get grantdate() : Date 
		{
			return _grantdate;
		}
		
		/**
		* @private
		*/
		public function set grantdate(date :  Date) : void 
		{
			_grantdate = date;
		}
				
		/**
		 * Returns <code>true</code> if the grantee has read permission.
		 * */
		public function get read():Boolean
		{
			return _read;
		}
		
		/**
		* @private
		*/
		public function set read(b:Boolean):void
		{
			_read = b;
		}

		/**
		 * Returns <code>true</code> if the grantee has write permission.
		 * */
		public function get write():Boolean
		{
			return _write;
		}
		
		/**
		* @private
		*/
		public function set write(b:Boolean):void
		{
			_write = b;
		}
		
		/**
		 * Returns <code>true</code> if the grantee has create permission.
		 * */
		public function get create():Boolean
		{
			return _create;
		}
		
		/**
		* @private
		*/
		public function set create(b:Boolean):void
		{
			_create = b;
		}
		
		/**
		 * Returns <code>true</code> if the grantee has modify permission.
		 * */
		public function get modify():Boolean
		{
			return _modify;
		}
		
		/**
		* @private
		*/
		public function set modify(b:Boolean):void
		{
			_modify = b;
		}
		
		/**
		 * Returns <code>true</code> if the grantee has share permission.
		 * */
		public function get share():Boolean
		{
			return _share;
		}
		
		/**
		* @private
		*/
		public function set share(b:Boolean):void
		{
			_share = b;
		}
		
		/**
		 * Returns <code>true</code> if the grantee has deletion permission.
		 * */
		public function get deletion():Boolean
		{
			return _delete;
		}
		
		/**
		* @private
		*/
		public function set deletion(b:Boolean):void
		{
			_delete = b;
		}
		
		
	}
}