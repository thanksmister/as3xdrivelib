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
	import com.xdrive.json.XdriveAPIFileTypes;
	import com.xdrive.json.XdriveAPIMethods;
	import com.xdrive.json.vo.Collection;
	import com.xdrive.json.vo.Media;
	import mx.collections.ArrayCollection;				

	public class CollectionUtils
	{
		public function CollectionUtils()
		{
		}
		
		/**
		 * Contructs a collection value object from an JSON object.
		 * 
		 * @param url The base url for the application.
		 * @param obj The returned JSON deserialized object.
		 * @return Collection
		 * */
		public static function buildCollection(collection:Collection, json:String, obj:Object):Collection
		{
			collection.filename = obj.filename;
			collection.fileid = obj.id;
			collection.type = XdriveAPIFileTypes.COLLECTION_OBJECT;
			collection.created = DateUtils.formatDate(String(obj.createTime)); 
			collection.modified = DateUtils.formatDate(String(obj.modifiedTime)); 
			collection.size = Number(obj.size);
			collection.ismapped = Boolean(obj.isMapped);  
			
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
				
				collection.firstimage = json + XdriveAPIMethods.IO_THUMBNAILSMALL + '?data=' + dataString;
			}
				
			if(obj.isShared != null) collection.isshared = Boolean(obj.isShared);
			if(obj.publicURL != null) collection.publicurl = obj.publicURL;
			if(obj.publishId != null)collection.publishid = obj.publishId;
			
			try{
				if(obj.show.RSSphotosUrl != null) collection.rssphotourl = obj.show.RSSphotosUrl;
				if(obj.show.RSSmusicUrl != null) collection.rssmusicurl = obj.show.RSSmusicUrl;
				if(obj.show.fitToMusic != null) collection.fittomusic = Boolean(obj.show.fitToMusic);
				if(obj.show.rate != null) collection.rate = obj.show.rate;
				if(obj.show.transitionCode != null) collection.transition= obj.show.transitionCode;
			} catch (e:Error){ trace(e.message); }
			
			return collection;
		}
		
		/**
		 * Returns list of collection media files.
		 * 
		 * @param url The base url for the application.
		 * @param obj The children of a folder (media and folders).
		 * @return ArrayCollection
		 * */
		public static function createCollectionChildren(json:String, obj:Object):ArrayCollection
		{
			var files:ArrayCollection = new ArrayCollection();
			
			for(var i:Object in obj){
				if(obj[i].type == XdriveAPIFileTypes.COLLECTION_OBJECT) {
					var collection:Collection = new Collection();
					files.addItem(buildCollection(collection, json, obj[i]));
				} else if( obj[i].type == XdriveAPIFileTypes.FILE_OBJECT ) {
					var media:Media = new Media();
					files.addItem(FileUtils.buildFile(media, json, obj[i]));
				} 
			}

			return files;
		}
		
		/**
		 * Returns a list of shows taht are not mapped.
		 * @return ArrayCollection
		 * */
		public static function filterShows(collections:ArrayCollection):ArrayCollection
		{
			var temp:ArrayCollection = new ArrayCollection();
			for each (var co:Collection in collections){
				if(!co.ismapped)temp.addItem(co);
			}
			return temp;
		}
		
		/**
		 * Returns a list of shows that are mapped.
		 * @return ArrayCollection
		 * */
		public static function filterStrings(collections:ArrayCollection):ArrayCollection
		{
			var temp:ArrayCollection = new ArrayCollection();
			for each (var co:Collection in collections){
				if(co.ismapped)temp.addItem(co);
			}
			return temp;
		}
		
		/**
		 * Returns a list of music formats.
		 * @return Array
		 * */
		public static function filterMusic(ac:ArrayCollection):Array
		{
			var temp:Array = new Array();
			for each (var media:Media in ac){
				if(FileUtils.isMusic(media.extension)){
					var asset:Object = FileUtils.createFileObject(media.fileid, XdriveAPIFileTypes.FILE_OBJECT);
					temp.push(asset);
				}
			}
			return temp;
		}
		
		/**
		 * Returns a list of photos and video formats.
		 * @return Array
		 * */
		public static function filterPhotos(ac:ArrayCollection):Array
		{
			var temp:Array = new Array();
			for each (var media:Media in ac){
				if(FileUtils.isImage(media.extension) || FileUtils.isVideo(media.extension)){
					var asset:Object = FileUtils.createFileObject(media.fileid, XdriveAPIFileTypes.FILE_OBJECT);
					temp.push(asset);
				}
			}
			return temp;
		}
		
		
		/**
		 * Create a link to the pickup page for <code>Collection</code>.
		 *  
		 * The <code>Collection</code> must be published first before the pickup page will work.
		 * 
		 * @param baseURL the url to the pickup pages
		 * @param id The publish id to the <code>Collection</code>
		 */
		public static function createPickupLink(baseURL: String, id:String):String
		{
			var link:String = baseURL + "/shows?p_id=" +  id;		
			return link;
		}
		
		/**
		 * Create a link to the pickup page for a <code>Collection</code>.
		 * 
		 * @param opcURL The Xdrive OPC (open publish channel) url
		 * @param id The publish id to the <code>Collection</code>
		 * @example http://public.xdrive.com/opc/XDPC-2953wbQaBKGQT4WOn5p0Hv9mabcPbntP/rss_index.xml
		 */
		public static function createRSSLink(opcURL: String, id:String):String
		{
			var link:String = opcURL + "/opc/" +  id + "/rss_index.xml";		
			return link;
		}
	}
}