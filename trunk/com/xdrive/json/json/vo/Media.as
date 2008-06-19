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
	 * Media is a value object representing the XdriveAPIFileType.FileObject type for files that are not directories.  
	 */
	[Bindable]
	public class Media 
	{
		private var _filename:String = "";
		private var _fileid:String = "";
		private var _parentid:String = "";
		private var _type:String = XdriveAPIFileTypes.FILE_OBJECT;
		private var _size:Number;
		private var _extension:String = "";
		private var _description:String = "";

		private var _created:Date = new Date();
		private var _modified:Date = new Date();
		private var _uploaded:Date = new Date();
		
		// THUMBNAILS
		private var _thumbnailsmall:String = ""; 
		private var _thumbnailmedium:String = ""; 
		private var _thumbnaillarge:String = "";
		private var _orginalimage:String = ""; 
		
		// PUBLISHING
		private var _publishid:String = "";
		private var _permalink:String = "";
		private var _embedcode:String = "";
		private var _htmllink:String = "";
		
		private var _aliasto:String = "";
		private var _refreshed:Boolean = false;
		private var _enabled:Boolean = true;
		private var _isdirectory:Boolean = false;
		
		// VIDEO AND INDEXING
		private var _indexingstatus:Number = -1; // -1 no index exists
		private var _viewurl:String = "";
		
		/**
		 * Constructor for value object.
		 */
		public function Media()
		{  
		}
		
		/**
	 	 * Clones the value object to break binding to the original object.
	 	 * 
	 	 * @return Media
	 	 */
		public function clone() : Media 
		{
			var clone:Media = new Media();
				clone.filename = this.filename;
				clone.fileid = this.fileid;
				clone.type = this.type;
				clone.extension = this.extension;
				clone.description = this.description;
				clone.size = this.size;
				clone.parentid = this.parentid;
				clone.created = this.created;
				clone.modified = this.modified;
				clone.thumbnailsmall = this.thumbnailsmall;
				clone.thumbnailmedium = this.thumbnailmedium;
				clone.thumbnaillarge = this.thumbnaillarge;
				clone.publishid = this.publishid;
				clone.permalink = this.permalink;
				clone.embedcode = this.embedcode;
				clone.htmllink = this.htmllink;
				clone.aliasto = this.aliasto;
				clone.refreshed = this.refreshed;
				clone.enabled = this.enabled;
				clone.indexingstatus = this.indexingstatus;
				clone.isdirectory = this.isdirectory;
				clone.viewurl = this.viewurl;
				
			return clone;
		}	
		
		/**
		 * The file name.
		 * */
		public function get filename() : String 
		{
			return _filename;
		}
		
		/**
		* @private
		*/
		public function set filename(fname : String) : void 
		{
			_filename = fname;
		}
		
		/**
		 * The file type.
		 * */
		public function get type() : String 
		{
			return _type;
		}

		/**
		* @private
		*/
		public function set type(ftype : String) : void 
		{
			_type = ftype;
		}
		
		/**
		 * The file size.
		 * */
		public function get size() : Number 
		{
			return _size;
		}

		/**
		* @private
		*/
		public function set size(sz :  Number) : void 
		{
			_size = sz;
		}
		
		/**
		 * The file extension.
		 * */
		public function get extension() : String 
		{
			return _extension;
		}
		
		/**
		* @private
		*/
		public function set extension(ext : String) : void 
		{
			_extension = ext;
		}
		
		/**
		 * The file description text.
		 * */
		public function get description() : String 
		{
			return _description;
		}
		
		/**
		* @private
		*/
		public function set description(desc : String) : void 
		{
			_description = desc;
		}
		
		/**
		 * The file id.
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
		 * The file parent <code>Folder</code> of the file.
		 * */
		public function get parentid() : String 
		{
			return _parentid;
		}
		
		/**
		* @private
		*/
		public function set parentid(id : String) : void 
		{
			_parentid = id;
		}
		
		/**
		 * The created date of the file.
		 * */
		public function get created() : Date 
		{
			return _created;
		}
		
		/**
		* @private
		*/
		public function set created(date :  Date) : void 
		{
			_created = date;
		}
		
		/**
		 * The modified date of the file.
		 * */
		public function get modified() : Date 
		{
			return _modified;
		}
		
		/**
		* @private
		*/
		public function set modified(date :  Date) : void 
		{
			_modified = date;
		}
		
		/**
		 * The upload date of the asset.
		 * */
		public function get uploaded() : Date 
		{
			return _uploaded;
		}
		
		/**
		* @private
		*/
		public function set uploaded(date :  Date) : void 
		{
			_uploaded = date;
		}
		
		/**
		 * The publish id of the asset.
		 * */
		public function get publishid() : String 
		{
			return _publishid;
		}
		
		/**
		* @private
		*/
		public function set publishid(id :  String) : void 
		{
			_publishid = id;
		}
		
		/**
		 * The permalink of the asset.
		 * */
		public function get permalink() : String 
		{
			return _permalink;
		}
		
		/**
		* @private
		*/
		public function set permalink(link :  String) : void 
		{
			_permalink = link;
		}
		
		/**
		 * The embed code of the asset.
		 * */
		public function get embedcode() : String 
		{
			return _embedcode;
		}
		
		/**
		* @private
		*/
		public function set embedcode(code :  String) : void 
		{
			_embedcode = code;
		}
		
		/**
		 * The html link to the assets pickup page.
		 * */
		public function get htmllink() : String 
		{
			return _htmllink;
		}
		
		/**
		* @private
		*/
		public function set htmllink(link :  String) : void 
		{
			_htmllink = link;
		}
		
		/**
		 * The small size thumbnail 100x100.
		 * */
		public function get thumbnailsmall() : String 
		{
			return _thumbnailsmall;
		}
		
		/**
		* @private
		*/
		public function set thumbnailsmall(img :  String) : void 
		{
			_thumbnailsmall = img;
		}
		
		/**
		 * The medium size thumbnail 570x450.
		 * */
		public function get thumbnailmedium() : String 
		{
			return _thumbnailmedium;
		}
		
		/**
		* @private
		*/
		public function set thumbnailmedium(img :  String) : void 
		{
			_thumbnailmedium = img;
		}
		
		/**
		 * The large size thumbnail 800x600.
		 * */
		public function get thumbnaillarge() : String 
		{
			return _thumbnaillarge;
		}
		
		/**
		* @private
		*/
		public function set thumbnaillarge(img :  String) : void 
		{
			_thumbnaillarge = img;
		}
		
		/**
		 * The raw image (could be large depending on asset size).
		 * */
		public function get orginalimage() : String 
		{
			return _orginalimage;
		}
		
		/**
		* @private
		*/
		public function set orginalimage(img :  String) : void 
		{
			_orginalimage = img;
		}
		
		/**
		 * The view url if the asset is FLV and it is being process
		 * by Uncut video on the server.  We can't play the original
		 * file unless its an FLV format, so we play this view url
		 * after the file is transencoded. Bluestring only feature.
		 * */
		public function get viewurl() : String 
		{
			return _viewurl;
		}
		
		/**
		* @private
		*/
		public function set viewurl(url :  String) : void 
		{
			_viewurl = url;
		}
		
		/**
		 * The indexing status if the asset is FLV and it is being process
		 * by Uncut video on the server.  This is only used for Bluestring.
		 * */
		public function get indexingstatus() : Number 
		{
			return _indexingstatus;
		}
		
		/**
		* @private
		*/
		public function set indexingstatus(status :  Number) : void 
		{
			_indexingstatus = status;
		}
		
		/**
		 * The alias id to the original asset if this asset is a reference.
		 * */
		public function get aliasto() : String 
		{
			return _aliasto;
		}
		
		/**
		* @private
		*/
		public function set aliasto(id : String):void
		{
			_aliasto = id;
		}
		
		/**
		 * Returns <code>true</code> if the asset has been refreshed. This is set by the client
		 * when the asset is refreshed so we don't keep refreshing the asset.
		 * */
		public function get refreshed() : Boolean 
		{
			return _refreshed;
		}
		
		/**
		* @private
		*/
		public function set refreshed(refresh : Boolean):void
		{
			_refreshed = refresh;
		}
		
		/**
		 * Returns <code>true</code> if the folder is enabled and can be worked with. This
		 * value is set by the client and can be used to determine if the asset can be 
		 * dragged for example.
		 * */
		public function get enabled() : Boolean 
		{
			return _enabled;
		}
		
		/**
		* @private
		*/
		public function set enabled(enable : Boolean):void
		{
			_enabled = enable;
		}
		
		/**
		 * Because in Xdrive <code>Media</code> and <code>Folder</code> objects
		 * are the same, we need a way to identify them for sorting.  I added
		 * this variable for indicating that the FileObject type is not a 
		 * directory, which is always the case. Only <code>Folder</code> objects
		 * are directories, but this gives us a common value to compare both 
		 * file types.
		 * */
		public function get isdirectory() : Boolean 
		{
			return _isdirectory;
		}
		
		/**
		* @private
		*/
		public function set isdirectory(dir : Boolean):void
		{
			_isdirectory = dir;
		}


	}
}