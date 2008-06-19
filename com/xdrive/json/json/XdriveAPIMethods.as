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
	 * The XdriveAPIFileTypes class contains a list of Xdrive JSON API methods.
	 * */
	public class XdriveAPIMethods
	{
		/** Login user */
		public static const MEMBER_LOGIN:String = "member.login";
		
		/** Logout user */
		public static const MEMBER_LOGOUT:String = "member.logout";
		
		/** Get user quota */
		public static const MEMBER_GETQUOTA:String = "member.getquota";
		
		/** Refresh user session */
		public static const MEMBER_REFRESHSESSION:String = "member.refreshsession";
		
		/** Get file listing */
		public static const FILE_GETLISTING:String = "file.getlisting";
		
		/** Create new file */
		public static const FILE_CREATE:String = "file.create";
		
		/** Publish a file */
		public static const FILE_PUBLISH:String = "file.publish";
		
		/** Unpublish a file */
		public static const FILE_UNPUBLISH:String = "file.unpublish";
		
		/** Create new folder */
		public static const FILE_NEWFOLDER:String = "file.newfolder";
		
		/** Move file */
		public static const FILE_MOVE:String = "file.move"; 
		
		/** Reindex a file */
		public static const FILE_REINDEX:String = "file.reindex"; 
		
		/** Modify asset */
		public static const ASSET_MODIFY:String = "asset.modify";
		
		/** Delete asset */
		public static const ASSET_DELETE:String = "asset.delete";
		
		/** Remove asset */
		public static const ASSET_REMOVE:String = "asset.remove";
		
		/** Get Asset with parent id and name */
		public static const ASSET_GET:String = "asset.get";
		
		/** Get collection listing */
		public static const COLLECTION_GETLISTING:String = "collection.getlisting";
		
		/** Save collection */
		public static const COLLECTION_SAVE:String = "collection.save";
		
		/** Create new collection */
		public static const COLLECTION_NEW:String = "collection.new";
		
		/** Duplicate collection */
		public static const COLLECTION_DUPLICATE:String = "collection.duplicate";
		
		/** Get share information for file */
		public static const SHARE_LISTOUTBOUNDSHARES:String = "share.listoutboundshares";
		
		/** Grant share permissions */
		public static const SHARE_GRANTPERMISSION:String = "share.grantpermission";
		
		/** Revoke share permissions */
		public static const SHARE_REVOKEPERMISSION:String = "share.revokepermission";
		
		/** Unmap folder */
		public static const SHARE_UNMAPFOLDER:String = "share.unmapfolder";
		
		/** Get AOL Mail listing */
		public static const CONTACT_GETAOLLISTING:String = "contact.getaollisting";
		
		/** Add new AOL Mail contact */
		public static const CONTACT_NEWAOLCONTACT:String = "contact.newaolcontact";
		
		/** Send feedback email */
		public static const MAIL_SENDFEEDBACK:String = "mail.sendfeedback";
		
		/** Send assets as email share */
		public static const MAIL_SENDASSETS:String = "mail.sendassets";
		
		/** Get query status for file upload */
		public static const IO_QUERYSTATUS:String = "io.querystatus";
		
		/** Get small thumbnail for media */
		public static const IO_THUMBNAILSMALL:String = "io.thumbnailsmall";
		
		/** Get medium thumbnail for media */
		public static const IO_THUMBNAILMEDIUM:String = "io.thumbnailmedium";
		
		/** Get large thumbnail for media */
		public static const IO_THUMBNAILLARGE:String = "io.thumbnaillarge";
		
		/** Get the orignal media */
		public static const IO_VIEW:String = "io.view";
		
		/** Download file */
		public static const IO_DOWNLOAD:String = "io.download";
		
		/** Download zip */
		public static const IO_ZIPDOWNLOAD:String = "io.zipdownload";
		
		/** Download zip */
		public static const IO_ZIPUPLOAD:String = "io.zipupload";
		
		/** Download file */
		public static const IO_OPEN:String = "io.open";
		
		/** Download file */
		public static const IO_CLOSE:String = "io.close";
		
		/** Download file */
		public static const IO_WRIE:String = "io.write";
		
		/** Download file */
		public static const IO_UPLOAD:String = "io.upload";
		
		/** Download file */
		public static const IO_FORMUPLOAD:String = "io.formupload";
		
		public function XdriveAPIMethods() 
		{
		}
	}
}