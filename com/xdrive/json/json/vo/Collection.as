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
	import mx.collections.ArrayCollection;
	
	/**
	 * Collection is a value object representing the XdriveAPIFileType.CollectionObject.  
	 */
	 [Bindable]
	public class Collection
	{
		private var _filename:String = "";
		private var _fileid:String = "";
		private var _parentid:String = "";
		private var _isdirectory:Boolean = true;
		private var _created:Date = new Date();
		private var _modified:Date = new Date();
		private var _size:Number;
		private var _ismapped:Boolean = false;
		private var _isshared:Boolean = false;
		private var _type:String = XdriveAPIFileTypes.COLLECTION_OBJECT; 
		private var _publicurl:String = "";
		private var _publishid:String = "";
		private var _rssmusicurl:String = "";
		private var _rssphotourl:String = "";
		private var _firstimage:String = "";
		private var _rate:String = "";
		private var _transition:String = "";
		private var _fittomusic:Boolean = false;
		private var _change:Boolean = false;  // track changes
		
		private var _children:ArrayCollection = new ArrayCollection();
		private var _music:ArrayCollection = new ArrayCollection();
		private var _photos:ArrayCollection = new ArrayCollection();

		public function Collection()
		{
		}
		
		/**
	 	 * Clones the VO object to break binding.
	 	 * 
	 	 * @return Collection
	 	 */
		public function clone() : Collection
		{
			var clone:Collection = new Collection();
				clone.filename = this.filename;
				clone.fileid = this.fileid;
				clone.parentid = this.parentid;
				clone.isdirectory = this.isdirectory;
				clone.created = this.created;
				clone.modified = this.modified;
				clone.size = this.size;
				clone.ismapped = this.ismapped;
				clone.isshared = this.isshared;
				clone.type = this.type;
				clone.publishid = this.publishid;
				clone.publicurl = this.publicurl;
				clone.firstimage = this.firstimage;
				clone.rssmusicurl = this.rssmusicurl;
				clone.rssphotourl = this.rssphotourl;
				clone.fittomusic = this.fittomusic;
				clone.rate = this.rate;
				clone.transition = this.transition;
				clone.change = this.change;
				clone.children = this.children;
				clone.music = this.music;
				clone.photos = this.photos;
			return clone;
		}	
		
		/**
	 	 * Convert collection object to string for tracing
	 	 * 
	 	 * @return String
	 	 */
		public function toString() : String
		{
			var str:String = "\nCollection Name: " + this.filename;
			str += "Collection ID: " + this.fileid + "\n";
			return str;
		}	
		
		/**
	 	 * Returns string of media id values for the collection.
	 	 * 
	 	 * @return String
	 	 */
		public function mediaString() : String
		{
			var temp:Array = mediaArray();
			return temp.toString();
		}	
		
		/**
	 	 * Returns array of media id values for the collection.
	 	 * 
	 	 * @return Array
	 	 */
		public function mediaArray() : Array
		{
			var temp:Array = new Array ();
			for each (var media:Media in this.children){
				temp.push(media.fileid);
			}
			return temp
		}
		
		/**
	 	 * Gets the first image within the list of genercially ordered media files.
	 	 * 
	 	 * @return Media
	 	 */
		public function firstImage() : Media
		{
			var mo:Media = new Media();
			if(this.children.length > 0) mo = this.children.getItemAt(0) as Media;
			return mo;
		}	
		
		/**
		 * The name of the collection.
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
		 * The id of the collection.
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
		 * The parent <code>Folder</code> id of the collection.
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
		 * Returns <code>true</code> collection is directory or <code>false</code>.
		 * */
		public function get isdirectory() : Boolean 
		{
			return _isdirectory;
		}
		
		/**
		* @private
		*/
		public function set isdirectory(dir : Boolean) : void 
		{
			_isdirectory = dir;
		}
		
		/**
		 * The created date.
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
		 * The modified date.
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
		 * The size of collection.
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
		 * Returns <code>true</code> collection is shared or <code>false</code>.
		 * */
		public function get isshared() : Boolean 
		{
			return _isshared;
		}
		
		/**
		* @private
		*/
		public function set isshared(shared :  Boolean) : void 
		{
			_isshared = shared;
		}
		
		/**
		 * Returns <code>true</code> collection is mapped to another users account or <code>false</code>.
		 * */
		public function get ismapped() : Boolean 
		{
			return _ismapped;
		}
		
		/**
		* @private
		*/
		public function set ismapped(mapped :  Boolean) : void 
		{
			_ismapped = mapped;
		}
		
		/**
		 * The type for the collection.
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
		 * The publish id for the collection.
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
		 * The public url for the collection.
		 * */
		public function get publicurl() : String 
		{
			return _publicurl;
		}
		
		/**
		* @private
		*/
		public function set publicurl(url :  String) : void 
		{
			_publicurl = url;
		}
		
		/**
		 * The the first image for the collection which is used in simple folder listings
		 * to show the first image on the collection icon. 
		 * */
		public function get firstimage() : String 
		{
			return _firstimage;
		}
		
		/**
		* @private
		*/
		public function set firstimage(img :  String) : void 
		{
			_firstimage = img;
		}
		
		/**
		 * The rate (in seconds) of the show. Specific for the RSS created for the show portion of a collection.  
		 * */
		public function get rate() : String 
		{
			return _rate;
		}
		
		/**
		* @private
		*/
		public function set rate(rt :  String) : void 
		{
			_rate = rt;
		}
		
		/**
		 * The transition effect between the images of a show. Specific for the RSS created for the show portion of a collection.  
		 * */
		public function get transition() : String 
		{
			return _transition;
		}
		
		/**
		* @private
		*/
		public function set transition(tran :  String) : void 
		{
			_transition = tran;
		}
		
		/**
		 * Returns true if the show length will fit the music. Specific for the RSS created for the show portion of a collection.  
		 * */
		public function get fittomusic() : Boolean 
		{
			return _fittomusic;
		}
		
		/**
		* @private
		*/
		public function set fittomusic(fit :  Boolean) : void 
		{
			_fittomusic = fit;
		}
		
		/**
		 * The RSS url for the photos of a show. Specific for the RSS created for the show portion of a collection.  
		 * */
		public function get rssphotourl() : String 
		{
			return _rssphotourl;
		}
		
		/**
		* @private
		*/
		public function set rssphotourl(url :  String) : void 
		{
			_rssphotourl = url;
		}
		
		/**
		 * The RSS url for the music of a show. Specific for the RSS created for the show portion of a collection.  
		 * */
		public function get rssmusicurl() : String 
		{
			return _rssmusicurl;
		}
		
		/**
		* @private
		*/
		public function set rssmusicurl(url :  String) : void 
		{
			_rssmusicurl = url;
		}
		
		/**
		 * Returns <code>true</code> if the collection has been changed and not saved.  This is used by
		 * the client to determine if a show is 'dirty' and needs to be saved.
		 * */
		public function get change() : Boolean 
		{
			return _change;
		}
		
		/**
		* @private
		*/
		public function set change(c :  Boolean) : void 
		{
			_change = c;
		}
		
		/**
		 * Gets the children (or sub files and folder) for the folder.
		 * */
		public function get children() : ArrayCollection 
		{
			return _children;
		}
		
		/**
		* @private
		*/
		public function set children(ac :  ArrayCollection) : void 
		{
			_children = new ArrayCollection();
			_children = ac;
		}
		
		/**
		 * Gets the music files for a collection.
		 * */
		public function get music() : ArrayCollection 
		{
			return _music;
		}
		
		/**
		* @private
		*/
		public function set music(ac :  ArrayCollection) : void 
		{
			_music = new ArrayCollection();
			_music = ac;
		}
		
		/**
		 * Gets the photo files for a collection.
		 * */
		public function get photos() : ArrayCollection 
		{
			return _photos;
		}
		
		/**
		* @private
		*/
		public function set photos(ac :  ArrayCollection) : void 
		{
			_photos = new ArrayCollection();
			_photos = ac;
		}
	}
}