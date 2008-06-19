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
	import com.adobe.serialization.json.JSON;
	import com.xdrive.json.XdriveAPI;
	import com.xdrive.json.XdriveAPIFileTypes;
	import com.xdrive.json.XdriveAPIMethods;
	import com.xdrive.json.vo.Folder;
	import com.xdrive.json.vo.Media;
	
	import mx.collections.ArrayCollection;
	
	public class FolderUtils
	{
		
		/**
	 	* Folder utitlies constructor
	 	*/
		public function FolderUtils()
		{
		}
	
		/** 
		 * Filters only specific folders for navigagion.  Unfortunately
		 * the only way we can filter is based on the name of the file.
		 * 
		 * @param url The base url for the application.
		 * @param obj The children of a folder (media and folders)
		 * @return ArrayCollection
		 * */
		public static function filterFolders(json:String, obj:Object = null):ArrayCollection
		{
			if (obj == null)return null;
			
			var temp:ArrayCollection = new ArrayCollection();
			
			for(var i:Object in obj){
				var isDir:Boolean = Boolean(obj[i].isDir);
				if(isDir){
					if(obj[i].filename == "My Videos" || obj[i].filename == "My Documents" || obj[i].filename == "My Photos" || obj[i].filename == "My Music"){
						var folder:Folder = new Folder();
						temp.addItem(buildFolder(folder, json, obj[i]));
					} 
				} 
			}
			return temp;
		}
		
		/**
		 * Returns list of folders.
		 * 
		 * @param url The base url for the application.
		 * @param obj The children of a folder (media and folders).
		 * @return ArrayCollection
		 * */
		public static function createFolderChildren(json:String, obj:Object):ArrayCollection
		{
			var files:ArrayCollection = new ArrayCollection();
			
			for(var i:Object in obj){
				
				var isDir:Boolean = Boolean(obj[i].isDir);
				
				if(isDir) {
					var folder:Folder = new Folder();
					files.addItem(buildFolder(folder, json, obj[i]));
				} else {
					var media:Media = new Media();
					files.addItem(FileUtils.buildFile(media, json, obj[i]));
				}
			}

			return files;
		}
		
		/**
		 * Contructs a folder value object from an JSON object.
		 * 
		 * @param url The base url for the application.
		 * @param obj The returned JSON deserialized object.
		 * @return Folder
		 * */
		public static function buildFolder(folder:Folder, json:String, obj:Object):Folder
		{
			folder.fileid = obj.id; 
			folder.filename = (obj.filename == "/")? "My Xdrive":obj.filename;
			folder.type = XdriveAPIFileTypes.FILE_OBJECT;
			folder.created = DateUtils.formatDate(String(obj.createTime)); 
			folder.modified = DateUtils.formatDate(String(obj.modifiedTime)); 
			folder.size = Number(obj.size); 
			folder.parentid = obj.parentId;
			folder.ismapped = Boolean(obj.isMapped); 
			if(obj.isShared != null)folder.isshared = Boolean(obj.isShared);
			if(obj.publishId != null)folder.htmllink = FolderUtils.createPickupLink(XdriveAPI.BASE_URL, obj.publishId); 
			if(obj.publishId != null)folder.rsslink = FolderUtils.createRSSLink(XdriveAPI.OPC_URL, obj.publishId); 
			if(obj.publishId != null)folder.publishid = obj.publishId; 
			//if(obj.publishId != null) folder.embedcode = FileUtils.createEmbedCode("rss_index.xml", folder.htmllink, opc, src);
			
			// create thumbnail from icon image when available
			if(obj.icon != null){
				var fileObject:Object = FileUtils.createFileObject(obj.icon.id, XdriveAPIFileTypes.FILE_OBJECT);
				var downloadObject:Object = new Object();
					downloadObject.toDownload = fileObject;	
					
				var optionObject:Object = new Object();
					optionObject.iscachable = false;
							
				var paramsObject:Object = new Object();
					paramsObject.params = downloadObject;
					paramsObject.options = optionObject;
							
				var dataString:String = JSON.encode(paramsObject);
				
				folder.firstimage = json + XdriveAPIMethods.IO_THUMBNAILSMALL + '?data=' + dataString;
			}
			return folder;	
		}
		
		/**
		 * Create a link to the pickup page for a <code>Folder</code>. The folder
		 * must be published first before the pickup page will work. 
		 * 
		 * @param baseURL The Xdrive base url for the main domain
		 * @param id The publish id to the <code>Folder</code>
		 */
		public static function createPickupLink(baseURL: String, id:String):String
		{
			var link:String = baseURL + "/folder?p_id=" +  id;		
			return link;
		}
		
		/**
		 * Create a link to the pickup page for <code>Folder</code>.  
		 * 
		 * The <code>Folder</code> must be published first to generate the RSS on the public server. 
		 * 
		 * @param opcURL The Xdrive OPC (open publish channel) url
		 * @param id The publish id to the <code>Folder</code>
		 */
		public static function createRSSLink(opcURL: String, id:String):String
		{
			var link:String = opcURL + "/opc/" +  id + "/rss_index.xml";	
			return link;
		}
		
	}
}