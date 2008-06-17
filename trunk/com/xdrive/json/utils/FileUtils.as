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

package com.xdrive.json.utils
{
	import com.adobe.serialization.json.JSON;
	import com.xdrive.json.XdriveAPI;
	import com.xdrive.json.XdriveAPIFileTypes;
	import com.xdrive.json.XdriveAPIMethods;
	import com.xdrive.json.vo.Media;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.NumberFormatter;
	
	public class FileUtils
	{
		/**
		 * Maximum allowed file size for video transencoding of uploaded files files.  This is optional
		 * to use with the maxFileSize() function, and since its public, you can reset this value
		 * to any max file size you would like to use within the maxFileSize() funciton.
		 */
		public static var MAX_FILE_SIZE:Number = 50000000;
		
		private var numberFormatter:NumberFormatter;
		
		/**
	 	* File utitlies constructor
	 	*/
		public function FileUtils()
		{
		}
		
		/**
		 * Contructs a file value object from an JSON object.
		 * 
		 * @param url The base url for the application.
		 * @param obj The returned JSON deserialized object.
		 * @return Media
		 * */
		public static function buildFile(media:Media, json:String, obj:Object):Media
		{
			media.fileid = obj.id; 
			media.filename = obj.filename;
			media.size = Number(obj.size);
			media.extension = FileUtils.fileExtension(media.filename);
			media.parentid = obj.parentId;
			media.created = DateUtils.formatDate(String(obj.createTime)); 
			media.modified = DateUtils.formatDate(String(obj.modifiedTime)); 
					
			var dataString:String = "";
			var dataObject:Object = FileUtils.createFileObject(media.fileid, XdriveAPIFileTypes.FILE_OBJECT);
			var toDownload:Object = new Object();
				toDownload.toDownload = dataObject;
				dataString = JSON.encode(toDownload); 
		
			media.thumbnailsmall = json + XdriveAPIMethods.IO_THUMBNAILSMALL + '?data=' + dataString;
			media.thumbnailmedium = json + XdriveAPIMethods.IO_THUMBNAILMEDIUM + '?data=' + dataString;	
			media.thumbnaillarge = json + XdriveAPIMethods.IO_THUMBNAILLARGE + '?data=' + dataString;
			media.orginalimage = json  + XdriveAPIMethods.IO_VIEW + '?data=' + dataString;
				
			if(obj.publishId != null) media.htmllink = FileUtils.createPickupLink(XdriveAPI.BASE_URL, obj.publishId);
			if(obj.publishId != null) media.publishid = obj.publishId;
			if(obj.permalink != null) media.permalink = obj.permalink;			
			//if(obj.publishId != null) media.embedcode = FileUtils.createEmbedCode(media.filename, media.htmllink, opc, src)
			if(obj.aliasTo != null) media.aliasto = obj.alisTo;
			if(obj.indexingStatus != null) media.indexingstatus = Number(obj.indexingStatus);
			if(obj.videoPlayUrl != null) media.viewurl = obj.videoPlayUrl; // to play the transencoded flv file, not original	

			return media;	
		}
		
		/**
		 * Determines the total size of files being uploaded.
		 * @param list List of files
		 * @return Number
		 */
		public static function totalSize(files:Array):Number
		{
			var num:Number = 0;
			for each (var obj:Object in files){
				num += Number(obj.size);	
			}
			return Math.round(num/1024);
		}
    	
    	/**
		 * Determines if a file already exists in a list of files by comparing ids.
		 * @param list List of files
		 * @param file The file to compare against the list
		 * @return Boolean
		 */
    	public static function duplicateIdCheck(list:ArrayCollection, file:Object):Boolean
    	{
    		for each(var obj:Object in list)
    		{
    			try{
    				if(obj.fileid == file.fileid) return true;
    			} catch(e:Error){trace(e.message); return true}
    			
    		}
    		return false;
    	}
    	
    	/**
		 * Determines if a file is over the maximum upload limit for Flash files using
		 * the Flash Player to upload.
		 * @param size Number reresenting the size of the asset or file
		 * @return Boolean
		 */
    	public static function maxFileSize(size : Number):Boolean
    	{
    		if(size < MAX_FILE_SIZE) return true;
    		return false;
    	}
    	
    	/**
		 * Returns the size of a file or asset with the correct unit name (B,KB,MB,GB).
		 * @param size Number reresenting the size of the asset or file
		 * @return String
		 */
		public static function formatSize(size : Number):String
		{
			var units:String;
			var test:Number = 1024;
			var numberFormatter:NumberFormatter = new NumberFormatter;
			
			if (size < test){
				units = "B";
			} else if (size < (test *= 1024)) {
				units = "KB";
			} else if (size < (test *= 1024)) {
				units = "MB";
			} else if (size < (test *= 1024)) {
				units = "GB";
			}
			
			var num:Number = size/(test/1024)*100;
			return (numberFormatter.format(Math.round(num)/100) + units);
		}	
		
		/**
		 * Returns the extension of the asset.
		 * @param name The name of the asset
		 * @return String
		 */
		public static function fileExtension(name:String):String
		{
			var dotindex:int = name.lastIndexOf('.') != -1 ? (name.lastIndexOf('.') + 1) : name.length;
		    var type:String = name.substr(dotindex, name.length).toLocaleLowerCase();
		    return type;
		}
		
		/**
		 * Returns the name of the asset without the extension.
		 * @param name The name of the asset
		 * @return String
		 */
		public static function fileName(name:String):String
		{
			var dotindex:int = name.lastIndexOf('.') != -1 ? (name.lastIndexOf('.') ) : name.length;
		    var trimname:String = name.substr(0, dotindex);
		    return trimname;
		}
		
		/**
		 * Determines if asset is a file can be displayed using Flash either natively or
		 * through tansencoding processes.  
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isFlashMediaType(type:String):Boolean
		{
			type = type.toLocaleLowerCase();
			switch (type)
			{
				case "gif":
				case "mp3":					
				case "jpg":
				case "jpeg":		
				case "png":			
				case "flv":
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is a video asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isVideo(type:String):Boolean
		{
			type = type.toLocaleLowerCase();
			switch (type)
			{		
				case "mpeg":
				case "avi":
				case "wmv":
				case "mpg":
				case "mov":
				case "flv":
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is an image asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isImage(type:String):Boolean
		{
			type = type.toLocaleLowerCase();
			switch (type)
			{		
				case "gif":				
				case "jpg":
				case "jpeg":		
				case "png":	
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is a music asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isMusic(type:String):Boolean
		{
			type = type.toLocaleLowerCase();
			switch (type)
			{		
				case "mp3":						
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is a PDF asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isPDF(type:String):Boolean
		{
			type = type.toLocaleLowerCase();
			switch (type)
			{		
				case "pdf":						
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if item is legal to share (no mp3 files).
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isLegalShare(type:String):Boolean
		{
			type = type.toLocaleLowerCase();
			switch (type)
			{
				case "wav":
				case "mp3":
				case "wma":
					return false;
				default:
					true;
			}	
			
			return true;			
		}
		
		/**
		 * Returns a list of files that are of type photo or video.
		 * @param files ArrayCollection of assets to filter by extension.
		 * @return Array
		 */
		public static function buildPhotoList(files:ArrayCollection):Array
		{
			var temp:Array = new Array();
			for each(var media:Media in files)
			{
				if(FileUtils.isImage(media.extension) || FileUtils.isVideo(media.extension)){
					var asset:Object = createFileObject(media.fileid, media.type);
					temp.push(asset);
				}
			}
			return temp
		}
		
		/**
		 * Returns a list of files that are of type music.
		 * @param files ArrayCollection of assets to filter by extension.
		 * @return Array
		 */
		public static function buildMusicList(files:ArrayCollection):Array
		{
			var temp:Array = new Array();
			for each(var media:Media in files)
			{
				if(FileUtils.isMusic(media.extension)){
					var asset:Object = createFileObject(media.fileid, media.type);
					temp.push(asset);
				}
			}
			return temp
		}
		
		/**
		 * @private
		 * 
		 * Helper function just to take care of repetition with FileObject creation
		 * param id String of file id to create file object.
		 */
		public static function createFileObject(id:String, type:String):Object
		{
			var obj:Object = new Object();
			obj.type = type;
			obj.id = id;
			return obj;
		}
		
		
		/**
		 * Create a link to the pickup page for images.
		 * @param baseURL the url to the pickup pages
		 * @param id The publish id to the image
		 */
		public static function createPickupLink(baseURL: String, id:String):String
		{
			var link:String = baseURL + "/media?p_id=" + id;
			return link;
		} 
		
		/**
		 * Create a direct link to the asset on the public server.
		 * 
		 * The asset must be published first to be available on the
		 * OPC (public) server.
		 * 
		 * @param opcURL The Xdrive OPC (open publish channel) url
		 * @param id The publish id to the asset
		 * @param name The full asset name with extension for the file
		 */
		public static function createPermaLink(opcURL: String, id:String, name:String):String
		{
			var link:String = opcURL + "/opc/" +  id + "/" + name;
			return link;
		} 
		
		/*
		 * Create a embed code to display assets on 3rd party sites.
		 * @param baseURL the url to the pickup pages
		 * @param id The publish id to the asset
		 * @param link The permlink to the asset
		 */
		 /*
		public static function createImageTag(baseURL: String, id:String, link:String):String
		{
			var link:String = "<a href=\"" + baseURL + "/media?p_id=" + id + "\" target=\"_blank\"/>" + "<img src=\"" + link + "\" border=\"0\"\"/></a>";
			return link;
		}*/
		
		/*
		 * Create a embed code to display assets on 3rd party sites.
		 * @param name Name of the file to embed
		 * @param src The source locaiton of the Flash swf to embed
		 * @param pid The publish id to the asset
		 * @param appname The name of the Flash file to embed
		 */
		/* public static function createEmbedCode(name:String, src:String, pid:String, appname:String):String
		{
			var link:String = "<object width='428' height='346'><param name='movie' value=\"" + appname + "\" /><param name='flashVars' value='p_id=" + pid + "&filename=" + name + "'/><param name='wmode' value='transparent' /><embed src=\"" + src + "\" flashVars='p_id=" + pid + "&filename=" + name + "' wmode='transparent' width='428' height='346'></embed></object>";
			return link;
		} */
		
		/*
		 * Create a link to the pickup page for images.
		 * @param baseURL the url to the pickup pages
		 * @param id The publish id to the image
		 */
		/* public static function createImageLink(baseURL: String, id:String):String
		{
			var link:String = baseURL + "/media?p_id=" + id;
			return link;
		} */
		
		/*
		 * Create a link to the pickup page for folders.
		 * @param baseURL the url to the pickup pages
		 * @param id The publish id to the folder
		 */
		/* public static function createFolderLink(id:String):String
		{
			var link:String = baseURL + "/folder?p_id=" +  id;		
			return link;
		} */
		
		/*
		 * Create a link to the pickup page for collections.
		 * @param baseURL the url to the pickup pages
		 * @param id The publish id to the collection
		 */
		/* public static function createCollectionLink(baseURL: String, id:String):String
		{
			var link:String = baseURL + "/shows?p_id=" +  id;		
			return link;
		} */
	}
}