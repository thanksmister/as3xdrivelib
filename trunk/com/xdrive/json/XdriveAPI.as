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
	import com.adobe.serialization.json.JSON;
	import com.xdrive.json.utils.CollectionUtils;
	import com.xdrive.json.utils.ContactUtils;
	import com.xdrive.json.utils.DateUtils;
	import com.xdrive.json.utils.FileUtils;
	import com.xdrive.json.utils.FolderUtils;
	import com.xdrive.json.vo.Collection;
	import com.xdrive.json.vo.Contact;
	import com.xdrive.json.vo.Folder;
	import com.xdrive.json.vo.Media;
	import com.xdrive.json.vo.Permission;
	import com.xdrive.json.vo.Share;
	import com.xdrive.json.vo.User;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * The XdriveAPI class abstracts the Xdrive JSON API found at <a href='http://dev.aol.com/xdrive'>http://dev.aol.com/xdrive</a>.
	 * <p>
	 * XdriveAPI is the helper class for accessing the Open Xdrive API. It provides much of the client-side 
	 * functionality for applications; for example, logging in and out, uploading files, sharing files, and basic
	 * file management. These functions build the requests with the appropriate JSON payload and decode the responses.
	 * </p>
	 */
	public class XdriveAPI
	{
		/**
		 * Private variable that we provide read-only access to
		 */
		
		/**
		 *	The main domain URL for Xdrive.com.
		 */
		public static var BASE_URL:String = "http://plus.xdrive.com/";
		
		/**
		 * The the URL to the open pubish channel server, the public Xdrive server
		 * for RSS feeds and assets. RSS feeds can be accessed from the OPC server
		 * when a folder or collection is published.  
		 * 
		 * Publishing a <code>Folder</code> or <code>Collection</code> will produce a 
		 * RSS feed that can be consumed by a RSS reader or any other type of 
		 * application capable of parcing XML. 
		 * 
		 * This server has an open cross domain policy file so Flash/Flex/AIR applications
		 * can consume resources without encountering security sandbox violation issue.
		 */
		public static var OPC_URL:String = "http://public.xdrive.com/";
		
		/**
		 * This is the end point for the secure service that we talk to.  This end point
		 * is used to do secure login.  Once you login with this service, subsequent calls
		 * will use the regulr service end point.
		 */
		public static var JSON_LOGIN_END_POINT:String = "https://plus.xdrive.com/json/v1.2/";
		 
		/**
		 *	This is the end point for the service that we talk to, it is not secure.
		 */
		public static var JSON_END_POINT:String = "http://plus.xdrive.com/json/v1.2/";
		
		/**
		 *	 A JSESSIONID cookie will be set, but for those clients with no cookie support the jsessionid
		 *   can be sent in the URL with each request. The jessonid is appended to all calls for 
		 *   cookie-less client calls.
		 */
		private static var JESSESSION_ID:String = "";
		
		/**
		 *	Represents a token that will allow the user's session to be remade if he/she bounces servers. 
		 *  When logging in the user is granted a secure session, but subsequent non-secure calls receive 
		 *  a new non-secure session that is no longer authenticated. The value of the XDRecTok is used 
		 *  in this case to rebuild the user's session. The recovery token is used if the session is 
		 *  is timed from the server (usually 20 minutes).
		 */
		private static var RECOVERY_TOKEN:String = "";
		
		/**
		 * Used to value to format the receipient email for Xdrive.
		 * @private  
		 */
		public static var IS_XDRIVE_API:Boolean = true;
		
		/**
		 * Xdrive API constructor. Note that the user must have registered with Xdrive account
		 * and will need to the username and password to continue.
		 * */
		public function XdriveAPI()
		{
		}
		
		/**
		 * This method logs the member in and returns his information. 
		 * It uses the OpenAuth API (<a href='http://dev.aol.com/OpenAuth'>http://dev.aol.com/OpenAuth</a>) in the server to log the user in.
		 * Two cookies will be set when the user logs in. For cookie-less clients, both the jsessionid 
		 * and recoveryToken can be sent in the request URL.
		 * 
		 * @param user <code>User</code> to login
		 * 
		 * @return A value of <code>User</code> on the token and the payload value of the event
		 */
		public function login(user : User) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.username =  user.username;
				dataObject.password =  user.password;
				dataObject.type = user.type;
	
			var loginObject:Object = new Object();
				loginObject.user = dataObject;
				
			var dataString:String = JSON.encode(loginObject);
			
			
			var urlRequest : URLRequest = createRequest(JSON_LOGIN_END_POINT, XdriveAPIMethods.MEMBER_LOGIN, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null); // token returned to applicaton layer
			var token : XdriveAPIToken = makeRequest(urlRequest)
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void {
						user.firstname = event.payload.user.firstname;
						user.lastname = event.payload.user.lastname;
						user.username = event.payload.user.username;
						user.email = event.payload.user.email;
						user.session = event.payload.jsessionid;
						
						user.recoverytoken = event.payload.recoveryToken;
						user.rootfolder = event.payload.user.rootFolderId;
					
						XdriveAPI.RECOVERY_TOKEN = user.recoverytoken; // set recovery token once
						XdriveAPI.JESSESSION_ID = user.session; // set session to secure cookie
						
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"user":user}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, {"user":user}, null, event.error));
					});
					
				returntoken.user = user;
			return returntoken;
		}
		
		/**
		 * This method invalidates the users session, essentially loggin the user out of the API.
		 * 
		 * @param user <code>User</code> to log out
		 * 
		 * @retutn A value of <code>User</code> on the token and the payload value of the event
		 */
		public function logout(user : User) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
			var dataString:String = JSON.encode(dataObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.MEMBER_LOGOUT, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void {
						user = new User ();
						XdriveAPI.RECOVERY_TOKEN = ""; //reset recovery token or user will never be logged out
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"user":user}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, {"user":user}, null, event.error));
					});
					
			returntoken.user = user;
			return returntoken;
		}
		
		/**
		 * This method returns the user's account quota information.
		 * 
		 * <p>Quota information sets the following values for a <code>User</code>: <code>quotaavailable</code> for 
		 * available space, <code>quotalimit</code> for maximum space of the account, and <code>quotaused</code>
		 * for the amount of uses space for the account.</p>
		 * 
		 * @param user <code>User</code> to retrieve account information for
		 * 
		 * @retutn A value of <code>User</code> on the token and the payload value of the event
		 */
		public function getQuota(user : User) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
			var dataString:String = JSON.encode(dataObject);		
			
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.MEMBER_GETQUOTA, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null); // token returned to applicaton layer
			var token : XdriveAPIToken = makeRequest(urlRequest);
			token.addEventListener(XdriveAPIEvent.API_RESULT,
				function(event : XdriveAPIEvent) : void { 
					if(event.payload.jsessionid != null)
						user.session = event.payload.jsessionid; // set non-secure jsessionid
					if(event.payload.quota.available != null)
						user.quotaavailable = Number(event.payload.quota.available)*1024;
					if(event.payload.quota.limit != null)
						user.quotalimit = Number(event.payload.quota.limit)*1024;
					if(event.payload.quota.used != null)
						user.quotaused = Number(event.payload.quota.used)*1024;
					if(event.payload.quota.userSeq != null)
						user.userseq = event.payload.quota.userSeq;
	
					returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"user":user}, null, null));
				});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, {"user":user}, null, event.error));
					});

			returntoken.user = user;
			return returntoken;
		}
		
		/**
		 * This method returns the contents of the <code>Folder</code> specified or the root ("My Xdrive") folder if no folder id is specified. 
		 * 
		 * @param folder <code>Folder</code> to retrieve file listing of
		 * 
		 * @return A value of <code>Folder</code> on the token and the payload value of the event
		 */
		public function getFileListing(folder : Folder) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = folder.type;
				dataObject.id = folder.fileid;
	
			var srcFile:Object = new Object();
				srcFile.srcFile = dataObject;

			var dataString:String = JSON.encode(srcFile);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_GETLISTING, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null); // token returned to applicaton layer
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						folder = FolderUtils.buildFolder(folder, JSON_END_POINT, event.payload.srcFile);
						folder.children = FolderUtils.createFolderChildren(JSON_END_POINT,event.payload.children);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folder":folder}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.folder = folder;
			return returntoken;
		}
		
		/**
		 * This method creates a new <code>Folder</code> in the specified destination <code>Folder</code>. 
		 * If the specified destination <code>Folder</code> id is blank the the new <code>Folder</code> is created in the root ("My Xdrive") location.
		 * 
		 * @param folder <code>Folder</code> to create with file name field set (don't leave the filename blank)
		 * @param parentid The id of the parent <code>Folder</code>
		 * @param renamecollision Boolean value when true will rename folder to <code>Folder(n)</code>, error will be thrown if true and a <code>Folder</code> exists with same name
		 * 
		 * @return A value of <code>Folder</code> on the token and the payload value of the event
		 */
		public function createFolder(folder : Folder, parentid:String = "", renamecollision:Boolean = true) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = parentid;
			
			var nameObject:Object = new Object();
				nameObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				nameObject.filename = folder.filename;
				
			var createModeObject:Object = new Object();
				createModeObject.type = XdriveAPIFileTypes.CREATE_MODE_OBJECT;
				createModeObject.renameOnCollision = renamecollision;
						
			var newFolder:Object = new Object();
				newFolder.destFolder = dataObject;
				newFolder.filename = nameObject;
				newFolder.createMode = createModeObject;
		  	
		  	var dataString:String = JSON.encode(newFolder);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_NEWFOLDER, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null); 
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						folder = FolderUtils.buildFolder(folder, JSON_END_POINT, event.payload.created);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folder":folder}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
			returntoken.folder = folder;
			return returntoken;
		}
		
		/**
		 * Refreshes the server side cache fro the provided <code>Folder</code>.
		 * 
		 * @param folder <code>Folder</code> to refresh
		 * 
		 * @return A value of <code>Folder</code> on the token and the payload value of the event
		 */
		public function refreshFolder(folder : Folder) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = folder.fileid;
				
			var srcFile:Object = new Object();
				srcFile.srcFile = dataObject;

		  	var dataString:String = JSON.encode(srcFile);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_REINDEX, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null); 
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folder":folder}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});		
					
			returntoken.folder = folder;
			return returntoken;
		}
		
		/**
		 * Grants permissions on <code>Folder</code> or <code>Collection</code> objects to other users. 
		 * 
		 * The shared <code>Folder</code> objects will be "mapped" into the grantee's accounts.  
		 * If the user is sharing a <code>Colletion</code>, it will be mapped under the "My Collections" 
		 * folder, otherwise, it will be mapped under the root directory. 
		 * 
		 * @param folders Array of <code>Folder</code> or <code>Collection</code> objects to to share
		 * @param share <code>Share</code> value object containing the addressees and the permissions to set for the <code>Folder</code> objects being shared
		 * @param isPrivate Optional boolean value to send as private share or public share (public share is published)
		 * 
		 * @return An value of folders on the token and the payload value of the event which is an array of <code>Folder</code> objects
		 */
		public function grantPermissions(folders : Array, share : Share, isPrivate : Boolean = false) : XdriveAPIToken
		{
			var permissionObject:Object = new Object();
				permissionObject.type = XdriveAPIFileTypes.SHARE_PERMISSION_OBJECT;
				permissionObject.hasRead = share.read;
				permissionObject.hasWrite = share.write;
				permissionObject.hasDelete = share.deletion;
				permissionObject.hasCreate = share.create;
				permissionObject.hasModify = share.modify;
				permissionObject.hasShare = share.share;
				
			var dataObject:Object = new Object();
				dataObject.permissions = permissionObject;
			
			var grantArray:Array = new Array();
			
			for each (var asset:Object in folders) {
				var toGrantObject:Object = new Object ();
					toGrantObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					toGrantObject.id = asset.fileid;
					
				grantArray.push(toGrantObject);
			}
			
			dataObject.toGrant = grantArray;
			
			var granteesArray:Array = new Array();
			
			for each (var co:Contact in share.email) {
				var granteeObject:Object = new Object ();
					granteeObject.type = XdriveAPIFileTypes.CONTACT_OBJECT;
					granteeObject.email = co.email;
					
				granteesArray.push(granteeObject);
			}
			
			dataObject.grantees = granteesArray;
			
			var messageObject:Object = new Object();
				messageObject.type = XdriveAPIFileTypes.MAIL_MESSAGE_OBJECT;
				messageObject.subject = share.subject;
				messageObject.message = share.message;
			
			dataObject.mailMessage = messageObject;
			
			var optionsObject:Object = new Object();
				optionsObject.publish = !isPrivate;
				optionsObject.bsemail = !IS_XDRIVE_API; // tells is to send Bluestring or Xdrive email format
				
			dataObject.options = optionsObject;
			
			var dataString:String = JSON.encode(dataObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.ASSET_DELETE, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						for each (var folder:Object in folders) {
							folder.isshared = true;
						}
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folders":folders}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.folders = folders;
			return returntoken;
		}
		
		/**
		 * Revoke permission to for a shared asset.
		 * 
		 * @param asset <code>Folder</code> or <code>Collection</code> to revoke permissions for
		 * 
		 * @return A value of asset on the token and the payload value of the event which is either a <code>Folder</code> or <code>Collection</code> object
		 */
		public function revokePermissions(asset : Object) : XdriveAPIToken
		{
			var permissionObject:Object = new Object();
				permissionObject.type = XdriveAPIFileTypes.SHARE_PERMISSION_OBJECT;
				permissionObject.id = asset.fileid;
				
			var temp:Array = new Array ();
				temp.push(permissionObject);

			var dataObject:Object = new Object();
				dataObject.permissions = temp;
				
			var dataString:String = JSON.encode(dataObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.SHARE_REVOKEPERMISSION, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						asset.isshared = false;
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folder":asset}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});	
					
			returntoken.asset = asset;
			return returntoken;
		}
		
		/**
		 * Unmaps Array of <code>Folder</code> objects that have been mapped to another users account.
		 * 
		 * @param folders Array of <code>Folder</code> objects to unmap
		 * 
		 * @return A value of folders on the token and the payload value of the event which is an array of <code>Folder</code> objects
		 */
		public function unmapFolders(folders : Array) : XdriveAPIToken
		{
			var arry:Array = new Array();
			
			for each (var folder:Object in folders) {
				var dataObject:Object = new Object();
				 	dataObject.type = folder.type;
				 	dataObject.id = folder.fileid;
				 
				arry.push(dataObject);
			}
			
			var objects:Object = new Object();
				objects.toUnmap = arry;
			
			var dataString:String = JSON.encode(objects);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.SHARE_UNMAPFOLDER, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						for each (var asset:Object in folders){
							asset.isshared = false;
						}
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folders":folders}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				returntoken.folders = folders;
				
			return returntoken;
		}
		
		/**
		 * Get listing of the outbound shares for an <code>Folder</code> or <code>Collection</code>. 
		 * 
		 * <p>Outbound shares represent a rostered list of users the <code>Folder</code> or <code>Collection</code> was shared with. 
		 * This list will be an ArrayCollection of <code>Permission</code> objects. </p>
		 * 
		 * @param asset A <code>Folder</code> or <code>Collection</code> to list the sharing information for
		 * @param shares ArrayCollection to store the returned list of <code>Permission</code> objects
		 * 
		 * @return A value of shares on the token and the payload value of the event which is an ArrayCollection of <code>Permission</code> objects
		 */
		public function listOutboundShares(asset : Object, shares : ArrayCollection = null) : XdriveAPIToken
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = asset.fileid;
			
			var shareObject:Object = new Object();
				shareObject.srcFile = dataObject;
				
			var dataString:String = JSON.encode(shareObject);
			
			if(shares == null) shares = new ArrayCollection();

			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.SHARE_LISTOUTBOUNDSHARES, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						for each (var permissionObj:Object in event.payload.permissions){	
							try{
								var permission:Permission = new Permission();
									permission.fileid = permissionObj.id;
									permission.write = permissionObj.hasWrite;
									permission.read = permissionObj.hasRead;
									permission.write = permissionObj.hasWrite;
									permission.create = permissionObj.hasCreate;
									permission.share = permissionObj.hasShare;
									permission.modify = permissionObj.hasModify;
									permission.deletion = permissionObj.hasDelete;
								
								var grantor:Contact = new Contact();
									grantor.nickname = permissionObj.grantor.nickname;
									grantor.lastname = permissionObj.grantor.lastname;
									grantor.firstname = permissionObj.grantor.firstname;
									grantor.email = permissionObj.grantor.email;
									grantor.fileid = permissionObj.grantor.id;
									
								permission.grantor = grantor;
	
								var grantee:Contact = new Contact();
									grantee.nickname = permissionObj.grantee.nickname;
									grantee.lastname = permissionObj.grantee.lastname;
									grantee.firstname = permissionObj.grantee.firstname;
									grantee.email = permissionObj.grantee.email;
									grantee.fileid = permissionObj.grantee.id;
									
								permission.grantee = grantee; 
								permission.grantdate = DateUtils.formatDate(String(permissionObj.grantDate)); 
								
								shares.addItem(permission);
			
							} catch(e:Error){trace(e.message);}
						}
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.shares = shares;
			return returntoken;
		}
		
		/**
		 * Get collection listing returns a list of all the <code>Collection</code> objects. 
		 * By default the listing will contain only the following fields for the <code>Collection</code>:
		 * <p>fileid, filename, ismapped, isshared, icon, modified, created, and publishid</p>
		 * Set the fetchfullfields value to true to retrieve the full listing of <code>Collection</code>.
		 * 
		 * @param collection <code>Collection</code> to retrieve
		 * @param fetchfullfields Boolean value when set to true retrieves a scaled down or sparse listing for <code>Collection</code>, false returns whole listing
		 * 
		 * @return A value of <code>Collection</code> on the token and the payload value of the event
		 */
		public function getCollectionListing(collection : Collection, fetchfullfields:Boolean = false) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.COLLECTION_OBJECT;
				dataObject.id = collection.fileid;
				
			var optionsObject:Object = new Object();
				optionsObject.sparse = fetchfullfields;

			var collectionObject:Object = new Object();
				collectionObject.collection = dataObject;
				
			var paramsObject:Object = new Object();
				paramsObject.params = collectionObject;
				paramsObject.options = optionsObject;

			var dataString:String = JSON.encode(paramsObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.COLLECTION_GETLISTING, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void {  
						collection = CollectionUtils.buildCollection(collection, JSON_END_POINT, event.payload.srcCollection);
						collection.children = CollectionUtils.createCollectionChildren(JSON_END_POINT, event.payload.children);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"collection":collection}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.collection = collection;
			return returntoken;
		}
		
		/**
		 * Create a new <code>Collection</code> object.
		 * 
		 * @param collection <code>Collection</code> to create with <code>Collection.filename</code> set to new name
		 * 
		 * @return A value of <code>Collection</code> on the token and the payload value of the event
		 */
		public function createCollection(collection : Collection) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.COLLECTION_OBJECT;
				dataObject.filename = collection.filename;
				
			var optionsObject:Object = new Object();
				optionsObject.publish = true;

			var newCollection:Object = new Object();
				newCollection.collection = dataObject;

		  	var dataString:String = JSON.encode(newCollection);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.COLLECTION_NEW, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						collection = CollectionUtils.buildCollection(collection, JSON_END_POINT, event.payload.collection);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"collection":collection}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.collection = collection;
			return returntoken;
		}
		
		/**
		 * Updates the changes for an existing <code>Collection</code>.
		 * 
		 * @param collection <code>Collection</code> to be udpated
		 * @param publish Flag to auto publish show when updated
		 * @param savename Flag used to save name changes if true or not if false
		 * @param saveshow Flag used to save show changes if ture or not if false
		 * 
		 * @return A value of <code>Collection</code> on the token and the payload value of the event
		 */
		public function updateCollection(collection : Collection, publish:Boolean = false, savename:Boolean = true, saveshow:Boolean = true) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.COLLECTION_OBJECT;
				dataObject.id = collection.fileid;
				
			if(savename) dataObject.filename = collection.filename;
	
			if(saveshow) {
				var show:Object = new Object();
					show.type = XdriveAPIFileTypes.SHOW_OBJECT; 
					show.photos =  FileUtils.buildPhotoList(collection.children);
					show.music = FileUtils.buildMusicList(collection.children);
					show.transitionCode = collection.transition;
					show.rate = collection.rate;	
				dataObject.show = show;	
			}
			
			var optionsObject:Object = new Object();
				optionsObject.publish = publish;

			var collectionObject:Object = new Object();
				collectionObject.collection = dataObject;		
				collectionObject.options = optionsObject;		
								
			var dataString:String = JSON.encode(collectionObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.COLLECTION_SAVE, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						collection = CollectionUtils.buildCollection(collection, JSON_END_POINT, event.payload.collection);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"collection":collection}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.collection = collection;
			return returntoken;
		}
		
		/**
		 * This method expunges the object from the system, freeing up any resources it may have held. Asset remove is different than asset delete.
		 * Asset remove will remove the reference to the object from the container. On the other hand, if asset delete is called with a reference object, 
		 * the reference object is deleted, not the original resource.  This method should be used for removing assets from a <code>Collection</code>.
		 * 
		 * @see deleteAssets
		 * 
		 * @param assets Array of assets <code>Media</code> objects to remove
		 * @param collection  The <code>Collection</code> container object to remove the assets from
		 * @return A value of assets on the token and the payload value of the event which is a array <code>Media</code> objects
		 */
		public function removeAssets(assets : Array, collection:Collection) : XdriveAPIToken 
		{
			var arry:Array = new Array();
			//{"container":{"type":"CollectionObject","id":"xdr:XFS-417769935"},"references":[{"type":"FileObject","id":"xdr:XFS-417852336"}]}
			
			for each (var asset:Object in assets)
			{
				var referenceObject:Object = new Object();
				 	referenceObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				 	referenceObject.id = asset.fileid;
				 
				arry.push(referenceObject);
			}
			
			var collectionObject:Object = new Object();
				collectionObject.type = XdriveAPIFileTypes.COLLECTION_OBJECT;
				collectionObject.id = collection.fileid;
				
			var containerObject:Object = new Object();
				containerObject.references = arry;
				containerObject.container = collectionObject;
				
			var dataString:String = JSON.encode(containerObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.ASSET_REMOVE, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.assets = assets;
			returntoken.collection = collection;
			return returntoken;
		}
		
		/**
		 * This method creates a new empty <code>Media</code> from an external source such as an aggregation source.  
		 * <p>The file must have the <code>Media.parentid</code> set with the id of the parent <code>Folder</code> or <code>Collection</code>.
		 * A blank id will create the <code>Media</code> within the root directory.</p>
		 * 
		 * @param media <code>Media</code> file to create
		 * @param parentid The id of the <code>Folder</code> or <code>Collection</code> to create the new file in
		 * @param isexternalsource Boolean value for external source files, such as aggregation sources, we will set the "thumbnail*" properties in the <code>Media</code> object passed in and create thumbnails for that external source.
		 * 
		 * @return A value of <code>Media</code> on the token and the payload value of the event
		 */
		public function createAsset(media : Media, parentid : String = "", isexternalsource : Boolean = false) : XdriveAPIToken 
		{ 
			if(isexternalsource){
				var subFilesArry:Array = new Array ();
				var subFileObject:Object = new Object();
					subFileObject.type =  XdriveAPIFileTypes.FILE_OBJECT;
					subFileObject.filename = "thumbnail:small";
					subFileObject.permalink = media.thumbnailsmall;
					
					subFilesArry.push(subFileObject);
				
					subFileObject = new Object();
					subFileObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					subFileObject.filename = "thumbnail:medium";
					subFileObject.permalink = media.thumbnailmedium;
				
					subFilesArry.push(subFileObject);
					
					subFileObject = new Object();
					subFileObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					subFileObject.filename = "thumbnail:large";
					subFileObject.permalink = media.thumbnaillarge;
				
					subFilesArry.push(subFileObject);
			}
			
			var dataObject:Object = new Object();
	 			dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
	 			dataObject.parentId = parentid;
	 			dataObject.filename = media.filename;
	 			dataObject.permalink = media.permalink; // permalink is link to source file on aggregation site
	 		
		 	var assetObj:Object = new Object();
				assetObj.srcFile = dataObject;
				if(isexternalsource)assetObj.subFiles = subFilesArry;
			
			var dataString:String = JSON.encode(assetObj);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_CREATE, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						media = FileUtils.buildFile(media, JSON_END_POINT, event.payload.fileObject);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"media":media}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.media = media;
			return returntoken;
		}
		
		/**
		 * This method renames a <code>Media</code>, <code>Folder</code>, or <code>Collection</code>. 
		 * 
		 * @param asset <code>Media</code>, <code>Folder</code>, or <code>Collection</code> to rename
		 * @param newname The new name for the asset
		 * 
		 * @return A value of asset on the token and the payload value of the event which is a <code>Media</code>, <code>Folder</code>, or <code>Collection</code>
		 */
		public function renameAsset(asset : Object, newname : String) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = asset.fileid;
				dataObject.filename = newname;
				
			var temp:Array = new Array();
				temp.push(dataObject);
			
			var objects:Object = new Object();
				objects.objects = temp;
			
			var dataString:String = JSON.encode(objects);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.ASSET_MODIFY, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						if(asset is Media){
							asset = FileUtils.buildFile(Media(asset), JSON_END_POINT, event.payload.objects[0]);
						} else if (asset is Folder){
							asset = FolderUtils.buildFolder(Folder(asset), JSON_END_POINT, event.payload.objects[0]);
						} else if (asset is Collection){
							asset = CollectionUtils.buildCollection(Collection(asset), JSON_END_POINT, event.payload.objects[0]);
						}
						
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"asset":asset}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.asset = asset;
			return returntoken;
		}
		
		/**
		 * This method expunges the object from the system, freeing up any resources it may have held. Asset delete is different than asset remove.
		 * Asset remove will remove the reference to the object from the container. On the other hand, if asset.delete is called with a reference object, 
		 * the reference object is deleted, not the original resource.
		 * 
		 * @see removeAssets
		 * 
		 * @param assets Array of assets (Media, Collection, Folder) to delete
		 * 
		 * @return A value of assets on the token and the payload value of the event which is a array <code>Media</code> objects
		 */
		public function deleteAssets(assets : Array) : XdriveAPIToken 
		{
			var arry:Array = new Array();
			
			for each (var asset:Object in assets)
			{
				var dataObject:Object = new Object();
				 	dataObject.type = asset.type;
				 	dataObject.id = asset.fileid;
				 
				arry.push(dataObject);
			}
			
			var objects:Object = new Object();
				objects.objects = arry;
			
			var dataString:String = JSON.encode(objects);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.ASSET_DELETE, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
				
			returntoken.assets = assets;
			return returntoken;
		}
		
		/**
		 * This method takes an array of sparse objects and returns their populated form. The filename and parentid fields cannot be null. 
		 * The parentid can be independent for each asset in the array. Each asset within the array can have an independent parentid value.   
		 * 
		 * @param assets Array of assets of type <code>Media</code>, <code>Folder</code>, or <code>Collection</code>
		 * 
		 * @return A value of assets on the token and the payload value of the event which is a array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects
		 */
		public function getAssetsByName(assets : Array) : XdriveAPIToken 
		{
			var arry:Array = new Array();
	
			for each (var asset:Object in assets)
			{
				var dataObject:Object = new Object();
				 	dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				 	dataObject.filename = asset.filename;
				 	dataObject.parentId = asset.parentid;
				 
				arry.push(dataObject);
			}
			
			var objects:Object = new Object();
				objects.objects = arry;
			
			var dataString:String = JSON.encode(objects);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.ASSET_GET, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						for each (var asset:Object in assets) {
							for ( var i:int = 0; i < event.payload.objects.length; i++){	
								if(asset is Media){
									asset = FileUtils.buildFile(Media(asset), JSON_END_POINT, event.payload.objects[i]);
								} else if (asset is Folder){
									asset = FolderUtils.buildFolder(Folder(asset), JSON_END_POINT, event.payload.objects[i]);
								} else if (asset is Collection){
									asset = CollectionUtils.buildCollection(Collection(asset), JSON_END_POINT, event.payload.objects[i]);
								}
							}
						}
						
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.assets = assets;
			return returntoken;
		}
		
		/**
		 * Share list of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects to a share via email.
		 * 
		 * @param assets Array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects
		 * @param share <code>Share</code> object containing the list of contact, subject, and message for the email
		 * 
		 * @return A value of assets on the token and the payload value of the event which is a array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects
		 */
		public function sendAssets(assets:Array, share:Share) : XdriveAPIToken 
		{
			var optionsObject:Object = new Object();
				optionsObject.isshow = false; // maybe not used??
				optionsObject.bsmail = !IS_XDRIVE_API;
				
			var contactsArray:Array = new Array();
			
			for each (var co:Contact in share.email){
				var contactObject:Object = new Object ();
					contactObject.type = co.type;
					contactObject.email = co.email;
				contactsArray.push(contactObject);
			}
			
			var messageObject:Object = new Object();
				messageObject.type = XdriveAPIFileTypes.MAIL_MESSAGE_OBJECT;
				messageObject.subject = share.subject;
				messageObject.message = share.message;
				messageObject.to = contactsArray;
			
			var sendArray:Array = new Array();
			
			for each (var asset:Object in assets)
			{
				var sendObject:Object = new Object();
					sendObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					sendObject.id = asset.fileid;
					
				sendArray.push(sendObject);
			}
			
			var paramsObject:Object = new Object();
				paramsObject.mailMessage = messageObject;
				paramsObject.toSend = sendArray;
			
			var dataObject:Object = new Object();
				dataObject.params = paramsObject;
				dataObject.options = optionsObject;

			var dataString:String = JSON.encode(dataObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.MAIL_SENDASSETS, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.assets = assets;
			return returntoken;
		}
		
		/**
		 * This method moves one or more <code>Media</code> or <code>Folder</code> objects from any location to a specified destination <code>Folder</code>.
		 * 
		 * @param assets Array of <code>Media</code> or <code>Folder</code> objects to move
		 * @param destination The destination <code>Folder</code> or <code>Collection</code> to move the assets
		 * 
		 * @return A value of assets on the token and the payload value of the event which is a array of <code>Media</code> or <code>Folder</code> objects
		 */
		public function moveAssets(assets:Array, destination:Folder) : XdriveAPIToken 
		{
			var arry:Array = new Array();
			
		  	for each (var asset:Object in assets){
		  		var dataObject:Object = new Object();
					dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					dataObject.id = asset.fileid;
					
				arry.push(dataObject);
		  	}

			var destObject:Object = new Object();
				destObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				destObject.id = destination.fileid;
						
			var moveFiles:Object = new Object();
				moveFiles.destFolder = destObject;
				moveFiles.toMove = arry;
			
			var dataString:String = JSON.encode(moveFiles);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_MOVE, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.assets = assets;
			return returntoken;
		}
		
		/**
		 * Publish list of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects by creating a public publish id for the asset.
		 * 
		 * @param assets Array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects to publish
		 * 
		 * @return A value of assets on the token and the payload value of the event which is a array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects
		 */
		public function publishAssets(assets:Array) : XdriveAPIToken 
		{
			var publishlist:Array = new Array();
			
			for each (var asset:Object in assets){
				var dataObject:Object = new Object();
					dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					dataObject.id = asset.fileid;

				publishlist.push(dataObject);	
			}
			
			var publishObject:Object = new Object();
				publishObject.toPublish = publishlist;
				
			var dataString:String = JSON.encode(publishObject);		
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_PUBLISH, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
			token.addEventListener(XdriveAPIEvent.API_RESULT,
				function(event : XdriveAPIEvent) : void { 
					for each (var asset:Object in assets) {
						for ( var i:int = 0; i < event.payload.published.length; i++){	
							if(event.payload.published[i].id == asset.fileid){
								if(asset is Media){
									try{
										Media(asset).publishid = event.payload.published[i].publishId;
										Media(asset).permalink  = event.payload.published[i].permalink;
									} catch(e:Error){trace(e.message);}
								} else if (asset is Folder){
									try{
										Folder(asset).publishid = event.payload.published[i].publishId;								
									} catch(e:Error){trace(e.message);}
								} else if (asset is Collection){
									try{
										Collection(asset).publishid = event.payload.published[i].publishId;
									} catch(e:Error){trace(e.message);}
								}	
							}
						}
					} 
					
					returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
				});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.assets = assets;
			return returntoken;
		}
		
		/**
		 * Unpublish list of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects by removing the public publish id for the asset.
		 * 
		 * @param assets Array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects
		 * 
		 * @return A value of assets on the token and the payload value of the event which is a array of <code>Media</code>, <code>Folder</code>, or <code>Collection</code> objects
		 */
		public function unpublishAssets(assets:Array) : XdriveAPIToken 
		{
			var publishlist:Array = new Array();
			
			for each (var asset:Object in assets){
				var dataObject:Object = new Object();
					dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					dataObject.id = asset.fileid;

				publishlist.push(dataObject);	
			}
			
			var publishObject:Object = new Object();
				publishObject.toUnpublish = publishlist;
				
			var dataString:String = JSON.encode(publishObject);		
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_PUBLISH, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
			token.addEventListener(XdriveAPIEvent.API_RESULT,
				function(event : XdriveAPIEvent) : void { 
					for each (var asset:Object in assets){
						asset.publishid = "";
						if(asset is Media){Media(asset).permalink = "";}
					}
					
					returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"assets":assets}, null, null));
				});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.assets = assets;
			return returntoken;
		}
		
		
		/**
		 * This method reindexes a <code>Media</code> asset. It first clears the cache. This will recreate the thumbnails for the <code>Media</code>.
		 * 
		 * @param asset <code>Media</code> to reindex and clear from cache
		 * 
		 * @return A value of <code>Media</code> on the token and the payload value of the event
		 */
		public function reindexAsset(media:Media) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = media.fileid;

			var temp:Array = new Array();
				temp.push(dataObject);
						
			var toReindex:Object = new Object();
				toReindex.toReindex = temp;
		  	
		  	var dataString:String = JSON.encode(toReindex);		
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.FILE_REINDEX, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						media.refreshed = true;
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"media":media}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.media = media;
			return returntoken;
		}
		
		/**
		 * Returns the thumbnail of a <code>Media</code> file.
		 * 
		 * @param media <code>Media</code> file to retrieve thumbnail for
		 * @param type XdriveAPIMethods type for thumbnail sizes (XdriveAPIMethods.IO_THUMBNAILSMALL, XdriveAPIMethods.IO_THUMBNAILMEDIAUM, XdriveAPIMethods.IO_THUMBNAILLARGE, XdriveAPIMethods.IO_VIEW) 
		 * 
		 * @return A value of <code>Media</code> on the token and the payload value of the event
		 */
		public function previewFile(media:Media, type:String = "") : XdriveAPIToken 
		{
			if(type == "") type = XdriveAPIMethods.IO_THUMBNAILSMALL;
			if(type != XdriveAPIMethods.IO_THUMBNAILSMALL || type != XdriveAPIMethods.IO_THUMBNAILMEDIUM || type != XdriveAPIMethods.IO_THUMBNAILLARGE || type != XdriveAPIMethods.IO_VIEW){
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = XdriveAPIError.getErrorMessage(XdriveAPIError.METHOD_NOT_SUPPORTED);
					resultError.errorCode = XdriveAPIError.METHOD_NOT_SUPPORTED; 
				var errortoken: XdriveAPIToken = new XdriveAPIToken(null);
					errortoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, {"media":media}, null, resultError));
					errortoken.media = media;
				return errortoken;
			} 
			
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = media.fileid;
				
			var toDownload:Object = new Object();
				toDownload.toDownload = dataObject;	
			
			var dataString:String = JSON.encode(toDownload);
			
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, type, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest, URLLoaderDataFormat.BINARY);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"media":media}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.media = media;
			return returntoken;
		}
		
		/**
		 * Downloads a <code>Media</code> asset.
		 * 
		 * @see flash.net.FileReference
		 * 
		 * @param media <code>Media</code> asset to download
		 * @param file The <code>FileReference</code> of the location to download the media asset
		 * 
		 * @return A value of <code>Media</code> on the payload value of the event
		 */
		public function downloadFile(media:Media, file:FileReference) : void 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = media.fileid;
			
			var rangeObject:Object = new Object();
				rangeObject.type = XdriveAPIFileTypes.BYTES_UNIT_OBJECT;
			
			var statusObject:Object = new Object();
				statusObject.type = XdriveAPIFileTypes.STATUS_OBJECT;
				statusObject.token = Math.random() + "";
			
			var toDownload:Object = new Object();
				toDownload.toDownload = dataObject;
				toDownload.range = rangeObject;
				toDownload.statusToken = statusObject;

			var dataString:String = JSON.encode(toDownload);

			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.IO_DOWNLOAD, dataString);
			
			try {
				file.download(urlRequest, media.filename);
			} catch(error : Error) {
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = error.message;
				file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
			}
			
			file.addEventListener(Event.COMPLETE,
				function(event : Event) : void {
					file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"media":media}, null, null));
				});
		}
		
		/**
		 * Downloads a zipped file of the current selection of <code>Media</code> or <code>Folder</code> objects. This method lets the member download one or more media files and 
		 * folders as a single ZIP compressed archival file in a way designed to make the browser prompt the user with 
		 * the file download dialog box.
		 * 
		 * @see flash.net.FileReference
		 * 
		 * @param files An array of <code>Media</code> or <code>Folder</code> objects to retrieve in the zip
		 * @param file The <code>FileReference</code> of the location to download the media asset
		 * 
		 * @return A value of files on the payload value of the event which is an array of <code>Folder</code> objects
		 */
		public function downloadZip(files:Array, file:FileReference) : void 
		{
			if(files.length == 0) return; // we have no files
			
			var fileArray:Array = new Array();
			var fileName:String = FileUtils.fileName(files[0].filename) + ".zip" // grab first file name for zip name
			
			
			for each (var obj:Object in files){
				var dataObject:Object = new Object();
					dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					dataObject.id = obj.fileid;
					
				fileArray.push(dataObject);
			}
			
			var statusObject:Object = new Object();
				statusObject.type = XdriveAPIFileTypes.STATUS_OBJECT;
				statusObject.token = Math.random() + "";
			
			var toDownload:Object = new Object();
				toDownload.toDownload = fileArray;
				toDownload.statusToken = statusObject;

			var dataString:String = JSON.encode(toDownload);

			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.IO_ZIPDOWNLOAD, dataString);
			
			try {
				file.download(urlRequest, fileName);
			} catch(error : Error) {
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = error.message;
				file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
			}
			
			file.addEventListener(Event.COMPLETE,
				function(event : Event) : void {
					file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"files":files}, null, null));
				});
		}
		
		/**
		 * Return the binary data of a <code>Media</code> asset using a <code>URLLoader</code (this to be moved to block read/write). 
		 * 
		 * This method would be used with AIR to write the bytes of a file to a directory on the users computer.
		 * 
		 * @see flash.net.URLLoader
		 * @see http://www.adobe.com/products/air/
		 * 
		 * @param media <code>Media</code> file to retrieve thumbnail
		 * @param urlLoader A URLLoader reference used to download the binary data of the file and receive events
		 * 
		 * @return A value of <code>Media</code> on the payload value of the event
		 */
		public function downloadBinaryFile(media:Media, urlLoader:URLLoader) : void 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = media.fileid;
			
			var rangeObject:Object = new Object();
				rangeObject.type = XdriveAPIFileTypes.BYTES_UNIT_OBJECT;
			
			var statusObject:Object = new Object();
				statusObject.type = XdriveAPIFileTypes.STATUS_OBJECT;
				statusObject.token = Math.random() + "";
			
			var toDownload:Object = new Object();
				toDownload.toDownload = dataObject;
				toDownload.range = rangeObject;
				toDownload.statusToken = statusObject;

			var dataString:String = JSON.encode(toDownload);

			var urlRequest:URLRequest = new URLRequest(JSON_END_POINT  + XdriveAPIMethods.IO_DOWNLOAD); 
				urlRequest.data = 'data=' + dataString;
				urlRequest.method = URLRequestMethod.GET;
				
			try {
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(urlRequest);
			} catch(error : Error) {
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = error.message;
				urlLoader.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
			}
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,
				function(event : IOErrorEvent) : void {
					var error:XdriveAPIError = new XdriveAPIError();
						error.errorMessage = event.text;
					urlLoader.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, error));
				});
				
			urlLoader.addEventListener(Event.COMPLETE,
				function(event : Event) : void {
					var bytes : ByteArray = urlLoader.data;
					urlLoader.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"media":media}, bytes, null));	
				});
		}
		
		/**
		 * Downloads a zipped file of the current selection of <code>Media</code> or <code>Folder</code> objects. This method lets the member download one or more media files and 
		 * folders as a single ZIP compressed archival file in a way designed to make the browser prompt the user with 
		 * the file download dialog box.
		 * 
		 * This method would be used with AIR to write the bytes of a file to a directory on the users computer
		 * 
		 * @see flash.net.URLLoader
		 * @see http://www.adobe.com/products/air/
		 * 
		 * @param files An array of <code>Media</code> or <code>Folder</code> objects to retrieve in the zip
		 * @param urlLoader The URLLoader reference to handle events from the download process
		 * 
		 * @return A value of files on the payload value of the event which is an array of <code>Folder</code> objects
		 */
		public function downloadBinaryZip(files:Array, urlLoader:URLLoader) : void 
		{
			var fileArray:Array = new Array();
			
			for each (var obj:Object in files){
				var dataObject:Object = new Object();
					dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
					dataObject.id = obj.fileid;
					
				fileArray.push(dataObject);
			}
			
			var statusObject:Object = new Object();
				statusObject.type = XdriveAPIFileTypes.STATUS_OBJECT;
				statusObject.token = Math.random() + "";
			
			var toDownload:Object = new Object();
				toDownload.toDownload = fileArray;
				toDownload.statusToken = statusObject;

			var dataString:String = JSON.encode(toDownload);

			var urlRequest:URLRequest = new URLRequest(JSON_END_POINT  + XdriveAPIMethods.IO_ZIPDOWNLOAD); 
				urlRequest.data = 'data=' + dataString;
				urlRequest.method = URLRequestMethod.GET;
			
			try {
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(urlRequest);
			} catch(error : Error) {
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = error.message;
				urlLoader.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
			}
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,
				function(event : IOErrorEvent) : void {
					var error:XdriveAPIError = new XdriveAPIError();
						error.errorMessage = event.text;
					urlLoader.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, error));
				});
				
			urlLoader.addEventListener(Event.COMPLETE,
				function(event : Event) : void {
					var bytes : ByteArray = urlLoader.data;
					urlLoader.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"files":files}, bytes, null));	
				});
		}
		
		/**
		 * This method allows you to upload multiple files to a single destination <code>Folder</code>. 
		 * 
		 * The request consists of the json portion with a destFolder telling us where to put 
		 * the files, and a zip file containing any number of files that will be put in the destination. 
		 * The path structure of the zip file is maintained, any needed paths are created. Uploads a zipped 
		 * local directory and recreates the directory structure in the users account.  
		 * 
		 * A blank parent id will upload the file to the root ("My Xdrive") directory.
		 * 
		 * @see flash.net.FileReference
		 * 
		 * @param folder <code>Folder</code> to upload
		 * @param file FileReference that contains reference to the zip file and is used to handle events
		 * @param parentid The id of the parent <code>Folder</code> to upload the zip file
		 * 
		 * @return A value of <code>Folder</code> on the payload value of the event
		 */
		public function uploadZip(folder:Folder, file:FileReference, parentid:String = "") : void 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = parentid;

			var statusObject:Object = new Object();
				statusObject.type = XdriveAPIFileTypes.STATUS_OBJECT;
				statusObject.token = Math.random() + "";
				
			var paramsObject:Object = new Object();
				paramsObject.destFolder = dataObject;
				paramsObject.statusToken = statusObject;
				
			var requestObject:Object = new Object();
				requestObject.params = paramsObject;

			var dataString:String = JSON.encode(requestObject);
				
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.IO_ZIPUPLOAD, dataString);
			
			try {
				file.upload(urlRequest);
			} catch(error : Error) {
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = error.message;
				file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
			}
			
			file.addEventListener(IOErrorEvent.IO_ERROR,
				function(event : IOErrorEvent) : void {
					var error:XdriveAPIError = new XdriveAPIError();
						error.errorMessage = event.text;
					file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, error));
				});
			
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,
				function(event : DataEvent) : void {
					var result : Object = onResult(event.data);
					if(String(event.data).indexOf(XdriveAPIError.JSON_EXCECTPION) > 0){
						var resultError:XdriveAPIError = new XdriveAPIError();
						var obj:Object = (JSON.decode(String(event.data)) as Object);
						var exception:Object = obj.exceptions;
						try{
							resultError.errorCode = exception[0].errorCode;
							resultError.errorMessage = exception[0].errorMessage;
						} catch (e:Error){trace(e.message)};
							
						file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
					} else {
						folder = FolderUtils.buildFolder(folder, JSON_END_POINT, result.uploaded[0]);
						file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"folder":folder}, null, null));
					}
				});
		}
		
		/**
		 * Upload single asset to a parent directory based on <code>Folder</code> id. A blank id will upload to the root ("My Xdrive") directory.
		 * 
		 * The "basic" upload method allows the multi-part upload of one or more individual files. Entire folders structures may not be 
		 * uploaded via this method. For folder upload, please refer to the <code>folderUpload()</code> method.
		 * 
		 * @see flash.net.FileReference
		 * @see folderUpload
		 * 
		 * @media The <code>Media</code> created by the upload process and returned on the event
		 * @param file FileReference object that references the file to upload
		 * @parentid The parent <code>Folder</code> id to upload the file, leaving this field blank will upload the file to the root directory 
		 * @param publish Optional value that will also publish the asset upon uploading the file
		 * 
		 * @return A value of <code>Media</code> on the payload value of the event
		 */
		public function uploadFile(media:Media, file:FileReference, parentid:String = "", publish:Boolean = false) : void 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.FILE_OBJECT;
				dataObject.id = parentid; 

			var statusObject:Object = new Object();
				statusObject.type = XdriveAPIFileTypes.STATUS_OBJECT;
				statusObject.token = Math.random() + "";
				
			var optionsObject:Object = new Object();
				optionsObject.publish = publish;
			
			var paramsObject:Object = new Object();
				paramsObject.destFolder = dataObject;
				paramsObject.statusToken = statusObject;
				
			var requestObject:Object = new Object();
				requestObject.params = paramsObject; 
				requestObject.options = optionsObject;

			var dataString:String = JSON.encode(requestObject);
				
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.IO_FORMUPLOAD, dataString);
			
			try {	
				file.upload(urlRequest);
			} catch(error : Error) {
				var resultError:XdriveAPIError = new XdriveAPIError();
					resultError.errorMessage = error.message;
				file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
			}
			
			file.addEventListener(IOErrorEvent.IO_ERROR,
				function(event : IOErrorEvent) : void {
					var error:XdriveAPIError = new XdriveAPIError();
						error.errorMessage = event.text;
					file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, error));
				});
			
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,
				function(event : DataEvent) : void {
					var result : Object = onResult(event.data);
					if(String(event.data).indexOf(XdriveAPIError.JSON_EXCECTPION) > 0){
						var resultError:XdriveAPIError = new XdriveAPIError();
						var obj:Object = (JSON.decode(String(event.data)) as Object);
						var exception:Object = obj.exceptions;
						try{
							resultError.errorCode = exception[0].errorCode;
							resultError.errorMessage = exception[0].errorMessage;
						} catch (e:Error){trace(e.message)};
							
						file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
					} else {
						media = FileUtils.buildFile(media, JSON_END_POINT, result.uploaded[0]);
						file.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"media":media}, null, null));
					}
				}
			);
		}
		
		
		/**
		 * Adds list of contacts objects to add to the user's address book.
		 * 
		 * @param assets ArrayCollection of <code>Contact</code> objects
		 * 
		 * @return A value of contacts on the token and the payload value of the event which is a ArrayCollection <code>Contact</code> objects
		 */
		public function addContacts(contacts : ArrayCollection) : XdriveAPIToken 
		{
			var arry:Array = new Array();
			
		  	for each (var cont:Contact in contacts){
		  		var contactObject:Object = new Object();
					contactObject.type = XdriveAPIFileTypes.CONTACT_OBJECT;
					contactObject.email = cont.email;
					
				arry.push(contactObject);
		  	}
		  	
		  	var contactsObject:Object = new Object();
				contactsObject.contacts = arry;
			
			var dataString:String = JSON.encode(contactsObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.CONTACT_NEWAOLCONTACT, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						contacts = ContactUtils.createContacts(event.payload.contacts);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"contacts":contacts}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.contacts = contacts;
			return returntoken;
		}
		
		/**
		 * Retrieves the contact listing.
		 * 
		 * @param assets An empty ArrayCollection to be filled by the return of this call
		 * 
		 * @return A value of contacts on the token and the payload value of the event which is a ArrayCollection <code>Contact</code> objects
		 */
		public function getContacts(contacts:ArrayCollection) : XdriveAPIToken 
		{
			var dataObject:Object = new Object();
				dataObject.type = XdriveAPIFileTypes.GROUP_OBJECT;
				dataObject.id = "";

			var groupObject:Object = new Object();
				groupObject.group = dataObject;

			var dataString:String = JSON.encode(groupObject);
			var urlRequest : URLRequest = createRequest(JSON_END_POINT, XdriveAPIMethods.CONTACT_GETAOLLISTING, dataString);
			
			var returntoken: XdriveAPIToken = new XdriveAPIToken(null);
			var token : XdriveAPIToken = makeRequest(urlRequest);
				token.addEventListener(XdriveAPIEvent.API_RESULT,
					function(event : XdriveAPIEvent) : void { 
						
						contacts = ContactUtils.createContacts(event.payload.contacts);
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, {"contacts":contacts}, null, null));
					});
				token.addEventListener(XdriveAPIEvent.API_FAILURE,
					function(event : XdriveAPIEvent) : void {
						returntoken.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, event.error));
					});
					
			returntoken.contacts = contacts
			return returntoken;
		}
		
		/**
		 * Make API request, handle HTTP status, parse results, and dispatch appropriate events
		 * 
		 * <p>
		 * If Flash Player or AIR cannot get a status code from the server, or if it cannot communicate with the server, 
		 * the default value of 0 is passed to your code. A value of 0 can be generated in any player (for example, 
		 * if a malformed URL is requested), and a value of 0 is always generated by the Flash Player plug-in when 
		 * it is run in the following browsers, which do not pass HTTP status codes to the player: Netscape, Mozilla, 
		 * Safari, Opera, and Internet Explorer for the Macintosh.
		 * </p>
		 * 
		 * @see flash.net.URLRequest
		 * @see http://www.adobe.com/products/air/
		 * 
		 * @param urlRequest The formatted <code>URLRequest</code> reference
		 * @param format The data format for the <code>URlLoader</code>, default is <code>URLLoaderDataFormat.TEXT</code>
		 * @param progress A Boolean value to show progress, default value false
		 * @private
		 */
		private function makeRequest(urlRequest:URLRequest, format:String = "", progress:Boolean = false) : XdriveAPIToken 
		{
			if(format == "") format = URLLoaderDataFormat.TEXT;
			
			var urlLoader : URLLoader = new URLLoader();
				urlLoader.dataFormat = format;
			 
			var token : XdriveAPIToken = new XdriveAPIToken(null);
			
			urlLoader.addEventListener(Event.COMPLETE,
				function(event : Event) : void {
					if(token.status != 200 && token.status !=0) {
						// Return error response
						var error:XdriveAPIError = new XdriveAPIError();
							error.errorCode = token.status;
							error.errorMessage = XdriveAPIError.getErrorMessage(XdriveAPIError.HTTP_REQUEST_ERROR);
						token.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, error));
					} else {
						// Return JSON or binary response
						switch(urlLoader.dataFormat) 
						{
							case URLLoaderDataFormat.TEXT:
								try {
									if(String(urlLoader.data).indexOf(XdriveAPIError.JSON_EXCECTPION) > 0){
										var obj:Object = (JSON.decode(String(urlLoader.data)) as Object);
										var exception:Object = obj.exceptions;
										var resultError:XdriveAPIError = new XdriveAPIError();
											resultError.errorCode = exception[0].errorCode;
											resultError.errorMessage = exception[0].errorMessage;
										token.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, resultError));
									} else {
										var result : Object = onResult(urlLoader.data);
										token.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, result, null, null));
									}
								} catch(e : Error) {
									var catchError:XdriveAPIError = new XdriveAPIError();
										catchError.errorMessage = e.message;
										catchError.errorCode =  e.errorID;
									token.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, catchError));
								}
								break;
								
							case URLLoaderDataFormat.BINARY:
								var bytes : ByteArray = urlLoader.data;
								token.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_RESULT, null, bytes, null));
								break;
						}
					}
				});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,
				function(event : IOErrorEvent) : void {
					var error:XdriveAPIError = new XdriveAPIError();
						error.errorMessage = event.text;
					token.dispatchEvent(new XdriveAPIEvent(XdriveAPIEvent.API_FAILURE, null, null, error));
				});
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,
				function(event : HTTPStatusEvent) : void {
					token.status = event.status;
				});
			if(progress) {
				urlLoader.addEventListener(ProgressEvent.PROGRESS,
					function(event : ProgressEvent) : void {
						token.dispatchEvent(event);
					});
			}
			urlLoader.load(urlRequest);

			return token;
		}
		
		/**
		 * Returns the decoded JSON result.
		 * 
		 * @param result JSON Object to decode
		 * @return Object
		 * @private
		 */
		private function onResult(result:Object) : Object 
		{
			trace("xdrive api json result: " + String(result) + "\n");
			
			if(String(result) == "") return null; // handle logout
			var obj:Object = (JSON.decode(String(result)) as Object);
			var resultObj:Object = obj.results;
			if(obj.jsessionid != null) resultObj.jsessionid = obj.jsessionid;
			if(obj.recoveryToken != null) resultObj.recoveryToken = obj.recoveryToken;
			
			return resultObj; 
		}

		/**
		 * Helper function to create JSON requests, adds jession id to every call and the recovery token
		 * 
		 * @param url The JSON URL
		 * @param jsonmethod The JSON method call name
		 * @param dataString The data to pass on the request to the method
		 * @return URLRequest
		 * @private
		 */
		private function createRequest(url:String, jsonmethod:String, dataString:String) : URLRequest 
		{
			trace("xdrive api sending json request: " + dataString + "\n");
			
			try{
				var params:URLVariables = new URLVariables("data=" + dataString + "&recoveryToken=" + XdriveAPI.RECOVERY_TOKEN);
			} catch (e:Error) { trace("error: " + e.message); }
			
			var urlRequest : URLRequest = new URLRequest();
				urlRequest.url = url + jsonmethod + ";jsessionid=" + XdriveAPI.JESSESSION_ID;
				urlRequest.method = URLRequestMethod.POST;
    			urlRequest.data = params
		
			return urlRequest;
		}
	}
		
}