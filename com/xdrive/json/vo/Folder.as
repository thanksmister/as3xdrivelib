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

package com.xdrive.json.vo
{
	import com.xdrive.json.XdriveAPIFileTypes;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Folder is a value object representing the XdriveAPIFileType.FileObject type for files that are directories.  
	 */
	 [Bindable]
	public class Folder
	{
		private var _filename:String = "";
		private var _fileid:String = "";
		private var _parentid:String = "";
		private var _description:String = "";
		private var _isdirectory:Boolean = true;
		private var _created:Date = new Date();
		private var _modified:Date = new Date();
		private var _size:Number;
		private var _ismapped:Boolean = false;
		private var _isshared:Boolean = false;
		private var _type:String = XdriveAPIFileTypes.FILE_OBJECT; 
		private var _publishid:String = "";
		private var _embedcode:String = "";
		private var _htmllink:String = "";
		private var _rsslink:String = "";
		private var _children:ArrayCollection = new ArrayCollection();
		private var _firstimage:String = "";
		private var _refreshed:Boolean = false;
		private var _enabled:Boolean = false;
		
		public function Folder()
		{
			// do nothing
		}
		
		/**
	 	 * Clones the VO object to break binding.
	 	 * 
	 	 * @return Folder
	 	 */
		public function clone() : Folder
		{
			var clone:Folder = new Folder();
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
				clone.embedcode = this.embedcode;
				clone.htmllink = this.htmllink;
				clone.children = this.children;
				clone.firstimage = this.firstimage;
				clone.refreshed = this.refreshed;
				clone.enabled = this.enabled;
			return clone;
		}	
		
		/**
	 	 * Creates a collection object from the folder assets.
	 	 * 
	 	 * @return Collection
	 	 */
		public function showCollection(): Collection
		{
			var collection:Collection = new Collection ();
				collection.filename = this.filename;
				collection.fileid = this.fileid;
	
			for each (var obj:Object in this.children){
				if(obj is Media) collection.children.addItem(obj as Media);
			}
			
			return collection;
		}
		
		/**
		 * The folder name.
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
		 * The folder id.
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
		 * The folder description text.
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
		 * The folder's parent id.
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
		 * Returns <code>true</code> folder is directory or <code>false</code>.
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
		 * The size of folder.
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
		 * Returns <code>true</code> folder is shared or <code>false</code>.
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
		 * Returns <code>true</code> folder is mapped to another users account or <code>false</code>.
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
		 * The type for the folder.
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
		 * The publish id for the folder.
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
		 * The embed code for the folder.
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
		 * The link to the folder's pickukp page.
		 * */
		public function get htmllink() : String 
		{
			return _htmllink;
		}
		
		/**
		* @private
		*/
		public function set htmllink(code :  String) : void 
		{
			_htmllink = code;
		}
		
		/**
		 * The link to the folder's rss.
		 * */
		public function get rsslink() : String 
		{
			return _rsslink;
		}
		
		/**
		* @private
		*/
		public function set rsslink(code :  String) : void 
		{
			_rsslink = code;
		}
		
		/**
		 * The children (or sub files and folder) for the folder.
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
		 * The the first image for the folder which is used in simple folder listings
		 * to show the first image on the folder icon.
		 * */
		public function get firstimage() : String 
		{
			return _firstimage;
		}
		
		/**
		* @private
		*/
		public function set firstimage(img : String) : void 
		{
			_firstimage = img;
		}
		
		/**
		 * Returns <code>true</code> if the folder was retrieved already or <code>false</code>.  This
		 * value is set by the client and can be used to determine if the firstimage was already
		 * loaded or failed. 
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
		 * value is set by the client and can be used to determine if the file can be 
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
	}
}