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

package com.xdrive.json
{
	/**
	 * The XdriveAPIFileTypes class contains a list of Xdrive JSON API file types.
	 * */
	public class XdriveAPIFileTypes
	{
		/** File or Folder object */
		public static const FILE_OBJECT:String = "FileObject";
		
		/** Collection object*/
		public static const COLLECTION_OBJECT:String = "CollectionObject";
		
		/** Show object*/
		public static const SHOW_OBJECT:String = "CollectionShowObject";
		
		/** Contact object */
		public static const CONTACT_OBJECT:String = "ContactObject";
		
		/** Contact object */
		public static const CREATE_MODE_OBJECT:String = "CreateModeObject";
		
		/** Group object */
		public static const GROUP_OBJECT:String = "GroupObject";
		
		/** Share Permission object */
		public static const SHARE_PERMISSION_OBJECT:String	 = "SharePermissionObject";
		
		/** Member object */
		public static const MEMBER_OBJECT:String = "MemberObject";
		
		/** Mail message object */
		public static const MAIL_MESSAGE_OBJECT:String = "MailMessageObject";
		
		/** Bye unit object */
		public static const BYTES_UNIT_OBJECT:String = "BytesUnitObject";
		
		/** Status object */
		public static const STATUS_OBJECT:String = "StatusObject";

		public function XdriveAPIFileTypes() 
		{
		}
		
	}
}