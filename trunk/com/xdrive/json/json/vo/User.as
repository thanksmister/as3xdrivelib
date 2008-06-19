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
	 * Collection is a value object representing the XdriveAPIFileType.MemberObject.  
	 */
	 [Bindable]
	public class User
	{
		private var _username:String = null;
		private var _password:String = null;
		private var _email:String = null;
		private var _firstname:String = null;
		private var _lastname:String = null;
		private var _rootfolder:String = null;
		private var _session:String = null;
		private var _recoverytoken:String = null;
		private var _type:String = XdriveAPIFileTypes.MEMBER_OBJECT;
		private var _quotalimit:Number;
		private var _quotaavailable:Number;
		private var _quotaused:Number;
		private var _userseq:String = "";


		public function User(username : String = "", password : String = "")
		{
			_username = username;
			_password = password;
		}
		
		/**
		 * users login name.
		 * */
		public function get username() : String 
		{
			return _username;
		}
		
		/**
		* @private
		*/
		public function set username(uname : String) : void 
		{
			_username = uname;
		}
		
		/**
		 * Users login password.
		 * */
		public function get password() : String {
			return _password;
		}
		
		/**
		* @private
		*/
		public function set password(pword : String) : void 
		{
			_password = pword;
		}
		
		/**
		 * The session set after login.
		 * */
		public function get session() : String 
		{
			return _session;
		}
		
		/**
		* @private
		*/
		public function set session(id : String) : void 
		{
			_session = id;
		}
		
		/**
		 * The recovery token set after login.
		 * */
		public function get recoverytoken() : String 
		{
			return _recoverytoken;
		}
		
		/**
		* @private
		*/
		public function set recoverytoken(id : String) : void 
		{
			_recoverytoken = id;
		}
		
		/**
		 * The user's root folder id.
		 * */
		public function get rootfolder() : String 
		{
			return _rootfolder;
		}
		
		/**
		* @private
		*/
		public function set rootfolder(folder : String) : void 
		{
			_rootfolder = folder;
		}
		
		/**
		 * The user's first name.
		 * */
		public function get firstname() : String 
		{
			return _firstname;
		}
		
		/**
		* @private
		*/
		public function set firstname(fn : String) : void 
		{
			_firstname = fn;
		}
		
		/**
		 * The user's last name.
		 * */
		public function get lastname() : String 
		{
			return _lastname;
		}
		
		/**
		* @private
		*/
		public function set lastname(ln : String) : void 
		{
			_lastname = ln;
		}
		
		/**
		 * The user's email address.
		 * */
		public function get email() : String 
		{
			return _email;
		}
		
		/**
		* @private
		*/
		public function set email(e : String) : void 
		{
			_email = e;
		}
		
		/**
		 * The value object type.
		 * */
		public function get type() : String 
		{
			return _type;
		}
		
		/**
		* @private
		*/
		public function set type(t : String) : void 
		{
			_type = t;
		}
		
		/**
		 * The total amount of storage space for the user.
		 * */
		public function get quotalimit() : Number 
		{
			return _quotalimit;
		}
		
		/**
		* @private
		*/
		public function set quotalimit(q : Number) : void 
		{
			_quotalimit = q;
		}
		
		/**
		 * The amount of available storage space for the user.
		 * */
		public function get quotaavailable() : Number 
		{
			return _quotaavailable;
		}
		
		/**
		* @private
		*/
		public function set quotaavailable(q : Number) : void 
		{
			_quotaavailable = q;
		}
		
		/**
		 * The amount of used storage space for the user.
		 * */
		public function get quotaused() : Number 
		{
			return _quotaused;
		}
		
		/**
		* @private
		*/
		public function set quotaused(q : Number) : void 
		{
			_quotaused = q;
		}
		
		/**
		 * The user seq id.
		 * */
		public function get userseq() : String 
		{
			return _userseq;
		}
		
		/**
		* @private
		*/
		public function set userseq(seq : String) : void 
		{
			_userseq = seq;
		}
	
	}
}