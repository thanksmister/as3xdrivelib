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
	import mx.collections.ArrayCollection;
	
	/**
	 * Share is a value object representing a Share object for sharing files with users and permissions.  
	 */
	 [Bindable]
	public class Share
	{
		private var _subject:String = "";
		private var _message:String = "";
		private var _email:ArrayCollection = new ArrayCollection();
		private var _read:Boolean = true;
		private var _write:Boolean = false;
		private var _create:Boolean = false;
		private var _modify:Boolean = false;
		private var _delete:Boolean = false;
		private var _share:Boolean = false;
	
		/**
	 	 * Clones the VO object to break binding.
	 	 * 
	 	 * @return Share
	 	 */
		public function clone() : Share
		{
			var clone:Share = new Share();
			clone.email = this.email;
			clone.message = this.message;
			clone.email = this.email;
			clone.write = this.write;
			clone.create = this.create;
			clone.modify = this.modify;
			clone.deletion = this.deletion;
			clone.share = this.share;
			return clone;
		}	
		
		/**
		 * The mail subject.
		 * */
		public function get subject():String
		{
			return _subject;
		}
		
		/**
		* @private
		*/
		public function set subject(sbj:String):void
		{
			_subject = sbj;
		}
		
		/**
		 * The mail message.
		 * */
		public function get message():String
		{
			return _message;
		}
		
		/**
		* @private
		*/
		public function set message(msg:String):void
		{
			_message = msg;
		}

		/**
		 * The list of <code>Contact</code> objects to send email to.
		 * */
		public function get email():ArrayCollection
		{
			return _email;
		}
		
		/**
		* @private
		*/
		public function set email(ac:ArrayCollection):void
		{
			_email = ac;
		}
		
		/**
		 * Returns <code>true</code> if the contact has read permission.
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
		 * Returns <code>true</code> if the contact has write permission.
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
		 * Returns <code>true</code> if the contact has create permission.
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
		 * Returns <code>true</code> if the contact has modify permission.
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
		 * Returns <code>true</code> if the contact has share permission.
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
		 * Returns <code>true</code> if the contact has deletion permission.
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